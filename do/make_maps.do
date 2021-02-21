**Transform shapefiles and make some maps
cd "${shapefile_path}"
spshape2dta detroit_council_districts, replace
use "detroit_council_districts.dta", clear
destring districts,replace 
rename districts council_district
save "detroit_council_districts.dta", replace

use "${dta_path}/merged_parcel_and_auction_data.dta", clear

collapse (sum) starting_bid winning_bid (count)count_of_properties=winning_bid, by(council_district)

save "${dta_path}/collapsed_data_by_council_district.dta", replace

merge 1:1 council_district using "detroit_council_districts.dta"

grmap winning_bid using "detroit_council_districts_shp.dta", id(_ID) fcolor(Greens) title("Total Money Spent per Council District", fcolor(dimgray) lcolor(dimgray) box) legend(ring(1) position(3)) 
graph export "${graph_path}/spend_per_council_district.png", replace
grmap starting_bid using "detroit_council_districts_shp.dta", id(_ID) fcolor(Greens) title("Total Money Sought per Council District", fcolor(dimgray) lcolor(dimgray) box) legend(ring(1) position(3)) 
graph export "${graph_path}/sought_per_council_district.png", replace
grmap sum_popula using "detroit_council_districts_shp.dta", id(_ID) fcolor(Greens)  title("Population per Council District", fcolor(dimgray) lcolor(dimgray) box) legend(ring(1) position(3)) 
graph export "${graph_path}/population_per_council_district.png", replace
grmap count_of_properties using "detroit_council_districts_shp.dta", id(_ID) fcolor(Greens)  title("Properties at Auction per Council District", fcolor(dimgray) lcolor(dimgray) box) legend(ring(1) position(3)) 
graph export "${graph_path}/total_properties_offered_per_council_district.png", replace

cd "${root}"
