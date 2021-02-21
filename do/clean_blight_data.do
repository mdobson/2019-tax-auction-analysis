**Clean blight data
use "${dta_path}/raw_blight_import.dta", clear

**Clean up violation date
gen double d = clock(violation_date, "YMD#hms##")

gen violation_full_date = dofc(d)

format violation_full_date %tdCCYY-NN-DD

gen violation_year = year(violation_full_date)
gen violation_month = month(violation_full_date)
gen violation_dow = dow(violation_full_date)
drop d

**Drop and rename old date
drop violation_date
rename violation_full_date violation_date

**Get rid of nonsensical or replicated data
drop location location_address 

**make the parcel identifier consistent
rename parcelno parcel_id

**Rename the zip_code variable to reflect it's contents
rename zip_code violator_zip_code

**Make violator city more explicit
rename city violator_city

**Label our data
label variable admin_fee "Administration Fee for Blight Violation"
label variable agency_name "Agency that issued Blight Violation"
label variable balance_due "Balance due for Blight Violation"
label variable violator_city "City that violator resides in"
label variable discount_amount "Amount discounted off Blight Violation"
label variable fine_amount "Total fine amount for Blight Violation"
label variable hearing_date "Date of hearing for blight violation"
label variable hearing_time "Time of hearing for blight violation"
label variable inspector_name "Name of inspector who issued blight violation"
label variable judgment_amount "Blight violation amount after judgement at hearing"
label variable late_fee "Fee levied for late payment on violation"
label variable latitude "Latitude of violation"
label variable longitude "Longitude of violation"
label variable mailing_address_str_name "Mailing address street for violator"
label variable mailing_address_str_number "Mailing address street number for violator"
label variable parcel_id "Unique parcel identifier from the City of Detroit"
label variable state "Violator state"
label variable state_fee "Fee levied by state for blight violation"
label variable ticket_id "Unique blight violation identifier"
label variable ticket_issued_time "Time ticket was issued for blight violation"
label variable ticket_number "Unique ticket identifier for violation"
label variable violation_address "Address of property where blight violation was identified"
label variable violation_code "Code for blight violation"
label variable violation_description "Plain text description of blight violation"
label variable violation_street_name "Street name of violation location"
label variable violation_street_number "Street number of violation location"
label variable violator_id "Unique identifier for violator"
label variable violator_name "Name of violator"
label variable violator_zip_code "Zip code of violator location"
label variable violation_date "Date violation was issued"
label variable violation_year "Year violation was issued"
label variable violation_month "Month violation was issued"
label variable violation_dow "Day of week violation was issued"
label variable violation_zip_code "Zip code violation took place in"

**add dummies for each of the top 10 blight violations
gen no_certificate_of_compliance =0
label variable no_certificate_of_compliance "Violation: No certificate of compliance from city inspection."
gen rental_property_not_registered =0
label variable rental_property_not_registered "Violation: Rental property not registered."
gen excess_plant_growth=0
label variable excess_plant_growth "Violation: Excess plant or weed growth on the property."
gen bulk_solid_waste_accumulation=0
label variable bulk_solid_waste_accumulation "Violation: Excess solid waste accumulation or any medical or other waste present on property."
gen inoperative_vehicle_present=0
label variable inoperative_vehicle_present "Violation: Inoperative vehicle present."
gen curbside_waste_containers=0
label variable curbside_waste_containers "Violation: Curbside waste containers not approved or on curb outside approved time."
gen rodent_infestation=0
label variable rodent_infestation "Violation: Rodent infestation"
gen snow_and_ice_removal=0
label variable snow_and_ice_removal "Violation: Snow and/or ice not removed within 24 hours."
gen no_lead_clearance=0
label variable no_lead_clearance "Violation: No lead clearance for property."
gen graffiti_present=0
label variable graffiti_present "Violation: Graffiti present on property."

replace no_certificate_of_compliance = 1 if strpos(violation_code, "9-1-36(a)")
replace rental_property_not_registered =1 if strpos(violation_code, "9-1-81(a)")
replace excess_plant_growth=1 if strpos(violation_code, "9-1-104")
replace bulk_solid_waste_accumulation=1 if strpos(violation_code, "22-2-88(b)")
replace inoperative_vehicle_present=1 if strpos(violation_code, "9-1-110(a)")
replace curbside_waste_containers=1 if strpos(violation_code, "22-2-45")
replace rodent_infestation=1 if strpos(violation_code, "9-1-105")
replace snow_and_ice_removal=1 if strpos(violation_code, "9-1-103")
replace no_lead_clearance=1 if strpos(violation_code, "9-1-82(d)")
replace graffiti_present=1 if strpos(violation_code, "9-1-111")


save "${dta_path}/cleaned_blight_data.dta", replace
