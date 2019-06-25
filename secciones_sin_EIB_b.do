cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones\3. Data"


use "2. IIEE Level\Stata\Secciones_2014.dta", clear
rename _all , lower
keep if niv_mod=="B0"
keep if substr(ges_dep,1,1)=="A"
keep if cod_car=="3"
merge m:1 cod_mod anexo using "2. IIEE Level\padron_eib.dta"
keep if _merge==1
drop _merge
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\06_junio_2019\huepetuhe.dta" // pasar esta bd
drop if _merge==2
replace codooii="170099" if _merge==3
drop _merge
rename codooii codooii_old
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\10_octubre_2018\padron_web.dta", keepusing(codooii)
drop if _merge==2
replace codooii=codooii_old if _merge==1
replace codooii=codooii_old if codooii_old=="170099"
collapse (sum) d01 d02 d03 d04 d05 d06, by(codooii)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\01_enero_2016\proyecciones_2015\tseccion_2015.dta", clear
keep if niv_mod=="B0"
keep if substr(ges_dep,1,1)=="A"
keep if cod_car=="3"
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\06_junio_2019\padron_EIB_x_IE.dta"
keep if _merge==1
drop _merge
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\06_junio_2019\huepetuhe.dta"
drop if _merge==2
replace codooii="170099" if _merge==3
drop _merge
rename codooii codooii_old
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\10_octubre_2018\padron_web.dta", keepusing(codooii)
drop if _merge==2
replace codooii=codooii_old if _merge==1
replace codooii=codooii_old if codooii_old=="170099"
collapse (sum) d01 d02 d03 d04 d05 d06, by(codooii)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2015_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\09_septiembre_2016\proyecciones_primaria\secciones_2016.dta", clear
keep if niv_mod=="B0"
keep if substr(ges_dep,1,1)=="A"
keep if cod_car=="3"
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\06_junio_2019\padron_EIB_x_IE.dta"
keep if _merge==1
drop _merge
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\06_junio_2019\huepetuhe.dta"
drop if _merge==2
replace codooii="170099" if _merge==3
drop _merge
rename codooii codooii_old
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\10_octubre_2018\padron_web.dta", keepusing(codooii)
drop if _merge==2
replace codooii=codooii_old if _merge==1
replace codooii=codooii_old if codooii_old=="170099"
collapse (sum) d01 d02 d03 d04 d05 d06, by(codooii)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2016_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\10_octubre_2017\INDICADORES_CE_2017\secciones_2017.dta", clear
keep if niv_mod=="B0"
keep if substr(ges_dep,1,1)=="A"
keep if cod_car=="3"
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\06_junio_2019\padron_EIB_x_IE.dta"
keep if _merge==1
drop _merge
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\06_junio_2019\huepetuhe.dta"
drop if _merge==2
replace codooii="170099" if _merge==3
drop _merge
rename codooii codooii_old
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\10_octubre_2018\padron_web.dta", keepusing(codooii)
drop if _merge==2
replace codooii=codooii_old if _merge==1
replace codooii=codooii_old if codooii_old=="170099"
collapse (sum) d01 d02 d03 d04 d05 d06, by(codooii)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2017_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\01_enero_2019\secciones_2018.dta", clear
keep if niv_mod=="B0"
keep if substr(ges_dep,1,1)=="A"
keep if cod_car=="3"
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\06_junio_2019\padron_EIB_x_IE.dta"
keep if _merge==1
drop _merge
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\06_junio_2019\huepetuhe.dta"
drop if _merge==2
replace codooii="170099" if _merge==3
drop _merge
rename codooii codooii_old
merge m:1 cod_mod anexo using "D:\ALuis_Trabajo2\10_octubre_2018\padron_web.dta", keepusing(codooii)
drop if _merge==2
replace codooii=codooii_old if _merge==1
replace codooii=codooii_old if codooii_old=="170099"
collapse (sum) d01 d02 d03 d04 d05 d06, by(codooii)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2018_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_x_ugel.dta", clear
gen año=1
append using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2015_x_ugel.dta"
replace año=2 if año==.
append using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2016_x_ugel.dta"
replace año=3 if año==.
append using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2017_x_ugel.dta"
replace año=4 if año==.
append using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2018_x_ugel.dta"
replace año=5 if año==.
append using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2018_x_ugel.dta"
replace año=6 if año==.
append using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2018_x_ugel.dta"
replace año=7 if año==.
replace d01=. if año==6|año==7
replace d02=. if año==6|año==7
replace d03=. if año==6|año==7
replace d04=. if año==6|año==7
replace d05=. if año==6|año==7
replace d06=. if año==6|año==7
bys codooii: egen años=sum(año)
gen año5=1 if año==5
bys codooii: egen años5=sum(año5)
drop if años<28 & años5==0
drop años año5 años5
count
set obs 1154
replace codooii="020004" in 1154
replace d01=0 in 1154
replace d02=0 in 1154
replace d03=0 in 1154
replace d04=0 in 1154
replace d05=0 in 1154
replace d06=0 in 1154
replace año=1 in 1154
set obs 1155
replace codooii="020004" in 1155
replace d01=0 in 1155
replace d02=0 in 1155
replace d03=0 in 1155
replace d04=0 in 1155
replace d05=0 in 1155
replace d06=0 in 1155
replace año=2 in 1155
set obs 1156
replace codooii="020004" in 1156
replace d01=0 in 1156
replace d02=0 in 1156
replace d03=0 in 1156
replace d04=0 in 1156
replace d05=0 in 1156
replace d06=0 in 1156
replace año=3 in 1156
set obs 1157
replace codooii="080014" in 1157
replace d01=0 in 1157
replace d02=0 in 1157
replace d03=0 in 1157
replace d04=0 in 1157
replace d05=0 in 1157
replace d06=0 in 1157
replace año=1 in 1157
set obs 1158
replace codooii="080014" in 1158
replace d01=0 in 1158
replace d02=0 in 1158
replace d03=0 in 1158
replace d04=0 in 1158
replace d05=0 in 1158
replace d06=0 in 1158
replace año=2 in 1158
set obs 1159
replace codooii="080014" in 1159
replace d01=0 in 1159
replace d02=0 in 1159
replace d03=0 in 1159
replace d04=0 in 1159
replace d05=0 in 1159
replace d06=0 in 1159
replace año=3 in 1159
set obs 1160
replace codooii="080014" in 1160
replace d01=0 in 1160
replace d02=0 in 1160
replace d03=0 in 1160
replace d04=0 in 1160
replace d05=0 in 1160
replace d06=0 in 1160
replace año=4 in 1160
set obs 1161
replace codooii="100003" in 1161
replace d01=0 in 1161
replace d02=0 in 1161
replace d03=0 in 1161
replace d04=0 in 1161
replace d05=0 in 1161
replace d06=0 in 1161
replace año=1 in 1161
set obs 1162
replace codooii="100003" in 1162
replace d01=0 in 1162
replace d02=0 in 1162
replace d03=0 in 1162
replace d04=0 in 1162
replace d05=0 in 1162
replace d06=0 in 1162
replace año=2 in 1162
sort codooii año
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="010001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="010002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="010003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="010005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="010006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="010007"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010007.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020008"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020008.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020010"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020010.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020011"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020011.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020012"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020012.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020015"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020015.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020017"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020017.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020018"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020018.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="020019"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020019.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="040001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="040002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="040003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="040004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="040005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="040006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="040007"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040007.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="040008"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040008.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="040010"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040010.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="050007"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_050007.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060007"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060007.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060008"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060008.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060010"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060010.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060011"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060011.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060012"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060012.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="060013"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060013.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="070101"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_070101.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="070102"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_070102.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="080001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="080003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="080004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="080009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="080013"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080013.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="080014"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080014.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="090001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="090004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="090006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="090007"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090007.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="090009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="100001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="100002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="100003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="100004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="100005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="100008"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100008.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="100009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="100010"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100010.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="100011"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100011.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="110001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="110002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="110003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="110004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="110005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="120001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="120004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="120005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="120006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="120008"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120008.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="120009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="120010"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120010.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="120011"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120011.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130007"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130007.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130008"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130008.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130010"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130010.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130011"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130011.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130012"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130012.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130014"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130014.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130015"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130015.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130016"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130016.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="130017"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130017.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="140001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_140001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="140002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_140002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="140003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_140003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150102"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150102.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150103"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150103.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150104"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150104.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150105"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150105.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150106"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150106.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150107"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150107.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150108"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150108.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150201"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150201.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150202"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150202.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150203"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150203.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150204"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150204.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150205"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150205.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150206"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150206.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150207"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150207.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150208"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150208.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="150209"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150209.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="160001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="160002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="160003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="160004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="160005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="160006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="160007"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160007.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="160008"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160008.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="170001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="170002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="170003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="170099"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170099.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="180001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_180001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="180002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_180002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="180003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_180003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="190001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_190001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="190003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_190003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200007"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200007.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200008"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200008.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200010"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200010.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200011"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200011.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="200012"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200012.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="210001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="210003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="210005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="210009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="210010"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210010.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="210011"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210011.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220005"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220005.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220006"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220006.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220007"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220007.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220008"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220008.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220009"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220009.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="220010"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220010.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="230001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="230002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="230003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="230004"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230004.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="240001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_240001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="240002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_240002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="240003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_240003.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="250001"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_250001.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="250002"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_250002.dta", replace
clear
use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta", clear
keep if codooii=="250003"
do "D:\ALuis_Trabajo2\06_junio_2019\proyeccion_secciones.do"
save "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_250003.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010001.dta", clear
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010007.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020008.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020010.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020011.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020012.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020015.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020017.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020018.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020019.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040007.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040008.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040010.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_050007.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060007.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060008.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060010.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060011.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060012.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060013.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_070101.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_070102.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080013.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080014.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090007.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100008.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100010.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100011.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120008.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120010.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120011.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130007.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130008.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130010.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130011.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130012.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130014.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130015.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130016.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130017.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_140001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_140002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_140003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150102.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150103.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150104.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150105.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150106.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150107.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150108.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150201.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150202.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150203.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150204.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150205.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150206.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150207.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150208.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150209.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160007.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160008.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170099.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_180001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_180002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_180003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_190001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_190003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200007.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200008.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200010.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200011.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200012.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210010.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210011.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220005.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220006.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220007.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220008.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220009.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220010.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230004.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_240001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_240002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_240003.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_250001.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_250002.dta"
append using "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_250003.dta"
preserve
keep if año==6
rename d01 d01_19
rename d02 d02_19
rename d03 d03_19
rename d04 d04_19
rename d05 d05_19
rename d06 d06_19
drop año
keep codooii d01_19 d02_19 d03_19 d04_19 d05_19 d06_19
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2019_x_ugel.dta", replace
restore
keep if año==7
rename d01 d01_20
rename d02 d02_20
rename d03 d03_20
rename d04 d04_20
rename d05 d05_20
rename d06 d06_20
drop año
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2020_x_ugel.dta", replace
clear

erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_010007.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020008.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020010.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020011.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020012.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020015.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020017.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020018.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_020019.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040007.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040008.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_040010.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_050007.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060007.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060008.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060010.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060011.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060012.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_060013.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_070101.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_070102.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080013.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_080014.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090007.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_090009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100008.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100010.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_100011.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_110005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120008.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120010.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_120011.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130007.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130008.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130010.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130011.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130012.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130014.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130015.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130016.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_130017.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_140001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_140002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_140003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150102.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150103.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150104.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150105.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150106.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150107.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150108.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150201.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150202.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150203.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150204.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150205.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150206.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150207.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150208.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_150209.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160007.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_160008.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_170099.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_180001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_180002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_180003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_190001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_190003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200007.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200008.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200010.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200011.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_200012.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210010.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_210011.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220005.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220006.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220007.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220008.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220009.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_220010.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_230004.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_240001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_240002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_240003.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_250001.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_250002.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\Proyeccion_250003.dta"

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_x_ugel.dta", clear
rename d01 d01_14
rename d02 d02_14
rename d03 d03_14
rename d04 d04_14
rename d05 d05_14
rename d06 d06_14
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2015_x_ugel.dta", clear
rename d01 d01_15
rename d02 d02_15
rename d03 d03_15
rename d04 d04_15
rename d05 d05_15
rename d06 d06_15
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2015_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2016_x_ugel.dta", clear
rename d01 d01_16
rename d02 d02_16
rename d03 d03_16
rename d04 d04_16
rename d05 d05_16
rename d06 d06_16
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2016_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2017_x_ugel.dta", clear
rename d01 d01_17
rename d02 d02_17
rename d03 d03_17
rename d04 d04_17
rename d05 d05_17
rename d06 d06_17
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2017_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2018_x_ugel.dta", clear
rename d01 d01_18
rename d02 d02_18
rename d03 d03_18
rename d04 d04_18
rename d05 d05_18
rename d06 d06_18
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2018_x_ugel.dta", replace
clear

