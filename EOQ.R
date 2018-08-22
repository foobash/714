# Richard Shea
# Math 625.714 Stochastic Forecast (and Control?) Project

library('SCperf')


d = 4000 #Let our mean demand be 4,000 from our forecast
c = 300000 # Total holding cost
hc = 0.3
p = 100  # zero shortage penalty.  

EOQ(d,c,hc,p)

# Q        T   TVC 
# 89443    22 26833 

#  For stochastics

# We use the Newsboy() model

m = 100 # mean demand 
sd = 30 # 
p = 4 # selling price
c = 1 # unit cost. 

Newsboy(m,sd,p,c)
