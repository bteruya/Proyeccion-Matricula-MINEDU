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
gsort id_persona -fecha_registro
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

collapse (sum) matri_ , by(grado cod_mod)
label data "Secciones y matricula por grado y codmod"
save "3. Data\Datasets_intermedios\secc_efectiva_2017_b", replace

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
*61,905 codmod que estan en padron y no siagie, esos 61mil no entrar al analisis
keep if _m == 3
drop _m

gen publico = substr(ges_dep,1,1) == "A" // no hay missings
keep if publico == 1

gen nivel = .
replace nivel = 1 if inlist(niv_mod, "A1" , "A2" , "A3" )
replace nivel = 2 if niv_mod == "B0"
replace nivel = 3 if niv_mod == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
keep if inlist(nivel,2,3) //solo primaria y secundaria como ejemplos

collapse (sum) matri_* , by(codooii)
label data "Matricula publica de c/grado por UGEL"
gen year = 2017
save "3. Data\Datasets_intermedios\matri_2017_UGEL", replace

*Matricula por ugel 2013-2017

use  "3. Data\4. Student level\siagie-Input\sit_final_cons_new.dta", clear
drop if year ==2012 //este ano solo tiene pronoei
keep if  unique 		
keep cod_mod grado id_persona fecnac year sit_final nombres apellimat apellipat dni sexo

tostring cod_mod id_persona, replace
replace cod_mod = "0"*(7-strlen(cod_mod)) + cod_mod 
replace id_persona = "0"*(8-strlen(id_persona)) + id_persona

gen matri_ = 1

preserve

use "3. Data\2. IIEE Level\Stata\Padron_web.dta", clear
rename _all, lower
keep if anexo=="0"
tempfile padron_cod
gen dpto_cod=substr(codgeo, 1, 2)
gen prov_cod=substr(codgeo, 1, 4)
gen publico = substr(ges_dep,1,1) == "A" // no hay missings
save `padron_cod', replace
	
restore
merge m:1 cod_mod using `padron_cod' , keepusing(  d_dpto d_prov d_dist ///
dpto_cod prov_cod gestion codgeo niv_mod area_censo publico codooii)

keep if publico == 1
		
keep if _merge==3 //publicas, EBR sin PRONOEI

collapse (sum) matri_ , by(codooii year grado)
reshape wide matri_, i(codooii year) j(grado)
label data "matricula por grado año y ugel"

append using "3. Data\Datasets_intermedios\matri_2017_UGEL"

save "3. Data\Datasets_intermedios\matri_ugel.dta" , replace

use "3. Data\2. IIEE Level\Stata\Padron_web.dta", clear
rename _all, lower
keep if anexo=="0"
tempfile padron_cod
gen dpto_cod=substr(codgeo, 1, 2)
gen prov_cod=substr(codgeo, 1, 4)
gen publico = substr(ges_dep,1,1) == "A" // no hay missings
save `padron_cod', replace

keep  d_dpto d_prov d_dist cod_mod ///
dpto_cod prov_cod gestion codgeo niv_mod area_censo publico codooii

merge 1:m cod_mod using "3. Data\4. Student level\2018.dta" 

encode dsc_grado, gen(dsc_grado_n)

gen nivel = .
replace nivel = 1 if inlist(niv_mod, "A1" , "A2" , "A3" )
replace nivel = 2 if niv_mod == "B0"
replace nivel = 3 if niv_mod == "F0"
drop if nivel == .

gen grado = .
replace grado = 2 if dsc_grado_n == 1 & nivel == 1
replace grado = 3 if dsc_grado_n == 2 & nivel == 1
replace grado = 4 if dsc_grado_n == 3 & nivel == 1
replace grado = 5 if dsc_grado_n == 4 & nivel == 1

replace grado = 9 if dsc_grado_n == 5 & nivel == 2
replace grado = 15 if dsc_grado_n == 5 & nivel == 3

replace grado = 3 if dsc_grado_n == 6 & nivel == 1
replace grado = 4 if dsc_grado_n == 7 & nivel == 1
replace grado = 5 if dsc_grado_n == 8 & nivel == 1

replace grado = 6 if dsc_grado_n == 9 & nivel == 2
replace grado = 12 if dsc_grado_n == 9 & nivel == 3

replace grado = 9 if dsc_grado_n == 10 & nivel == 2
replace grado = 6 if dsc_grado_n == 11 & nivel == 2
replace grado = 10 if dsc_grado_n == 12 & nivel == 2
replace grado = 7 if dsc_grado_n == 13 & nivel == 2
replace grado = 11 if dsc_grado_n == 14 & nivel == 2

replace grado = 8 if dsc_grado_n == 15 & nivel == 2
replace grado = 16 if dsc_grado_n == 16 & nivel == 3
replace grado = 10 if dsc_grado_n == 16 & nivel == 2

replace grado = 7 if dsc_grado_n == 17 & nivel == 2
replace grado = 13 if dsc_grado_n == 17 & nivel == 3

replace grado = 11 if dsc_grado_n == 18 & nivel == 2
replace grado = 8 if dsc_grado_n == 19 & nivel == 2
replace grado = 14 if dsc_grado_n == 19 & nivel == 3

preserve 
drop d_dpto d_prov d_dist cod_mod ///
dpto_cod prov_cod gestion codgeo niv_mod area_censo publico codooii nivel

save "3. Data\Datasets_intermedios\siagie_2018", replace
restore

gen matri_ = 1
gen year = 2018

keep if publico == 1
		
keep if _merge==3 //publicas, EBR sin PRONOEI

collapse (sum) matri_, by(codooii year grado)
reshape wide matri_, i(codooii year) j(grado)
label data "matricula por grado año y ugel"

append using "3. Data\Datasets_intermedios\matri_ugel.dta"
label data "Matricula por grado ugel y año"

rename codooii CODOOII
destring CODOOII, gen(codooii)
xtset codooii year

forvalues i = 2/16 {
tssmooth exponential matri_exp_`i' = matri_`i' , forecast(2) 
label var matri_exp_`i' "Matricula edad `i' por UGEL forecast exponencial"
}