erase "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_18_x_ugel.dta" 

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_x_ugel.dta", clear
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2015_x_ugel.dta"
drop _merge
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2016_x_ugel.dta"
drop _merge
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2017_x_ugel.dta"
drop _merge
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2018_x_ugel.dta"
drop _merge
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2019_x_ugel.dta"
drop _merge
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2020_x_ugel.dta"
drop _merge

replace modelo_01="1/y=a+b1/x" if modelo_01=="modelo1"
replace modelo_01="1/y=a+blnx" if modelo_01=="modelo2"
replace modelo_01="1/y=a+bx" if modelo_01=="modelo3"
replace modelo_01="lny=a+b1/x" if modelo_01=="modelo4"
replace modelo_01="lny=a+blnx" if modelo_01=="modelo5"
replace modelo_01="lny=a+bx" if modelo_01=="modelo6"
replace modelo_01="y=a+b1/x" if modelo_01=="modelo7"
replace modelo_01="y=a+blnx" if modelo_01=="modelo8"
replace modelo_01="y=a+bx" if modelo_01=="modelo9"

replace modelo_02="1/y=a+b1/x" if modelo_02=="modelo1"
replace modelo_02="1/y=a+blnx" if modelo_02=="modelo2"
replace modelo_02="1/y=a+bx" if modelo_02=="modelo3"
replace modelo_02="lny=a+b1/x" if modelo_02=="modelo4"
replace modelo_02="lny=a+blnx" if modelo_02=="modelo5"
replace modelo_02="lny=a+bx" if modelo_02=="modelo6"
replace modelo_02="y=a+b1/x" if modelo_02=="modelo7"
replace modelo_02="y=a+blnx" if modelo_02=="modelo8"
replace modelo_02="y=a+bx" if modelo_02=="modelo9"

