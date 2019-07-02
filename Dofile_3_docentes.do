/*******************************************************************************
					PROYECCIÓN DE MATRÍCULA
					Dofile: Metodología Moving Average
					Brenda Teruya
*******************************************************************************/

*-------------------------------Docentes----------------------------------------
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"

use "3. Data\Datasets_intermedios\docentes_peru_2013-2018.dta", clear
isid year CODOOII



*los docentes se estiman a nivel nacional, no están grado a grado
destring CODOOII, gen(codooii)
xtset codooii year


tssmooth exponential doc_exp1 = doc_total, forecast(2)  // forecast 2019 y 2020

replace CODOOII = CODOOII[_n-1] if CODOOII == ""

bys codooii: gen doc_ma = (doc_total[_n-1] + doc_total[_n-2] + doc_total[_n-3])/3
replace doc_ma = (doc_ma[_n-1] + doc_total[_n-2] + doc_total[_n-3])/3 if year == 2020

gen epm_ma2018 = abs(doc_ma - doc_total)/doc_total if year == 2018
gen epm_exp2018 = abs(doc_exp1 - doc_total)/doc_total if year == 2018

gen epm_ue2018 = .


*-------------------------------------------------------------------------------
*preparando variables para el bucle
gen yniv = doc_total
label var yniv "Nivel de docentes"
gen ylog = log(doc_total)
label var ylog "Log docentes"
gen yinv = 1/doc_total
label var yinv "Inversa docentes"

gen tniv = year
label var tniv "Nivel de tiempo"
gen tlog = log(year)
label var tlog "Log tiempo"
gen tinv = 1/year
label var tinv "Inversa tiempo"
gen doc_metodo_ue = ""
label var doc_metodo_ue "Método escogido por UGEL con método UE"

gen doc_metodo = ""

encode CODOOII, gen(ugel)

foreach y in yniv ylog yinv {

	foreach x in tniv tlog tinv {

	gen modelo_`y'_`x' = .
	label var modelo_`y'_`x' "Estimación del modelo `y' vs `x' "
	gen epm_`y'_`x' = .
	label var epm_`y'_`x' "Error porcentual medio del modelo `y' vs `x' "

	}
}
*-------------------------------------------------------------------------------
*ugel por ugel

summarize ugel
local ugel_max = r(max)

forvalues ugel = 1/`ugel_max' {
	display `ugel'

	foreach y in yniv ylog yinv {

		foreach x in tniv tlog tinv {
			
		*local y yniv
		*loca x tniv
		*local ugel 1
		
		regress `y' `x' if ugel == `ugel'
		predict modelo_aux if ugel == `ugel', xb
		
		replace modelo_`y'_`x' = modelo_aux if ugel == `ugel' 
		
		if `y' == ylog {
		replace modelo_`y'_`x' = exp(modelo_`y'_`x')
		} 
		else if `y' == yinv{
		replace modelo_`y'_`x' = 1/modelo_`y'_`x'
		}
		
		replace epm_`y'_`x' = abs(modelo_`y'_`x' - doc_total)/doc_total ///
			if ugel == `ugel' & year == 2018
		
		drop modelo_aux

		}
	}
mvencode epm_y*  if ugel == `ugel', mv(0) override

local doc_min = .
foreach var of varlist epm_y*  {

summarize `var' if ugel == `ugel'
	if r(sum) < `doc_min' {
	local doc_min = r(sum)
	replace doc_metodo_ue = "`var'" if ugel == `ugel'	
	}
}
	replace epm_ue2018 = `doc_min' if ugel == `ugel' & year == 2018

dis `min_metodo'
codebook doc_metodo_ue
	
	
	
}
 
mvencode epm_ma2018  epm_exp2018 epm_ue2018 , mv(0) override
 
local doc_min = .
foreach var of varlist epm_ma2018  epm_exp2018 epm_ue2018 {

summarize `var'
	return list
	if r(sum) < `doc_min' {
	local doc_min = r(sum)
	replace doc_metodo = "`var'"	
	}
}

dis `doc_min'
codebook doc_metodo
count if year == 2018
local error = 100*`doc_min'/r(N)
dis "El error porcentual medio del mejor modelo es `error'% para el 2018"
