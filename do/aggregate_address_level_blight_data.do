**Generate address level blight violation information

use "${dta_path}/repaired_blight_data.dta", clear

**Drop violations from the far past and post-auction
drop if violation_year < 2016 & violation_year > 2017

**egen counts of violations per parcel
bysort parcel_id: egen violation_count = count(violation_address)

**egen aggregate level parcel data
bysort parcel_id: egen no_certificate_of_compliance_sum = sum(no_certificate_of_compliance)
bysort parcel_id: egen rental_property_not_reg_sum = sum(rental_property_not_registered)
bysort parcel_id: egen excess_plant_growth_sum = sum(excess_plant_growth)
bysort parcel_id: egen bulk_solid_waste_accum_sum = sum(bulk_solid_waste_accumulation)
bysort parcel_id: egen inoperative_vehicle_present_sum = sum(inoperative_vehicle_present)
bysort parcel_id: egen curbside_waste_containers_sum = sum(curbside_waste_containers)
bysort parcel_id: egen rodent_infestation_sum = sum(rodent_infestation)
bysort parcel_id: egen snow_and_ice_removal_sum = sum(snow_and_ice_removal)
bysort parcel_id: egen no_lead_clearance_sum = sum(no_lead_clearance)
bysort parcel_id: egen graffiti_present_sum = sum(graffiti_present)

gen other_violation=0
replace other_violation = 1 if !no_certificate_of_compliance & !rental_property_not_registered & !excess_plant_growth & !bulk_solid_waste_accumulation & !inoperative_vehicle_present & !curbside_waste_containers & !rodent_infestation & !snow_and_ice_removal & !no_lead_clearance & !graffiti_present
bysort parcel_id: egen other_violation_sum = sum(other_violation)

bysort parcel_id: egen fine_sum = sum(fine_amount)

order fine_sum other_violation_sum graffiti_present_sum no_lead_clearance_sum snow_and_ice_removal_sum rodent_infestation_sum curbside_waste_containers_sum inoperative_vehicle_present_sum bulk_solid_waste_accum_sum excess_plant_growth_sum rental_property_not_reg_sum no_certificate_of_compliance_sum violation_count 
order parcel_id

collapse fine_sum-violation_count, by(parcel_id)

**Label pre-auction data
label variable fine_sum "Total violation fine amount."
label variable other_violation_sum "Other violations not within top 10."
label variable graffiti_present_sum "Total graffiti violations present."
label variable no_lead_clearance_sum "Total no lead clearance violations."
label variable snow_and_ice_removal_sum "Total snow and ice removal violations."
label variable rodent_infestation_sum "Total rodent infestation violations."
label variable curbside_waste_containers_sum "Total curbside waste container violations."
label variable inoperative_vehicle_present_sum "Total inoperative vehicle violations."
label variable bulk_solid_waste_accum_sum "Total bulk solid waste accumulation violations."
label variable excess_plant_growth_sum "Total excess plant growth violations."
label variable rental_property_not_reg_sum "Total non-registered rental property violations."
label variable no_certificate_of_compliance_sum "Total no certificate of compliance violations."
label variable violation_count "Total violation count."

save "${dta_path}/aggregated_blight_violation_data_by_address.dta", replace
