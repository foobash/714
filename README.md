# 714
SDE Project

Richard_Shea_625.714_Final_Project.pdf is the report of what I did.

Data:

train.zip contains the data needed to load into beta1.R.  This is the Rossmann Store (sales) data. 

Store_909.csv is needed to run project714_beta.m

MATLAB file:

project714_beta1.m is a MATLAB file using CAPTAIN toolbox.  A failed attempt to model daily daily with Dynamic Harmonic Regression.  I think the dhr() only allows a maximum of 52 periods (not 365).  I sent an email to Young with my errors.  

R files:

beta_1.R needs to be ran first with train.zip unpacked in working directory.  This starts the The Priestley-Subba Rao (PSR) Test 

beta_2.R is a continuation (for loop) loaded after beta_1.R

beta_3.R exports the nonstationary data.

FPP_beta1.R is the contingecy after the failed MATLAB attempt. Most results were obatined from this script.

EOQ.R is a simple Economic Order Quantity and toy exmaple of Stochastic Inventory Control using the R 'SCperf' package.  

Any questions or comments, please feel free to email me at rshea5@jhu.edu  











