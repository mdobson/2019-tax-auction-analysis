**Import each file and save them

**Import the tax auction data
import delimited "${csv_path}/Wayne_County_Tax_Auction_Results_2017.csv", delimiter(comma) bindquote(strict) clear

save "${dta_path}/raw_auction_import.dta", replace


**Import the parcel data
import delimited "${csv_path}/parcel_points_Wayne_County_Tax_Auction_Results_2017.csv", delimiter(comma) bindquote(strict) clear

save "${dta_path}/raw_parcel_import.dta", replace

**Import the blight ticket data
import delimited "${csv_path}/blight_data_Wayne_County_Tax_Auction_Results_2017.csv", delimiter(comma) bindquote(strict) clear

save "${dta_path}/raw_blight_import.dta", replace