save "3. Data\Datasets_intermedios\matri_ugel_2020.dta", replace

*******TASAS A USAR DESERCION desaprobados traslado
	
*1. Desercion
use  "3. Data\4. Student level\siagie-Input\sit_final_cons_new.dta", clear
drop if year ==2012 //este ano solo tiene pronoei
keep if  unique 		
keep cod_mod grado id_persona fecnac year sit_final nombres apellimat apellipat dni sexo

tostring cod_mod id_persona, replace
replace cod_mod = "0"*(7-strlen(cod_mod)) + cod_mod 
replace id_persona = "0"*(8-strlen(id_persona)) + id_persona

append using "3. Data\Datasets_intermedios\siagie_2017.dta"

bys id_persona: gen  drop_den =  (grado < 16)  & year < 2017

sort id_persona year
bys id_persona: gen  drop = grado[_n+1] == . & (grado < 16) & year < 2017

preserve 

use "3. Data\2. IIEE Level\Stata\Padron_web.dta", clear
rename _all, lower
keep if anexo=="0"
tempfile padron_cod
gen dpto_cod=substr(codgeo, 1, 2)
gen prov_cod=substr(codgeo, 1, 4)
gen publico = substr(ges_dep,1,1) == "A" // no hay missings
save `padron_cod', replace
	
restore
merge m:1 cod_mod using `padron_cod' , keepusing(  d_dpto d_prov d_dist ///
dpto_cod prov_cod gestion codgeo niv_mod area_censo publico codooii)

keep if publico == 1
		
keep if _merge==3 //publicas, EBR sin PRONOEI
save "3. Data\Datasets_intermedios\desercion_id.dta" , replace

use  "3. Data\Datasets_intermedios\desercion_id.dta",clear
gen nivel = .
replace nivel = 1 if inlist(niv_mod, "A1" , "A2" , "A3" )
replace nivel = 2 if niv_mod == "B0"
replace nivel = 3 if niv_mod == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
keep if inlist(nivel,2,3) //solo primaria y secundaria como ejemplos

tabstat nivel, stat(min max) by(grado) // por grado está bien definido el nivel. 
*Los grados de primaria tienen 2 y secundaria 3, no hay alguno cruzado

collapse (sum)  drop* (first) d_dpto d_prov prov_cod, by(year codooii nivel) 
gen  r_drop = drop/drop_den

label var r_drop "Tasa desercion prim/sec x UGEL y año"
keep r_drop year codooii nivel
reshape wide r_drop , i(year codooii) j(nivel)
rename codooii CODOOII
destring CODOOII, gen(codooii)
xtset codooii year


replace year = year + 1
drop if year == 2018

tssmooth exponential r_drop2_exp = r_drop2 , forecast(3) 
label var r_drop2_exp "Deserción por UGEL forecast exponencial primaria"
tssmooth exponential r_drop3_exp = r_drop3  , forecast(3) 
label var r_drop3_exp "Deserción por UGEL forecast exponencial secundaria"

replace CODOOII = CODOOII[_n-1] if CODOOII == ""

save "3. Data\Datasets_intermedios\deser_ugel2020", replace


*2. Desaprobados

