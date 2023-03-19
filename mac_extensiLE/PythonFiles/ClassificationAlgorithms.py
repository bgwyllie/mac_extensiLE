import numpy as np
from numpy.linalg import norm
from pyquaternion import Quaternion
from scipy.spatial.transform import Rotation
from scipy.signal import find_peaks
import pandas as pd
from mpl_interactions import ioff, panhandler, zoom_factory
import matplotlib.pyplot as plt
import bisect
import matplotlib.patches as mpatches

hand = pd.read_csv("/Users/bgwyllie/Documents/symposium_data/hand_data_Quaternion.csv")
forearm = pd.read_csv("/Users/bgwyllie/Documents/symposium_data/forearm_data_Quaternion.csv")
gyroscope = pd.read_csv("/Users/bgwyllie/Documents/symposium_data/stroke_data_Gyroscope.csv")

#standardize gyroscope column names
gyroscope = gyroscope.set_axis(['epoch (ms)', 'timestamp (-0500)', 'elapsed (s)', 'x-axis (deg/s)', 'y-axis (deg/s)', 'z-axis (deg/s)'], axis='columns', copy=False)
print(len(hand.index))
print(len(forearm.index))
print(len(gyroscope.index))

def break_check(hand, forearm):
  hand_cut = False

#Added more if statements in case no big breaks --> CHECK
  if (len(hand.index) < len(forearm.index)):
    df_dif = hand[['epoch (ms)']].diff()
    test_df = (df_dif[['epoch (ms)']] > 100).any(axis=1)
    values = test_df.unique()
    if len(values) > 1:
      df_dif = df_dif[df_dif['epoch (ms)']>100]
      cut_index = df_dif.tail(1).index.values[0]
      df_cut = hand.iloc[cut_index:]
      hand_cut = True
    else:
      df_cut = hand
      hand_cut = True
  else:
    df_dif = forearm[['epoch (ms)']].diff()
    test_df = (df_dif[['epoch (ms)']] > 100).any(axis=1)
    values = test_df.unique()
    if len(values) > 1:
      df_dif = df_dif[df_dif['epoch (ms)']>100]
      cut_index = df_dif.tail(1).index.values[0]
      df_cut = forearm.iloc[cut_index:]
      hand_cut = False
    else:
      df_cut = forearm
      hand_cut = False

  if (hand_cut == True):
    combined = pd.merge_asof(df_cut, forearm, on='epoch (ms)', direction='nearest')
    combined.head(5)
  else:
    combined = pd.merge_asof(hand, df_cut, on='epoch (ms)', direction='nearest')

  return combined

#Standardize Column names
combined = break_check(hand, forearm)
combined = combined.set_axis(['epoch (ms)', 'time (-13:00)_x', 'elapsed (s)_x', 'w (number)_x','x (number)_x', 'y (number)_x', 'z (number)_x', 'time (-13:00)_y','elapsed (s)_y', 'w (number)_y', 'x (number)_y', 'y (number)_y','z (number)_y'], axis='columns', copy=False)
print(len(combined.index))

def angle_calculation(combined):
  angle_table = combined[['epoch (ms)']]
  angle_list = []

  for index, row in combined.iterrows():
    q_forearm = row[['w (number)_y', 'x (number)_y', 'y (number)_y', 'z (number)_y']].values.flatten().tolist() #McEnroe Forearm
    q_forearm_quat = Quaternion(q_forearm)

    q_hand = row[['w (number)_x', 'x (number)_x', 'y (number)_x', 'z (number)_x']].values.flatten().tolist() #Ashe Hand
    q_hand_quat = Quaternion(q_hand)
    q_hand_inverse = q_hand_quat.inverse

    delta_q = q_forearm_quat*q_hand_inverse

    rot = Rotation.from_quat(list(delta_q))
    rot_euler = rot.as_euler('xyz', degrees=True)

    angle_list.append(rot_euler[1])
  
  angle_table = angle_table[['epoch (ms)']] - angle_table.loc[0,'epoch (ms)']
  angle_df = pd.DataFrame(angle_list, columns = ['Angle'])
  angle_df = angle_df - angle_df.loc[0] #comment out if not making all angles relative to first calibrated angle
  angle_table = pd.concat([angle_table, angle_df], axis=1)
  #print(angle_table.loc[0,'epoch (ms)'])

  return angle_table

# calculate the D[n]= 1/3 sum |(Ai[n] - Ai[n-1])|
d_n = (1/3)*abs(gyroscope.iloc[:, 3:6].diff()).sum(axis=1)
d_n_peaks, _ = find_peaks(d_n, height=130) # 200#160) # should this be peaks or just find above 200
diff_ten = 10
peaks = np.delete(d_n_peaks, np.argwhere(np.ediff1d(d_n_peaks) <= diff_ten) + 1)
peak_data = gyroscope.iloc[peaks]

