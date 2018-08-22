# Richard Shea
# Math 625.714 Stochastic Forecast (and Control?) Project

# Here we need to load data, then find nonstationary time series.
# Hopefully we will use CAPTAIN in MATLAB

#set working directory to keep organized.
#setwd("F:/personal/JHU/625.714/project_714/R_Code")
#setwd("E:/personal/JHU/625.714/project_714/R_Code")

library('aTSA') # need for adf.test

library('xts') # needed for xts function

library("fractal")
library("astsa")

mydata <- read.csv("train.csv")  # read csv file and create data.frame

#mydata$Date <- as.Date(mydata$Date , "%m/%d/%y")

mydata[[3]] <- as.Date(mydata[[3]]) # set Date colum as date (R very picky about Date formats)

#mydata2 <- subset(mydata, select=c("Date", "Store","Sales")) #grab desired data

#store1 <- subset(mydata2, select=c("Sales","Store" == 1)) #grab store 1 for test purposes.

#store1 <- newdata <- mydata2[ which(mydata2$gender=='F' & mydata$age > 65), ]

# create empty data frame for PSR results.  
psr.df <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("Store", "p-value") # column names.  
colnames(psr.df) <- x

i <- 1047  # first store. 

store <- subset(mydata,Store == i, select=c(Date,Sales)) #grab store 1 for test purposes.

store.xts <- xts(store$Sales, as.Date(store$Date, format='%m/%d/%Y')) # change to time series df.

#store.sales <- store$Sales

#adf.test(store.xts)

#kpss.test(store.xts)

#par(mar=c(1,1,1,1)) # use if margins too large

acf(store.xts)

# The Priestley-Subba Rao (PSR) Test  
stat.p <- attr(stationarity(store.xts),"pvals")[1] # store first p-value for T


psr.df[nrow(psr.df)+1,] <-c(i, stat.p) # add store and p value to results.

TS <- ts(store.xts, frequency = 365, start=c(2013,1)) #create ts for components

store.components <- decompose(TS) # store components

plot(store.components) # plot components seperately.  