use  "3. Data\4. Student level\siagie-Input\sit_final_cons_new.dta", clear

drop if year == 2012
keep if  unique 		
keep cod_mod grado id_persona fecnac year sit_final nombres apellimat apellipat dni sexo 

keep if grado>=7 & grado <=16 

tostring cod_mod id_persona, replace

replace cod_mod = "0"*(7-strlen(cod_mod)) + cod_mod 

replace id_persona = "0"*(8-strlen(id_persona)) + id_persona

preserve 

use "3. Data\2. IIEE Level\Stata\Padron_web.dta", clear
rename _all, lower
keep if anexo=="0"
tempfile padron_cod
gen dpto_cod=substr(codgeo, 1, 2)
gen prov_cod=substr(codgeo, 1, 4)
gen publico = substr(ges_dep,1,1) == "A" // no hay missings
save `padron_cod', replace
	
restore
merge m:1 cod_mod using `padron_cod' , keepusing(  d_dpto d_prov d_dist ///
dpto_cod prov_cod gestion codgeo niv_mod area_censo publico codooii)

keep if publico == 1
		
keep if _merge==3 //publicas, EBR sin PRONOEI

gen desaprobado=1 if sit_final==2
gen matri=1
drop if grado==16


gen nivel = .
replace nivel = 1 if inlist(niv_mod, "A1" , "A2" , "A3" )
replace nivel = 2 if niv_mod == "B0"
replace nivel = 3 if niv_mod == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
keep if inlist(nivel,2,3) //solo primaria y secundaria como ejemplos

save  "3. Data\Datasets_intermedios\desapr_id.dta" , replace

*-----------------------------------------------------------
use "3. Data\Datasets_intermedios\desapr_id.dta" , clear

collapse  (sum)  desaprobado matri  (first) d_dpto d_prov d_dist dpto_cod prov_cod, by( year codooii nivel) 

gen tasa_desapr= desaprobado/matri

label var tasa_desapr "Tasa repitencia por ugel prim/sec"
keep tasa_desapr year codooii nivel
reshape wide tasa_desapr , i( year codooii) j(nivel)

rename codooii CODOOII
destring CODOOII, gen(codooii)
xtset codooii year

tssmooth exponential t_desap_exp2 = tasa_desapr2 , forecast(4) 
label var t_desap_exp "Desaprobación por UGEL forecast exponencial primaria"
tssmooth exponential t_desap_exp3 = tasa_desapr3 , forecast(4) 
label var t_desap_exp3 "Desaprobación por UGEL forecast exponencial secundaria"

save "3. Data\Datasets_intermedios\desapr_ugel2020", replace


*3. Traslado migracion
	*no hay migracion de quinto de secundaria


use  "3. Data\4. Student level\siagie-Input\sit_final_cons_new.dta", clear
drop if year ==2012 //este ano solo tiene pronoei
keep if  unique 		
keep cod_mod grado id_persona fecnac year sit_final nombres apellimat apellipat dni sexo

tostring cod_mod id_persona, replace
replace cod_mod = "0"*(7-strlen(cod_mod)) + cod_mod 
replace id_persona = "0"*(8-strlen(id_persona)) + id_persona

append using "3. Data\Datasets_intermedios\siagie_2017.dta"

keep if grado>=6 

tostring cod_mod id_persona, replace

replace cod_mod = "0"*(7-strlen(cod_mod)) + cod_mod 

replace id_persona = "0"*(8-strlen(id_persona)) + id_persona
	

preserve 

use "3. Data\2. IIEE Level\Stata\Padron_web.dta", clear
rename _all, lower
keep if anexo=="0"
tempfile padron_cod
gen dpto_cod=substr(codgeo, 1, 2)
gen prov_cod=substr(codgeo, 1, 4)
gen publico = substr(ges_dep,1,1) == "A" // no hay missings
save `padron_cod', replace
	
restore
merge m:1 cod_mod using `padron_cod' , keepusing(  d_dpto d_prov d_dist ///
dpto_cod prov_cod gestion codgeo niv_mod area_censo publico codooii)

keep if publico == 1
			
keep if _merge==3 //publicas, EBR sin PRONOEI
	
sort id_persona year
		
bys id_persona: gen  tras = codooii[_n] != codooii[_n+1]  & year<2018  & grado[_n+1] != . 

bys id_persona:  gen codooii_mas= codooii[_n+1]	if tras==1

gen tras_mas= 1 if codooii_mas!=""
	
gen nivel = .
replace nivel = 1 if inlist(niv_mod, "A1" , "A2" , "A3" )
replace nivel = 2 if niv_mod == "B0"
replace nivel = 3 if niv_mod == "F0"

