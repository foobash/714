# Richard Shea
# Math 625.714 Stochastic Forecast (and Control?) Project

# This is a for loop for beta_1.R
# we want to store the PSR values for all 1115 stores.


# create empty data frame for PSR results.  
psr.df <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("Store", "p-value") # column names.  
colnames(psr.df) <- x

for (i in 1:1115){
  store <- subset(mydata,Store == i, select=c(Date,Sales)) #grab store 1 for test purposes.
  
  store.xts <- xts(store$Sales, as.Date(store$Date, format='%m/%d/%Y')) # change to time series df.
  
  
  # The Priestley-Subba Rao (PSR) Test  
  stat.p <- attr(stationarity(store.xts),"pvals")[1] # store first p-value for T
  
  
  psr.df[nrow(psr.df)+1,] <-c(i, stat.p) # add store and p value to results.
  
}

write.csv(psr.df, "psr.csv")

