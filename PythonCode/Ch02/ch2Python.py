#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#  ch2Python.py. Finding the best fitting line.
#  This is demonstration code, so it is transparent but inefficient.

import numpy as np
import matplotlib.pyplot as plt

x = [1.00,1.25,1.50,1.75,2.00,2.25,2.50,2.75,3.00,3.25,3.50,3.75,4.00]
y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]

# convert data to vectors.   
x = np.array(x)
y = np.array(y)
xmean = np.mean(x)
ymean = np.mean(y)
# Find zero mean versions of x and y.
xzm = x - xmean
yzm = y - ymean

numerator = np.sum(xzm * yzm) 
denominator = np.sum(xzm * xzm)
print("numerator = %0.3f" %numerator) # 8.693
print("denominator = %0.3f" %denominator) # 11.375

# Find slope b1.
# b1 = numerator/denominator # 0.764
b1 = np.sum(xzm * yzm) / ( np.sum(xzm * xzm) ) # 0.764

# Find intercept b0.
b0 = ymean - b1*xmean # 3.225
print('slope b1 = %6.3f\nintercept b0 = %6.3f' % (b1, b0))

# Draw best fitting line.
xx = np.array([-0.3, 3, 5])
yline = b1 * xx + b0
fig, ax = plt.subplots(figsize=(8, 6))
ax.plot(x, y, "ko", label="Data")
ax.plot(xx, yline, "k-",label="Best fitting line (LSE)")
ax.legend(loc="best")
plt.grid()

###############################
# END OF FILE.
###############################
