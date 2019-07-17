/*******************************************************************************
					PROYECCIÓN DE VARIABLES EDUCATIVAS
					Orden: 3
					Dofile: Proyecciones	
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

export excel CODOOII year doc_total metodo metodo_ue ue exp1 ma   using ///
	"4. Codigos\Output\Proyeccion_porUGEL.xls", ///
	sheet("doc_total") sheetreplace firstrow(varlabels)
	
	
preserve

keep CODOOII year doc_total
drop if year == 2013
reshape wide doc_total , ///
	i(CODOOII) j(year)
export excel using "4. Codigos\Output\Proyeccion_actual_UE.xls", ///
	sheet("doc_total") sheetreplace firstrow(variables)

*En este excel está la serie de docentes totales que se pone en el aplicativo
*excel de la actual metodologia UE

restore 
preserve

collapse (sum) ue doc_total exp1 ma ///
	$epm , by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("Docentes") sheetreplace firstrow(variables)

restore

export excel codooii CODOOII epm_ue2018 if year == 2018 using ///
 "3. Data\Datasets_intermedios\Mapa.xls", sheet("doc_total") sheetreplace ///
	firstrow(variables)

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

export excel CODOOII year `var' metodo metodo_ue ue exp1 ma   using ///
	"4. Codigos\Output\Proyeccion_porUGEL.xls", ///
	sheet("`var'") sheetreplace firstrow(varlabels)

preserve 
collapse (sum) ue `var' exp1 ma ///
	epm_ma2018 epm_exp2018 epm_ue2018, by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("`var'") sheetreplace firstrow(variables)
	
restore	
keep CODOOII year `var'
keep if inrange(year, 2014,2018)
reshape wide `var' , ///
	i(CODOOII) j(year)
export excel using "4. Codigos\Output\Proyeccion_actual_UE.xls", ///
	sheet("`var'") sheetreplace firstrow(variables)
	
}


*-------------------------------Matrícula---------------------------------------
*BID exp
use "3. Data\Datasets_intermedios\matri_tasas_2020.dta" , clear
*en 2017 no hay inicial, debido a la bd que me han pasado
* seguimos con lo que tenemos
keep matri_* matri_exp_* codooii year t_tras_exp2 t_tras_exp3 ///
	t_desap_exp2 t_desap_exp3 r_drop2_exp r_drop3_exp

renvars matri_? matri_?? matri_exp_* ///
	 , suffix("_")

reshape wide matri_?_ matri_??_ matri_exp_* ///
	t_tras_exp2 t_tras_exp3 t_desap_exp2 t_desap_exp3 r_drop2_exp r_drop3_exp , ///
	i(codooii ) j(year)


forval a = 2017/2019 {
*local a 2017
local b = `a'+1 

gen p_matri_7_`b' = matri_exp_6_`a'*(1 - r_drop2_exp`a'  + t_tras_exp2`a') ///
	+ matri_exp_7_`a'*t_desap_exp2`a'

forval x = 7/10 {
local y = `x' + 1
gen p_matri_`y'_`b' = matri_exp_`x'_`a'*(1 - r_drop2_exp`a' - t_desap_exp2`a' + ///
	t_tras_exp2`a') + matri_exp_`y'_`a'*t_desap_exp2`a'
}

gen p_matri_12_`b' = matri_exp_11_`a'*(1 - r_drop2_exp`a' - t_desap_exp2`a'+ t_tras_exp2`a')+  matri_exp_11_`a'*t_desap_exp3`a'
forval x = 13/15{
local y = `x'+1
gen p_matri_`y'_`b' = matri_exp_`x'_`a'*(1 - r_drop3_exp`a' - t_desap_exp3`a'+ t_tras_exp3`a') + matri_exp_`y'_`a'*t_desap_exp3`a'
}

}
keep codooii p_matri_9_20?? p_matri_15_20?? ///
	matri_9_20?? matri_15_20?? //4to primaria y 4to secundaria
rename (p_matri_9_20?? p_matri_15_20?? matri_9_20?? matri_15_20?? ) ///
	(matri_4_prim_bid20?? matri_4_sec_bid20?? matri_4_prim_siagie20?? matri_4_sec_siagie20??)
reshape long matri_4_prim_bid matri_4_sec_bid matri_4_prim_siagie matri_4_sec_siagie ///
	, i(codooii) j(year)

egen matri_4_bid = rowtotal(matri_4_prim_bid matri_4_sec_bid)
egen matri_4_siagie = rowtotal(matri_4_prim_siagie matri_4_sec_siagie), missing

gen epm_bid_prim = abs(matri_4_prim_bid - matri_4_prim_siagie)/matri_4_prim_siagie if year == 2018
gen epm_bid_sec = abs(matri_4_sec_bid - matri_4_sec_siagie)/matri_4_sec_siagie if year == 2018
gen epm_bid = abs(matri_4_bid - matri_4_siagie)/matri_4_siagie if year == 2018


save "3. Data\Datasets_intermedios\matri_proy_2020.dta", replace

*-------------------------------------------------------------------------------
*BID MCO
use "3. Data\Datasets_intermedios\matri_tasas_2020_MCO.dta" , clear
*en 2017 no hay inicial, debido a la bd que me han pasado
* seguimos con lo que tenemos
keep  matri_ue_? matri_ue_?? matri_? matri_?? codooii year t_tras_ue2 t_tras_ue3 t_desap_ue2 t_desap_ue3 r_drop2_ue r_drop3_ue

renvars matri_? matri_?? matri_ue_? matri_ue_?? ///
	 , suffix("_")

reshape wide matri_?_ matri_??_ matri_ue_?_ matri_ue_??_ ///
	t_tras_ue2 t_tras_ue3 t_desap_ue2 t_desap_ue3 r_drop2_ue r_drop3_ue , i(codooii ) j(year)


forval a = 2017/2019 {
*local a 2017
local b = `a'+1 

gen p_ue_matri_7_`b' = matri_ue_6_`a'*(1 - r_drop3_ue`a'  + t_tras_ue2`a')+matri_ue_7_`a'*t_desap_ue2`a'

forval x = 7/10 {
local y = `x' + 1
gen p_ue_matri_`y'_`b' = matri_ue_`x'_`a'*(1 - r_drop3_ue`a' - t_desap_ue2`a'+ t_tras_ue2`a') + matri_ue_`y'_`a'*t_desap_ue2`a'
}

gen p_ue_matri_12_`b' = matri_ue_11_`a'*(1 - r_drop3_ue`a' - t_desap_ue2`a'+ t_tras_ue2`a')+  matri_ue_11_`a'*t_desap_ue3`a'
forval x = 13/15{
local y = `x'+1
gen p_ue_matri_`y'_`b' = matri_ue_`x'_`a'*(1 - r_drop3_ue`a' - t_desap_ue3`a'+ t_tras_ue3`a') + matri_ue_`y'_`a'*t_desap_ue3`a'
}

}



keep codooii p_ue_matri_9_20?? p_ue_matri_15_20?? ///
	matri_9_20?? matri_15_20?? //4to primaria y 4to secundaria
rename ( p_ue_matri_9_20?? p_ue_matri_15_20?? matri_9_20?? matri_15_20?? ) ///
	(matri_4_prim_bid_mco20?? matri_4_sec_bid_mco20?? matri_4_prim_siagie20?? matri_4_sec_siagie20??)
reshape long matri_4_prim_bid_mco matri_4_sec_bid_mco matri_4_prim_siagie matri_4_sec_siagie ///
	, i(codooii) j(year)

egen matri_4_bid_mco = rowtotal(matri_4_prim_bid_mco matri_4_sec_bid_mco)
egen matri_4_siagie = rowtotal(matri_4_prim_siagie matri_4_sec_siagie), missing

gen epm_bid_prim_mco = abs(matri_4_prim_bid - matri_4_prim_siagie)/matri_4_prim_siagie if year == 2018
gen epm_bid_sec_mco = abs(matri_4_sec_bid - matri_4_sec_siagie)/matri_4_sec_siagie if year == 2018
gen epm_bid_mco = abs(matri_4_bid - matri_4_siagie)/matri_4_siagie if year == 2018

drop matri_*siagie

save "3. Data\Datasets_intermedios\matri_proy_2020_MCO.dta", replace
*-------------------------------------------------------------------------------
global variables4 matri_4 matri_4_prim matri_4_secun
global variables3 matri_3 matri_3_prim matri_3_secun
global errorbid epm_bid epm_bid_prim epm_bid_sec
global matribid matri_4_bid matri_4_prim_bid matri_4_sec_bid
global errorbidmco epm_bid_mco epm_bid_prim_mco epm_bid_sec_mco 
global matribidmco matri_4_bid_mco matri_4_prim_bid_mco matri_4_sec_bid_mco 

local n : word count $variables4

forval i = 1/`n' {	
use "3. Data\Datasets_intermedios\matricula_secciones_peru_2013-2018.dta",  clear
	local var4 : word `i' of $variables4
	codebook `var4'
	local var3 : word `i' of $variables3
	local varbid : word `i' of $errorbid
	local matbid : word `i' of $matribid
	local e_bid_mco : word `i' of $errorbidmco
	local m_bid_mco : word `i' of $matribidmco
	
	
*programa que proyecta según ma y exp
p1_exp_ma `var4'

*programa que proyecta según MCO por UGEL
p2_metodo_ue `var4'
*--------
*Cohort Survival Ratio
gen CSR = ( `var4' + L1.`var4' ) /(L1.`var3' + L2.`var3' )
gen mat_CSR = CSR * L1.`var3' if year < 2018
label variable mat_CSR "Cohort Survival Ratio"
replace CSR = L1.CSR if CSR == .
replace mat_CSR = L1.CSR * L1.mat_CSR if year >= 2018

gen epm_csr2018 = abs(mat_CSR - `var4')/`var4' if year == 2018

merge 1:1 codooii year using "3. Data\Datasets_intermedios\matri_proy_2020.dta", nogen
merge 1:1 codooii year using "3. Data\Datasets_intermedios\matri_proy_2020_MCO.dta"
global epm epm_ma2018 epm_exp2018 epm_ue2018 epm_csr2018 `varbid' `e_bid_mco'

p3_eleccion $epm 

replace epm_ma2018 = epm_ma2018/221
replace epm_exp2018 = epm_exp2018/221
replace epm_ue2018 = epm_ue2018/221
replace epm_csr2018 = epm_csr2018/221
replace `varbid' = `varbid'/222
replace `e_bid_mco' = `e_bid_mco' / 222
*exportamos la bd

export excel CODOOII year `var4' `m_bid_mco' metodo metodo_ue ue exp1 ma  mat_CSR `matbid' /// 
using "4. Codigos\Output\Proyeccion_porUGEL.xls", ///
	sheet("`var4'") sheetreplace firstrow(varlabels)

collapse (sum) ue `var4'  exp1 ma mat_CSR `matbid' `m_bid_mco' ///
	epm_ma2018  epm_exp2018 epm_ue2018 epm_csr2018 `varbid' `e_bid_mco' , by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("`var4'") sheetreplace firstrow(variables)
}



*Método UE del Excel, pasar data a Excel y luego copiarla al aplicativo con el que
*se proyecta

use "3. Data\Datasets_intermedios\matricula_secciones_peru_2013-2018.dta",  clear
keep CODOOII year matri_4*
rename matri_4 matri_4_
drop if year == 2013
reshape wide matri_4_* ///
	, i(CODOOII) j(year)

order CODOOII matri_4_???? matri_4_prim???? matri_4_secun????
export excel using "4. Codigos\Output\Proyeccion_actual_UE.xls", ///
	sheet("Matricula") sheetreplace firstrow(variables)

*Metodo a usar aprobados y deaprobados por UGEL 

use "3. Data\Datasets_intermedios\aprobados2013_2018.dta", clear
rename codooii CODOOII	
merge 1:1 CODOOII year using "3. Data\Datasets_intermedios\matricula_secciones_peru_2013-2018.dta" /// 
	, keepusing(matri_4*)

preserve

use "3. Data\Datasets_intermedios\matri_tasas_2020_MCO.dta" , clear
keep if year == 2020
keep CODOOII
expand 2
bys CODOOII : gen year = _n
replace year = 2018 + year

tempfile append2020
save `append2020'

restore

append using `append2020'

sort CODOOII year
save "3. Data\Datasets_intermedios\aprobados_matri2020.dta", replace

use "3. Data\Datasets_intermedios\aprobados_matri2020.dta", clear

p2_metodo_ue_year aprob_7 2018 
drop metodo_ue metodo epm_ue2016 ugel
rename ue aprob_6_ue
