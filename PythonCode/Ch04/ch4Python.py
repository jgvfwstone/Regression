#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ch4Python.py Statistical significance of mean.
This is demonstration code, so it is transparent but inefficient. 
"""
import numpy as np
from scipy import stats

y = [3.34,4.97,4.15,5.40,5.21,4.56,3.69,5.86,4.58,6.94,5.57,5.62,6.87]

# convert sequence to vector.   
y = np.array(y)
n = len(y)

# find zero mean version of y.
ymean = np.mean(y)
yzm = y-ymean
vary = np.sum(yzm * yzm)/n
print("Variance of y = %0.3f" %vary) # 1.095

# population estimates
varpopy = np.sum(yzm * yzm)/(n-1)
m = 0
sstr = '%-14s mean = %6.4f, variance = %6.4f'
print(sstr % ('population:', m, varpopy))

# standard error of ymean
semymean = np.sqrt(varpopy/float(n)) # 0.302
print('standard error of ymean = %.3f\n' %  semymean)

# find t value 
tval = ymean/semymean

# two-sided pvalue = Prob(abs(t)>tt)
pval = stats.t.sf(np.abs(tval), n-1)*2
print('\nt-statistic = %6.3f p-value = %6.4e' % (tval, pval))

# compare the library version of t-test.
t, p = stats.ttest_1samp(y, m)
print('\nLIBRARY RESULT FOR COMPARISON: ')
print('t-statistic = %6.3f pvalue = %6.4e'  % (t, p))

# END OF FILE.

