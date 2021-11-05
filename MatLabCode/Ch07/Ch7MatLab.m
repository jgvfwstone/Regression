% Ch7MatLab.m
% Multivariate regression with two regressors x1 and x2.

clear all;

x1=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]; 
x2=[7.47 9.24 3.78 1.23 5.57 4.48 4.05 4.19 0.05 7.20 2.48 1.73  2.37];
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]; 

% standardize data to have unit variance?
donorm=0;
if donorm
    y=y/std(y,1);
    x1=x1/std(x1,1);
    x2=x2/std(x2,1);
end

% number of data points.
n = length(y);
x1col = x1';
x2col = x2';
ycol = y';
ymean=mean(ycol);

% FULL MODEL
% make array of data.
X = [ones(size(ycol))  x1col x2col]; % Prepend ones to intercept term.
numparamsFull = length(X(1,:));
% Get fitted weighted  regression plane.
params = inv( X'  * X) * X' * ycol;
% params = 2.1484    0.9664    0.1378
yhat = X*params;
r2 = var(yhat,1)/var(y,1); % 0.5472 

% Assess overall fit.
% IN F-TABLE  df numerator = 2,  df denominator = 10
numFull = r2/(numparamsFull-1);
denFull = (1-r2)/(n-numparamsFull);
FFull = numFull/denFull; %  F=6.0634 => p= 0.0189
SSExplainedFull = sum((yhat-ymean).^2); % 7.804

pfull = mFCDF(FFull, numparamsFull-1, n-numparamsFull);

intercept = params(1); % intercept
slope1 = params(2);
slope2 = params(3);

fprintf('\nslope1 = %.3f\n',slope1);
fprintf('slope2 = %.3f\n',slope2);
fprintf('intercept = %.3f\n\n',intercept);
fprintf('p-value full model = %.3f\n',pfull);

% M = 3 x 3 matrix of variances for parameters.
E = sum((ycol-yhat).^2);

% diagonal matrix of sems
M = E/(n-numparamsFull) * inv(X'*X);

ymean = mean(ycol);

SSNoise = sum( (ycol-yhat).^2 );
SST = sum( (ycol-ymean).^2 );

% Find adjusted r2.
num = (1/(n-numparamsFull))*SSNoise;
den = (1/(n-1))*SST;
r2adj = 1 - num/den;

fprintf('\nr2 = %.3f\nr2adj = %.3f\n',r2,r2adj);
% r2 = 0.548 r2adj = 0.458

stds = sqrt(diag(M))'; % == 3 sems.
semint = stds(1);
semslope1 = stds(2);
semslope2 = stds(3);

tslope1 = abs(slope1 / semslope1);
tslope2 = abs(slope2 / semslope2);
tint = abs(intercept / semint);

 pslope1 = mTCDF(tslope1,n-numparamsFull);
 pslope2 = mTCDF(tslope2,n-numparamsFull);
 pintercept = mTCDF(tint,n-numparamsFull);

fprintf('\nStatistics of parameters ...\n')
fprintf('slope1=%.3f\n',slope1);
fprintf('semslope1=%.3f\n',semslope1);
fprintf('tslope1=%.3f\n\n',tslope1);
fprintf('p-value of slope b1=%.3f\n\n',pslope1);

fprintf('slope2=%.3f\n',slope2);
fprintf('semslope2=%.3f\n',semslope2);
fprintf('tslope2=%.3f\n\n',tslope2);
fprintf('p-value of slope b2=%.3f\n\n',pslope2);

fprintf('INTERCEPT:\n');
fprintf('intercept=%.3f\n',intercept);
fprintf('semintercept=%.3f\n',semint);
fprintf('tintercept=%.3f\n',tint);
fprintf('p-value of inercept b0=%.3f\n\n',pintercept);

clear X params; % just to be safe.

% REDUCED MODEL
XRed =[x1col];
XRed = [ones(size(ycol)) XRed];       % Prepend ones to intercept term.
numparamsRed = length(XRed(1,:));
% Get fitted weighted  regression line.
paramsRed = inv( XRed'  * XRed) * XRed' * ycol;
yhat = XRed*paramsRed;
r2Reduced = var(yhat,1)/var(y,1); 
SSExplainedReduced = sum((ymean-yhat).^2);

num = r2Reduced/(numparamsRed-1);
den = (1-r2Reduced)/(n-numparamsRed);
FReduced = num/den; %  
SSExplainedRed = sum((yhat-ymean).^2); % 

pReduced = mFCDF(FReduced, numparamsRed-1, n-numparamsRed);
fprintf('p-value of Reduced model = %.3f\n',pReduced);

%==========================
fprintf('\nEvaluate contribution of second regressor ...\n');
SSfFullMinusRed = SSExplainedFull - SSExplainedReduced;

SST = var(ycol,1)*n;
SSNoise = sum((ycol-yhat).^2);
SSE = SST-SSExplainedFull;
MSE = SSNoise/(n-numparamsRed);

FFullMinusRed = SSfFullMinusRed/MSE;

fprintf('\nr2 of full model =%.3f\n',r2); % r2=0.548
fprintf('r2 of reduced model =%.3f\n\n',r2Reduced); % r2Reduced=0.466

fprintf('SSExplainedFull=%.3f\n',SSExplainedFull); % =7.805
fprintf('SSExplainedReduced=%.3f\n',SSExplainedReduced); % =6.643
fprintf('F =%.3f\n',FFullMinusRed); % F=1.529

pFullMinusRed = mFCDF(FFullMinusRed, numparamsRed-1, n-numparamsRed);
fprintf('p-value of Full Minus Reduced model = %.3f\n',pFullMinusRed); 
%  0.221
