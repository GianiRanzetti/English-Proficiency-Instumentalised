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

* reg eng idvar agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)

// Regressions for Table 3, IV and OLS on Marriage outcomes, only the coefficient on 'eng' are reported in the report

// Full sample
reg marriedpresent eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store marriedpresent_ols_tab3

ivreg marriedpresent (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store marriedpresent_iv_tab3

reg divorced eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2],  cluster(bpld)
estimates store divorced_ols_tab3

ivreg divorced (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store divorced_iv_tab3

reg evermarried eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2],  cluster(bpld)
estimates store evermarried_ols_tab3

ivreg evermarried (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store evermarried_iv_tab3

esttab marriedpresent_ols_tab3 marriedpresent_iv_tab3 divorced_ols_tab3 divorced_iv_tab3 evermarried_ols_tab3 evermarried_iv_tab3 using  "$output/Table3/Table3_full.csv", keep(eng)

// Women
reg marriedpresent eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1, cluster(bpld)
estimates store marriedpresent_ols_tab3_fem

ivreg marriedpresent (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1, cluster(bpld)
estimates store marriedpresent_iv_tab3_fem

reg divorced eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1,  cluster(bpld)
estimates store divorced_ols_tab3_fem

ivreg divorced (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1, cluster(bpld)
estimates store divorced_iv_tab3_fem

reg evermarried eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1,  cluster(bpld)
estimates store evermarried_ols_tab3_fem

ivreg evermarried (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1, cluster(bpld)
estimates store evermarried_iv_tab3_fem

esttab marriedpresent_ols_tab3_fem marriedpresent_iv_tab3_fem divorced_ols_tab3_fem divorced_iv_tab3_fem evermarried_ols_tab3_fem evermarried_iv_tab3_fem using  "$output/Table3/Table3_fem.csv", keep(eng)

// Men
reg marriedpresent eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==0, cluster(bpld)
estimates store marriedpresent_ols_tab3_men

ivreg marriedpresent (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==0, cluster(bpld)
estimates store marriedpresent_iv_tab3_men

reg divorced eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==0,  cluster(bpld)
estimates store divorced_ols_tab3_men

ivreg divorced (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==0, cluster(bpld)
estimates store divorced_iv_tab3_men

reg evermarried eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==0,  cluster(bpld)
estimates store evermarried_ols_tab3_men

ivreg evermarried (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==0, cluster(bpld)
estimates store evermarried_iv_tab3_men

esttab marriedpresent_ols_tab3_men marriedpresent_iv_tab3_men divorced_ols_tab3_men divorced_iv_tab3_men evermarried_ols_tab3_men evermarried_iv_tab3_men using  "$output/Table3/Table3_men.csv", keep(eng)
