# Richard Shea
# Math 625.714 Stochastic Forecast (and Control?) Project

# needs beta_1 loaded.  May also be dependent on beta_2
# Now we have our stores with pvalues
# grab these store values
# analyzise in R.
# setup data for CAPTAIN.

stores.pzero <- read.csv("zero_pvalue.csv")  # read csv file and create data.frame

m = merge(mydata, stores.pzero, by="Store")

write.csv(m, "nonstationary_stores.csv")

# Aggreate datat (attempt)

stores.totalsales <- aggregate(m[c("Sales")], list(Store = m$Store), FUN = sum)

write.csv(stores.totalsales,"nonstationary_stores_totals.csv")