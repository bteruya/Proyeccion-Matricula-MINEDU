merge m:1 cod_mod using `CE_2018_padron', gen(x) keepusing(gestion d_gestion niv_mod d_niv_mod) update
tab _m x ,m
drop if x == 2
drop x _m



*-------------------------------------------------------------------------------
*Cuántos alumnos hay por año, se suma el total y divide entre 6
use "3. Data\4. Student level\2013.dta", clear
count
scalar suma = r(N)

use "3. Data\4. Student level\2014.dta", clear
count
scalar suma = suma + r(N)

use "3. Data\4. Student level\2015.dta", clear
count
scalar suma = suma + r(N)
use "3. Data\4. Student level\2016.dta", clear
count
scalar suma = suma + r(N)

use "3. Data\4. Student level\2017.dta", clear
count
scalar suma = suma + r(N)

use "3. Data\4. Student level\siagie_2018_al_11012019.dta", clear
count
scalar suma = suma + r(N)
save "3. Data\4. Student level\2018.dta", replace
dis suma/6

*Docentes

forvalues year = 2016/2018 {
use "3. Data\3. Staff Level\Stata\NEXUS_`year'_UE.dta", clear
gen n_doc = 1
collapse (count) n_doc
label var n_doc "# docentes en Peru"
gen year = `year'
tempfile nexus`year'
save `nexus`year''
}

use  `nexus2016', clear
forvalues year = 2017/2018 {

append using  `nexus`year''
}
tempfile nexus_peru
save `nexus_peru'

*alumnos / secciones

forvalues year = 2013/2018 {

	use "3. Data\4. Student level/`year'.dta", clear
gen n_alumnos = 1
*max n_seccion por grado
*sum n_seccion por peru
collapse (sum) n_alumnos 
label var n_alumnos "# alumnos en Peru"
gen year = `year'

tempfile siagie`year'
save `siagie`year''
}

use `siagie2013' , replace
forvalues year = 2014/2018 {
append using  `siagie`year''
}
tempfile siagie_peru
save `siagie_peru'

merge 1:1 year using `nexus_peru' , nogen
order year n_doc n_alumnos
tempfile siagie_nexus_peru
save `siagie_nexus_peru'

use "3. Data\4. Student level\Siagie_codmod\siagie16_310317.dta", clear
rename MATRIC_SIAGIE16_310317 MATRICULA
collapse (sum) MATRICULA NUM_SECC
gen year = 2016
tempfile siagie2016
save `siagie2016'

use "3. Data\4. Student level\Siagie_codmod\siagie17_200418.dta", clear
rename MATRIC_SIAGIE17_200418 MATRICULA
collapse (sum) MATRICULA NUM_SECC
gen year = 2017
tempfile siagie2017
save `siagie2017'

use "3. Data\4. Student level\Siagie_codmod\siagie18_010518.dta", clear
rename MATRIC_SIAGIE17_010518 MATRICULA
collapse (sum) MATRICULA NUM_SECC
gen year = 2018
tempfile siagie2018
save `siagie2018'

use `siagie2016' , replace
forvalues year = 2017/2018 {
append using  `siagie`year''
}
tempfile siagie_peru
save `siagie_peru'

merge 1:1 year using `siagie_nexus_peru' , nogen
sort year
order year n_alumnos n_doc MATRICULA NUM_SECC
export excel using "4. Codigos\Output\Tendencia.xlsx", sheet(Peru) sheetreplace ///
	firstrow(varlabels)

	
use "3. Data\4. Student level\siagie_2018_al_11012019_idseccion.dta", clear
	
********************************************************************************
********************************************************************************
********************************************************************************
*Tendencias con el Censo Escolar
local year 2018
use "3. Data\2. IIEE Level\Stata\Matricula_01_`year'.dta", clear	
*solo EBR 
gen nivel = .
replace nivel = 1 if inlist(NIV_MOD, "A1" , "A2" , "A3" )
replace nivel = 2 if NIV_MOD == "B0"
replace nivel = 3 if NIV_MOD == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
drop if missing(nivel)

egen matri_ini =  rowtotal(D01-D14) if nivel == 1, missing
egen matri_pri =  rowtotal(D01-D12) if nivel == 2, missing
egen matri_sec =  rowtotal(D01-D10) if nivel == 3, missing

egen matri_total = rowtotal(matri_ini - matri_sec), missing

collapse (sum) matri_total, by(COD_MOD)
gen year = `year'
tabstat matri_total, stat(sum)
tempfile matri_`year'
save `matri_`year''


use "3. Data\2. IIEE Level\Stata\Docentes_01_`year'.dta" , clear
gen nivel = .
replace nivel = 1 if inlist(NIV_MOD, "A1" , "A2" , "A3"  )
replace nivel = 2 if NIV_MOD == "B0"
replace nivel = 3 if NIV_MOD == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
drop if missing(nivel)

egen doc_ini =  rowtotal(D01-D13) if nivel == 1 & CUADRO == "C301"
egen doc_pri =  rowtotal(D01-D13) if nivel == 2 & CUADRO == "C301"
egen doc_sec =  rowtotal(D01-D24) if nivel == 3 & CUADRO == "C301"

egen doc_total = rowtotal(doc_ini - doc_sec), missing

collapse (sum) doc_total, by(COD_MOD)
gen year = `year'

tabstat doc_total, stat(sum)

tempfile doc_2018
save `doc_`year''

use "3. Data\2. IIEE Level\Stata\Secciones_`year'.dta" , clear
gen nivel = .
replace nivel = 1 if inlist(NIV_MOD, "A1" , "A2" , "A3" )
replace nivel = 2 if NIV_MOD == "B0"
replace nivel = 3 if NIV_MOD == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
drop if missing(nivel)

egen seccion_ini =  rowtotal(D01-D07) if nivel == 1, missing
egen seccion_pri =  rowtotal(D01-D06) if nivel == 2, missing
egen seccion_sec =  rowtotal(D01-D10) if nivel == 3, missing

egen seccion_total = rowtotal(seccion_ini - seccion_sec), missing

collapse (sum) seccion_total, by(COD_MOD)
gen year = `year'
tabstat seccion_total, stat(sum)
tempfile seccion_`year'
save `seccion_`year''


use `matri_`year'', clear
merge 1:1 COD_MOD using `doc_`year'', nogen
merge 1:1 COD_MOD using `seccion_`year'', nogen
rename COD_MOD cod_mod
merge 1:1 cod_mod using `padron_2018'
drop if _m == 2
drop _m

drop if gestion == "3" //sin privados

tabstat *_total, stat(sum) 

