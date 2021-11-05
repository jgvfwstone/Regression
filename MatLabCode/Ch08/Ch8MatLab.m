% Ch8MatLab.m

% data used in regression book
x=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]';
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]';
sds=[0.09 0.15 0.24 0.36 0.50 0.67 0.87 1.11 1.38 1.68 2.03 2.41 2.83]';

useWeightedRegression = 1; % choose weighted regression. 
if useWeightedRegression
    ws = 1./(sds.^2);
    fprintf('Using WEIGHTED regression ...\n');
else % set weights to 1.
    ws=ones(size(sds));
    fprintf('Using SIMPLE (UNWEIGHTED) regression ...\n');
end
% Put weights in diagonal of matrix.
W = diag(ws,0);

xcol = x;
ycol = y;
n = length(ycol);
numparams = 2;

xmean = mean(xcol);
% Prepend ones to find intercept term.
X = [ones(size(xcol)) xcol];

% Estimate parameters using vector-matrix.
b = inv( X' * W  * X) * X' * W * ycol;
b1 = b(2); % estimated slope b1.
b0 = b(1); % estimated intercept b0.
yhat = X*b; % data projected onto best fitting line.

fprintf('slope = %.3f\n', b1);
fprintf('intercept = %.3f\n', b0);

% Find weighted mean.
ymean = sum(ycol.*ws/sum(ws));  

SSExplained = (yhat-ymean)' * W * (yhat - ymean); 

SSNoise = (ycol-yhat)' * W * (ycol - yhat);

SST = (ycol - ymean)' * W * (ycol - ymean);

SSx =  sum( (xcol - xmean).^2 );

% variance accounted for ...
r2 = 1 - SSNoise / SST; % 0.452
r2adjusted = 1 - 1/(n-numparams)*SSNoise / (1/(n-1) * SST);

fprintf('r2 = %.3f\n', r2);
fprintf('r2adjusted = %.3f\n', r2adjusted);
fprintf('\nSST = %.3f\n', SST);
fprintf('SSExplained = %.3f\n', SSExplained);
fprintf('SSNoise = %.3f\n', SSNoise);

% F ratio
num = r2/(numparams-1);
den = (1-r2) / (n-numparams);
F = num  / den;
p = mFCDF(F,numparams-1,n-numparams);

fprintf('Model fit: F = %.3f\n',F);
fprintf('Model fit: p = %.4f\n',p);

% Weighted Model fit: p = 0.0118
% Simple Model fit: p = 0.0101

% Significance of individual parameters.
varXmatrix = SSNoise/(n-numparams) * inv(X' * W * X);

stdb0 = sqrt(varXmatrix(1,1));
stdb1 = sqrt(varXmatrix(2,2));

% Find t-value for each parameter.
tb1 = b1/stdb1;
tb0 = b0/stdb0;

pb0=mTCDF(tb0,n-numparams);
pb1=mTCDF(tb1,n-numparams);

fprintf('\nb1 = %.3f\n', b1);
fprintf('std(b1) = %.3f\n', stdb1);
fprintf('t(b1) = %.3f\n', tb1);
fprintf('p(b1) = %.3f\n',pb1); % = 0.012

fprintf('\nb0 = %.3f\n', b0);
fprintf('std(b0) = %.3f\n', stdb0);
fprintf('t(b0) = %.3f\n', tb0);
fprintf('p(b0) = %.3f\n',pb0); % = 0.006

% END OF FILE.
