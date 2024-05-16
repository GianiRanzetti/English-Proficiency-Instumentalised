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

// Creates Categorical variables: eng1 = Speaks English not well, eng2 = Speaks english well, eng3 = Speakes very well, eng = ordinal english speaking ability measure
gen eng1=eng>=1
replace eng1=. if eng==.
gen eng2=eng>=2
replace eng2=. if eng==.
gen eng3=eng>=3
replace eng3=. if eng==.

// Regressions for Table 2, only the coefficient on the indicator function 'tr9' are reported in the report
reg eng1 tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store eng1_tab2

reg eng2 tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store eng2_tab2

reg eng3 tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store eng3_tab2

reg eng tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store eng_tab2

reg marriedpresent tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store marriedpresent_tab2


reg divorced tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store divorced_tab2

reg evermarried tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store evermarried_tab2

reg nchild tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store nchild_tab2

reg haskid tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store haskid_tab2

reg singleparent tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store singleparent_tab2

reg nevermarried_haskid tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store nevermarried_tab2

keep if datanum==1

reg share_bpld_minusself tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store minusself_tab2

reg abovemean_bpld2 tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store abovemean_tab2

reg ancestpct_minusself tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store ancestpct_tab2

reg abovemean_ancestry2 tr9 agearr1-agearr17 dumage* female black asianpi other multi hispdum dbpld* [aw=perwt2], cluster(bpld)
estimates store ancestry2_tab2

// Table 2 coeeficients are saved as a CSV for Report formatting 
esttab eng1_tab2 eng2_tab2 eng3_tab2 eng_tab2 marriedpresent_tab2 divorced_tab2 evermarried_tab2 nchild_tab2 haskid_tab2 singleparent_tab2 nevermarried_tab2 minusself_tab2 abovemean_tab2 ancestpct_tab2 ancestry2_tab2 using "$output/Table2/Table2.csv", keep(tr9)
