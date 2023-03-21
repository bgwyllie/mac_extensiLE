import numpy as np
from pyquaternion import Quaternion
from scipy.spatial.transform import Rotation
from scipy.signal import find_peaks
import pandas as pd
from mpl_interactions import panhandler, zoom_factory
import matplotlib.pyplot as plt
import bisect
import matplotlib.patches as mpatches
from datetime import datetime
import os

#import the csv files and standardize column names to account for collection differences across devices
data_directory = "/Users/bgwyllie/Documents/symposium_data"
hand_file = "hand_data_Quaternion.csv"
forearm_file = "forearm_data_Quaternion.csv"
gyroscope_file = "stroke_data_Gyroscope.csv"

hand_path = os.path.join(data_directory, hand_file)
forearm_path = os.path.join(data_directory, forearm_file)
gyroscope_path = os.path.join(data_directory, gyroscope_file)

hand = pd.read_csv(hand_path).set_axis(['epoch (ms)', 'timestamp (-0400)', 'elapsed (s)', 'w (number)','x (number)', 'y (number)', 'z (number)'], axis='columns', copy=False)
forearm = pd.read_csv(forearm_path).set_axis(['epoch (ms)', 'timestamp (-0400)', 'elapsed (s)', 'w (number)','x (number)', 'y (number)', 'z (number)'], axis='columns', copy=False)
gyroscope = pd.read_csv(gyroscope_path).set_axis(['epoch (ms)', 'timestamp (-0500)', 'elapsed (s)', 'x-axis (deg/s)', 'y-axis (deg/s)', 'z-axis (deg/s)'], axis='columns', copy=False)

data_time_unix = os.path.getmtime(gyroscope_path)
data_time_unix = datetime.fromtimestamp(data_time_unix)
data_date = str(data_time_unix)[:10]

def findCutIndex(df, df_dif):
    test_df = (df_dif[['epoch (ms)']] > 100).any(axis=1)
    values = test_df.unique()
    if len(values) > 1:
        df_dif = df_dif[df_dif['epoch (ms)']>100]
        cut_index = df_dif.tail(1).index.values[0]
        df = df.iloc[cut_index:]
    return df
    
def checkForDataBreaks(hand, forearm):
  df_cut = hand
  hand_cut = True
  
  #Added more if statements in case no big breaks --> CHECK
  if (len(hand.index) >= len(forearm.index)):
    df_dif = forearm[['epoch (ms)']].diff()
    df_cut = findCutIndex(forearm, df_dif)
    hand_cut = False

  else:
    df_dif = hand[['epoch (ms)']].diff()
    df_cut = findCutIndex(hand, df_dif)
    hand_cut = True
    
  if hand_cut:
    combined_angle_data = pd.merge_asof(df_cut, forearm, on='epoch (ms)', direction='nearest')
    combined_angle_data.head(5)
  else:
    combined_angle_data = pd.merge_asof(hand, df_cut, on='epoch (ms)', direction='nearest')

  return combined_angle_data

#Standardize Column names
combined_angle_data = checkForDataBreaks(hand, forearm)
combined_angle_data = combined_angle_data.set_axis(['epoch (ms)', 'timestamp (-0400)_x', 'elapsed (s)_x', 'w (number)_x','x (number)_x', 'y (number)_x', 'z (number)_x', 'timestamp (-0400)_y','elapsed (s)_y', 'w (number)_y', 'x (number)_y', 'y (number)_y','z (number)_y'], axis='columns', copy=False)

def calculateWristAngles(combined_angle_data):
  angle_table = combined_angle_data[['epoch (ms)']]

  angle_list = (
    Rotation.from_quat(
      list(Quaternion(row[['w (number)_y', 'x (number)_y', 'y (number)_y', 'z (number)_y']].values.flatten().tolist())*Quaternion(row[['w (number)_x', 'x (number)_x', 'y (number)_x', 'z (number)_x']].values.flatten().tolist()).inverse)
      ).as_euler('xyz', degrees=True)[1]
      for _, row in combined_angle_data.iterrows()
  )

  # Subtract the first epoch value so that axis is in ms NOT epochs
  angle_table = angle_table[['epoch (ms)']] - angle_table.loc[0,'epoch (ms)']
    
  # Create a DataFrame from the angle list and subtract the first angle value
  angle_df = pd.DataFrame(angle_list, columns=['Angle'])
  angle_df = angle_df - angle_df.iloc[0]['Angle']  # comment out if not making all angles relative to first calibrated angle
    
  # Concatenate the epoch and angle DataFrames
  angle_table = pd.concat([angle_table, angle_df], axis=1)

  return angle_table

