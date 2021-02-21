**Clean parcel file

use "${dta_path}/raw_parcel_import.dta", clear

**Make parcel identifier consistent
rename parcelnum parcel_id

**Drop some repeated variables
drop objectid location location_address

**Change categorical string variables to labeled numerical categories

**Building style
gen bstyle = 1 if building_style == "SINGLE FAMILY"
replace bstyle = 2 if building_style == "INCOME BUNGALOW"
replace bstyle = 3 if building_style == "LARGE FLATS"
replace bstyle = 4 if building_style == "MULTI DWELLING"
replace bstyle = 5 if building_style == "TWO FAMILY FLAT"

label define building_style_label 1 "Single Family" 2 "Income Bungalow" 3 "Large Flats" 4 "Multi Dwelling" 5 "Two Family Flat" 
label values bstyle building_style_label

drop building_style 
rename bstyle building_style

**Zoning Type
gen zoning_code=.
replace zoning_code = 1 if zoning == "B4"
replace zoning_code = 2 if zoning == "M4"
replace zoning_code = 3 if zoning == "R1"
replace zoning_code = 4 if zoning == "R2"
replace zoning_code = 5 if zoning == "R3"
replace zoning_code = 6 if zoning == "R5"
replace zoning_code = 7 if zoning == "R6"
label define zoning_code_label 1 "B4" 2 "M4" 3 "R1" 4 "R2" 5 "R3" 6 "R5" 7 "R6"
label values zoning_code zoning_code_label

drop zoning 
rename zoning_code zoning

**Terms of sale
gen terms_of_sale_code=.
replace terms_of_sale_code = 1 if last_terms_of_sale == "BANK SALE NOT USED"
replace terms_of_sale_code = 2 if last_terms_of_sale == "BANK SALE USED"
replace terms_of_sale_code = 3 if last_terms_of_sale == "EXEMPT/GOVT"
replace terms_of_sale_code = 4 if last_terms_of_sale == "FORECLOSURE/FORFEIT"
replace terms_of_sale_code = 5 if last_terms_of_sale == "MULTI PARCEL SALE"
replace terms_of_sale_code = 6 if last_terms_of_sale == "MULTI PARCEL VALID"
replace terms_of_sale_code = 7 if last_terms_of_sale == "NO CONSIDERATION"
replace terms_of_sale_code = 8 if last_terms_of_sale == "NOT ARMS LENGTH"
replace terms_of_sale_code = 9 if last_terms_of_sale == "SPECIAL ACTS"
replace terms_of_sale_code = 10 if last_terms_of_sale == "VALID ARMS LENGTH"
label define terms_of_sale_code_label 1 "Bank Sale Not Used" 2 "Bank Sale Used" 3 "Exempt/Govt" 4 "Foreclosure/Forfeit" 5 "Multi Parcel Sale" 6 "Multi Parcel Valid" 7 "No Consideration" 8 "Not Arms Length" 9 "Special Acts" 10 "Valid Arms Length"
label values terms_of_sale_code terms_of_sale_code_label

drop last_terms_of_sale 
rename terms_of_sale_code last_terms_of_sale

**Taxable status
gen taxable_status_code=.
replace taxable_status_code=0 if taxable_status==""
replace taxable_status_code=1 if taxable_status=="TAXABLE"
label define taxable_status_code_label 0 "Not Taxable" 1 "Taxable" 
label values taxable_status_code taxable_status_code_label
drop taxable_status
rename taxable_status_code taxable_status

**Generate information on ownership
gen detroit_owner=0
gen michigan_owner=0
gen us_owner=0

replace detroit_owner = 1 if owner_city == "DETROIT"
replace michigan_owner = 1 if owner_state == "MI"
replace us_owner = 1 if owner_state != "MI"
replace us_owner = 0 if owner_country != ""

label define detroit_owner_label 0 "Owner not within Detroit" 1 "Owner within Detroit" 
label define michigan_owner_label 0 "Owner not within Michigan" 1 "Owner within Michigan" 
label define us_owner_label 0 "Owner not within US" 1 "Owner within US" 
label values detroit_owner detroit_owner_label
label values michigan_owner michigan_owner_label
label values us_owner us_owner_label

**Who owns these buildings? Businesses or people?
gen corporate_ownership=0
replace corporate_ownership = 1 if strpos(taxpayer, "LLC") != 0
replace corporate_ownership = 1 if strpos(taxpayer, "INC") != 0
replace corporate_ownership = 0 if corporate_ownership ==.

label define corporate_owner_label 0 "Responsible Taxpayer is not Corporate Entity" 1 "Responsible Taxpayer is Corporate Entity" 
label values corporate_owner corporate_owner_label
rename corporate_owner corporate_taxpayer

gen corporate_ownership=.
replace corporate_ownership = 1 if strpos(owner1, "LLC") != 0
replace corporate_ownership = 1 if strpos(owner1, "INC") != 0
replace corporate_ownership = 0 if corporate_ownership ==.

label define corporate_owner_label_two 0 "Owner is not Corporate Entity" 1 "Owner is Corporate Entity" 
label values corporate_owner corporate_owner_label_two

**Fix last sale date
gen double d = clock(last_sale_date, "YMD#hms##")
gen dofc = dofc(d)
format dofc %tdCCYY-NN-DD
drop last_sale_date d
rename dofc last_sale_date

**Houses were not built in year 0. So we will assume that the date is missing.
replace year_built = . if year_built == 0

**Label all the variables
label variable address "Address of property"
label variable council_district "City council district property resides in"
label variable depth "Depth of parcel from street"
label variable floor_area "Floor area of property"
label variable frontage "Width of parcel relative to street"
label variable improved_value "Value of parcel if improvements made"
label variable land_value "Value of land"
label variable landmap "Unkown"
label variable last_sale_date "Last sale date of parcel"
label variable latitude "Latitude of parcel"
label variable legaldesc "Legal description of parcel location"
label variable longitude "Longitude of parcel"
label variable num_buildings "Number of buildings present on parcel"
label variable owner1 "Owner of parcel"
label variable owner_city "City where owner of parcel resides"
label variable owner_state "State where owner of parcel resides"
label variable owner_street "Street where owner of parcel resides"
label variable owner_zip "Zip code of where owner of parcel resides"
label variable parcel_id "Unique identifier for parcel"
label variable pre "Unknown"
label variable property_class "Unknown"
label variable sev "Unknown"
label variable sqft "Square footage of parcel"
label variable taxable_value "Value of parcel from tax assessment"
label variable taxpayer "The taxpayer responsible for the parcel"
label variable total_acres "Total acres of parcel"
label variable ward "Ward parcel is located in"
label variable year_built "Year building was constructed on parcel"
label variable zip_code "Zip code of parcel"
label variable owner_country "The country where the owner of the parcel resides"
label variable related_parcel "Related parcel to current parcel"
label variable owner2 "Secondary owner of parcel"
label variable nez "Unknown"
label variable building_style "Style of building present on parcel"
label variable zoning "Zoning of parcel"
label variable last_terms_of_sale "Last terms of sale of the parcel"
label variable taxable_status "Taxable status of parcel"
label variable detroit_owner "Is owner of the parcel from Detroit?"
label variable michigan_owner "Is the owner of the parcel from Michigan?"
label variable us_owner "Is the owner of the parcel from the United States?"
label variable corporate_taxpayer "Is the taxpayer responsible for the parcel a corporate entity?"
label variable corporate_ownership "Is the owner of the property a corporate entity?"
label variable last_sale_price "Last price parcel was sold for"

save "${dta_path}/cleaned_parcel_data.dta", replace
