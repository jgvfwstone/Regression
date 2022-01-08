#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ch9Python.py. Nonlinear regression.

import matplotlib.pyplot as plt
import numpy as np
import statsmodels.api as sm

x1 = [1.00,1.25,1.50,1.75,2.00,2.25,2.50,2.75,3.00,3.25,3.50,3.75,4.00]
y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]

# Convert data to vectors.   
x1 = np.array(x1)
y = np.array(y)
n = len(y)
x2 = x1**2 # define x2 as square of x1.

###############################
# Quadratic model. Repeated twice: 1) Vector-matrix, 2) Standard library.
###############################
ymean = np.mean(y)
ones = np.ones(len(y)) # 1 x n vector
Xtr = [ones, x1, x2]   # 3 x n matrix
X = np.transpose(Xtr)  # n x 3 matrix
y = np.transpose(y)    # 1 x n vector

# 1) Find slopes and intercept using vector-matrix notation.
Xdot = np.dot(Xtr,X)
Xdotinv = np.linalg.pinv(Xdot)
XdotinvA = np.dot(Xdotinv,Xtr)
params = np.dot(XdotinvA,y)

b0Quadratic = params[0] # 3.819
b1Quadratic = params[1] # 0.212
b2Quadratic = params[2] # 0.111

print('\nQUADRATIC VECTOR-MATRIX PARAMETERS') 
print('slope b1 = %6.3f' % b1Quadratic) 
print('slope b2 = %6.3f' % b2Quadratic)
print('intercept b0 = %6.3f' % b0Quadratic)

# 2) STANDARD LIBRARY Quadratic output.
quadraticModel = sm.OLS(y, X).fit()
print('\n\nQUADRATIC MODEL SUMMARY') 
print(quadraticModel.params)
print(quadraticModel.summary())

###############################
# Linear model (using standard library).
###############################
Xtr = [ones, x1]
X = np.transpose(Xtr)
linearModel = sm.OLS(y, X).fit()
print('\n\nLINEAR MODEL SUMMARY') 
print(linearModel.params)
print(linearModel.summary())

params = linearModel.params
b0LINEAR = params[0] # 3.225
b1LINEAR = params[1] # 0.764
yhatLINEAR = b1LINEAR * x1 + b0LINEAR

###############################
# PLOT DATA.
###############################
fig = plt.figure(1)
fig.clear()
yhatQuadratic = b1Quadratic * x1 + b2Quadratic * x2 + b0Quadratic

plt.plot(x1, y, "o", label="Data")
plt.plot(x1, yhatQuadratic, "b--",label="Quadratic fit")
plt.plot(x1, yhatLINEAR, "r--",label="Linear fit")
plt.legend(loc="best")
plt.show()

###############################
# STANDARD LIBRARY: Results of extra sum of squares method.
###############################
# test hypothesis that x2=0
hypothesis = '(x2 = 0)'
f_test = quadraticModel.f_test(hypothesis)
print('\nResults of extra sum of squares method:')
print('F df_num = %.3f df_denom = %.3f' 
% (f_test.df_num, f_test.df_denom))       # 1, 10
print('F partial = %.3f' % f_test.fvalue) # 1.127
print('p-value (that x2=0) = %.3f' % f_test.pvalue)   # 0.729

###############################
# END OF FILE.
###############################