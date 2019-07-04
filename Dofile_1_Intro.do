/*******************************************************************************
					PROYECCIÓN DE MATRÍCULA
					Orden: 1
					Dofile: Introducción estadísticas descriptivas
					Brenda Teruya
*******************************************************************************/
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"
set excelxlsxlargefile on
capture mkdir  "3. Data\3. Staff Level\Stata" // se crea solo una vez
capture mkdir "3. Data\2. IIEE Level\Stata" //se crea una vez 

*Cuántas IIEE EIB hay
use "3. Data\2. IIEE Level\padron_eib.dta" , clear
isid cod_mod anexo
duplicates drop cod_mod, force
count

use "3. Data\4. Student level\siagie_2018_al_11012019.dta", clear
count
save "3. Data\4. Student level\2018.dta", replace

*-------------------------------------------------------------------------------
*Cuántos docentes hay por año, se guarda una sola vez
/*
import excel "3. Data\3. Staff Level\NEXUS_2016_UE.xlsx", sheet("Sheet1") firstrow clear
count
save "3. Data\3. Staff Level\Stata\NEXUS_2016_UE.dta" , replace

import excel "3. Data\3. Staff Level\NEXUS_2017_UE.xlsx", sheet("Sheet1") firstrow clear
count
save "3. Data\3. Staff Level\Stata\NEXUS_2017_UE.dta" , replace

import excel "3. Data\3. Staff Level\NEXUS_2018_UE.xlsx", sheet("Sheet1") firstrow clear
count
save "3. Data\3. Staff Level\Stata\NEXUS_2018_UE.dta" , replace
*/

*-------------------------------------------------------------------------------
*Padron escolar, se guarda solo una vez
*
import dbase "3. Data\2. IIEE Level\Padron_web_20190531\Padron_web.dbf", clear
save "3. Data\2. IIEE Level\Stata\Padron_web.dta" , replace

import dbase "3. Data\2. IIEE Level\Censo Escolar\2018\Padron.dbf", clear
save "3. Data\2. IIEE Level\Stata\CE_2018_padron.dta" , replace

*Censo Escolar

import dbase "3. Data\2. IIEE Level\Censo Escolar\2018\Matricula_01.dbf", clear
isid  COD_MOD ANEXO TIPOREG NROCED CUADRO TIPDATO
save "3. Data\2. IIEE Level\Stata\Matricula_01_2018.dta" , replace



forvalues year = 2013/2018 {
import dbase "3. Data\2. IIEE Level\Censo Escolar/`year'\Matricula_01.dbf", clear
save "3. Data\2. IIEE Level\Stata\Matricula_01_`year'.dta" , replace

import dbase "3. Data\2. IIEE Level\Censo Escolar/`year'\Docentes_01.dbf", clear
save "3. Data\2. IIEE Level\Stata\Docentes_01_`year'.dta" , replace

import dbase "3. Data\2. IIEE Level\Censo Escolar/`year'\Secciones.dbf", clear
save "3. Data\2. IIEE Level\Stata\Secciones_`year'.dta" , replace
}

*

********************************************************************************
*cuántos alumnos hay de EBR pública en 2018

use "3. Data\2. IIEE Level\Stata\Padron_web.dta" ,  clear
duplicates drop COD_MOD, force
rename _all, lower
tempfile padron_2018
save `padron_2018'

use "3. Data\2. IIEE Level\Stata\CE_2018_padron.dta" , clear
duplicates drop COD_MOD, force
rename _all, lower
tempfile CE_2018_padron
save `CE_2018_padron'

use "3. Data\4. Student level\2018.dta", clear
isid id_persona

