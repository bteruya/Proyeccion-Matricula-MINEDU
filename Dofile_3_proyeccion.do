/*******************************************************************************
					PROYECCIÓN DE VARIABLES EDUCATIVAS
					Orden: 3
					Dofile: Docentes
					Brenda Teruya
*******************************************************************************/

*-------------------------------Docentes----------------------------------------
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"

use "3. Data\Datasets_intermedios\docentes_peru_2013-2018.dta", clear

*programa que proyecta según ma y exp
p1_exp_ma doc_total

*programa que proyecta según MCO por UGEL
p2_metodo_ue doc_total
 
*programa que elige entre metodos
global epm epm_ma2018 epm_exp2018 epm_ue2018 

p3_eleccion $epm 
 
tabstat ue, stat(sum) by(year)
graph bar (sum) ue , over(year)

replace epm_ma2018 = epm_ma2018/221 //hay 221 UGEL en 2018 
replace epm_exp2018 = epm_exp2018/221
replace epm_ue2018 = epm_ue2018/221

export excel CODOOII year doc_total metodo metodo_ue ue exp1 ma   using "4. Codigos\Output\Proyeccion_porUGEL.xls", ///
	sheet("doc_total") sheetreplace firstrow(varlabels)

collapse (sum) ue doc_total exp1 ma ///
	$epm , by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("Docentes") sheetreplace firstrow(variables)


*-------------------------------Secciones---------------------------------------

foreach var in seccion_4 seccion_4_prim seccion_4_secun {
use "3. Data\Datasets_intermedios\matricula_secciones_peru_2013-2018.dta",  clear

keep `var' CODOOII year
codebook `var'

*programa que proyecta según ma y exp
p1_exp_ma `var'

*programa que proyecta según MCO por UGEL
p2_metodo_ue `var'

global epm epm_ma2018 epm_exp2018 epm_ue2018 

p3_eleccion $epm 

replace epm_ma2018 = epm_ma2018/221
replace epm_exp2018 = epm_exp2018/221
replace epm_ue2018 = epm_ue2018/221

export excel CODOOII year `var' metodo metodo_ue ue exp1 ma   using "4. Codigos\Output\Proyeccion_porUGEL.xls", ///
	sheet("`var'") sheetreplace firstrow(varlabels)

collapse (sum) ue `var' exp1 ma ///
	epm_ma2018 epm_exp2018 epm_ue2018, by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("`var'") sheetreplace firstrow(variables)
	
}


*-------------------------------Matrícula---------------------------------------

global variables4 matri_4 matri_4_prim matri_4_secun
global variables3 matri_3 matri_3_prim matri_3_secun

local n : word count $variables4

forval i = 1/`n' {	
use "3. Data\Datasets_intermedios\matricula_secciones_peru_2013-2018.dta",  clear
	local var4 : word `i' of $variables4
	local var3 : word `i' of $variables3

*programa que proyecta según ma y exp
p1_exp_ma `var4'

*programa que proyecta según MCO por UGEL
p2_metodo_ue `var4'
*--------
*Cohort Survival Ratio
gen CSR = ( `var4' + L1.`var4' ) /(L1.`var3' + L2.`var3' )
gen mat_CSR = L1.CSR * L1.`var3'
label variable mat_CSR "Cohort Survival Ratio"
replace  mat_CSR = L2.CSR * L1.mat_CSR if year == 2020

gen epm_csr2018 = abs(mat_CSR - `var4')/`var4' if year == 2018

global epm epm_ma2018 epm_exp2018 epm_ue2018 epm_csr2018

p3_eleccion $epm 

replace epm_ma2018 = epm_ma2018/221
replace epm_exp2018 = epm_exp2018/221
replace epm_ue2018 = epm_ue2018/221
replace epm_csr2018 = epm_csr2018/221

*exportamos la bd

export excel CODOOII year `var4' metodo metodo_ue ue exp1 ma  mat_CSR using "4. Codigos\Output\Proyeccion_porUGEL.xls", ///
	sheet("`var4'") sheetreplace firstrow(varlabels)

collapse (sum) ue `var4' exp1 ma mat_CSR ///
	epm_ma2018  epm_exp2018 epm_ue2018 epm_csr2018 , by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("`var4'") sheetreplace firstrow(variables)
}

use "3. Data\Datasets_intermedios\matri_tasas_2020.dta" , clear
*en 2017 no hay inicial, debido a la bd que me han pasado
* seguimos con lo que tenemos
keep matri_* matri_exp_* codooii year t_tras_exp2 t_tras_exp3 t_desap_exp2 t_desap_exp3 r_drop2_exp r_drop3_exp

renvars matri_? matri_?? matri_exp_* ///
	 , suffix("_")

reshape wide matri_?_ matri_??_ matri_exp_* ///
	t_tras_exp2 t_tras_exp3 t_desap_exp2 t_desap_exp3 r_drop2_exp r_drop3_exp , i(codooii ) j(year)


	forval a = 2017/2019 {
	local b = `a'+1 
	
	gen p_matri_7_`b' = matri_6_`a'*(1 - r_drop2_exp`a'  + t_tras_exp2`a')+matri_7_`a'*t_desap_exp2`a'
	
	forval x = 7/10 {
	local y = `x' + 1
	gen p_matri_`y'_`b' = matri_`x'_`a'*(1 - r_drop2_exp`a' - t_desap_exp2`a'+ t_tras_exp2`a') + matri_`y'_`a'*t_desap_exp2`a'
	}
	
	gen p_matri_12_`b' = matri_11_`a'*(1 - r_drop2_exp`a' - t_desap_exp2`a'+ t_tras_exp2`a')+  matri_11_`a'*t_desap_exp3`a'
	forval x = 13/15{
	local y = `x'+1
	gen p_matri_`y'_`b' = matri_`x'_`a'*(1 - r_drop3_exp`a' - t_desap_exp3`a'+ t_tras_exp3`a') + matri_`y'_`a'*t_desap_exp3`a'
	}
	
	/*forval x = 3/5 {
	gen p_matri20`b'_`x' = matri20`b'_6 * cobertura_`x'
	replace p_matri20`b'_`x' = matri20`a'_`x' if matri20`b'_`x' == 0
	
	}	
	*/
	}