# calculate the D[n]= 1/3 sum |(Ai[n] - Ai[n-1])|
d_n = (1/3)*abs(gyroscope.iloc[:, 3:6].diff()).sum(axis=1)
d_n_peaks, _ = find_peaks(d_n, height=130)
diff_ten = 10
peaks = np.delete(d_n_peaks, np.argwhere(np.ediff1d(d_n_peaks) <= diff_ten) + 1)
peak_data = gyroscope.iloc[peaks]

def determineStrokeTime(peak):
  peak_data = gyroscope.iloc[peak]
  timestamp = peak_data['timestamp (-0500)']
  peak_time_index = gyroscope[gyroscope["timestamp (-0500)"]==timestamp].index[0]
  elapsed_time = gyroscope.at[peak_time_index, 'elapsed (s)']
  
  #Creating the window for the stroke (0.5 seconds at peak is based on papers)
  start_time = elapsed_time - 0.5
  end_time = elapsed_time + 0.5

  #Since exact start and end times might not exist, finding the closest exisiting value
  start_idx = bisect.bisect_left(gyroscope['elapsed (s)'].values, start_time)
  end_idx = bisect.bisect_left(gyroscope['elapsed (s)'].values, end_time)
  window_of_peak = gyroscope.iloc[start_idx:end_idx].drop(['timestamp (-0500)'], axis=1)
  epoch_list = window_of_peak['epoch (ms)'].values.flatten().tolist()
  #Returning epoch of start and end times
  start_peak = epoch_list[0]
  end_peak = epoch_list[len(epoch_list)-1]
  return start_peak, end_peak

def classifyStrokes(peak):
  peak_data = gyroscope.iloc[peak]
  peak_index = peak_data.drop(['epoch (ms)', 'timestamp (-0500)', 'elapsed (s)']) #, axis=1) #, 'D[n]'

  max_gyro = peak_index.max()
  min_gyro = peak_index.min()
  
  if max_gyro == peak_index["x-axis (deg/s)"] and min_gyro == peak_index["x-axis (deg/s)"]:
    return
    
  stroke = "unknown"
  if max_gyro == peak_index["x-axis (deg/s)"] and min_gyro == peak_index["z-axis (deg/s)"]:
    stroke = "overhead serve"
  elif max_gyro == peak_index["x-axis (deg/s)"] and min_gyro == peak_index["y-axis (deg/s)"]:
    stroke = "forehand"
  elif max_gyro == peak_index["y-axis (deg/s)"] and min_gyro == peak_index["x-axis (deg/s)"]:
    stroke = "backhand"
  return stroke

if len(peaks) != 0:
    stroke_list = []
    start_list = []
    end_list = []
    
    for peak in peaks:
        stroke_class = classifyStrokes(peak)
        stroke_list.append(stroke_class)
        start, end = determineStrokeTime(peak)
        start_list.append(start)
        end_list.append(end)

def createStrokeDataframe(stroke_list, start_list, end_list):
  first_epoch = combined_angle_data.loc[0,'epoch (ms)']
  start_ms = [time - first_epoch for time in start_list]
  end_ms = [time - first_epoch for time in end_list]
  stroke_df = pd.DataFrame(zip(start_ms, end_ms, stroke_list), columns=['start (ms)', 'end (ms)', 'stroke'])
  return stroke_df