collapse (count) n_alumnos = id_anio , by(cod_mod)
label var n_alumnos "# alumnos por codmod"
merge m:1 cod_mod using `padron_2018', ///
	keepusing(gestion d_gestion niv_mod d_niv_mod ges_dep d_ges_dep)
keep if _m==3
drop _m

codebook 
gen ebr_publica = 1 if gestion !="3"  & (niv_mod == "A1" |niv_mod == "A2" ///
	|niv_mod == "A3" |niv_mod == "B0" |niv_mod == "F0" )
replace ebr_publica = 0 if ebr_publica == . //no hay missing en estas variables por el 
*update del merge
tabstat n_alumnos, stat(sum) by(ebr_publica)
display 5701303/8013195

********************************************************************************
*Tendencia en Perú de alumnos docentes y secciones
*-------------------------------matricula---------------------------------------

*matricula
*2013 SOLO CUADRO 302
*2014 cuadro 201 (hay otros)
*2015 cuadro 201
*2016 cuadro 201 (hay otros)
*2017 cuadro C201

forvalues year = 2013/2018 {
use "3. Data\2. IIEE Level\Stata\Matricula_01_`year'.dta" , clear
*solo EBR 
gen nivel = .
replace nivel = 1 if inlist(NIV_MOD, "A1" , "A2" , "A3" )
replace nivel = 2 if NIV_MOD == "B0"
replace nivel = 3 if NIV_MOD == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
drop if missing(nivel)
dis `year'
tab CUADRO nivel,m

	if `year' == 2014 | `year' == 2016  {
		keep if CUADRO == "201"
	}

	dis `year'
	tab CUADRO nivel, missing

egen matri_tot =  rowtotal(D??) , missing
gen publico = substr(GES_DEP,1,1) == "A" // no hay missings
keep if publico == 1
collapse (sum) matri_tot, by(CODOOII)

gen year = `year'
tabstat matri_tot, stat(sum)
tempfile matri_`year'
save `matri_`year''

}
use `matri_2013' , replace
forvalues year = 2014/2018 {
append using `matri_`year''
label data "Matrícula de EBR pública por UGEL"
}
tempfile matri_peru
save `matri_peru'
tabstat matri, stat(sum) by(year)


*todos los años tienen correctamente los cuadros
*no hay que elegir entre cuadros
*hay que buscar dónde están las auxiliares y sumar todos los docentes menos
*auxiliares

*-------------------------------secciones---------------------------------------

*Secciones, van cambiando los cuadros pero no es necesario filtrar, todas las 
*secciones entran en el calculo
forvalues year = 2013/2018 {
use "3. Data\2. IIEE Level\Stata\Secciones_`year'.dta" , clear
gen nivel = .
replace nivel = 1 if inlist(NIV_MOD, "A1" , "A2" , "A3" )
replace nivel = 2 if NIV_MOD == "B0"
replace nivel = 3 if NIV_MOD == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
drop if missing(nivel)
tab CUADRO nivel, missing

egen seccion_total =  rowtotal(D??) , missing
gen publico = substr(GES_DEP,1,1) == "A" // no hay missings
keep if publico == 1

collapse (sum) seccion_total, by(CODOOII)
gen year = `year'
tabstat seccion_total, stat(sum)
tempfile seccion_`year'
save `seccion_`year''

}
use `seccion_2013' , replace
forvalues year = 2014/2018 {
append using `seccion_`year''
label data "Secciones de EBR pública por UGEL"
}
tempfile seccion_peru
save `seccion_peru'

tabstat seccion_total, stat(sum) by(year)

*-------------------------------Docentes----------------------------------------
*No todos los docentes entran al calculo, los auxiliares deben ser excluidos.
*No todos los cuadros son los relevantes.
*Abajo una lista de los cuadros relevates y la variable que indica el auxiliar 


