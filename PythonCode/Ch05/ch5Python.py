#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ch5Python.py Statistical significance of regression.
"""
import numpy as np
from scipy import stats
import statsmodels.api as sm

x = [1.00,1.25,1.50,1.75,2.00,2.25,2.50,2.75,3.00,3.25,3.50,3.75,4.00]
y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]

# Convert data to vectors.   
x = np.array(x)
y = np.array(y)
n = len(y)
xmean = np.mean(x)
ymean = np.mean(y)
# Find zero mean versions of x and y.
xzm = x - xmean
yzm = y - ymean
covxy = np.sum(xzm * yzm)/n
varx = np.var(x)
vary = np.var(y)
print("Variance of x = %0.3f." %varx) # 0.875
print("Variance of y = %0.3f." %vary) # 1.095
print("Covariance of x and y = %0.3f." %covxy) # 0.669 

# Find slope b1.
b1 = covxy/varx # 0.764
# Find intercept b0.
b0 = ymean - b1*xmean # 3.225
print('\nslope b1 = %6.3f\nintercept b0 = %6.3f.' % (b1, b0))

# Find vertical projection of y onto best fitting line.
yhat = b1*x + b0

numparams = 2 # number of parameters=2 (slope and intercept).

# SLOPE
# Find sem of slope.
num = ( (1/(n-numparams)) * sum((y-yhat)**2) )**0.5 # 0.831.
den = sum((x-xmean)**2)**0.5 # 3.373
semslope = num/den
print('semslope = %6.3f.' % (semslope))


# Find t-value of slope.
tslope = b1/semslope # 3.101

# Find p-value of slope.
# two-tailed pvalue = Prob(abs(t)>tt).
pvalue = stats.t.sf(np.abs(tslope), n-numparams)*2 # 0.0101
print('\nSLOPE:\nt-statistic = %6.3f.' % tslope)
print('pvalue = %6.4f.\m' % pvalue)

# INTERCEPT
# Find sem of intercept.
a = ( (1/(n-numparams)) * sum((y-yhat)**2) )**0.5 # 0.831
b = ( (1/n) + xmean**2 / sum( xzm**2 ))**0.5 # 0.791
semintercept = a * b  # 0.658
print('\na = %6.3f\nb = %6.3f\nsemintercept = a/b = %6.3f.'
% (a, b, semintercept))

# Find t-value of intercept.
tintercept = b0 / semintercept
pintercept = stats.t.sf(np.abs(tintercept), n-numparams)*2  
print('\nINTERCEPT:\nt-statistic = %6.3f.'% tintercept)
print('pvalue = %6.4f.\n'% pintercept)

# Overall model fit to data.
# Find coefficient of variation r2.
r2 = covxy * covxy / (varx * vary)
print("coefficient of variation = %0.3f." %r2) # 0.466.

# Find F ratio.
A = r2 / (numparams-1)
B = (1-r2) / (n-numparams)
F = A/B # 9.617
print("F ratio = %0.4f." % F) 

pfit = stats.f.sf(F, numparams-1, n-numparams)
print("p overall fit = %0.4f." % pfit) # 0.0101.

# Run standard library regression method for comparison.
ones = np.ones(len(x))
X = [ones, x]
X = np.transpose(X)
y = np.transpose(y)
res_ols = sm.OLS(y, X).fit()
print(res_ols.summary()) # Print table of results.

# END OF FILE.