def plotFinalGraph(combined_angle_data, stroke_list, start_list, end_list):
  #Convention --> positive (clockwise) = extension, negative (CCW) = flexion
  angle_table = calculateWristAngles(combined_angle_data)
  stroke_df = createStrokeDataframe(stroke_list, start_list, end_list)
  stroke_df = stroke_df.drop(stroke_df[stroke_df['stroke']=='None'].index)

  plt.style.use('dark_background')
  fig, ax = plt.subplots()
  colours = {"forehand": "#ABE1FF", "backhand": "#34A5DA", "overhead serve": "#00447A", "unknown": "#ADC1CC"}
  
  ax.plot(angle_table['epoch (ms)'], angle_table['Angle'], color='white')
  zero_line = np.zeros(len(angle_table.index))
  ax.plot(angle_table['epoch (ms)'], zero_line, linestyle='dashed', color = 'white')
  ax.set_xlabel("Time (ms)")
  ax.set_ylabel("Wrist Angle (Degrees), +Extension, -Flexion")

  for index, row in stroke_df.iterrows():
      value = colours[str(row['stroke'])]
      x_cords = []
      for i in range(row['end (ms)']-row['start (ms)']):
          x_cords.append(row['start (ms)']+i)
          ax.fill_between(x_cords, 0, 1, color=value, alpha=0.5, transform=ax.get_xaxis_transform())

  markers = [plt.Line2D([0,0],[0,0],color=color, marker='o', linestyle='') for color in colours.values()]
  plt.legend(markers, colours.keys(), numpoints=1)
  fig.savefig(f'/Users/bgwyllie/Documents/GitHub/mac_extensiLE/mac_extensiLE/mac_extensiLE/PythonFiles/{data_date}graph.png')
#  plt.show()

plotFinalGraph(combined_angle_data, stroke_list, start_list, end_list)

def countNumberOfBackhands(stroke_list, start_list, end_list):
  stroke_df = createStrokeDataframe(stroke_list, start_list, end_list)
  backhand_df = stroke_df[stroke_df['stroke'] == 'backhand']
  backhand_count = len(backhand_df)
  return backhand_df, backhand_count

backhand_strokes_df, backhand_count = countNumberOfBackhands(stroke_list, start_list, end_list)

def getBackhandDuration(backhand_strokes_df):
  start_epoch = backhand_strokes_df['start (ms)'].to_numpy()
  end_epoch = backhand_strokes_df['end (ms)'].to_numpy()
  times = end_epoch-start_epoch
  total_times = times.sum()

  return total_times

backhand_duration = getBackhandDuration(backhand_strokes_df)

def countNumberOfBadBackhands(combined_angle_data, backhand_strokes_df):
  angle_table = calculateWristAngles(combined_angle_data)
  epoch_times = angle_table['epoch (ms)'].values
  start_epoch = np.array(backhand_strokes_df['start (ms)'].to_list())
  end_epoch = np.array(backhand_strokes_df['end (ms)'].to_list())

  start_indx = np.searchsorted(epoch_times, start_epoch)
  end_indx = np.searchsorted(epoch_times, end_epoch)
  number_of_bad_backhands = 0
  for i in range(len(start_indx)):
    stroke_mask = (angle_table['epoch (ms)'].values >= epoch_times[start_indx[i]]) & \
                      (angle_table['epoch (ms)'].values <= epoch_times[end_indx[i]])
    stroke_range = angle_table.loc[stroke_mask]
    bad_stroke = (stroke_range['Angle'] < -10).any()
    if bad_stroke:
      number_of_bad_backhands += 1
    
  return(number_of_bad_backhands)

def getTotalDuration(combined_angle_data):
  angle_table = calculateWristAngles(combined_angle_data)
  final_ms =  angle_table['epoch (ms)'].iat[-1]
  seconds=(final_ms/1000)%60
  minutes=(final_ms/(1000*60))%60
  hours=(final_ms/(1000*60*60))%24
  return("%d:%d:%d" % (hours, minutes, seconds))

def getDisplayInformation():
    play_duration = str(getTotalDuration(combined_angle_data))
    backhand_strokes_df, number_of_backhands = countNumberOfBackhands(stroke_list, start_list, end_list)
    number_of_backhands = str(number_of_backhands)
    bad_backhands = str(countNumberOfBadBackhands(combined_angle_data, backhand_strokes_df))
    duration_of_backhands = str(getBackhandDuration(backhand_strokes_df))
    data_time_unix = os.path.getmtime("/Users/bgwyllie/Documents/symposium_data/hand_data_Quaternion.csv")
    data_time_unix = datetime.fromtimestamp(data_time_unix)
    data_date = data_time_unix.strftime("%B %d, %Y")
    image_url = f'/Users/bgwyllie/Documents/GitHub/mac_extensiLE/mac_extensiLE/mac_extensiLE/PythonFiles/{data_date}graph.png'
    return play_duration, bad_backhands, duration_of_backhands, number_of_backhands, data_date, image_url
    
