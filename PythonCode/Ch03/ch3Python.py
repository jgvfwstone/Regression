#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ch3Python.py. Evaluating the fit with the coefficient of variantion.
This is demonstration code, so it is transparent but inefficient. 
"""
import numpy as np

x = [1.00,1.25,1.50,1.75,2.00,2.25,2.50,2.75,3.00,3.25,3.50,3.75,4.00]
y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]

# convert sequences to vectors.   
x = np.array(x)
y = np.array(y)
n = len(y)

xmean = np.mean(x)
ymean = np.mean(y)

# find zero mean versions of x and y.
xzm = x-xmean
yzm = y-ymean
covxy = np.sum(xzm * yzm)/n

varx = np.var(x)
vary = np.var(y)

# find r2 
r2 = covxy * covxy / (varx * vary)

print("Variance of x = %0.3f" %varx) # 0.875
print("Variance of y = %0.3f" %vary) # 1.095
print("Covariance of x and y = %0.3f" %covxy) # 0.669 

print("Coefficient of variation = %0.3f" %r2) # 0.466

# END OF FILE.