replace modelo_03="1/y=a+b1/x" if modelo_03=="modelo1"
replace modelo_03="1/y=a+blnx" if modelo_03=="modelo2"
replace modelo_03="1/y=a+bx" if modelo_03=="modelo3"
replace modelo_03="lny=a+b1/x" if modelo_03=="modelo4"
replace modelo_03="lny=a+blnx" if modelo_03=="modelo5"
replace modelo_03="lny=a+bx" if modelo_03=="modelo6"
replace modelo_03="y=a+b1/x" if modelo_03=="modelo7"
replace modelo_03="y=a+blnx" if modelo_03=="modelo8"
replace modelo_03="y=a+bx" if modelo_03=="modelo9"

replace modelo_04="1/y=a+b1/x" if modelo_04=="modelo1"
replace modelo_04="1/y=a+blnx" if modelo_04=="modelo2"
replace modelo_04="1/y=a+bx" if modelo_04=="modelo3"
replace modelo_04="lny=a+b1/x" if modelo_04=="modelo4"
replace modelo_04="lny=a+blnx" if modelo_04=="modelo5"
replace modelo_04="lny=a+bx" if modelo_04=="modelo6"
replace modelo_04="y=a+b1/x" if modelo_04=="modelo7"
replace modelo_04="y=a+blnx" if modelo_04=="modelo8"
replace modelo_04="y=a+bx" if modelo_04=="modelo9"

