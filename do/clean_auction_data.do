**Begin by cleaning and labelling auction data

use "${dta_path}/raw_auction_import.dta", clear

**Bidder name has some strange character issues that stata doesn't like
**Replace line carriage statements with a space
local strings_with_newlines "biddername biddercitystate deedname bidderaddress deedaddress deedcitystate"

foreach v of varlist `strings_with_newlines' {
	gen clean_`v' = subinstr(`v', char(10), " ", .)
	drop `v'
}

**Clean variable names
rename parcelid parcel_id
rename propertyaddress property_address
rename propertycity property_city
rename propertyzipcode property_zip_code
rename clean_deedname name_on_deed
rename clean_deedaddress deed_address
rename clean_deedcitystate deed_city_state
rename deedzip deed_zip_code
rename deeddate deed_date
rename clean_biddername name_of_bidder
rename biddernumber bidder_number
rename septemberstartingbid starting_bid
rename winningbid winning_bid
rename clean_biddercitystate bidder_city_and_state
rename clean_bidderaddress bidder_address
rename bidderzip bidder_zip_code

drop location

**Date formatting
gen ddate = date(deed_date, "MDY")
format ddate %tdNN/DD/CCYY
drop deed_date 
rename ddate deed_date

**Stringify the bidder zip
tostring bidder_zip_code, gen(stringified_bidder_zip)

**Generate variables about bidders
gen bidder_in_detroit = strpos(stringified_bidder_zip, "482") == 1
gen bidder_in_michigan = strpos(stringified_bidder_zip, "48") == 1 | strpos(stringified_bidder_zip, "49") == 1
gen bidder_in_us = stringified_bidder_zip != "."


**Label our variables
label variable parcel_id "Unique identifier for property given by the City of Detroit"
label variable property_address "Address of property won in auction"
label variable property_zip_code "Zip code of the property won in the auction"
label variable starting_bid "Starting September bid for property"
label variable winning_bid "Final winning bid for property"
label variable deed_zip_code "Zip code of new deed owner"
label variable deed_date "Date of deed transfer"
label variable bidder_number "Unique identifier for bidder"
label variable bidder_zip_code "Zip code of bidder"
label variable name_of_bidder "Name of bidder"
label variable bidder_city_and_state "City and state of bidder"
label variable name_on_deed "Name on the deed that has been transferred"
label variable bidder_address "Address of bidder"
label variable deed_address "Address where deed was transferred to"
label variable deed_city_stat "City and state where deed was transferred to"
label variable bidder_in_detroit "Dummy variable indicating whether or not bidder is located in the City of Detroit"
label variable bidder_in_michigan "Dummy variable indicating whether or not bidder is located in the State of Michigan"
label variable bidder_in_us "Dummy variable indicating whether or not bidder is located in the United States"

label define bidder_in_detroit_label 0 "Bidder not in Detroit" 1 "Bidder in Detroit" 
label define bidder_in_michigan_label 0 "Bidder not in Michigan" 1 "Bidder in Michigan" 
label define bidder_in_united_states_label 0 "Bidder not in United States" 1 "Bidder in United States"
label values bidder_in_detroit bidder_in_detroit_label
label values bidder_in_michigan bidder_in_michigan_label
label values bidder_in_us bidder_in_united_states_label
 
**Deed transfer
gen deed_transferred = 0
replace deed_transferred = 1 if deed_date !=.
label variable deed_transferred "Has the deed been transferred? (No if deed_date missing)"
label define deed_transferred_label 0 "Deed not transferred" 1 "Deed transferred" 
label values deed_transferred deed_transferred_label

save "${dta_path}/cleaned_auction_data.dta", replace

