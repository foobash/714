% Richard Shea
% Johns Hopkins Math 625.714 (SDE)
% Final Project
% Attempt to use DHR model from CAPTAIN Toolbox 
% Attemp is on non-stationary daily sales data (Rossmann)

clear all;

M = csvread('F:\personal\JHU\625.714\project_714\R_Code\Store_909.csv');
%Randomly select 144 ordered data points. 
%Max = length(M) - 365;
%S = randperm(Max,1);
S = 1;
End = S + 364;
%sales = M;
sales = M(S:End);
E = length(sales);



y=fcast(sales, [84 94; (E-10) E]);

%y=fcast(sales, [740 750; 131 144]);

figure(1)

plot([sales y])
title(['Interpolation & Forecast Starting Starting at Day ' num2str(S)])

% We first call DHROPT to optimise the Noise Variance
% Ratio (NVR) hyper-parameters.
 
% We will use a trend component and 5 harmonics.
 
%P=[0 12./(1:5)]
S0 = 365
s = (S0-1)/2 
P=[0 S0./(1:(s-1))]
% P =
%          0   12.0000    6.0000    4.0000    3.0000    2.4000
 
% All of the parameters will be modelled with
% an Integrated Random Walk (IRW).

TVP=1;
 
% The order of the AR spectrum is specified below.
 
nar=21;

% ESTIMATING HYPER-PARAMETERS : PLEASE WAIT
figure(2)

nvr=dhropt(y, P, TVP, nar);
%nvr = dhropt(sales, P, TVP);

% The plot compares the estimated and fitted spectra.

% ??? Can we make the spectra fit better???

% The DHR function utilises the optimsed NVR values.
 
[fit, fitse, trend, trendse, comp]=dhr(y, P, TVP, nvr);
%[fit, fitse, trend, trendse, comp]=dhr(y, P, [1], [0.001 0.01], [0.95 1]);
% The trend identifies the business cycle.

figure(3)
plot([trend(:, 1) sales])
set(gca, 'xlim', [0 length(sales)])
title('Data and trend')

% The seasonal component increases over time.
 
figure(4)
plot(sum(comp'))
set(gca, 'xlim', [0 length(sales)])
title('Total seasonal component')

% The functions successfully interpolate over the 10 months
% of missing data starting at sample 85. Similarly, they predict
% the output for the final year, i.e. sample 132 until the end
% of the series. Note that since missing data were introduced at
% the start of the analysis, the latter is a 'true' forecast.
 
figure(5)
plot(fit, 'b')
hold on
plot(sales, 'r')
%plot([fit-sales zeros(144, 1)], 'b')% This needs to match fit and sales dim
plot([fit-sales zeros(E, 1)], 'b') % This needs to match fit and sales dim.
plot([84, 84], [-50 50], 'r')  % start of interpolation
plot([94, 94], [-50 50], 'r')  % end of interpolation
plot([130, 130], [-50 50], 'r')  % forecasting horizon
set(gca, 'xlim', [0 length(sales)])
title('Data, fit and residuals')
 
% A zoomed in view of the final two years are shown, with
% the standard errors and forecasting horizon also indicated.
 
%%%!!!!! Do not understand (yet) why below is not working for my data !!!

%% Sent email to Young
figure(6)
plot(fit, 'b')
hold on
plot(sales, 'ro')
plot([fit+2*fitse fit-2*fitse], ':b')
plot([130, 130], [200 700], 'r')  % forecasting horizon
axis([119 length(fit) 250 700])
title('Data (o), fit and standard errors')
 
%end of demo.  

