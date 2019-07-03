/*******************************************************************************
					PROYECCIÓN DE VARIABLES EDUCATIVAS
					Orden: 5
					Dofile: secciones
					Brenda Teruya
*******************************************************************************/
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"

*-------------------------------Matrícula---------------------------------------
use "3. Data\Datasets_intermedios\matricula_secciones_peru_2013-2018.dta",  clear
isid year CODOOII

destring CODOOII, gen(codooii)
xtset codooii year

tssmooth exponential sec_exp1 = seccion_4, forecast(2)  // forecast 2019 y 2020
label var sec_exp1 "Proyección exponencial"

replace CODOOII = CODOOII[_n-1] if CODOOII == ""

bys codooii: gen sec_ma = (seccion_4[_n-1] + seccion_4[_n-2] + seccion_4[_n-3])/3
replace sec_ma= (sec_ma[_n-1] + seccion_4[_n-2] + seccion_4[_n-3])/3 if year == 2020
label var sec_ma "Proyección medias móviles"

gen epm_ma2018 = abs(sec_ma - seccion_4)/seccion_4 if year == 2018
gen epm_exp2018 = abs(sec_exp1 - seccion_4)/seccion_4 if year == 2018


*-------------------------------------------------------------------------------
*preparando variables para el bucle

gen yniv = seccion_4
label var yniv "Nivel de seccion_4"
gen ylog = log(seccion_4)
label var ylog "Log seccion_4"
gen yinv = 1/seccion_4
label var yinv "Inversa seccion_4"

gen tniv = year
label var tniv "Nivel de tiempo"
gen tlog = log(year)
label var tlog "Log tiempo"
gen tinv = 1/year
label var tinv "Inversa tiempo"
gen sec_metodo_ue = ""
label var sec_metodo_ue "Método escogido por UGEL con método UE"

gen sec_metodo = ""

gen epm_ue2018 = .

gen sec_ue = .
label var sec_ue "Resultado de estimacion por UGEL"

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
local sec_min = .
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
		
		replace epm_`y'_`x' = abs(modelo_`y'_`x' - seccion_4)/seccion_4 ///
			if ugel == `ugel' & year == 2018
		
		mvencode epm_`y'_`x'  if ugel == `ugel', mv(0) override

		summarize epm_`y'_`x' if ugel == `ugel' 
		if r(sum) < `sec_min' {
			local sec_min = r(sum)
			replace sec_metodo_ue = "epm_`y'_`x'" if ugel == `ugel'	

			replace sec_ue =  modelo_`y'_`x' if ugel == `ugel'
			replace epm_ue2018 = epm_`y'_`x' if ugel == `ugel'
		
		}
		
		drop modelo_aux

		}
	}

dis `min_metodo'
codebook sec_metodo_ue
	
}
 
mvencode epm_ma2018  epm_exp2018 epm_ue2018 , mv(0) override
 
local sec_min = .
foreach var of varlist epm_ma2018  epm_exp2018 epm_ue2018 {

summarize `var'
	return list
	if r(sum) < `sec_min' {
		local sec_min = r(sum)
		replace sec_metodo = "`var'"	
	}
}

dis `sec_min'
codebook sec_metodo
count if year == 2018
local error = 100*`sec_min'/r(N)
dis "El error porcentual medio del mejor modelo es `error'% para el 2018"

replace epm_ma2018 = epm_ma2018/221 ///221 ugel en 2018
replace epm_exp2018 = epm_exp2018/221
replace epm_ue2018 = epm_ue2018/221

collapse (sum) sec_ue seccion_4 sec_exp1 sec_ma ///
	epm_ma2018 epm_exp2018 epm_ue2018, by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("Secciones") sheetreplace firstrow(variables)


