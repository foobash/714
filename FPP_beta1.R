# Richard Shea
# Math 625.714 Stochastic Forecast (and Control?) Project


#set working directory to keep organized.
#setwd("F:/personal/JHU/625.714/project_714/R_Code")
#setwd("E:/personal/JHU/625.714/project_714/R_Code")

# The following packages need to be installed  

library('aTSA') # need for adf.test

library('xts') # needed for xts function

library("fractal")
library("astsa")

library("fpp") # need for Forecasting: Principles and Practice

library("ggplot2")


#load non_stationary stores generated from beta_3.R

stores <- read.csv("nonstationary_stores.csv")

stores[[3]] <- as.Date(stores[[3]]) # set Date colum as date (R very picky about Date formats)

i <- 837  # set nonstationary store to select here.

store <- subset(stores,Store == i, select=c(Date,Sales)) # select store


store.xts <- xts(store$Sales, as.Date(store$Date, format='%m/%d/%Y')) # change to time series df.

# Create some frequency time series.  

y <- ts(store$Sales, start=c(2013,1,1), frequency = 365.25)
y7 <- ts(store$Sales, start=c(2013,1,1), frequency = 7)



#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# now lets look at some deterministic vs. stochastic forecasting

test2 <- window(y, start=c(2014), end = c(2015))
# take the trend of our test data, deterministically.
trend <- seq_along(test2)
#(fit1 <- auto.arima(test, d=0, xreg=trend))
(fit1 <- Arima(test2, xreg=trend, order = c(0, 0, 0)))

# Coefficients:
#   ar1      ar2  intercept    trend
# -0.0542  -0.0296  3584.7368  -0.0226

#Now for the stochastic trend model

(fit2 <- Arima(test2, order = c(0,1,1), include.drift = TRUE))

# Coefficients:
#   ma1    drift
# -1.0000  -0.0266

# Observe that the trend = drift = -0.0266

# But lets take the forecast horizon:

fc1 <- forecast(fit1,
                xreg = cbind(trend = length(test2) + 1:30))

fc2 <- forecast(fit2, h=30)

autoplot(window(test2, start=c(2014,360))) +
  autolayer(fc2, series="Stochastic trend") +
  autolayer(fc1, series="Deterministic trend") +
  ggtitle("Forecasts from trend models") +
  xlab("Year") + ylab("Sales") +
  guides(colour=guide_legend(title="Forecast"))

# Observe the stochastic window is wider due to the assumed nonstationary errors.


# Create plot of Store = i.
autoplot(y) +
  ggtitle(paste0("Store ", i)) +
  xlab("Year") +
  ylab("Sales")

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Now let us look at something more sophisticated.  

test <- window(y,start=2013, end= c(2015,15)) # test data to model up to 2015. 

days =30 # set horizon here

storefit1 <- meanf(test,h=days) # mean
storefit2 <- rwf(test,h=days) # random walk
storefit3 <- snaive(test,h=days) # Seasonal naive.

#plot superimposed graph
autoplot(window(y, start=c(2014,360), end = c(2015,60))) + # these are days, have to +1 on end?
  autolayer(storefit1, series="Mean", PI=FALSE) +
  autolayer(storefit2, series="Naïve", PI=FALSE) +
  autolayer(storefit3, series="Seasonal naïve", PI=FALSE) +
  xlab("Year") + ylab("Sales") +
  ggtitle("Forecasts for daily store sales") +
  guides(colour=guide_legend(title="Forecast"))


# Now run some accuracy metrics

store3 <- window(y, start=2013, end = c(2015,16)) # 2015 = c(2015,1), so add 1 for horizon.
accuracy(storefit1, store3)
accuracy(storefit2, store3)
accuracy(storefit3, store3)

# we just saw accuracy measurements fore naive forecasting to our nonstationary data.



#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#Now for seasonality 


i = 52 #52 works good.  

fit <- auto.arima(y, seasonal= FALSE, xreg=fourier(y, K=i)) # works with K = 4,10 on store 349

autoplot(forecast(fit,
                  xreg=fourier(y, K=i, h=30)))


fit <- auto.arima(y, seasonal= FALSE, xreg=fourier(y, K=c(7,52))) # works with K = 4,10 on store 349

autoplot(forecast(fit,
                  xreg=fourier(y, K=c(1,4), h=30)))

# Multi seasonal
y <- msts(y, c(7,365)) # multiseasonal ts
fit <- auto.arima(y, seasonal=F, xreg=fourier(y, K=c(3,30)))
fit_f <- forecast(fit, xreg= fourierf(y, K=c(3,30), 180), 180)
plot(fit_f)

# another attempt
y7 <- msts(y, c(7,52,365)) # multiseasonal ts
# Now remember our period <= K/2 for each element of our vector.
fit7 <- auto.arima(y7, seasonal=F, xreg=fourier(y7, K=c(3,7,100)))
fit_f <- forecast(fit7, xreg= fourier(y7, K=c(2,20,30), 180), 180)
plot(fit_f)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
# TBATS fit attempt and fail
  
fit2 <- tbats(y,seasonal.periods = c(7,52,365.25))
fc2 <- forecast(fit2, h=30)
autoplot(fc2) 

#y2 <- msts(y7,seasonal.periods=c(7,30.4, 365.25))

fity2 <- tbats(yclean, seasonal.periods = c(7,30.4, 365.25))

fc_y2 <- forecast(fity2)

plot(fc_y2)


##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# SARIMA attempt, but run out of RAM.  

x <- y7


fitx <- sarima(x,2,1,0,0,1,1,50) #Produces error, run out of RAM at 7.7GB



