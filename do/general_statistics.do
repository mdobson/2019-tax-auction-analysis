**General statistics portion of the report 
**Let's take a look at summary statistics 
tabstat starting_bid winning_bid year_built sqft num_buildings floor_area land_value violation_count, stat(min max mean median sd sem) c(stat)

**Fully Merge data analysis
tabout bidder_in_detroit using "${tabout_path}/bidder_in_detroit.txt", replace

tabout bidder_in_detroit council_district using "${tabout_path}/bidder_in_detroit_x_council_district.txt", replace
bysort bidder_in_detroit: tabstat starting_bid winning_bid year_built sqft num_buildings floor_area land_value, stat(min max mean median sd sem) c(stat)

tabout council_district using "${tabout_path}/council_districts.txt", replace sort mi
tabout building_style using "${tabout_path}/building_style.txt", replace sort mi

oneway winning_bid council_district, tabulate
oneway winning_bid bidder_in_detroit, tabulate
oneway winning_bid corporate_bidder, tabulate
oneway winning_bid building_style, tabulate

**Average winning bid price by Council District
graph bar (mean) winning_bid, over(council_district) bar(1, fcolor(navy)) blabel(bar, size(small)) ytitle(Mean Winning Bid) ylabel(, nogrid) title(Mean winning bid by council district (in $)) scheme(s2mono)
graph play "${grec_path}/fix_mean_winning_bid_by_council_district.grec"
graph export "${graph_path}/mean_winning_bid_by_council_district.png", replace

**Total winning bids by Council District
graph bar (mean) winning_bid, over(building_style, relabel(1 `" "Single" "Family" "' 2 `" "Income" "Bungalow" "' 3 `" "Large" "Flats" "' 4 `" "Multi-Dwelling" "' 5 `" "Two-Family Flat" "')) bar(1, fcolor(navy)) blabel(bar, size(small)) ytitle(Winning Bid Amount) ylabel(, nogrid) title(Mean winning bid by building style (in $)) scheme(s2mono)
graph play "${grec_path}/fix_mean_winning_bid_by_building_style.grec"
graph export "${graph_path}/mean_winning_bid_by_building_style.png", replace
