cls
clear all

use "$data/p00use_mf_indiv.dta"

// Program/ Function to create Dummy for Age arrived to US
capture program drop makedum1
program define makedum1
	local i = 0
	while `i' <= 17 {
		gen agearr`i' = agearr == `i'
	local i = `i' + 1
	}
end

// Data transformation
keep if eng ~= .
gen young9 = agearr <= 9

makedum1

quietly tab age, gen(dumage)
drop dumage1

// Creates the parameterazation of arriving after 9 years old
gen pwlinear = max(0,agearr-9)
gen tr9 = pwlinear*nengdom

quietly tab bpld, gen(dbpld)
drop dbpld1

gen idvar = pwlinear*nengdom

// Regressions for Table 6, IV probit on Marriage outcomes, only the coefficient on 'eng' are reported in the report
// Automatic Tabulation of estimates did not work well so we manually wrote each marginal effect in the final report table

// Full sample
reg eng idvar agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
predict res_full, resid

probit marriedpresent eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* res_full [pw=perwt2]
margins, dydx(eng)
estimates store married_full_table6

probit divorced eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* res_full [pw=perwt2]
margins, dydx(eng)
estimates store divorced_full_table6

probit evermarried eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* res_full [pw=perwt2]
margins, dydx(eng)
estimates store evermarried_full_table6

esttab married_full_table6 divorced_full_table6 evermarried_full_table6 using  "$output/Table6/Table6_full.csv", keep(eng) replace

// Women
reg eng idvar agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1, cluster(bpld)
predict res_fem, resid

probit marriedpresent eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* res_fem [pw=perwt2] if female ==1
margins, dydx(eng)
estimates store married_fem_table6

probit divorced eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* res_fem [pw=perwt2] if female ==1
margins, dydx(eng)
estimates store divorced_fem_table6

probit evermarried eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* res_fem [pw=perwt2] if female ==1
margins, dydx(eng)
estimates store evermarried_fem_table6

esttab married_fem_table6 divorced_fem_table6 evermarried_fem_table6 using  "$output/Table6/Table6_fem.csv", keep(eng) replace

// Men
reg eng idvar agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1, cluster(bpld)
predict res_man, resid

probit marriedpresent eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* res_man [pw=perwt2] if female ==0
margins, dydx(eng)
estimates store married_men_table6

probit divorced eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* res_man [pw=perwt2] if female ==0
margins, dydx(eng)
estimates store divorced_men_table6

probit evermarried eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* res_man [pw=perwt2] if female ==0
margins, dydx(eng)
estimates store evermarried_men_table6

esttab married_men_table6 divorced_men_table6 evermarried_men_table6 using  "$output/Table6/Table6_men.csv", keep(eng) replace
