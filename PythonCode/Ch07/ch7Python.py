#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ch7Python.py. Multivariate regression.
This is demonstration code, so it is transparent but inefficient. 
"""
import matplotlib.pyplot as plt
import numpy as np
import statsmodels.api as sm
from scipy import stats
import warnings # python complains about small n, so turn off warnings.
warnings.filterwarnings('ignore') 
x1 = [1.00,1.25,1.50,1.75,2.00,2.25,2.50,2.75,3.00,3.25,3.50,3.75,4.00]
x2 = [7.47,9.24,3.78,1.23,5.57,4.48,4.05,4.19,0.05,7.20,2.48,1.73,2.37]
y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]

# Set donorm=1 to use standardized regressors to compare coefficients.   
donorm = 0
if donorm==1:
    x1 = x1 / np.std(x1)
    x2 = x2 / np.std(x2)
    y = y / np.std(y)
    print('Using standardized regressors ...')

# convert data to vectors.   
x1 = np.array(x1)
x2 = np.array(x2)
y = np.array(y)
n = len(y)

###############################
# FULL model. Repeat twice: 
# 1) by hand (vector-marix) then 2) check using standard library.
###############################
ymean = np.mean(y)
ones = np.ones(len(y)) # 1 x n vector
Xtr = [x1, x2, ones]   # 3 x n matrix
X = np.transpose(Xtr)  # n x 3 matrix
y = np.transpose(y)    # 1 x n vector

# find slopes and intercept using vector-matrix notation.
Xdot = np.dot(Xtr,X)
Xdotinv = np.linalg.pinv(Xdot)
XdotinvA = np.dot(Xdotinv,Xtr)
params = np.dot(XdotinvA,y)


b0 = params[2] # 2.148
b1 = params[0] # 0.966
b2 = params[1] # 0.138

print('slope b1 = %6.3f' % b1) 
print('slope b2 = %6.3f' % b2)
print('intercept b0 = %6.3f' % b0)

# PLOT DATA.
fig = plt.figure(1)
ax = fig.add_subplot(111, projection='3d')
ax.scatter(X[:,0], X[:,1], y, marker='.', color='red')
ax.set_xlabel("x1")
ax.set_ylabel("x2")
ax.set_zlabel("y")

# PLOT BEST FITTING PLANE.
x1s = np.tile(np.arange(10), (10,1))
x2s = np.tile(np.arange(10), (10,1)).T
yhats = x1s*b1 + x2s*b2 + b0
ax.plot_surface(x1s,x2s,yhats, alpha=0.4)
plt.show()

# find vertical projection of data onto plane.
yhat = np.dot(X,params)
SSExplainedFULL1 = sum((ymean-yhat)**2)
ax.scatter(X[:,0], X[:,1], yhat, marker='.', color='blue')

SSExpFULL = sum((yhat-ymean)**2) # 7.804
print('SSExplainedFULL (vector-matrix) = %6.4f' % SSExpFULL ) 

SSNoiseFULL = sum((yhat-y)**2)

# find coefficient of variation r2.
r2 = np.var(yhat) / np.var(y) # 0.548
print('coefficient of variation r2 = %6.3f' % r2) 

# Compare to STANDARD LIBRARY OUTPUT.
modelFULL = sm.OLS(y, X).fit()


SSExplainedFULL = modelFULL.ess # 7.804
print('SSExplainedFULL (vector-matrix) = %6.4f' % SSExpFULL ) 
print('SSExplainedFULL (standard library) = %6.4f' % SSExplainedFULL ) 

print('\n\nFULL MODEL SUMMARY') 
print(modelFULL.summary())
###############################
# REDUCED model. Repeat twice: 
# 1) by hand (vector-matrix) then 2) check using standard library.
###############################
XREDtr = [x1, ones]
XRED = np.transpose(XREDtr)

# 1) Find slopes and intercept of best fitting plane.
Xdot = np.dot(XREDtr,XRED)
Xdotinv = np.linalg.pinv(Xdot)
XdotinvA = np.dot(Xdotinv,XREDtr)
paramsRED = np.dot(XdotinvA,y)
yhatRED = np.dot(XRED,paramsRED) # projection of data onto plane.
SSExplainedRED1 = sum((ymean-yhatRED)**2) # 6.643
print('SSExplainedRED (vector-matrix) = %6.3f' % SSExplainedRED1) 

# 2) STANDARD LIBRARY OUTPUT.
modelRED = sm.OLS(y, XRED).fit()
SSExplainedRED = modelRED.ess # 6.643
print('SSExplainedRED (standard library) = %6.3f' % SSExplainedRED) 
print('\n\nREDUCED MODEL SUMMARY')
print(modelRED.summary())

###############################
# Extra sum of squares method (partial F-test). Repeat twice: 
# 1) by hand (vector-marix) then 2) check using standard library.
###############################
# 1) Vector-matrix: Results of extra sum of squares method.
print('\nVector-matrix: Results of extra sum of squares method:')
dofDiff = 1 # Difference in dof between full and partial model.
numparamsFULL = 3 # params in full model.
num = (SSExplainedFULL - SSExplainedRED) / dofDiff
den = SSNoiseFULL / (n-numparamsFULL)
Fpartial = num / den
print("Fpartial = %0.3f" % Fpartial) 
p_valuepartial = stats.f.sf(Fpartial, dofDiff, n-numparamsFULL)
print("p_valuepartial (vector-matrix) = %0.3f" % p_valuepartial) # 0.209

# 2) STANDARD LIBRARY: Results of extra sum of squares method.
# test hypothesis that x2=0
hypothesis = '(x2 = 0)'
f_test = modelFULL.f_test(hypothesis)
print('\nSTANDARD LIBRARY: Results of extra sum of squares method:')
print('F df_num = %.3f df_denom = %.3f' 
% (f_test.df_num, f_test.df_denom)) # 1, 10
print('F partial = %.3f' % f_test.fvalue) # 1.805
print('p-value (standard library) = %.3f' % f_test.pvalue) # 0.209
# END OF FILE.
