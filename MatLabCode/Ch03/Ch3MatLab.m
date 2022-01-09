% File: Ch3MatLab.m
% Find coefficient of determination = r2.

% load data
x=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]';
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]';

n = length(y);
numparams = 2; % slope and intercept.

% Estimate slope b1.
xmean = mean(x);    
ymean = mean(y);

numerator = sum( (x-xmean) .* (y-ymean) ) / n;
denominator = sum( (x-xmean).^2 ) / n;

b1 = numerator/denominator; % slope

% Estimate intercept b0.
b0 = ymean - b1*xmean;

% Get projection of data onto best fitting line.
yhat = b1 .* x + b0; % points on line.

% Find coefficient of determination = r2.
varyhat = var(yhat,1); % Variance of yhat.
vary = var(y,1); % Variance of y.
r2 = varyhat / vary;

fprintf('Variance of yhat = %.3f\n',varyhat);  
fprintf('Variance of y = %.3f\n',vary);  
fprintf('Coefficient of determination, r2 = varyhat/vary = %.3f\n',r2);  

% END OF FILE.