def stroke_times(peak):
  peak_data = gyroscope.iloc[peak]
  timestamp = peak_data['timestamp (-0500)']
  peak_time_index = gyroscope[gyroscope["timestamp (-0500)"]==timestamp].index[0]
  elapsed_time = gyroscope.at[peak_time_index, 'elapsed (s)']
  start_time = elapsed_time - 0.5
  end_time = elapsed_time + 0.5
  start_idx = bisect.bisect_left(gyroscope['elapsed (s)'].values, start_time)
  end_idx = bisect.bisect_left(gyroscope['elapsed (s)'].values, end_time)
  window_of_peak = gyroscope.iloc[start_idx:end_idx].drop(['timestamp (-0500)'], axis=1)
  time_list = window_of_peak['epoch (ms)'].values.flatten().tolist()
  start_peak = time_list[0]
  end_peak = time_list[len(time_list)-1]
  return start_peak, end_peak

def stroke_classifier(peak):
  peak_data = gyroscope.iloc[peak]
    
  timestamp = peak_data['timestamp (-0500)']
    
  peak_time_index = gyroscope[gyroscope["timestamp (-0500)"]==timestamp].index[0]
  peak_index = gyroscope.iloc[peak_time_index].drop(['epoch (ms)', 'timestamp (-0500)', 'elapsed (s)']) #, axis=1) #, 'D[n]'

  max_gyro = max(peak_index)
  min_gyro = min(peak_index)

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
        stroke_class = stroke_classifier(peak)
        stroke_list.append(stroke_class)
        start, end = stroke_times(peak)
        start_list.append(start)
        end_list.append(end)
    
# print(stroke_list)
# print(start_list)
# print(end_list)


def graph_data(combined, start_list, end_list):
  #Convention --> positive (clockwise) = extension, negative (CCW) = flexion
  angle_table = angle_calculation(combined)
  
  # plt.figure()
  plt.style.use('dark_background')
  # plt.plot(angle_table['epoch (ms)'])

  first_epoch = combined.loc[0,'epoch (ms)']
  
  start_ms = []
  for time in start_list:
    start_ms.append(time-first_epoch)

  end_ms = []
  for time in end_list:
    end_ms.append(time-first_epoch)

  stroke_df = pd.DataFrame(list(zip(start_ms, end_ms, stroke_list)), columns =['start (ms)', 'end (ms)', 'stroke'])
  print(stroke_df)

  colours = {"forehand": "#ABE1FF", "backhand": "#34A5DA", "overhead serve": "#3399CC", "unknown": "#ADC1CC", "None": "#ADC1CC"}
  last = len(angle_table['epoch (ms)'])
  with plt.ioff():
      fig, ax = plt.subplots()

  #ax.set_xlim(angle_table.loc[0,'epoch (ms)'], angle_table.loc[end,'epoch (ms)'])
  ax.plot(angle_table['epoch (ms)'], angle_table['Angle'], color='white')
  zero_line = np.zeros(len(angle_table.index))
  ax.plot(angle_table['epoch (ms)'], zero_line, linestyle='dashed', color = 'white')
  ax.set_ylim(bottom=-85, top=85)

  for index, row in stroke_df.iterrows():
      value = colours[str(row['stroke'])]
      threshold = np.zeros(len(angle_table['epoch (ms)']))
      x_cords = []
      for i in range(row['end (ms)']-row['start (ms)']):
          x_cords.append(row['start (ms)']+i)
          ax.fill_between(x_cords, 0, 1, color=value, alpha=0.5, transform=ax.get_xaxis_transform())

  disconnect_zoom = zoom_factory(ax)
  # Enable scrolling and panning with the help of MPL
  # Interactions library function like panhandler.
  pan_handler = panhandler(fig)

  # one_patch = mpatches.Patch(label=list(colours)[0], color=list(colours.values())[0])
  # two_patch = mpatches.Patch(label=list(colours)[1], color=list(colours.values())[1])
  # three_patch = mpatches.Patch(label=list(colours)[2], color=list(colours.values())[2])
  # four_patch = mpatches.Patch(label=list(colours)[3], color=list(colours.values())[3])
  # plt.legend(handles=[one_patch, two_patch, three_patch, four_patch])

  markers = [plt.Line2D([0,0],[0,0],color=color, marker='o', linestyle='') for color in colours.values()]
  plt.legend(markers, colours.keys(), numpoints=1)

  plt.show()

#graph_data(combined, start_list, end_list)

def backhand(combined):
  angle_table = angle_calculation(combined)
  backhands = stroke_df[stroke_df['stroke'] == 'backhand']
  start_epoch = backhands['start (ms)'].to_list()
  end_epoch = backhands['end (ms)'].to_list()
  print(start_epoch)
  print(end_epoch)
  start_indx = []
  end_indx = []
  for i in start_epoch:
    index = bisect.bisect_left(angle_table['epoch (ms)'].values, start_epoch[i])
    start_indx.append(index)
  for i in end_epoch:
    index = bisect.bisect_left(gyroscope['epoch (ms)'].values, end_epoch[i])
    end_indx.append(index)

  print(start_indx)
  print(end_indx)

#backhand(combined)

def duration(combined):
  angle_table = angle_calculation(combined)
  final_ms =  angle_table['epoch (ms)'].iat[-1]
  print(final_ms)
  seconds=(final_ms/1000)%60
  minutes=(final_ms/(1000*60))%60
  hours=(final_ms/(1000*60*60))%24
  print("%d:%d:%d" % (hours, minutes, seconds))
    
duration(combined)

