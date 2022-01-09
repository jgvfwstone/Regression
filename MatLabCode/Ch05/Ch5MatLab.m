% File: Ch5MatLab.m. The mFCDF function is listed in Appendix F.
% Statistical significance of simple regression.

x=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]';
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]';
n = length(y);
numparams = 2; % slope (b1) and intercept (b0).

% Estimate slope, b1.
xmean = mean(x);    ymean = mean(y);
numerator = sum( (x-xmean) .* (y-ymean) ) / n;
denominator = sum( (x-xmean).^2 ) / n;
b1 = numerator/denominator; % slope
% Estimate intercept, b0.
b0 = ymean - b1 * xmean;
% Get projection of data onto best fitting line.
yhat = b1 .* x + b0; % points on line.
fprintf('slope b1 = %.3f\nintercept b0 = %.3f.\n\n',b1,b0); 

% Find slope standard error (sem).
semslope = (1/(n-2) * sum((y-yhat).^2) )^0.5 / (sum((x-xmean).^2) )^0.5;
fprintf('slope standard error = %.3f.\n',semslope); % 0.246
tslope = b1/semslope; % Find t-value of slope.
fprintf('t-value of slope = %.3f.\n',tslope);  % 3.1012
p = mTCDF(tslope,n-numparams); % Find p-value of slope.
fprintf('p-value of slope = %.3f.\n\n',p);  %   0.0101

% Find standard error of intercept.
a = (1/(n-2) * sum((y-yhat).^2) )^0.5;
b =  ( (1/n) + xmean^2 / (sum((x-xmean).^2)) )^0.5;
semint = a * b;
fprintf('standard error of intercept = %.3f.\n',semint); % 0.6578
tint = b0/semint; % Find t-value of intercept.
fprintf('t-value of intercept = %.3f\n',tint); % 4.9030
pint = mTCDF(tint,n-numparams); % Find p-value of intercept.
fprintf('p-value of intercept = %.3e.\n\n',pint);  %  4.694e-04

% Find overall model fit to data.
r2 = sum( (yhat-mean(yhat)).^2 ) / sum( (y-mean(y)).^2 );
fprintf('coefficient of determination, r2 = %.3f.\n',r2); % 0.4665
F = r2/(numparams-1) / ((1-r2)/(n-numparams)); % 9.6172
pfit = mFCDF(F, numparams-1, n-numparams); 
fprintf('Overall fit p-value from F ratio = %.4f.\n',pfit); % 0.0101

% END OF FILE.
