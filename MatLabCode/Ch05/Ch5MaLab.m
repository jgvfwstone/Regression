% File: Ch5MatLab.m.

x=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]';
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]';
n = length(y);
numparams = 2; % slope + intercept.

% Estimate slope.
xmean = mean(x);    ymean = mean(y);
numerator = sum( (x-xmean) .* (y-ymean) ) / n;
denominator = sum( (x-xmean).^2 ) / n;
b1 = numerator/denominator; % slope

% Estimate intercept.
b0 = ymean - b1*xmean;
% Get projection of data onto best fitting line.
yhat = b1.*x + b0; % points on line.

% slope sem.
semslope = (1/(n-2) * sum((y-yhat).^2) )^0.5 / (sum((x-xmean).^2) )^0.5;
fprintf('semslope = %.3f\n',semslope); % 0.246

tslope = b1/semslope;
fprintf('tslope = %.3f\n',tslope);  % 3.1012

p = mTCDF(tslope,n-numparams);
fprintf('p from t-value = %.3f\n',p);  %   0.0101

% intercept sem.
a = (1/(n-2) * sum((y-yhat).^2) )^0.5;
b =  ( (1/n) + xmean^2 / (sum((x-xmean).^2)) )^0.5;
semint = a * b;
fprintf('sem intercept = %.3f\n',semint); % 0.6578

tint = b0/semint;
fprintf('tintercept = %.3f\n',tint); % 4.9030

% Overall model fit to data.
r2 = cov(x,y,1).^2 / (var(x,1)*var(y,1));
r2 = r2(1,2);
fprintf('r2 = %.3f\n',r2);        % 0.4665

F = r2/(numparams-1) / ((1-r2)/(n-numparams)); % 9.6172

p = mFCDF(F, numparams-1, n-numparams);
fprintf('p from F ratio = %.3f\n',r2);        % 0.0101

% END OF FILE.
