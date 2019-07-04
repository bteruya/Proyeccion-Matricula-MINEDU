*Programa que hace la proyección por método exponencial y medias móviles
program p1_exp_ma
isid year CODOOII
destring CODOOII, gen(codooii)
xtset codooii year

tssmooth exponential exp1 = `1', forecast(2)  // forecast 2019 y 2020
label var exp1 "Proyección exponencial"

replace CODOOII = CODOOII[_n-1] if CODOOII == ""

bys codooii: gen ma = (`1'[_n-1] + `1'[_n-2] + `1'[_n-3])/3
replace ma = (ma[_n-1] + `1'[_n-2] + `1'[_n-3])/3 if year == 2020
label var ma "Proyección medias móviles"

gen epm_ma2018 = abs(ma - `1')/`1' if year == 2018
gen epm_exp2018 = abs(exp1 - `1')/`1' if year == 2018

end

*Programa que hace la proyección por un MCO UGEL por UGEL
program p2_metodo_ue
gen yniv = `1'
label var yniv "Nivel de `1'"
gen ylog = log(`1')
label var ylog "Log `1'"
gen yinv = 1/`1'
label var yinv "Inversa `1'"

gen tniv = year
label var tniv "Nivel de tiempo"
gen tlog = log(year)
label var tlog "Log tiempo"
gen tinv = 1/year
label var tinv "Inversa tiempo"
gen metodo_ue = ""
label var metodo_ue "Método escogido por UGEL con método UE"

gen metodo = ""

gen epm_ue2018 = .

gen ue = .
label var ue "Resultado de estimacion por UGEL"

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
local min = .
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
		
		replace epm_`y'_`x' = abs(modelo_`y'_`x' - `1')/`1' ///
			if ugel == `ugel' & year == 2018
		
		mvencode epm_`y'_`x'  if ugel == `ugel', mv(0) override

		summarize epm_`y'_`x' if ugel == `ugel' 
		if r(sum) < `min' {
			local min = r(sum)
			replace metodo_ue = "epm_`y'_`x'" if ugel == `ugel'	

			replace ue =  modelo_`y'_`x' if ugel == `ugel'
			replace epm_ue2018 = epm_`y'_`x' if ugel == `ugel'
		
		}
		
		drop modelo_aux

		}
	}

dis `min_metodo'
codebook metodo_ue
	
}
 
end

*Programa que permite elegir entre métodos

program p3_eleccion 

local min = .
foreach var of varlist `0' {

summarize `var'
	return list
	if r(sum) < `min' {
		local min = r(sum)
		replace metodo = "`var'"	
	}
}

dis `min'
codebook metodo
count if year == 2018
local error = 100*`min'/r(N)
dis "El error porcentual medio del mejor modelo es `error'% para el 2018"




end
