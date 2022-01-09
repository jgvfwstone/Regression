% Ch7MatLab.m. The function mFCDF and mTCDF are in Appendix F.
% Multivariate regression with two regressors x1 and x2.
x1=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]; 
x2=[7.47 9.24 3.78 1.23 5.57 4.48 4.05 4.19 0.05 7.20 2.48 1.73 2.37];
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]; 

donorm=0; 
if donorm % Use normalised data to compare coefficients.
    y=y/std(y,1);  x1=x1/std(x1,1); x2=x2/std(x2,1);
    fprintf('\nWARNING: USING NORMALISED REGRESSORS.\n');
end
n = length(y); % number of data points.
x1col = x1';    x2col = x2';
ycol = y'; % define ycol column vector for vector-matrix algebra.
ymean = mean(ycol);
%%%%%%%%%%%%%%%%
% FULL MODEL
%%%%%%%%%%%%%%%%
fprintf('FULL MODEL ...\n'); 
% make array of data for full model.
X = [ones(size(ycol))  x1col x2col]; % Prepend ones for intercept term.
numparamsFull = length(X(1,:)); % 3 =two slopes plus one intercept.
% Get best fitting  regression plane.
params = inv( X'  * X) * X' * ycol;

b0 = params(1); % intercept.
b1 = params(2); % first slope.
b2 = params(3); % second slope.
fprintf('\nfirst slope b1 = %.3f.\n',b1); % 0.966.
fprintf('second slope b2 = %.3f.\n',b2); % 0.138.
fprintf('intercept b0 = %.3f.\n\n',b0); % 2.148.

yhat = X*params; % Find projection of data onto plane.
% Find coefficient of determination, r2.
r2 = var(yhat,1)/var(y,1); % 0.548.

% Assess overall fit.
% IN F-TABLE  df numerator = 2,  df denominator = 10.
numFull = r2/(numparamsFull-1);
denFull = (1-r2)/(n-numparamsFull);
FFull = numFull/denFull; %  F = 6.0634 => p= 0.0189.
SSExplainedFull = sum((yhat-ymean).^2); % 7.805.
fprintf('SS Explained of full model = %.3f.\n',SSExplainedFull); % 7.805.
pfull = mFCDF(FFull, numparamsFull-1, n-numparamsFull);
fprintf('p-value of full model = %.3f.\n',pfull); % 0.0189.

SSNoise = sum( (ycol-yhat).^2 ); % Sum of squared noise.
ymean = mean(ycol);
SST = sum( (ycol-ymean).^2 ); % Total sum of squares.

% Find adjusted coefficient of determination, r2adj.
num = (1/(n-numparamsFull))*SSNoise;
den = (1/(n-1))*SST;
r2adj = 1 - num / den;
fprintf('\nCoefficient of determination = %.3f.\n',r2);
fprintf('Adjusted coefficient of determination = %.3f.\n',r2adj);

% Find standard error of each parameter.
E = sum((ycol-yhat).^2);
SSNoiseFULL = E; % 6.436.

% M = 3 x 3 matrix, parameter variances of are on diagonal of M.
M = E/(n-numparamsFull) * inv(X'*X);
stds = sqrt(diag(M))'; % = 3 sems.
semb0 = stds(1); semb1 = stds(2); semb2 = stds(3);

% Find t-value of each parameter.
tb1 = abs(b1/semb1); tb2 = abs(b2/semb2); tb0 = abs(b0/semb0);

% Find p-value of each parameter.
pb1 = mTCDF(tb1,n-numparamsFull);
pb2 = mTCDF(tb2,n-numparamsFull);
pb0 = mTCDF(tb0,n-numparamsFull);

fprintf('\nStatistics of parameters ...\n')
fprintf('SLOPES:\n');
fprintf('Slope b1 = %.3f..\n',b1);
fprintf('Standard error of b1 = %.3f.\n',semb1);
fprintf('t-value of slope b1 = %.3f.\n',tb1);
fprintf('p-value of slope b1 = %.3f.\n\n',pb1);

fprintf('Slope b2 = %.3f.\n',b2);
fprintf('Standard error of b2 = %.3f.\n',semb2);
fprintf('t-value of b2 = %.3f.\n',tb2);
fprintf('p-value of slope b2 = %.3f.\n\n',pb2);

fprintf('INTERCEPT:\n');
fprintf('Intercept b0 = %.3f.\n',b0);
fprintf('Standard error of b0 = %.3f.\n',semb0);
fprintf('t-value of b0 = %.3f.\n',tb0);
fprintf('p-value of intercept b0 = %.3f.\n\n',pb0);
fprintf('Coeff of determination (full model) = %.3f.\n',r2); % 0.548.


% Assess overall fit to plane with F ratio.
num = r2/(numparamsFull-1);
den = (1-r2) / (n-numparamsFull);
F = num  / den;
p = mFCDF(F,numparamsFull-1,n-numparamsFull);
fprintf('Full model fit: F = %.3f\n',F); %  6.063.
fprintf('p-value of Full model, p = %.4f\n',p); % 0.0189.
%%%%%%%%%%%%%%%%
% REDUCED MODEL
%%%%%%%%%%%%%%%%
fprintf('\nREDUCED MODEL ...\n'); 
XRed = [ones(size(ycol)) x1col];  % Prepend ones for b0 term.
numparamsRed = length(XRed(1,:));
% Get fitted weighted  regression line.
paramsRed = inv( XRed'  * XRed) * XRed' * ycol;
yhat = XRed*paramsRed;
r2Reduced = var(yhat,1)/var(y,1); 
SSExplainedReduced = sum((ymean-yhat).^2); % 6.643
fprintf('SS Explained by reduced model=%.3f.\n',SSExplainedReduced);

num = r2Reduced/(numparamsRed-1);
den = (1-r2Reduced)/(n-numparamsRed);
FReduced = num/den; %  9.617
fprintf('Reduced model fit: F = %.3f\n',FReduced); %  9.617.
pReduced = mFCDF(FReduced, numparamsRed-1, n-numparamsRed);
fprintf('p-value of Reduced model = %.3f.\n',pReduced); %  0.010.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluate contribution of second regressor.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nEvaluate contribution of second regressor ...\n');
SSfFullMinusRed = SSExplainedFull - SSExplainedReduced;
SST = sum((ycol-ymean).^2);
SSNoise = sum((ycol-yhat).^2);
SSE = SST-SSExplainedFull;
fprintf('\nCoeff of det of full model r2 =%.3f.\n',r2); % 0.548
fprintf('Coeff of det of reduced model r2 =%.3f.\n\n',r2Reduced); % 0.466.
fprintf('SS Explained Full model = %.3f.\n',SSExplainedFull); % 7.805.
fprintf('SS Explained Reduced model=%.3f.\n',SSExplainedReduced);%6.643.

dfdiff = 1; % Difference in DOF between full and reduced models.
% Get partial F ratio.
num = (SSExplainedFull - SSExplainedReduced)/dfdiff;
den = SSNoiseFULL / (n-numparamsFull);
Fpartial = num/den; % 1.805
fprintf('Partial F =%.3f.\n',Fpartial); % F=1.8054
pFpartial = mFCDF(Fpartial, dfdiff, n-numparamsFull); %  0.2087
fprintf('p-value of Full Minus Reduced model = %.3f.\n',pFpartial); 
% END OF FILE.
