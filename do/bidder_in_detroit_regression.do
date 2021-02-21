**Logit analysis of bidder_in_detroit_variable

**What facets of a property and parcel contribute to a bidder being a detroit resident?
logit bidder_in_detroit ln_sqft num_buildings i.council_district
outreg2 using "${outreg_path}/detroit_bidder_log.doc", replace
**How well does our logit model classify detroit buyers?
estat class

**Look at the marginal change on probability for the number of buildings on the probability that the bidder is a detroit resident
margins, predict() at(num_buildings =(0(1)6) council_district=3 (medians) ln_sqft)

marginsplot, plotopts(lcolor(navy) mcolor(navy)) plot1opts(lcolor(navy)) ciopts(lcolor(navy)) ci1opts(lcolor(navy)) yline(0, lcolor(red) lpattern(shortdash)) ytitle(Marginal effect of number of buildings) xtitle(Number of Buildings on Property)  ylabel(, noticks nogrid) ytitle(, margin(right)) xtitle(, margin(top)) scheme(s2mono) graphregion(margin(large))
graph export "${graph_path}/probability_of_buildings_on_detroit_bidder.png", replace

**Look at the marginal change on probability for the number of buildings on the probability that the bidder is a detroit resident
margins, predict() at(num_buildings =1 council_district=(1(1)7) (medians) ln_sqft num_buildings)

marginsplot, plotopts(lcolor(navy) mcolor(navy)) plot1opts(lcolor(navy)) ciopts(lcolor(navy)) ci1opts(lcolor(navy)) yline(0, lcolor(red) lpattern(shortdash)) ytitle(Probability of Detroiter as winning bidder) xtitle(Council District of Property)  ylabel(, noticks nogrid) ytitle(, margin(right)) xtitle(, margin(top)) scheme(s2mono) graphregion(margin(large))
graph export "${graph_path}/probability_of_detroit_bidder_probability_by_council_district.png", replace

logit bidder_in_detroit ln_sqft num_buildings i.council_district ln_starting_bid no_lead_clearance_sum
outreg2 using "${outreg_path}/detroit_bidder_log.doc", append
**How well does our logit model classify detroit buyers?
estat class
