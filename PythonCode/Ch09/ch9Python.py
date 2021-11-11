#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ch9Python.py. Nonlinear regression.
This is demonstration code, so it is transparent but inefficient. 
"""
import matplotlib.pyplot as plt
import numpy as np
import statsmodels.api as sm
from scipy import stats

x1 = [1.00,1.25,1.50,1.75,2.00,2.25,2.50,2.75,3.00,3.25,3.50,3.75,4.00]
y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]

# convert sequences to vectors.   
x1 = np.array(x1)
y = np.array(y)
n = len(y)
# define x2 as square of x1.
x2 = x1**2

###############################
# Quadratic model.
###############################
ymean = np.mean(y)
ones = np.ones(len(y)) # 1 x n vector
Xtr = [ones, x1, x2]   # 3 x n matrix
X = np.transpose(Xtr)  # n x 3 matrix
y = np.transpose(y)    # 1 x n vector

# find slopes and intercept using vector-matrix notation.
Xdot = np.dot(Xtr,X)
Xdotinv = np.linalg.pinv(Xdot)
XdotinvA = np.dot(Xdotinv,Xtr)
params = np.dot(XdotinvA,y)

b0 = params[0] # 
b1 = params[1] # 
b2 = params[2] # 

print('slope b1 = %6.3f' % (b1)) 
print('slope b2 = %6.3f' % (b2))
print('intercept b0 = %6.3f' % (b0))

# PLOT DATA
fig = plt.figure(1)
fig.clear()
yhat = b1*x1 + b2*x2 + b0

plt.plot(x1, y, "o", label="Data")
plt.plot(x1, yhat, "b--",label="Quadratic")

# Quadratic standard library output.
res_ols = sm.OLS(y, X).fit()
print('\n\nQUADRATIC MODEL SUMMARY') 
print(res_ols.params)
print(res_ols.summary())

# Linear standard library output.
Xtr = [ones, x1]
X = np.transpose(Xtr)
res_olsLIN = sm.OLS(y, X).fit()
print('\n\nLINEAR MODEL SUMMARY') 
print(res_olsLIN.params)
print(res_olsLIN.summary())

params = res_olsLIN.params
b0 = params[0] # 
b1 = params[1] # 
yhatLIN = b1*x1 + b0

plt.plot(x1, yhatLIN, "r--",label="Linear")
plt.legend(loc="best")

# END OF FILE.
