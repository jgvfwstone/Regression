% File: Ch4MatLab.m. The mTCDF function is listed in Appendix F.
% Statistical Significance of the Mean.

y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]';

n = length(y);
ymean = mean(y);
fprintf('ymean = %.3f.\n',ymean); % = 5.135

% Variance of sample.
vary = 1/n * sum( (y-ymean).^2 ); % = 1.095
fprintf('Variance of sample = %.3f.\n',vary); 

% Estimated (un-biased) variance of parent population.
varhaty =  1/(n-1) * sum( (y-ymean).^2 ); % = 1.187
fprintf('Estimated variance of parent population = %.3f.\n',varhaty); 

% Find standard error of ymean.
semymean = sqrt( varhaty / n);
fprintf('Standard error of mean = %.3f.\n',semymean); % =  0.302

% Find t-value for ymean.
tymean = ymean/semymean; % 16.99
fprintf('t-value for the mean = %.3f.\n',tymean); % = 16.997

% Find p-value for ymean.
p = mTCDF(tymean,n-1); 
fprintf('p-value for the mean = %.3e.\n',p); % p = 9.234e-10

% END OF FILE.