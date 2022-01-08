#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ch8Python.py. Weighted linear regression.
import matplotlib.pyplot as plt
import numpy as np
import statsmodels.api as sm
import sympy as sy

x = [1.00,1.25,1.50,1.75,2.00,2.25,2.50,2.75,3.00,3.25,3.50,3.75,4.00]
y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]
sds = [0.09,0.15,0.24,0.36,0.50,0.67,0.87,1.11,1.38,1.68,2.03,2.41,2.83]
# sds = standard deviations of each value of y.

# Convert data to vectors.   
y0 = y
sds = np.array(sds)
x = np.array(x)
y = np.array(y)

###############################
# Weighted least squares model (WLS) using vector-matrix notation.
###############################
# Convert vector w into diagonal matrix W.
w = 1 / (sds**2)
W = np.diag(w)
ones = np.ones(len(y))
Xtr = [x, ones] # 2 rows by 13 cols.
Xtr = sy.Matrix(Xtr)
X = Xtr.T # transpose = 13 rows by 2 cols.
y = sy.Matrix(y)
W = sy.Matrix(W)
ymean = np.mean(y)

# Find weighted least squares solution by hand (ie vector-matrix).
temp = Xtr * W * X
tempinv = temp.inv() # invert matrix.
params = tempinv * Xtr * W * y

b1 = params[0] # 1.511
b0 = params[1] # 2.122
print('slope b1 = %6.3f' % b1) 
print('intercept b0 = %6.3f' % b0)




# Convert to arrays for input to library funcitons
y = np.array(y0)
X = np.array(X)
w = np.array(w)
Xtr = [ones, x]
X = np.transpose(Xtr)

##############################################
# Compare to standard WLS library output.
##############################################
mod_wls = sm.WLS(y, X, weights=w )
res_wls = mod_wls.fit()
print('\n\nWeighted Least Squares LIBRARY MODEL SUMMARY') 
print(res_wls.summary())

##############################################
# Estimate OLS model for comparison:
##############################################
res_ols = sm.OLS(y, X).fit()
print('\n\nOrdinary Least Squares LIBRARY MODEL SUMMARY') 
print(res_ols.params)
print(res_wls.params)
print(res_ols.summary())

##############################################
# PLOT Ordinary LS and Weighted LS best fitting lines.
##############################################
fig = plt.figure(1)
fig.clear()
plt.plot(x, y, "o", label="Data")

# Ordinary Least Squares.
plt.plot(x,res_ols.fittedvalues,"r--",label="Ordinary Least Squares")

# Weighted Least Squares.
plt.plot(x,res_wls.fittedvalues,"k-",label="Weighted Least Squares")
plt.legend(loc="best")

plt.xlabel('salary')
plt.ylabel('height')
plt.show()

##############################################
# END OF FILE.
##############################################
