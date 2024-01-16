clear all
log using "/Users/hrp/Desktop/BU/EC204/Research Project/Stata Analysis/educ_on_married_FINAL.log", replace
use "/Users/hrp/Desktop/BU/EC204/Research Project/Stata Analysis/educ_rev_on_married_FINAL_ORIGINAL.dta"

**************************DATA CLEANING****************************************

**cleaning and recoding the EDUC variable**
replace educ = . if educ == 1
gen educ_rev = educ
replace educ_rev = 0 if educ == 2
replace educ_rev = 4 if educ == 10
replace educ_rev = 6 if educ == 20
replace educ_rev = 8 if educ == 30
replace educ_rev = 9 if educ == 40
replace educ_rev = 10 if educ == 50
replace educ_rev = 11 if educ == 60 | educ == 71
replace educ_rev = 12 if educ == 73
replace educ_rev = 13 if educ == 81
replace educ_rev = 14 if educ == 91 | educ == 92
replace educ_rev = 16 if educ == 111
replace educ_rev = 18 if educ == 123
replace educ_rev = 21 if educ == 124 | educ == 125
replace educ_rev = . if educ == .
drop if educ_rev == .

**Creating the married dummy variable from marst**
gen married = marst 
replace married = 1 if marst == 1
replace married = 1 if marst == 2
replace married = 0 if marst == 3
replace married = 0 if marst == 4
replace married = . if marst == 5
replace married = 0 if marst == 6
drop if married == .

**Cleaning race variable**
replace race = . if race == 820
replace race = . if race == 830
replace race = . if race == 700
replace race = . if race == 999
drop if race == .

**Cleaning region Variable**
replace region = . if region == 97
drop if region == .

**Cleaning metro variable**
replace metro = . if metro == 0
replace metro = . if metro == 4
replace metro = . if metro == 9
drop if metro == .

**creating female DV**
gen female = 1
replace female = 0 if sex == 1

**Creating white DV**
gen white = 0
replace white = 1 if race == 100

**Creating North DV**
gen north = 1
replace north = 0 if region == 31
replace north = 0 if region == 32
replace north = 0 if region == 33

**Creating East DV**
gen east = 1
replace east = 0 if region == 41
replace east = 0 if region == 42
replace east = 0 if region == 22
replace east = 0 if region == 33

**Creating City DV**
gen city = 1 
replace city = 0 if metro == 1

**Creating alternate variables for regression**
gen educ_rev_sq = educ_rev*educ_rev
gen educ_rev_cu = educ_rev*educ_rev*educ_rev
gen leduc_rev = ln(educ_rev)

*Create Interaction Terms*
gen educ_female = educ_rev*female
gen educ_white = educ_rev*white
gen educ_city = educ_rev*city

***************************DESCRIPTIVE STATS***********************************

**Table 2**
outreg2 using table2.doc, replace sum(log) keep(married educ_rev age white taxinc female north east city) eqkeep(mean sd min max)

**Table 3**
bys married: outreg2 using table3a.doc, replace sum(log) keep(educ_rev age white taxinc female north east city) eqkeep(mean sd N) title(Summary Statistics by Married)

bys white: outreg2 using table3b.doc, replace sum(log) keep(married educ_rev age taxinc female north east city) eqkeep(mean sd N) title(Summary Statistics by White)

bys female: outreg2 using table3c.doc, replace sum(log) keep(married educ_rev age white taxinc north east city) eqkeep(mean sd N) title(Summary Statistics by Female)

bys north: outreg2 using table3d.doc, replace sum(log) keep(married educ_rev age white taxinc female east city) eqkeep(mean sd N) title(Summary Statistics by North)

bys east: outreg2 using table3e.doc, replace sum(log) keep(married educ_rev age white taxinc female north city) eqkeep(mean sd N) title(Summary Statistics by East)

bys city: outreg2 using table3f.doc, replace sum(log) keep(married educ_rev age white taxinc female north east) eqkeep(mean sd N) title(Summary Statistics by City)

****************************REGRESSION*****************************************

**Table 4**

reg married educ_rev
outreg2 using table4.doc, replace ctitle(Model 1)

cap predict ehat, resid
sum ehat, detail

hettest ehat

reg married educ_rev_sq
outreg2 using table4.doc, append ctitle(Model 2)

cap predict ehat_quadratic, resid
sum ehat_quadratic, detail

reg married educ_rev_cu
outreg2 using table4.doc, append ctitle(Model 3)

reg married educ_rev age white taxinc female north east city
outreg2 using table4.doc, append ctitle(Model 4)

reg married educ_rev_sq age white taxinc female north east city
outreg2 using table4.doc, append ctitle(Model 5)

cap predict ehat_mult_lin, resid
sum ehat_mult_lin, detail

**Table 5**

reg married educ_rev_sq age white taxinc female north east city educ_female 
outreg2 using table5.doc, replace ctitle(Model 6)

reg married educ_rev_sq age white taxinc female north east city educ_white
outreg2 using table5.doc, append ctitle(Model 7)

reg married educ_rev_sq age white taxinc female north east city educ_city
outreg2 using table5.doc, append ctitle(Model 8)

save "/Users/hrp/Desktop/BU/EC204/Research Project/Stata Analysis/educ_rev_on_married_FINAL_CLEAN.dta", replace
log close
