**Corporate Bidder Regression

**Lastly let's examine factors that may determine a corporate bidder on a property
logit corporate_bidder i.council_district ln_starting_bid ln_sqft no_lead_clearance_sum bidder_in_detroit num_buildings
outreg2 using "${outreg_path}/corp_bidder.doc", replace
estat class

**Use margins to predict probabilities of certain cases
**A property bid on by a non-detroit bidder with 1 building 2 lead violations that has median square footage and starting bid.
**Have it vary by council district
margins, predict() at(num_buildings=1 bidder_in_detroit=0 no_lead_clearance_sum=2 council_district=(1(1)7) (medians)ln_sqft ln_starting_bid)
marginsplot, plotopts(lcolor(navy) mcolor(navy)) plot1opts(lcolor(navy)) ciopts(lcolor(navy)) ci1opts(lcolor(navy)) yline(0, lcolor(red) lpattern(shortdash)) ytitle(Probability of Corporation as winning bidder) xtitle(Council District of Property)  ylabel(, noticks nogrid) ytitle(, margin(right)) xtitle(, margin(top)) scheme(s2mono) graphregion(margin(large))
graph export "${graph_path}/corp_bidder_council_dist.png", replace

**A property bid on by a non-detroit bidder with 2 buildings in 4th council distrct that has median square footage and starting bid.
**Have it vary by lead clearance violations
margins, predict() at(num_buildings=2 bidder_in_detroit=0 no_lead_clearance_sum=(0(1)3) council_district=4 (medians)ln_sqft ln_starting_bid)
marginsplot, plotopts(lcolor(navy) mcolor(navy)) plot1opts(lcolor(navy)) ciopts(lcolor(navy)) ci1opts(lcolor(navy)) yline(0, lcolor(red) lpattern(shortdash)) ytitle(Probability of Corporation as winning bidder) xtitle(Number of Lead Clearance Violations)  ylabel(, noticks nogrid) ytitle(, margin(right)) xtitle(, margin(top)) scheme(s2mono) graphregion(margin(large))
graph export "${graph_path}/corp_bidder_lead_clearance.png", replace
