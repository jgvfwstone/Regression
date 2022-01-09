% Ch9MatLab.m. % The function mFCDF is listed in Appendix F.
% Nonlinear (NL, quadratic) regression: y = b1*x1 + b2*x1^2 + b0.

x1=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]; 
x2 = x1.^2; % define quadratic term.
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]; 

n = length(y); % number of data points.
x1col = x1';
x2col = x2';
ycol = y';
ymean = mean(ycol);

% QUADRATIC MODEL.
% make array of data by prepending ones for intercept term.
X = [ones(size(ycol))  x1col x2col]; 
numparamsNL = length(X(1,:));
% Get best fitting curve.
paramsNL = inv( X'  * X) * X' * ycol;
yhatNL = X*paramsNL;
r2NL = var(yhatNL,1)/var(y,1); 

% Assess overall fit of quadratic.
% IN F-TABLE  df numerator = 2,  df denominator = 10.
numNL = r2NL/(numparamsNL-1);
denNL = (1-r2NL)/(n-numparamsNL);
FNL = numNL/denNL; 
SSExplainedNL = sum((yhatNL-ymean).^2); 
pNL = mFCDF(FNL, numparamsNL-1, n-numparamsNL); 

b0 = paramsNL(1); % intercept.
b1 = paramsNL(2); % linear coefficient.
b2 = paramsNL(3); % quadratic coefficient.

fprintf('\nLinear coefficient b1 = %.3f.\n',b1); % 0.212. 
fprintf('Quadratic coefficient b2 = %.3f.\n',b2); %  0.111. 
fprintf('Intercept b0 = %.3f.\n\n',b0); % 3.819.
fprintf('p-value of quadratic model = %.3f.\n',pNL); % 0.041

% PLOT QUADRATIC MODEL.
xforline = 0:0.1:6;
% points on curve.
yhatforlineNL = b1 * xforline +b2 * xforline.^2 + b0; 



% Plot fitted quadratic curve and data points.
figure(1); clf; hold on;
plot(xforline,yhatforlineNL,'k-'); % plot best fitting curve.
plot(x1,y, 'k.', 'MarkerSize',20); % plot data.
set(gca,'Linewidth',2);  set(gca,'FontSize',20);
xlabel('Salary, {\it x} (groats)'); ylabel('Height, {\it y} (feet)');
set(gca,'XLim',[0 5],'FontName','Times');
set(gca,'YLim',[0 8],'FontName','Times');
box on; clear X params; % just to be safe.

% LINEAR MODEL.
XLin = [ones(size(ycol)) x1col]; % Prepend ones to intercept term.
numparamsLin = length(XLin(1,:));
% Get best fitting regression line.
paramsLin = inv( XLin'  * XLin) * XLin' * ycol;
yhatLin = XLin*paramsLin;
% PLOT LINEAR MODEL.
b0LIN = paramsLin(1); % 3.225.
b1LIN = paramsLin(2); % 0.764.
yhatforlineLIN = b1LIN * xforline + b0LIN; % points on line.
figure(1); hold on; plot(xforline,yhatforlineLIN,'k--'); 
legend('Quadratic','Data','Linear', 'Location','northwest');

% Get p-value for linear model.
r2Lin = var(yhatLin,1)/var(y,1); 
num = r2Lin/(numparamsLin-1);
den = (1-r2Lin)/(n-numparamsLin);
FLin = num/den; %  9.617.
SSExplainedLin = sum((yhatLin-ymean).^2); % 6.643.
pLin = mFCDF(FLin, numparamsLin-1, n-numparamsLin); % 0.010.
fprintf('p-value of linear model = %.3f.\n',pLin); % 0.010.

fprintf('\nEvaluate contribution of nonlinear regressor x2 ...\n');
SSfNLMinusLin = SSExplainedNL - SSExplainedLin; % 0.0955.
SST = var(ycol,1)*n; % 14.240.
SSNoise = sum((ycol-yhatNL).^2); % 7.502.
FNLMinusLin = SSfNLMinusLin/ (SSNoise/(n-numparamsNL)); % 0.1273.

fprintf('\nCoeff of det r2 of NL model =%.3f.\n',r2NL); %0.4732.
fprintf('Coeff of det r2 of Linear model =%.3f.\n\n',r2Lin);%0.466.
fprintf('SSExplainedNL=%.3f.\n',SSExplainedNL); % 6.738.
fprintf('SSExplainedLin=%.3f.\n\n',SSExplainedLin); % 6.643.
fprintf('F-partial =%.3f.\n',FNLMinusLin); % 0.127.

pNLMinusLin = mFCDF(FNLMinusLin,numparamsLin-1,n-numparamsNL);
fprintf('p-value of quadratic term=%.3f.\n',pNLMinusLin);%0.729.
% END OF FILE.