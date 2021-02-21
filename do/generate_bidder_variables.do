
**Generate a variable indicating whether or not bidder lives in the same zip code as the property
gen bidder_in_same_zip_code = bidder_zip_code == property_zip_code 
label var bidder_in_same_zip_code "Dummy variable indicating whether or not bidder is in the same zip code as property they are bidding on"
label define same_bidder_zip_code_label 0 "Bidder not in same zip code" 1 "Bidder in same zip code" 
label values bidder_in_same_zip_code same_bidder_zip_code_label
 
**Generate a variable to indicate whether or not the bidder is a corporate entity
gen corporate_bidder = strpos(name_of_bidder, "LLC") != 0 | strpos(name_of_bidder, "INC") != 0
label var corporate_bidder "Was the bidder a corporate entity?"
label define corporate_bidder_label 0 "Bidder is not a corporate entity" 1 "Bidder is a corporate entity" 
label values corporate_bidder corporate_bidder_label

**If there is missing blight data that means there were no violations recorded for that property.
local blight_variables "fine_sum other_violation_sum graffiti_present_sum no_lead_clearance_sum snow_and_ice_removal_sum rodent_infestation_sum curbside_waste_containers_sum inoperative_vehicle_present_sum bulk_solid_waste_accum_sum excess_plant_growth_sum rental_property_not_reg_sum no_certificate_of_compliance_sum violation_count "
foreach v of varlist `blight_variables' {
	replace `v' = 0 if `v' == .
}
