% Ch9MatLab.m
% Nonlinear (polynomial) regression: y = b1*x1 + b2*x1^2 + b0.

x1=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]; 
x2 = x1.^2; % define quadratic term.
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]; 

% number of data points.
n = length(y);
x1col = x1';
x2col = x2';
ycol = y';
ymean = mean(ycol);

% Quadratic MODEL
% make array of data.
X = [ones(size(ycol))  x1col x2col]; % Prepend ones to intercept term.
numparamsNL = length(X(1,:));
% Get best fitting curve.
paramsNL = inv( X'  * X) * X' * ycol;
yhatNL = X*paramsNL;
r2NL = var(yhatNL,1)/var(y,1); 

% Assess overall fit.
% IN F-TABLE  df numerator = 2,  df denominator = 10
numNL = r2NL/(numparamsNL-1);
denNL = (1-r2NL)/(n-numparamsNL);
FNL = numNL/denNL; 
SSExplainedNL = sum((yhatNL-ymean).^2); 
pNL = mFCDF(FNL, numparamsNL-1, n-numparamsNL); 

b0 = paramsNL(1); % intercept
b1 = paramsNL(2);
b2 = paramsNL(3);

fprintf('\nslope1 = %.3f\n',b1);
fprintf('slope2 = %.3f\n',b2);
fprintf('intercept = %.3f\n\n',b0);
fprintf('p-value NL model = %.3f\n',pNL); % =0.041

% PLOT NonLinear MODEL
xforline = 0:0.1:6;
yhatforlineNL = b1.*xforline +b2*xforline.^2 + b0; % points on line.

% Plot fitted line xest (=xhat in text) and data points.
figure(1); clf; hold on;
plot(xforline,yhatforlineNL,'k-'); % plot best fitting curve.
plot(x1,y, 'k.', 'MarkerSize',20); % plot data.
set(gca,'Linewidth',2);  set(gca,'FontSize',20);
xlabel('Salary, {\it x} (groats)'); ylabel('Height, {\it y} (feet)');
set(gca,'XLim',[0 5],'FontName','Times');
set(gca,'YLim',[0 8],'FontName','Times');
box on; clear X params; % just to be safe.

% Linear MODEL
XLin = [ones(size(ycol)) x1col]; % Prepend ones to intercept term.
numparamsLin = length(XLin(1,:));
% Get fitted regression line.
paramsLin = inv( XLin'  * XLin) * XLin' * ycol;
yhatLin = XLin*paramsLin;
r2Lin = var(yhatLin,1)/var(y,1); 
SSExplainedLin = sum((ymean-yhatLin).^2);

num = r2Lin/(numparamsLin-1);
den = (1-r2Lin)/(n-numparamsLin);
FLin = num/den; %  
SSExplainedLin = sum((yhatLin-ymean).^2); % 
pLin = mFCDF(FLin, numparamsLin-1, n-numparamsLin);
fprintf('p-value of Lin model = %.3f\n',pLin); % 0.010

fprintf('\nEvaluate contribution of nonlinear regressor ...\n');
SSfNLMinusLin = SSExplainedNL - SSExplainedLin;

SST = var(ycol,1)*n;
SSNoise = sum((ycol-yhatNL).^2);
MSE = SSNoise/(n-numparamsNL); % full

FNLMinusLin = SSfNLMinusLin/MSE;

fprintf('\nr2 of NL model =%.3f\n',r2NL); % r2=0.4732
fprintf('r2 of Linear model =%.3f\n\n',r2Lin); % r2Lin=0.466
fprintf('SSExplainedNL=%.3f\n',SSExplainedNL); % =6.738
fprintf('SSExplainedLin=%.3f\n',SSExplainedLin); % =6.643
fprintf('F =%.3f\n',FNLMinusLin); % F=0.126

pNLMinusLin = mFCDF(FNLMinusLin, numparamsLin-1, n-numparamsNL);
fprintf('p-value of NL Minus Lin model = %.3f\n',pNLMinusLin); %=0.730

% PLOT LINEAR MODEL
b0 = paramsLin(1); b1 = paramsLin(2);
yhatforlineLIN = b1.*xforline + b0; % points on line.
figure(1); hold on; plot(xforline,yhatforlineLIN,'k--'); %

% END OF FILE.
