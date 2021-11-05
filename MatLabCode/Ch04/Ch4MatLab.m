% File: Ch4MatLab.m.

x=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]';
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]';

n = length(y);
ymean = mean(y);
fprintf('ymean = %.3f\n',ymean); % = 5.135

% variance of y.
vary = 1/n * sum( (y-ymean).^2 );
fprintf('vary = %.3f\n',vary); % = 1.095

% estimated parent population variance.
varhaty =  1/(n-1) * sum( (y-ymean).^2 );
fprintf('varhaty = %.3f\n',varhaty); % = 1.187

% standard error of ymean.
semymean = sqrt( varhaty / n);
fprintf('semymean = %.3f\n',semymean); % =  0.302

% t-value for tymean
tymean = ymean/semymean; % 16.99
fprintf('tymean = %.3f\n',tymean); % = 16.997

p=mTCDF(tymean,n-1);
fprintf('p = %.3e\n',p); % p = 9.234e-10

% END OF FILE.
