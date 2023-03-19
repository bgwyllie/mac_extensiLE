#
#  uploaddata.py
#  mac_extensiLE
#
#  Created by Becca GW on 2023-03-13.
#
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.datasets import make_blobs

def uploadData():
    X, Y = make_blobs(n_samples=300, centers=3, cluster_std=0.50, random_state=0)
    data = np.vstack([X.T, Y]).T
    plt.scatter(X[:,0], X[:,1])
    plt.show()
#    fileinput = str(input("Which file do you want?"))
#    if not ".csv" in fileinput:
#        fileinput += ".csv"
    
#    gyroscope = pd.read_csv()
#    forearm = pd.read_csv()
#    hand = pd.read_csv()
    