replace modelo_05="1/y=a+b1/x" if modelo_05=="modelo1"
replace modelo_05="1/y=a+blnx" if modelo_05=="modelo2"
replace modelo_05="1/y=a+bx" if modelo_05=="modelo3"
replace modelo_05="lny=a+b1/x" if modelo_05=="modelo4"
replace modelo_05="lny=a+blnx" if modelo_05=="modelo5"
replace modelo_05="lny=a+bx" if modelo_05=="modelo6"
replace modelo_05="y=a+b1/x" if modelo_05=="modelo7"
replace modelo_05="y=a+blnx" if modelo_05=="modelo8"
replace modelo_05="y=a+bx" if modelo_05=="modelo9"

replace modelo_06="1/y=a+b1/x" if modelo_06=="modelo1"
replace modelo_06="1/y=a+blnx" if modelo_06=="modelo2"
replace modelo_06="1/y=a+bx" if modelo_06=="modelo3"
replace modelo_06="lny=a+b1/x" if modelo_06=="modelo4"
replace modelo_06="lny=a+blnx" if modelo_06=="modelo5"
replace modelo_06="lny=a+bx" if modelo_06=="modelo6"
replace modelo_06="y=a+b1/x" if modelo_06=="modelo7"
replace modelo_06="y=a+blnx" if modelo_06=="modelo8"
replace modelo_06="y=a+bx" if modelo_06=="modelo9"

preserve
keep codooii d01* minimo_01 modelo_01
drop if minimo_01==.
replace d01_14=0 if d01_14==.
replace d01_15=0 if d01_15==.
replace d01_16=0 if d01_16==.
replace d01_17=0 if d01_17==.
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_1_2014_18_x_ugel.dta", replace
restore

preserve
keep codooii d02* minimo_02 modelo_02
drop if minimo_02==.
replace d02_14=0 if d02_14==.
replace d02_15=0 if d02_15==.
replace d02_16=0 if d02_16==.
replace d02_17=0 if d02_17==.
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2_2014_18_x_ugel.dta", replace
restore

preserve
keep codooii d03* minimo_03 modelo_03
drop if minimo_03==.
replace d03_14=0 if d03_14==.
replace d03_15=0 if d03_15==.
replace d03_16=0 if d03_16==.
replace d03_17=0 if d03_17==.
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_3_2014_18_x_ugel.dta", replace
restore

preserve
keep codooii d04* minimo_04 modelo_04
drop if minimo_04==.
replace d04_14=0 if d04_14==.
replace d04_15=0 if d04_15==.
replace d04_16=0 if d04_16==.
replace d04_17=0 if d04_17==.
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_4_2014_18_x_ugel.dta", replace
restore

preserve
keep codooii d05* minimo_05 modelo_05
drop if minimo_05==.
replace d05_14=0 if d05_14==.
replace d05_15=0 if d05_15==.
replace d05_16=0 if d05_16==.
replace d05_17=0 if d05_17==.
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_5_2014_18_x_ugel.dta", replace
restore

keep codooii d06* minimo_06 modelo_06
drop if minimo_06==.
replace d06_14=0 if d06_14==.
replace d06_15=0 if d06_15==.
replace d06_16=0 if d06_16==.
replace d06_17=0 if d06_17==.
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_6_2014_18_x_ugel.dta", replace
clear

erase "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2014_x_ugel.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2015_x_ugel.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2016_x_ugel.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2017_x_ugel.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2018_x_ugel.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2019_x_ugel.dta"
erase "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2020_x_ugel.dta"


use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_1_2014_18_x_ugel.dta", clear
gen proy_1_20=max(d01_18,d01_19,d01_20)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_1_2014_18_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2_2014_18_x_ugel.dta", clear
gen proy_2_20=max(d02_18,d02_19,d02_20)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2_2014_18_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_3_2014_18_x_ugel.dta", clear
gen proy_3_20=max(d03_18,d03_19,d03_20)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_3_2014_18_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_4_2014_18_x_ugel.dta", clear
gen proy_4_20=max(d04_18,d04_19,d04_20)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_4_2014_18_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_5_2014_18_x_ugel.dta", clear
gen proy_5_20=max(d05_18,d05_19,d05_20)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_5_2014_18_x_ugel.dta", replace
clear

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_6_2014_18_x_ugel.dta", clear
gen proy_6_20=max(d06_18,d06_19,d06_20)
save "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_6_2014_18_x_ugel.dta", replace

