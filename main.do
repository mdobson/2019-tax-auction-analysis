**Main Do File

capture log close
clear all

**Update this line with the location of the current working directory
global root "/Users/mdobs/Desktop/stata_practicum/final_project"
global do_path "${root}/do"
global csv_path "${root}/data/csv"
global dta_path "${root}/data/dta"
global log_path "${root}/log"
global graph_path "${root}/graphs"
global shapefile_path "${root}/data/shapefiles"
global outreg_path "${root}/outreg"
global tabout_path "${root}/tabout"
global grec_path "${root}/graph_edit_files"

global time_string = subinstr("􏰅`c(current_time)'", ":", "_", .) 
global date_string = subinstr("`c(current_date)'", " ", "_", .)

log using "${log_path}/mdobs_final_project_${time_string}_${date_string}.smcl", replace

**Import CSVs and save raw imports to dta path
do "${do_path}/import_csv_data.do"
**Open and clean auction file

do "${do_path}/clean_auction_data.do"

**Open and clean parcel file

do "${do_path}/clean_parcel_data.do"

**Open and clean blight ticket file

do "${do_path}/clean_blight_data.do"

**Open blight ticket file
**Fix the blight tickets zip code
use "${dta_path}/cleaned_blight_data.dta", clear
**Merge and clean up zip code info.
merge m:1 parcel_id using "${dta_path}/cleaned_parcel_data.dta", keepusing(zip_code)
drop if _merge==2
drop violation_zip_code 
rename zip_code violation_zip_code
drop _merge
save "${dta_path}/repaired_blight_data.dta", replace

**Merge 1 to 1 the parcel file and the auction file
**Save it

use "${dta_path}/cleaned_auction_data.dta", clear
merge 1:1 parcel_id using "${dta_path}/cleaned_parcel_data.dta"
drop if _merge == 1
drop _merge
save "${dta_path}/merged_parcel_and_auction_data.dta", replace

**Collapse blight tickets

do "${do_path}/aggregate_address_level_blight_data.do"

use "${dta_path}/aggregated_blight_violation_data_by_address.dta", clear

**Merge with the already merged parcel and auction data file

merge m:1 parcel_id using "${dta_path}/merged_parcel_and_auction_data.dta"
drop if _merge == 1
drop _merge
save "${dta_path}/fully_merged_auction_blight_and_parcel_data.dta", replace

**Do analysis on auction values

**Graphs and Maps
do "${do_path}/make_maps.do"

use "${dta_path}/fully_merged_auction_blight_and_parcel_data.dta", clear

do "${do_path}/generate_bidder_variables.do"

**Do the necessary calculations for the general statistics section of the paper
do "${do_path}/general_statistics.do"

**Do the necessary regression analysis on the winning bid variable.
**This is the next section of the paper
do "${do_path}/winning_bid_regression.do"

**Next we run analysis on the bidder_in_detroit variable
**Third section of the paper
do "${do_path}/bidder_in_detroit_regression.do"

**Lastly we use logit analysis on the corporate_bidder variable
**Last section of the paper
do "${do_path}/corporate_bidder_regression.do"

log close

translate "${log_path}/mdobs_final_project_${time_string}_${date_string}.smcl" "${log_path}/mdobs_final_project_${time_string}_${date_string}.pdf"