/*2018
*Inicial, cuadro C301, auxiliar D14
*Primaria, cuadro C301, auxiliar D14
*Secundaria,  cuadro C301, auxiliar D26

*2017
Inicial idem 2018
Primaria idem 2018
Secundaria,  cuadro C301, auxiliar D25

2016
Incial, cuadro 301, auxiliar D14
Primaria, cuadro 301, auxiliar D22
Secundaria, cuadro 301, auxiliar D22

2015
Incial, cuadro 301, auxiliar D13
Primaria, cuadro 301, auxiliar D13
Secundaria, cuadro 301, auxiliar D13

2014
Incial, idem 2015
Primaria, idem 2015
Secundaria, idem 2015

2013
Incial, cuadro 401, auxiliar D13
Primaria, cuadro 401, auxiliar D13
Secundaria, cuadro 401, auxiliar D13

*/
forvalues year = 2013/2018 {
use "3. Data\2. IIEE Level\Stata\Docentes_01_`year'.dta" , clear
gen nivel = .
replace nivel = 1 if inlist(NIV_MOD, "A1" , "A2" , "A3"  )
replace nivel = 2 if NIV_MOD == "B0"
replace nivel = 3 if NIV_MOD == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
drop if missing(nivel)

gen auxiliar =.

if `year' == 2018 {
replace auxiliar = D14 if nivel == 1 & CUADRO == "C301"
replace auxiliar = D14 if nivel == 2 & CUADRO == "C301"
replace auxiliar = D26 if nivel == 3 & CUADRO == "C301"
}

else if `year' == 2017 {
replace auxiliar = D14 if nivel == 1 & CUADRO == "C301"
replace auxiliar = D14 if nivel == 2 & CUADRO == "C301"
replace auxiliar = D25 if nivel == 3 & CUADRO == "C301"
}
else if `year' == 2016 {
replace auxiliar = D14 if nivel == 1 & CUADRO == "301"
replace auxiliar = D22 if nivel == 2 & CUADRO == "301"
replace auxiliar = D22 if nivel == 3 & CUADRO == "301"
}
else if `year' == 2015 {
replace auxiliar = D13 if nivel == 1 & CUADRO == "301"
replace auxiliar = D13 if nivel == 2 & CUADRO == "301"
replace auxiliar = D13 if nivel == 3 & CUADRO == "301"
}
else if `year' == 2014 {
replace auxiliar = D13 if nivel == 1 & CUADRO == "301"
replace auxiliar = D13 if nivel == 2 & CUADRO == "301"
replace auxiliar = D13 if nivel == 3 & CUADRO == "301"
}
else if `year' == 2013 {
replace auxiliar = D13 if nivel == 1 & CUADRO == "401"
replace auxiliar = D13 if nivel == 2 & CUADRO == "401"
replace auxiliar = D13 if nivel == 3 & CUADRO == "401"
}
egen doc_total =  rowtotal(D??) , missing
replace doc_total = doc_total - auxiliar

gen publico = substr(GES_DEP,1,1) == "A" // no hay missings
keep if publico == 1


collapse (sum) doc_total, by(CODOOII)
gen year = `year'

tabstat doc_total, stat(sum)

tempfile doc_`year'
save `doc_`year''
}

use `doc_2013' , replace
forvalues year = 2014/2018 {
append using `doc_`year''
label data "Docentes de EBR pública por UGEL"
}
tempfile doc_peru
save `doc_peru'
save "3. Data\Datasets_intermedios\docentes_peru_2013-2018.dta", replace	


tabstat doc_total, stat(sum) by(year)

use `matri_peru', clear
merge 1:1 year CODOOII using `doc_peru', nogen
merge 1:1 year CODOOII using `seccion_peru', nogen
label data "Data set a nivel de UGEL y anio"
rename matri_tot matri_total

tabstat *_total, stat(sum) by(year)


*-------------------------------------------------------------------------------
*CENSO REDATAM POBLACIÓN POR EDADES Y DISTRITOS

import excel "3. Data\5. Country Level\Censo 2017_edad distrito.xlsx", ///
	sheet("Output") cellrange(B10:C189368) clear
	
split B if substr(B,1,4) == "AREA"	, gen(ubigeo)
split B if substr(B,1,4) == "Edad"	, gen(edad)

drop ubigeo1 ubigeo2 edad1 edad3
rename (ubigeo3 edad2) (ubigeo edad)
drop if B == ""
gen total = B == "Total"

gen ubigeo_id = ""
replace ubigeo_id = ubigeo if ubigeo != ""
replace ubigeo_id = ubigeo_id[_n-1] if ubigeo == ""

destring edad, replace
drop if edad == .
destring C, replace
rename C poblacion
keep ubigeo_id edad poblacion
order ubigeo_id edad poblacion
rename ubigeo_id ubigeo


*-------------------------------------------------------------------------------
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

