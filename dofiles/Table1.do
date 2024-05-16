cls
clear all

use "$data/p00use_mf_indiv.dta"

// Data transformation
keep if eng ~= .
gen young9 = agearr <= 9

// Grouping variables for readibility
global sumlist "eng age female white black asianpi other multi hispdum yrssch marriedpresent divorced evermarried nchild haskid singleparent nevermarried_haskid share_bpld_minusself abovemean_bpld2 ancestpct_minusself abovemean_ancestry2  [aw=perwt2] "

// Creating Table 1: Means of variables
sum $sumlist
estpost sum $sumlist
esttab using "$output/Table1/sum1.csv", cells("mean sd min max") replace

estpost sum $sumlist if nengdom==1
esttab using "$output/Table1/sum2.csv", cells("mean sd min max") replace

estpost sum $sumlist if nengdom==1 & young9 == 1
esttab using "$output/Table1/sum3.csv", cells("mean sd min max") replace

estpost sum $sumlist if nengdom==1 & young9 == 0
esttab using "$output/Table1/sum4.csv", cells("mean sd min max") replace

estpost sum $sumlist if nengdom==0
esttab using "$output/Table1/sum5.csv", cells("mean sd min max") replace

estpost sum $sumlist if nengdom==0 & young9 == 1
esttab using "$output/Table1/sum6.csv", cells("mean sd min max") replace

estpost sum $sumlist if nengdom==0 & young9 == 0
esttab using "$output/Table1/sum7.csv", cells("mean sd min max") replace

/// Creating figure 1 which tests if english profficiency is different between treatemnt and control at age 9

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

// Loop over the agearr dummy variables
forval i = 1/14 {
    // Create the interaction term
    gen agearr`i'_nengdom = agearr`i' * nengdom
}

quietly tab age, gen(dumage)
drop dumage1

reg eng agearr1-agearr14 agearr1_nengdom-agearr14_nengdom dumage* female black asianpi other multi hispdum [aw=perwt2], cluster(bpld)
estimates store eng_hat

esttab eng_hat using "$output/Table1/Figure1/Figure1.csv", replace

collapse (mean) eng, by(agearr nengdom)

twoway (line eng agearr if nengdom == 1, sort) ///
       (line eng agearr if nengdom == 0, sort), ///
       xtitle(Age at arrival in the US) ytitle("Average English Ability") ///
       legend(label(1 "Non English Speaking Country") label(2 "English Speaking Country") ///
       rows(1) position(6))

graph export "$output/Table1/Figure1/Figure1A.png", replace

reshape wide eng, i(agearr) j(nengdom)
gen diff = eng1 - eng0

twoway (line diff agearr, sort), ///
       xtitle("Age at arrival in the US") ///
       ytitle("Difference in English Ability") ///
       legend(label(1 "Difference"))

graph export "$output/Table1/Figure1/Figure1B.png", replace

/// Creating Figure 2

use "$data/p00use_mf_indiv.dta", clear

collapse (mean) marriedpresent, by(agearr nengdom)

twoway (line marriedpresent agearr if nengdom == 1, sort) ///
       (line marriedpresent agearr if nengdom == 0, sort), ///
       xtitle(Age at arrival in the US) ytitle("Is married with spouse present") ///
       legend(label(1 "Non English Speaking Country") label(2 "English Speaking Country") ///
       rows(1) position(6))
	   
graph export "$output/Table1/Figure2/Figure2A.png", replace

reshape wide marriedpresent, i(agearr) j(nengdom)
gen diff2 = marriedpresent0 - marriedpresent1

twoway (line diff2 agearr, sort), ///
       xtitle("Age at arrival in the US") ///
       ytitle("Difference in Marriage Prob") ///
       legend(label(1 "Difference"))

graph export "$output/Table1/Figure2/appendixdiff/Figure2A.png", replace

use "$data/p00use_mf_indiv.dta", clear

collapse (mean) nchild, by(agearr nengdom)

twoway (line nchild agearr if nengdom == 1, sort) ///
       (line nchild agearr if nengdom == 0, sort), ///
       xtitle(Age at arrival in the US) ytitle("Number of children living in same household") ///
       legend(label(1 "Non English Speaking Country") label(2 "English Speaking Country") ///
       rows(1) position(6))
	   
graph export "$output/Table1/Figure2/Figure2B.png", replace

reshape wide nchild, i(agearr) j(nengdom)
gen diff3 = nchild0 - nchild1

twoway (line diff3 agearr, sort), ///
       xtitle("Age at arrival in the US") ///
       ytitle("Difference in mean # of children") ///
       legend(label(1 "Difference"))

graph export "$output/Table1/Figure2/appendixdiff/Figure2B.png", replace

use "$data/p00use_mf_indiv.dta", clear

collapse (mean) divorced, by(agearr nengdom)

twoway (line divorced agearr if nengdom == 1, sort) ///
       (line divorced agearr if nengdom == 0, sort), ///
       xtitle(Age at arrival in the US) ytitle("Probability of Divorce") ///
       legend(label(1 "Non English Speaking Country") label(2 "English Speaking Country") ///
       rows(1) position(6))
	   
graph export "$output/Table1/Figure2/Figure2C.png", replace

reshape wide divorced, i(agearr) j(nengdom)
gen diff4 = divorced1 - divorced0

twoway (line diff4 agearr, sort), ///
       xtitle("Age at arrival in the US") ///
       ytitle("Difference in Divorce probability") ///
       legend(label(1 "Difference"))

graph export "$output/Table1/Figure2/appendixdiff/Figure2C.png", replace

use "$data/p00use_mf_indiv.dta", clear

collapse (mean) share_bpld_minusself, by(agearr nengdom)

twoway (line share_bpld_minusself agearr if nengdom == 1, sort) ///
       (line share_bpld_minusself agearr if nengdom == 0, sort), ///
       xtitle(Age at arrival in the US) ytitle("Fraction of PUMA population from same country") ///
       legend(label(1 "Non English Speaking Country") label(2 "English Speaking Country") ///
       rows(1) position(6))
	  
graph export "$output/Table1/Figure2/Figure2D.png", replace

reshape wide share_bpld_minusself, i(agearr) j(nengdom)
gen diff5 = share_bpld_minusself0 - share_bpld_minusself1

twoway (line diff5 agearr, sort), ///
       xtitle("Age at arrival in the US") ///
       ytitle("Difference in Living in Ethnic Enclave prob") ///
       legend(label(1 "Difference"))

graph export "$output/Table1/Figure2/appendixdiff/Figure2D.png", replace

