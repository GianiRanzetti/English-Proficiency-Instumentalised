cls
clear all

cd "/Users/gianiranzetti/Desktop/NOVA/Micro-Econometrics/assignment/113738-V1"

global dofile  "/Users/gianiranzetti/Desktop/NOVA/Micro-Econometrics/assignment/Assignment_file_Group_8/dofiles"

global data "/Users/gianiranzetti/Desktop/NOVA/Micro-Econometrics/assignment/Assignment_file_Group_8/data"

global output  "/Users/gianiranzetti/Desktop/NOVA/Micro-Econometrics/assignment/Assignment_file_Group_8/output"

cd "$dofile"

// Summary Statistic table
do "$dofile/Table1.do"

// OLS regression using idicator variable
do "$dofile/Table2.do"

// OLS and IV regression on marriage outcomes
do "$dofile/Table3.do"

// OLS and IV regression on residencial outcomes
do "$dofile/Table4.do"

// OLS and IV regression on marriage residencial outcomes with alternative samples and specifications

// Controlling for country of origin GDP
do "$dofile/Table5_gdp.do"

// Controlling for fertility of country of origin
do "$dofile/Table5_frt.do"

// Controlling for canadian immigrants
do "$dofile/Table5_no_canada.do"

// Controlling for mexican immigrants
do "$dofile/Table5_no_mexico.do"

// Linear Index Models model
do "$dofile/Table6.do"

