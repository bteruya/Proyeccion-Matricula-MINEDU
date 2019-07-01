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

bys codooii: gen doc_ma = (doc_total[_n-1] + doc_total[_n-2] + doc_total[_n-3])/3
replace doc_ma = (doc_ma[_n-1] + doc_total[_n-2] + doc_total[_n-3])/3 if year == 2020





gen epm_ma2018 = abs(doc_ma - doc_total)/doc_total if year == 2018
gen epm_exp2018 = abs(doc_exp1 - doc_total)/doc_total if year == 2018
mvencode epm_ma2018 epm_exp2018 , mv(0) override

summ epm_ma2018
return list
local epm_ma2018_t =  r(sum)

summ epm_exp2018
return list
local epm_exp2018_t =  r(sum)

local doc_min = .
gen doc_metodo = ""
foreach var of varlist epm_ma2018  epm_exp2018  {

summ `var'
	if r(sum) < `doc_min' {
	local min_metodo `doc_min' = r(sum)
	replace doc_metodo = "`var'"	
	}
}

dis `min_metodo'
codebook doc_metodo