use "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_1_2014_18_x_ugel.dta", clear
keep codooii proy_1_20
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_2_2014_18_x_ugel.dta", keepusing(proy_2_20)
drop _merge
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_3_2014_18_x_ugel.dta", keepusing(proy_3_20)
drop _merge
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_4_2014_18_x_ugel.dta", keepusing(proy_4_20)
drop _merge
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_5_2014_18_x_ugel.dta", keepusing(proy_5_20)
drop _merge
merge 1:1 codooii using "D:\ALuis_Trabajo2\06_junio_2019\secciones_primaria_6_2014_18_x_ugel.dta", keepusing(proy_6_20)
drop _merge

replace proy_1_20=proy_1_20+1
replace proy_2_20=proy_2_20+1
replace proy_3_20=proy_3_20+1
replace proy_4_20=proy_4_20+1
replace proy_5_20=proy_5_20+1
replace proy_6_20=proy_6_20+1

set obs 167
replace codooii="010000" in 167
replace proy_1_20=1 in 167
replace proy_2_20=1 in 167
replace proy_3_20=1 in 167
replace proy_4_20=1 in 167
replace proy_5_20=1 in 167
replace proy_6_20=1 in 167

set obs 168
replace codooii="020000" in 168
replace proy_1_20=1 in 168
replace proy_2_20=1 in 168
replace proy_3_20=1 in 168
replace proy_4_20=1 in 168
replace proy_5_20=1 in 168
replace proy_6_20=1 in 168

set obs 169
replace codooii="040000" in 169
replace proy_1_20=1 in 169
replace proy_2_20=1 in 169
replace proy_3_20=1 in 169
replace proy_4_20=1 in 169
replace proy_5_20=1 in 169
replace proy_6_20=1 in 169

set obs 170
replace codooii="050000" in 170
replace proy_1_20=1 in 170
replace proy_2_20=1 in 170
replace proy_3_20=1 in 170
replace proy_4_20=1 in 170
replace proy_5_20=1 in 170
replace proy_6_20=1 in 170

set obs 171
replace codooii="060000" in 171
replace proy_1_20=1 in 171
replace proy_2_20=1 in 171
replace proy_3_20=1 in 171
replace proy_4_20=1 in 171
replace proy_5_20=1 in 171
replace proy_6_20=1 in 171

set obs 172
replace codooii="070100" in 172
replace proy_1_20=1 in 172
replace proy_2_20=1 in 172
replace proy_3_20=1 in 172
replace proy_4_20=1 in 172
replace proy_5_20=1 in 172
replace proy_6_20=1 in 172

set obs 173
replace codooii="080000" in 173
replace proy_1_20=1 in 173
replace proy_2_20=1 in 173
replace proy_3_20=1 in 173
replace proy_4_20=1 in 173
replace proy_5_20=1 in 173
replace proy_6_20=1 in 173

set obs 174
replace codooii="090000" in 174
replace proy_1_20=1 in 174
replace proy_2_20=1 in 174
replace proy_3_20=1 in 174
replace proy_4_20=1 in 174
replace proy_5_20=1 in 174
replace proy_6_20=1 in 174

set obs 175
replace codooii="100000" in 175
replace proy_1_20=1 in 175
replace proy_2_20=1 in 175
replace proy_3_20=1 in 175
replace proy_4_20=1 in 175
replace proy_5_20=1 in 175
replace proy_6_20=1 in 175

set obs 176
replace codooii="110000" in 176
replace proy_1_20=1 in 176
replace proy_2_20=1 in 176
replace proy_3_20=1 in 176
replace proy_4_20=1 in 176
replace proy_5_20=1 in 176
replace proy_6_20=1 in 176

set obs 177
replace codooii="120000" in 177
replace proy_1_20=1 in 177
replace proy_2_20=1 in 177
replace proy_3_20=1 in 177
replace proy_4_20=1 in 177
replace proy_5_20=1 in 177
replace proy_6_20=1 in 177

