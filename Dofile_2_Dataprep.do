/*******************************************************************************
					PROYECCIÓN DE VARIABLES EDUCATIVAS
					Orden: 2
					Dofile: Preparación de los datos para las 5 metodologías
					MA, CSR, MES, panel dinamico, minedu
					Brenda Teruya
*******************************************************************************/
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"

*Data para la metodología moving average (medias moviles) de cuarto de primaria
*tercero de secundaria
*CUARTO GRADO PRIMARIA Y SECUNDARIA


*-------------------------------matricula---------------------------------------

/*
cuarto de primaria y cuarto secundaria
2013: cuadro 301 (solo uno) , D07 D08
2014: cuadro 201 (varios en inicial) , D07 D08
2015: cuadro 201 (solo uno) , D07 D08
2016: cuadro 201 (varios en los 3 niveles) , D07 D08
2017: cuadro C201 (solo uno) , D07 D08
2018: cuadro C201 (solo uno) , D07 D08
*/


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
tabstat	D11, stat(sum)	by(nivel) // En secundaria no hay sexto grado hombres, todo bien

	if `year' == 2014 | `year' == 2016  {
		keep if CUADRO == "201"
	}

	dis `year'
	tab CUADRO nivel, missing

egen matri_4 =  rowtotal(D07 D08) , missing
gen matri_4_prim = matri_4*(nivel == 2)
gen matri_4_secun = matri_4*(nivel == 3)

egen matri_3 = rowtotal(D05 D06) , missing
gen matri_3_prim = matri_3*(nivel == 2)
gen matri_3_secun = matri_3*(nivel == 3)

gen publico = substr(GES_DEP,1,1) == "A" // no hay missings
keep if publico == 1
collapse (sum) matri_4 matri_4_* matri_3 matri_3_*, by(CODOOII)

gen year = `year'
tabstat matri_4_*, stat(sum)
tempfile matri_`year'
save `matri_`year''

}
use `matri_2013' , replace
forvalues year = 2014/2018 {
append using `matri_`year''
label data "Matrícula de EBR pública por UGEL de 4 y 3 grado"
}
tempfile matri_peru
save `matri_peru', replace
tabstat matri*, stat(sum) by(year)

*-------------------------------secciones---------------------------------------

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

gen seccion_4 =  D04
gen publico = substr(GES_DEP,1,1) == "A" // no hay missings
keep if publico == 1

gen seccion_4_prim = seccion_4*(nivel == 2)
gen seccion_4_secun = seccion_4*(nivel == 3)

collapse (sum) seccion_4 seccion_4_* , by(CODOOII)
gen year = `year'
tabstat seccion_4 , stat(sum)
tempfile seccion_`year'
save `seccion_`year'', replace

}
use `seccion_2013' , replace
forvalues year = 2014/2018 {
append using `seccion_`year''
label data "Secciones de EBR pública por UGEL"
}
tempfile seccion_peru
save `seccion_peru'

tabstat seccion*, stat(sum) by(year)

*-------------------------------Docentes----------------------------------------

use `matri_peru', clear

merge 1:1 year CODOOII using `seccion_peru'
drop _m

label variable matri_4 "Matrícula 4 primaria o secundaria"
label variable matri_4_prim "Matrícula 4 primaria"
label variable matri_4_secun "Matrícula 4 secundaria"

label variable matri_3 "Matrícula 3 primaria o secundaria"
label variable matri_3_prim "Matrícula 3 primaria"
label variable matri_3_secun "Matrícula 3 secundaria"

label variable seccion_4 "Secciones 4 primaria o secundaria"
label variable seccion_4_prim "Secciones 4 primaria"
label variable seccion_4_secun "Secciones 4 secundaria"

label data "Matrícula y secciones de EBR pública por UGEL de 4 grado primaria secundaria entre 2013-2018"
save "3. Data\Datasets_intermedios\matricula_secciones_peru_2013-2018.dta", replace
isid year CODOOII


