/*******************************************************************************
					PROYECCIÓN DE MATRÍCULA
					Orden: 2
					Dofile: Preparación de los datos para las 3 metodologías
					MA, CSR, MES
					Brenda Teruya
*******************************************************************************/
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"

*matricula
*2013 SOLO CUADRO 302
*2014 cuadro 201 (hay otros)
*2015 cuadro 201
*2016 cuadro 201 (hay otros)
*2017 cuadro C201

forvalues anio = 2013/2018 {
use "3. Data\2. IIEE Level\Stata\Matricula_01_`anio'.dta" , clear
*solo EBR 
gen nivel = .
replace nivel = 1 if inlist(NIV_MOD, "A1" , "A2" , "A3" )
replace nivel = 2 if NIV_MOD == "B0"
replace nivel = 3 if NIV_MOD == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
drop if missing(nivel)
dis `anio'
tab CUADRO nivel,m

	if `anio' == 2014 {
		keep if CUADRO == "201"
	}

	else if `anio' == 2016 {
		keep if CUADRO == "201"
	}
	dis `anio'
	tab CUADRO nivel, missing

egen matri =  rowtotal(D??) , missing
gen publico = substr(GES_DEP,1,1) == "A" // no hay missings
keep if publico
collapse (sum) matri, by(CODOOII)

gen year = `anio'
tabstat matri, stat(sum)
tempfile matri_`anio'
save `matri_`anio''

}
local year = 2013
use "3. Data\2. IIEE Level\Stata\Secciones_`year'.dta" , clear
gen nivel = .
replace nivel = 1 if inlist(NIV_MOD, "A1" , "A2" , "A3" )
replace nivel = 2 if NIV_MOD == "B0"
replace nivel = 3 if NIV_MOD == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
drop if missing(nivel)
tab CUADRO nivel, missing


egen seccion_ini =  rowtotal(D01-D07) if nivel == 1, missing
egen seccion_pri =  rowtotal(D01-D06) if nivel == 2, missing
egen seccion_sec =  rowtotal(D01-D10) if nivel == 3, missing

egen seccion_total = rowtotal(seccion_ini - seccion_sec), missing

collapse (sum) seccion_total, by(COD_MOD)
gen year = `year'
tabstat seccion_total, stat(sum)
tempfile seccion_`year'
save `seccion_`year''


use `matri_2013' , replace
forvalues anio = 2014/2018 {
append using `matri_`anio''
label data "Matrícula de EBR pública por UGEL"
}
tempfile matri_peru
save `matri_peru'



*todos los años tienen correctamente los cuadros
*no hay que elegir entre cuadros
*hay que buscar dónde están las auxiliares y sumar todos los docentes menos
*auxiliares

