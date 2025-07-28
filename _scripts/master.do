***********************************
* Housekeeping
***********************************
	clear all
	set more off
	macro drop _all	
	mat drop _all
	program drop _all

	*cd 	"/Users/dnoh/Library/CloudStorage/GoogleDrive-dnohkim00@gmail.com/My Drive/Work/_Job Application/3_Job Market 2025/3_Interviews/UNICEF/Written Assessment/unicef_assessment_submitted/Consultancy-Assessment"


	global in 	"./01_rawdata/"
	global data "./02_data_processed/"
	global out 	"./03_out/"

*********************************************
* Cleaning, data analysis, exporting figures
*********************************************
	do "./_scripts/01_cleaning_export.do"
***********************************
* Exporting a report (html)
***********************************
	dyndoc "./_scripts/02_report.stmd", saving("./04_document/report.html") replace

log off
