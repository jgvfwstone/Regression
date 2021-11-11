#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ch2Python.py. Finding the best fitting line.
This is demonstration code, so it is transparent but inefficient. 
"""

import numpy as np
from scipy import stats
import statsmodels.api as sm
import matplotlib.pyplot as plt

x = [1.00,1.25,1.50,1.75,2.00,2.25,2.50,2.75,3.00,3.25,3.50,3.75,4.00]
y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]

# convert sequences to vectors.   
x = np.array(x)
y = np.array(y)
n = len(y)
xmean = np.mean(x)
ymean = np.mean(y)
# find zero mean versions of x and y.
xzm = x - xmean
yzm = y - ymean
covxy = np.sum(xzm * yzm)/n
varx = np.var(x)
vary = np.var(y)
print("Variance of x = %0.3f" %varx) # 0.875
print("Variance of y = %0.3f" %vary) # 1.095
print("Covariance of x and y = %0.3f" %covxy) # 0.669 

# find slope b1
b1 = covxy/varx # 0.764
# find intercept b0
b0 = ymean - b1*xmean # 3.225
print('slope b1 = %6.3f\nintercept b0 = %6.3f' % (b1, b0))
# find vertical projection of y onto line
yhat = b1 * x + b0

fig, ax = plt.subplots(figsize=(8, 6))
ax.plot(x, y, "o", label="Data")
ax.plot(x, yhat, "b--",label="OLS")
ax.legend(loc="best")

# END OF FILE.