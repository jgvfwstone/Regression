#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ch4Python.py Statistical significance of mean.

import numpy as np
from scipy import stats

y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]

# Convert daa to vector.   
y = np.array(y)
n = len(y)

# Find zero mean version of y.
ymean = np.mean(y)
yzm = y-ymean
varsampley = np.sum(yzm * yzm)/n
print("Sample variance of y = %0.3f." %varsampley) # 1.095

# Unbiased estimate of parent population variance (divide by n-1).
varpopy = np.sum(yzm * yzm)/(n-1)
print("Est of pop variance of y = %0.3f." %varpopy) # 1.187

# Standard error of ymean.
semymean = np.sqrt(varpopy/float(n)) # 0.302
print('Standard error of ymean = %.3f.\n' %  semymean)

# Find t value. 
tval = ymean/semymean # 16.997

# One-tailed p-value = Prob(t>tval).
pval = stats.t.sf(np.abs(tval), n-1) # 9.2343e-10.

print('RESULT CALCULATED BY HAND: ')
print('t-statistic (by hand) = %6.3f.' % tval)
print('p-value = %6.4e.\n' % pval)

# Compare the standard library version of t-test.
m = 0 # mean
t, p = stats.ttest_1samp(y, m)
p = p/2 # for one-tailed p-value.
print('\nLIBRARY RESULT FOR COMPARISON: ')
print('t-statistic (by hand) = %6.3f.' % t)
print('p-value = %6.4e.\n' % p)
# END OF FILE.
