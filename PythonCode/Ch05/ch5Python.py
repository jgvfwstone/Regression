#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ch5Python.py Statistical significance of regression.
This is demonstration code, so it is transparent but inefficient. 
"""
import numpy as np
from scipy import stats
import statsmodels.api as sm

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
yhat = b1*x + b0

# SLOPE
# find sem of slope
num = ( (1/(n-2)) * sum((y-yhat)**2) )**0.5 # 0.831
den = sum((x-xmean)**2)**0.5 # 3.373
semslope = num/den
print('semslope = %6.3f' % (semslope))


# find t-value of slope
tslope = b1/semslope

# find p-value of slope
# two-sided pvalue = Prob(abs(t)>tt)
pvalue = stats.t.sf(np.abs(tslope), n-2)*2  
print('SLOPE: t-statistic = %6.3f pvalue = %6.4f' % (tslope, pvalue))

# INTERCEPT
# find sem of intercept
a = ( (1/(n-2)) * sum((y-yhat)**2) )**0.5 # 0.831
b = ( (1/n) + xmean**2 / sum( xzm**2 ))**0.5 # 0.791
semintercept = a * b  # 0.658
print('a = %6.3f\nb = %6.3f\nsemintercept = %6.3f'
% (a, b, semintercept))

# find t-value of intercept
tintercept = b0 / semintercept
pintercept = stats.t.sf(np.abs(tintercept), n-2)*2  
print('INTERCEPT: t-statistic = %6.3f pvalue = %6.4f'
% (tintercept, pintercept))

# Overall model fit to data
# find coefficient of variation r2 
r2 = covxy * covxy / (varx * vary)
print("coefficient of variation = %0.3f" %r2) # 0.466

# find F ratio
numparams = 2
A = r2 / (numparams-1)
B = (1-r2) / (n-numparams)
F = A/B # 9.617
print("F ratio = %0.4f" % F) 

pfit = stats.f.sf(F, numparams-1, n-numparams)
print("p overall fit = %0.4f" % pfit) # 0.0101

# run library regression for comparison, print table of results
ones = np.ones(len(x))
X=[ones, x]
X = np.transpose(X)
y = np.transpose(y)
res_ols = sm.OLS(y, X).fit()
print(res_ols.params)
print(res_ols.summary())

# END OF FILE.


