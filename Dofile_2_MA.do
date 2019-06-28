/*******************************************************************************
					PROYECCIÓN DE MATRÍCULA
					Dofile: Metodología Moving Average
					Brenda Teruya
*******************************************************************************/

*-------------------------------Docentes----------------------------------------

use "3. Data\Datasets_intermedios\docentes_peru_2013-2018.dta", clear
isid year CODOOII

*los docentes se estiman a nivel nacional, no están grado a grado
destring CODOOII, gen(codooii)
xtset codooii year

tssmooth exponential doc_exp1 = doc_total, forecast(2)  // forecast 2019 y 2020

bys codooii: gen doc_ma = (doc_total[_n-1] + doc_total[_n-2] + doc_total[_n-3])/3
replace doc_ma = (doc_ma[_n-1] + doc_total[_n-2] + doc_total[_n-3])/3 if year == 2020

gen epm_ma2018 = (doc_ma-doc_total)^2