label  def nivel 1 "Inicial sin PRONOEI" 2 "Primaria" 3 "Secundaria"
label val nivel nivel
keep if inlist(nivel,2,3) //solo primaria y secundaria como ejemplos

label data "data con dummy que dice si la persona se traslado  de ugel entre 2013-2017"
save "3. Data\Datasets_intermedios\tras_trasmas_id.dta", replace

	
	
use  "3. Data\Datasets_intermedios\tras_trasmas_id.dta", clear
gen matri=1
	
drop if grado==16

preserve

drop if codooii_mas==""
drop codooii tras
rename codooii_mas codooii
collapse  (sum)  tras_mas , by( year codooii nivel )	//todos los a;os	

tempfile entradas_v2
save `entradas_v2' , replace

restore


collapse  (sum)  tras matri , by( year codooii nivel)	
	 
  cap drop _merge
 merge 1:1 year codooii nivel using `entradas_v2'  // no cruzan por los grado no coinciden
 
 drop _merge
 sort codooii year 
 
 mvencode tras*, mv(0) override
 gen flujo_neto= tras_mas -tras
 
gen tasa_tras= flujo_neto/matri
 
keep tasa_tras year codooii nivel
reshape wide tasa_tras , i( year codooii) j(nivel)

rename codooii CODOOII
destring CODOOII, gen(codooii)
xtset codooii year

replace year = year + 1
drop if year == 2018

tssmooth exponential t_tras_exp2 = tasa_tras2 , forecast(3) 
label var t_tras_exp2 "Traslado por UGEL forecast exponencial primaria"
tssmooth exponential t_tras_exp3 = tasa_tras3 , forecast(3) 
label var t_tras_exp3 "Traslado por UGEL forecast exponencial secundaria"
label data "Tasa traslado por ugel y nivel: prim/sec promediada por a;os 2013-2017"

save "3. Data\Datasets_intermedios\tras_ugel2020", replace
	 

use "3. Data\Datasets_intermedios\tras_ugel2020", clear

merge 1:1 year codooii using "3. Data\Datasets_intermedios\desapr_ugel2020", nogen

merge 1:1 year codooii using "3. Data\Datasets_intermedios\deser_ugel2020", nogen

save "3. Data\Datasets_intermedios\tasas_2020.dta" , replace

use  "3. Data\Datasets_intermedios\matri_ugel_2020.dta", clear
merge 1:1 codooii year using "3. Data\Datasets_intermedios\tasas_2020.dta", nogen
save "3. Data\Datasets_intermedios\matri_tasas_2020.dta" , replace

*MCO forecast
*-------------------------------------------------------------------------------
use "3. Data\Datasets_intermedios\matri_tasas_2020.dta", clear
replace CODOOII = CODOOII[_n-1] if CODOOII == ""


p2_metodo_ue_year tasa_desapr2 2016 // 2016 es el ultimo año disponible
drop metodo_ue metodo epm_ue2016 ugel
rename ue t_desap_ue2

p2_metodo_ue_year tasa_desapr3 2016 // 2016 es el ultimo año disponible
drop metodo_ue metodo epm_ue2016 ugel
rename ue t_desap_ue3

/*
p2_metodo_ue_year r_drop2 2017 // 2017 es el ultimo año disponible
drop metodo_ue metodo epm_ue2017 ugel
rename ue r_drop2_ue
mvencode r_drop2_ue , mv(0) override
*/
p2_metodo_ue_year r_drop3 2017 // 2017 es el ultimo año disponible
drop metodo_ue metodo epm_ue2017 ugel
rename ue r_drop3_ue
*mvencode r_drop3_ue , mv(0) override

gen t_tras_mas = tasa_tras2 + 1 // mas uno porque log de negativo es missing

p2_metodo_ue_year t_tras_mas 2017 // 2017 es el ultimo año disponible
drop metodo_ue metodo epm_ue2017 ugel
replace ue = ue - 1  // menos uno para retomar la forma anterior
rename ue t_tras_ue2

replace t_tras_mas = tasa_tras3 + 1

p2_metodo_ue_year t_tras_mas 2017 // 2017 es el ultimo año disponible
drop metodo_ue metodo epm_ue2017 ugel
replace ue = ue - 1 
rename ue t_tras_ue3

forvalues i = 6/16 {
p2_metodo_ue_year matri_`i' 2018
drop metodo_ue metodo epm_ue2018 ugel
rename ue matri_ue_`i'
label var matri_ue_`i' "Matricula edad `i' por UGEL forecast exponencial"

}

save "3. Data\Datasets_intermedios\matri_tasas_2020_MCO.dta", replace
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