set obs 178
replace codooii="130000" in 178
replace proy_1_20=1 in 178
replace proy_2_20=1 in 178
replace proy_3_20=1 in 178
replace proy_4_20=1 in 178
replace proy_5_20=1 in 178
replace proy_6_20=1 in 178

set obs 179
replace codooii="140000" in 179
replace proy_1_20=1 in 179
replace proy_2_20=1 in 179
replace proy_3_20=1 in 179
replace proy_4_20=1 in 179
replace proy_5_20=1 in 179
replace proy_6_20=1 in 179

set obs 180
replace codooii="150100" in 180
replace proy_1_20=1 in 180
replace proy_2_20=1 in 180
replace proy_3_20=1 in 180
replace proy_4_20=1 in 180
replace proy_5_20=1 in 180
replace proy_6_20=1 in 180

set obs 181
replace codooii="150200" in 181
replace proy_1_20=1 in 181
replace proy_2_20=1 in 181
replace proy_3_20=1 in 181
replace proy_4_20=1 in 181
replace proy_5_20=1 in 181
replace proy_6_20=1 in 181

set obs 182
replace codooii="160000" in 182
replace proy_1_20=1 in 182
replace proy_2_20=1 in 182
replace proy_3_20=1 in 182
replace proy_4_20=1 in 182
replace proy_5_20=1 in 182
replace proy_6_20=1 in 182

set obs 183
replace codooii="170000" in 183
replace proy_1_20=1 in 183
replace proy_2_20=1 in 183
replace proy_3_20=1 in 183
replace proy_4_20=1 in 183
replace proy_5_20=1 in 183
replace proy_6_20=1 in 183

set obs 184
replace codooii="180000" in 184
replace proy_1_20=1 in 184
replace proy_2_20=1 in 184
replace proy_3_20=1 in 184
replace proy_4_20=1 in 184
replace proy_5_20=1 in 184
replace proy_6_20=1 in 184

set obs 185
replace codooii="190000" in 185
replace proy_1_20=1 in 185
replace proy_2_20=1 in 185
replace proy_3_20=1 in 185
replace proy_4_20=1 in 185
replace proy_5_20=1 in 185
replace proy_6_20=1 in 185

set obs 186
replace codooii="200000" in 186
replace proy_1_20=1 in 186
replace proy_2_20=1 in 186
replace proy_3_20=1 in 186
replace proy_4_20=1 in 186
replace proy_5_20=1 in 186
replace proy_6_20=1 in 186

set obs 187
replace codooii="210000" in 187
replace proy_1_20=1 in 187
replace proy_2_20=1 in 187
replace proy_3_20=1 in 187
replace proy_4_20=1 in 187
replace proy_5_20=1 in 187
replace proy_6_20=1 in 187

set obs 188
replace codooii="220000" in 188
replace proy_1_20=1 in 188
replace proy_2_20=1 in 188
replace proy_3_20=1 in 188
replace proy_4_20=1 in 188
replace proy_5_20=1 in 188
replace proy_6_20=1 in 188

set obs 189
replace codooii="230000" in 189
replace proy_1_20=1 in 189
replace proy_2_20=1 in 189
replace proy_3_20=1 in 189
replace proy_4_20=1 in 189
replace proy_5_20=1 in 189
replace proy_6_20=1 in 189

set obs 190
replace codooii="240000" in 190
replace proy_1_20=1 in 190
replace proy_2_20=1 in 190
replace proy_3_20=1 in 190
replace proy_4_20=1 in 190
replace proy_5_20=1 in 190
replace proy_6_20=1 in 190

set obs 191
replace codooii="250000" in 191
replace proy_1_20=1 in 191
replace proy_2_20=1 in 191
replace proy_3_20=1 in 191
replace proy_4_20=1 in 191
replace proy_5_20=1 in 191
replace proy_6_20=1 in 191

replace proy_1_20=0 if proy_1_20==.
replace proy_2_20=0 if proy_2_20==.
replace proy_3_20=0 if proy_3_20==.
replace proy_4_20=0 if proy_4_20==.
replace proy_5_20=0 if proy_5_20==.
replace proy_6_20=0 if proy_6_20==.

sort codooii



*clear

log close
