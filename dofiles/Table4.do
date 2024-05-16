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

// Table 4 Regressions, OLS and IV on Residencial outcomes
keep if datanum==1

// Full sample
reg share_bpld_minusself eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2],  cluster(bpld)
estimates store minusself_ols_tab4

ivreg share_bpld_minusself (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store minusself_iv_tab4

reg abovemean_bpld2 eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2],  cluster(bpld)
estimates store abovemean_ols_tab4

ivreg abovemean_bpld2 (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store abovemean_iv_tab4

reg ancestpct_minusself eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2],  cluster(bpld)
estimates store ancestpct_ols_tab4

ivreg ancestpct_minusself (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store ancestpct_iv_tab4

reg abovemean_ancestry2 eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2],  cluster(bpld)
estimates store ancestry2_ols_tab4

ivreg abovemean_ancestry2 (eng = idvar) agearr1-agearr14 dumage* female black asianpi other hispdum multi dbpld* [aw=perwt2], cluster(bpld)
estimates store ancestry2_iv_tab4

esttab minusself_ols_tab4 minusself_iv_tab4 abovemean_ols_tab4 abovemean_iv_tab4 ancestpct_ols_tab4 ancestpct_iv_tab4 ancestry2_ols_tab4 ancestry2_iv_tab4 using  "$output/Table4/Table4_full.csv", keep(eng)

// Female sample
reg share_bpld_minusself eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1,  cluster(bpld)
estimates store minusself_ols_tab4_fem

ivreg share_bpld_minusself (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1, cluster(bpld)
estimates store minusself_iv_tab4_fem

reg abovemean_bpld2 eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1,  cluster(bpld)
estimates store abovemean_ols_tab4_fem

ivreg abovemean_bpld2 (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1, cluster(bpld)
estimates store abovemean_iv_tab4_fem

reg ancestpct_minusself eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1,  cluster(bpld)
estimates store ancestpct_ols_tab4_fem

ivreg ancestpct_minusself (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1, cluster(bpld)
estimates store ancestpct_iv_tab4_fem

reg abovemean_ancestry2 eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female ==1,  cluster(bpld)
estimates store ancestry2_ols_tab4_fem

ivreg abovemean_ancestry2 (eng = idvar) agearr1-agearr14 dumage* female black asianpi other hispdum multi dbpld* [aw=perwt2] if female ==1, cluster(bpld)
estimates store ancestry2_iv_tab4_fem

esttab minusself_ols_tab4_fem minusself_iv_tab4_fem abovemean_ols_tab4_fem abovemean_iv_tab4_fem ancestpct_ols_tab4_fem ancestpct_iv_tab4_fem ancestry2_ols_tab4_fem ancestry2_iv_tab4_fem using  "$output/Table4/Table4_fem.csv", keep(eng)

// Male sample
reg share_bpld_minusself eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female == 0,  cluster(bpld)
estimates store minusself_ols_tab4_men

ivreg share_bpld_minusself (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female == 0, cluster(bpld)
estimates store minusself_iv_tab4_men

reg abovemean_bpld2 eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female == 0,  cluster(bpld)
estimates store abovemean_ols_tab4_men

ivreg abovemean_bpld2 (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female == 0, cluster(bpld)
estimates store abovemean_iv_tab4_men

reg ancestpct_minusself eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female == 0,  cluster(bpld)
estimates store ancestpct_ols_tab4_men

ivreg ancestpct_minusself (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female == 0, cluster(bpld)
estimates store ancestpct_iv_tab4_men

reg abovemean_ancestry2 eng agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2] if female == 0,  cluster(bpld)
estimates store ancestry2_ols_tab4_men

ivreg abovemean_ancestry2 (eng = idvar) agearr1-agearr14 dumage* female black asianpi other hispdum multi dbpld* [aw=perwt2] if female == 0, cluster(bpld)
estimates store ancestry2_iv_tab4_men

esttab minusself_ols_tab4_men minusself_iv_tab4_men abovemean_ols_tab4_men abovemean_iv_tab4_men ancestpct_ols_tab4_men ancestpct_iv_tab4_men ancestry2_ols_tab4_men ancestry2_iv_tab4_men using  "$output/Table4/Table4_men.csv", keep(eng)

