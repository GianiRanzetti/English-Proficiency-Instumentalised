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

keep if lngdp ~= .
gen pwxgdp=(pwlinear*lngdp)/100

// Effect of english on marital status
ivreg marriedpresent (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* pwxgdp [aw=perwt2], cluster(bpld)
estimates store marriedpresent_tab5

ivreg divorced (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* pwxgdp [aw=perwt2], cluster(bpld)
estimates store divorced_tab5

ivreg evermarried (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* pwxgdp [aw=perwt2], cluster(bpld)
estimates store evermarried_tab5

keep if datanum==1

ivreg share_bpld_minusself (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* pwxgdp [aw=perwt2], cluster(bpld)
estimates store share_bpld_minusself_tab5

ivreg abovemean_bpld2 (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* pwxgdp [aw=perwt2], cluster(bpld)
estimates store abovemean_bpld2_tab5

ivreg ancestpct_minusself (eng = idvar) agearr1-agearr14 dumage* female black asianpi other multi hispdum dbpld* pwxgdp [aw=perwt2], cluster(bpld)
estimates store ancestpct_minusself_tab5

ivreg abovemean_ancestry2 (eng = idvar) agearr1-agearr14 dumage* female black asianpi other hispdum multi dbpld* pwxgdp [aw=perwt2], cluster(bpld)
estimates store abovemean_ancestry2_tab5

esttab marriedpresent_tab5 divorced_tab5 evermarried_tab5 share_bpld_minusself_tab5 abovemean_bpld2_tab5 ancestpct_minusself_tab5 abovemean_ancestry2_tab5 using  "$output/Table5/Table5_gdp.csv", keep(eng)
