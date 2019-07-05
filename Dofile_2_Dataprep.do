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
keep if inlist(nivel,2,3) //solo primaria y secundaria como ejemplos
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

************ Matricula para el método BID
*matricula 2017

	use "3. Data\4. Student level\siagie-Input\data_2017", clear
	duplicates report id_persona
	duplicates report id_persona fecha_registro //cuando vemos la fecha ne la que la persona 
	gsort id_persona -fecha_registro
	duplicates tag id_persona, gen(dupli_persona)
	tab dupli_persona
	
	by id_persona: gen unique=_n //ya esta ordenado, de la fecha mas reciente a la mas antigua
	*unique sera 1 cuando sea la fecha mas reciente
	keep if unique==1
	*nos quedamos con los de la fecha de registro mas reciente, si la fecha de registro es la misma (44 casos)
	*es aleatorio

	gen dsc_grado_noespacio= subinstr(dsc_grado," ","",.)
	
	gen grado=.
	*inicial
	replace grado=2 if id_grado==1
	replace grado=3 if id_grado ==2 
	replace grado=3 if dsc_grado_noespacio=="Grupo3años"
	replace grado=4 if  dsc_grado_noespacio=="4años" 
	replace grado=4 if dsc_grado_noespacio=="Grupo4años"
	replace grado=5 if dsc_grado_noespacio=="5años"
	replace grado=5 if dsc_grado_noespacio=="Grupo5años"
	
	*primaria
	replace grado=6 if id_grado ==4 &  dsc_grado_noespacio=="PRIMERO"
	replace grado=7 if id_grado ==5 &  dsc_grado_noespacio=="SEGUNDO"
	replace grado=8 if id_grado ==6 &  dsc_grado_noespacio=="TERCERO"
	replace grado=9 if id_grado ==7 
	replace grado=10 if id_grado ==8
	replace grado=11 if  dsc_grado_noespacio =="SEXTO"
	
	*SECUNDARIA
	replace grado=12 if id_grado == 10
	replace grado=13 if id_grado == 11
	replace grado=14 if id_grado == 12
	replace grado=15 if id_grado == 13
	replace grado=16 if id_grado == 14
	
	rename id_anio year
	
	keep year id_persona grado cod_mod id_seccion
	
	tostring id_persona, replace format(%08.0f)
	tostring cod_mod, replace format(%07.0f)
	
	
	save "3. Data\Datasets_intermedios\siagie_2017.dta", replace 
	
	
	use "3. Data\Datasets_intermedios\siagie_2017.dta",clear
	gen matri_ = 1
	tostring cod_mod, replace format(%07.0f)
	
	replace id_seccion="01" if id_seccion=="  "
	encode id_seccion, gen(n_sec)
	
	
	collapse (sum) matri_ (max) n_sec, by(grado cod_mod)
	label data "Secciones y matricula por grado y codmod"
	save "3. Data\Datasets_intermedios\secc_efectiva_2017_b", replace
	
	use  "3. Data\Datasets_intermedios\secc_efectiva_2017_b", clear
	collapse (sum) n_sec_ef=n_sec, by(cod_mod)
	tab n_sec_ef
	label data "Secciones y matricula por codmod"
	save "3. Data\Datasets_intermedios\secc_efectiva_codmod_2017_b", replace
	
	
	use  "3. Data\Datasets_intermedios\secc_efectiva_2017_b", clear
	
	keep matri_ cod_mod grado
	reshape wide matri_, i(cod_mod) j(grado)
	
	label data "secciones y matricula por grado codmod wide"
	save "3. Data\Datasets_intermedios\matri_efectiva_2017_b", replace

	use "3. Data\2. IIEE Level\Stata\Padron_web.dta", clear
	
	rename _all, lower
	duplicates drop cod_mod, force
	keep niv_mod d_niv_mod d_forma cod_car d_cod_car gestion d_gestion ///
		ges_dep d_ges_dep codooii cod_mod
	merge 1:1 cod_mod using "3. Data\Datasets_intermedios\matri_efectiva_2017_b"
	*hay 80 codmod que solo estan en siagie no en el padron 
	*los busque en escale y no estan, los botare.
	keep if _m == 3
	drop _m
	
	gen publico = substr(ges_dep,1,1) == "A" // no hay missings
	keep if publico == 1
	
	collapse (sum) matri_* , by(codooii)
	label data "Matricula publica de c/grado por UGEL"
	gen year = 2017
	save "3. Data\Datasets_intermedios\matri_2017_UGEL", replace

*******TASAS A USAR DESERCION REPITENCIA
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

*-------------------------------secciones---------------------------------------

forvalues year = 2013/2018 {
use "3. Data\2. IIEE Level\Stata\Secciones_`year'.dta" , clear
gen nivel = .
replace nivel = 1 if inlist(NIV_MOD, "A1" , "A2" , "A3" )
replace nivel = 2 if NIV_MOD == "B0"
replace nivel = 3 if NIV_MOD == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
keep if inlist(nivel,2,3) //solo primaria y secundaria como ejemplos
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


