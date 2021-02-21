**Regression analysis of winning bid

**What facets contribute to a winning bid?

local model "sqft starting_bid no_lead_clearance_sum num_buildings bidder_in_same_zip_code"
**These are variables that are candidates for individual heteroskdasticity

reg winning_bid `model'
outreg2 using "${outreg_path}/winning_bid.doc", replace

**Sneaking suspicion of heteroskedasticity
estat hettest, fstat
estat hettest `model'
foreach c of varlist `model' {
	estat hettest `c', fstat
	**We do it for all variables except the dichotomous one. The graph looks bad and doesn't add value
	if "`c'"!="bidder_in_same_zip_code" {
		rvpplot `c', mcolor(navy) ytitle(Residuals) title(Residual vs Predictor for `c' in Model 1) ylabel(, nogrid) yline(0, lcolor(red) lpattern(shortdash)) scheme(s2mono)
		graph export "${graph_path}/rvp_`c'.png", replace
	}
}


**Fix Heteroskedasticity
**First let's make the independent variable measurement closer to the dependent variable

gen ln_sqft = ln(sqft)
label var ln_sqft "Log square footage of property"
gen ln_starting_bid = ln(starting_bid)
label var ln_starting_bid "Log starting bid of property"
gen ln_winning_bid = ln(winning_bid)
label var ln_winning_bid "Log winning bid of property"

local new_model "ln_sqft ln_starting_bid no_lead_clearance_sum num_buildings bidder_in_same_zip_code"

**Regress on variables that have been log transformed
reg ln_winning_bid `new_model'
outreg2 using "${outreg_path}/winning_bid.doc", append

estat hettest, fstat
estat hettest `new_model', fstat
foreach c of varlist `new_model' {
	estat hettest `c', fstat
	if "`c'"!="bidder_in_same_zip_code" {
		rvpplot `c', mcolor(navy) ytitle(Residuals) title(Residual vs Predictor for `c' in Model 2) ylabel(, nogrid) yline(0, lcolor(red) lpattern(shortdash)) scheme(s2mono)
		graph export "${graph_path}/rvp_`c'1.png", replace
	}
}

**Next let's regress on non-open lot parcels
reg ln_winning_bid `new_model' if building_style !=.
outreg2 using "${outreg_path}/winning_bid.doc", append
estat hettest, fstat
estat hettest `model'
foreach c of varlist `new_model' {
	estat hettest `c', fstat
	if "`c'"!="bidder_in_same_zip_code" {
		rvpplot `c', mcolor(navy) ytitle(Residuals) title(Residual vs Predictor for `c' in Model 3) ylabel(, nogrid) yline(0, lcolor(red) lpattern(shortdash)) scheme(s2mono)
		graph export "${graph_path}/rvp_`c'2.png", replace
	}
}

**Finally we'll use robust standard errors
reg ln_winning_bid `new_model', r
outreg2 using "${outreg_path}/winning_bid.doc", append

**Use matrix operators to extract margins prediction to exponentiate and print out
margins, predict() at((medians) _all)
matrix B = r(b)
local margins_constant = B[1,1]
local exponentiated_bid = exp(`margins_constant')
display "Estimated winning bid after exponentiation: `exponentiated_bid'"


margins, predict() at(num_buildings=(0(1)7) (medians)ln_sqft ln_starting_bid no_lead_clearance_sum bidder_in_same_zip_code)
marginsplot, plotopts(lcolor(navy) mcolor(navy)) plot1opts(lcolor(navy)) ciopts(lcolor(navy)) ci1opts(lcolor(navy)) yline(0, lcolor(red) lpattern(shortdash)) ytitle(Log Winning Bid) xtitle(Number of Buildings on Property)  ylabel(, noticks nogrid) ytitle(, margin(right)) xtitle(, margin(top)) scheme(s2mono) graphregion(margin(large))
graph export "${graph_path}/winning_bid_predicts_based_on_number_of_buildings.png", replace
