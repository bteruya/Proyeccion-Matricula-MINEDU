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
 
global epm epm_ma2018 epm_exp2018 epm_ue2018 

p3_eleccion $epm 
 
tabstat ue, stat(sum) by(year)
graph bar (sum) ue , over(year)

replace epm_ma2018 = epm_ma2018/221
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
gen CSR = ( `var4' + L1.`var4' + L2.`var4') /(L1.`var3' + L2.`var3' + L3.`var3')
replace CSR = L1.CSR if inlist(year, 2019,2020)
gen mat_CSR = CSR * L1.`var4'
label variable mat_CSR "Cohort Survival Ratio"
replace  mat_CSR = CSR * L1.mat_CSR if year == 2019 | year == 2020

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


