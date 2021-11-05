% File: Ch2MatLab.m.

% load data
x=[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]';
y=[3.34 4.97 4.15 5.40 5.21 4.56 3.69 5.86 4.58 6.94 5.57 5.62 6.87]';

n = length(y); % number of data points.

% Estimate slope.
xmean = mean(x);
ymean = mean(y);
numerator = sum( (x-xmean) .* (y-ymean) ) / n;
denominator = sum( (x-xmean).^2 ) / n;
b1 = numerator/denominator; % slope

% Estimate intercept.
b0 = ymean - b1*xmean;

fprintf('Slope = %.3f\n',b1);        % 0.764
fprintf('Intercept = %.3f\n',b0);   % 3.225

yhat = b1*x + b0;
r2 = var(yhat,1) / var(y,1); % 0.4665

% Plot best fitting line through data.
xforline = 0:0.1:6;
yhatforline = b1.*xforline + b0; % points on line.

% Plot fitted line xest (=xhat in text) and data points.
figure(1); clf; hold on;
plot(xforline,yhatforline,'k--'); % plot best fitting line.
plot(x,y, 'k.', 'MarkerSize',20); % plot data.
set(gca,'Linewidth',2); 
set(gca,'FontSize',20);
xlabel('Salary, {\it x} (groats)');
ylabel('Height, {\it y} (feet)');
set(gca,'XLim',[0 5],'FontName','Times');
set(gca,'YLim',[0 8],'FontName','Times');
box on;

% END OF FILE.
