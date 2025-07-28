***********************************
* Housekeeping
***********************************
	clear all
	cap log close
	set more off
	macro drop _all	
	mat drop _all
	program drop _all


	*cd 	"/Users/dnoh/Library/CloudStorage/GoogleDrive-dnohkim00@gmail.com/My Drive/Work/_Job Application/3_Job Market 2025/3_Interviews/UNICEF/Written Assessment/unicef_assessment_submitted/Consultancy-Assessment"
	log using "./master.log", replace

	global in 	"./01_rawdata/"
	global data "./02_data_processed/"
	global out 	"./03_out/"

	ssc install unique
***********************************
* Import & Clean
***********************************
	/*Population*/
		import excel "${in}WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", clear cellrange(A17) firstrow case(lower) sheet(Projections)
			* Keeping the country level data only
				keep if type=="Country/Area"
			* Use projected births for 2022 as weights
				keep if year==2022
			* Keeping the variables of interest
				keep regionsubregioncountryorar iso3alphacode year birthsthousands 
			* Format: destring
				g weight=real(birthsthousands)
				lab var weight  "Weight: Number of births (thousands) projected for 2022"
				drop birthsthousands
			* Rename for consistency
				rename (regionsubregioncountryorar iso3alphacode) (country iso3code)
			* Cleaning countery name for merge
				replace country="United States" if country=="United States of America"
				replace country="Kosovo (UNSCR 1244)" if country=="Kosovo (under UNSC res. 1244)"
		save "${data}country_population.dta", replace 
		
	/*U5 mortality targets status*/
		import excel "${in}On-track and off-track countries.xlsx", clear firstrow case(lower)

			* Generating dummy for on-track
				ta statusu5mr, m
				g ontrack=cond(missing(statusu5mr),.,cond(statusu5mr=="Achieved" | statusu5mr=="On Track",1,0,.))
					lab define ontrack 0 "Off-track" 1 "On-track"
					lab value ontrack ontrack
					lab var ontrack "1 if ehtier achieved or on-track or 0 if off-track"
					drop statusu5mr
			* Rename for consistency
				rename officialname country
		save "${data}country_u5mr_status.dta", replace 

	/*Key indicators by country ('18-'22)*/
		import excel "${in}MNCH_2018-2022.xlsx", clear firstrow case(lower)
			* Leading relevant data
				keep if  wealthquintile=="Total" & residence=="Total" & currentage=="15 to 49 years old"
			* misc
				destring obs_value time_period, replace
				replace indicator="ANC4" if indicator=="Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider"
				replace indicator="SBA" if indicator=="Skilled birth attendant - percentage of deliveries attended by skilled health personnel"
				format indicator %4s
			* keeping the most recent ANC4 and SBA data
				*br geographicarea indicator time_period obs_value
				g sort_order = -time_period
				gsort geographicarea indicator sort_order
				bysort geographicarea indicator (sort_order): keep if _n == 1
			
			* Rename for consistency
				rename geographicarea country
			* Keeping the variables of interest
				keep country indicator obs_value
		save "${data}country_anc4sba.dta", replace 
	
***********************************
* Merge datasets
***********************************
use  "${data}country_anc4sba.dta",clear
	* Merging with U5 mortality target status datset
		merge m:1 country using  "${data}country_u5mr_status.dta", keep(match) nogen
			// Drop unmatched because we need both information for estimation
	* Merging with U5 mortality target status datset
		merge m:1  country using "${data}country_population.dta", keep(match) nogen
			// Drop unmatched because we need both information for estimation
save  "${data}country_merged.dta", replace
			
***********************************
* Analysis & Visualization
***********************************
use  "${data}country_merged.dta",clear
		
	* Create separate datasets for ANC4 and SBA
		foreach INDICATOR in ANC4 SBA {
			preserve
			keep if indicator == "`INDICATOR'"
			g w_`INDICATOR' = (obs_value/100) *weight
			collapse (sum) w_`INDICATOR' weight, by(ontrack)
			g pw_`INDICATOR' = (w_`INDICATOR' / weight)*100
			tempfile temp_`INDICATOR'
			save `temp_`INDICATOR''
			restore
		}
			
	* Merge both results
		use `temp_ANC4', clear
		g indicator="ANC4"
		g pw_coverage=pw_ANC4
		

		append using `temp_SBA'
		replace indicator="SBA"		if indicator==""
		replace pw_coverage=pw_SBA	if pw_coverage==.
		
		keep ontrack indicator pw_coverage
		
	* Visualization
		set graphic off
		foreach INDICATOR in ANC4 SBA {
			g cov_`INDICATOR'_offtrack =pw_coverage 	if ontrack == 0	& indicator=="`INDICATOR'"
			g cov_`INDICATOR'_ontrack  =pw_coverage 	if ontrack == 1	& indicator=="`INDICATOR'"
			
			gr  bar cov_`INDICATOR'_offtrack cov_`INDICATOR'_ontrack, ///
				bar(1,color(black%20)) ///
				bar(2, color(midblue%70)) ///
				ytitle("Population-weighted coverage (%)") ///
				ylabel(0(10)100, angle(0)) ///
				title("`INDICATOR' Coverage (%)") ///
				blabel(bar, format(%9.1f)) ///
				legend(order(1 "Off-track" 2 "On-track")) ///
				scheme(s1color) ///
				name(`INDICATOR', replace)	
		}
		gr combine 		ANC4 SBA, scheme(s1color) row(1) col(2) ysize(3)
		gr export 		"${out}fig_comparison_anc4_sba.png", replace
