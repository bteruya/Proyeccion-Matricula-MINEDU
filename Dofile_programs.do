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


*-------------------------------------------------------------------------------

*Programa que permite elegir entre métodos

program p3_eleccion 
capture drop metodo
gen metodo = ""
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


*-------------------------------------------------------------------------------
program p2_metodo_ue_year
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

gen epm_ue`2' = .

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
			replace modelo_`y'_`x' = exp(modelo_`y'_`x') if ugel == `ugel'
		} 
		else if `y' == yinv{
			replace modelo_`y'_`x' = 1/modelo_`y'_`x' if ugel == `ugel'
		}
		
		replace epm_`y'_`x' = abs(modelo_`y'_`x' - `1')/`1' ///
			if ugel == `ugel' & year == `2'
		
		mvencode epm_`y'_`x'  if ugel == `ugel', mv(0) override

		summarize epm_`y'_`x' if ugel == `ugel' 
		if r(sum) < `min' {
			local min = r(sum)
			replace metodo_ue = "epm_`y'_`x'" if ugel == `ugel'	

			replace ue =  modelo_`y'_`x' if ugel == `ugel'
			replace epm_ue`2' = epm_`y'_`x' if ugel == `ugel'
		
		}
		
		drop modelo_aux

		}
	}

dis `min_metodo'
codebook metodo_ue
	
}

drop yniv - tinv modelo_* epm_*_*
 
end


program p4_metodo_siete 
cap drop ylog

gen ylog = log(`1')

gen mco3 = .
gen mco4 = .
gen mcoln3 = .
gen mcoln4 = .
	
*moving average
gen ma3 = (L1.`1' + L2.`1' + L3.`1')/3
replace ma3 = (L1.ma3 + L2.`1' + L3.`1')/3 if year == 2020
gen epm_ma3_2018 = abs(ma3 - `1')/`1' if year == 2018

gen ma4 = (L1.`1' + L2.`1' + L3.`1' + L4.`1')/4
replace ma4 = (L1.ma4 + L2.`1' + L3.`1' + L4.`1')/4 if year == 2020
gen epm_ma4_2018 = abs(ma4 - `1')/`1' if year == 2018

*media ponderada
gen mp3 = (L1.`1' + 2*L2.`1' + 3*L3.`1')/6
replace mp3 = (L1.mp3 + 2*L2.`1' + 3*L3.`1')/6 if year == 2020
gen epm_mp3_2018 = abs(mp3 - `1')/`1' if year == 2018
gen mp4 = (L1.`1' + 2*L2.`1' + 3*L3.`1' + 4*L4.`1')/10
replace mp4 = (L1.mp4 + 2*L2.`1' + 3*L3.`1' + 4*L4.`1')/10 if year == 2020
gen epm_mp4_2018 = abs(mp4 - `1')/`1' if year == 2018

*media geometrica
gen mg3 = (L1.`1' * L2.`1' * L3.`1')^(1/3)
replace mg3 = (L1.mg3 * L2.`1' * L3.`1')^(1/3) if year == 2020
gen epm_mg3_2018 = abs(mg3 - `1')/`1' if year == 2018

gen mg4 = (L1.`1' * L2.`1' * L3.`1' * L4.`1')^(1/4)
replace mg4 = (L1.mg4 * L2.`1' * L3.`1' * L4.`1')^(1/4) if year == 2020
gen epm_mg4_2018 = abs(mg4 - `1')/`1' if year == 2018

*crecimiento geometrico
gen cg3 = L1.`1' * (L3.`1' / L1.`1')^(1/2)
replace cg3 = L1.cg3 * (L3.`1' / L1.cg3)^(1/2) if year == 2020
gen epm_cg3_2018 = abs(cg3 - `1')/`1' if year == 2018

gen cg4 = L1.`1' * (L4.`1' / L1.`1')^(1/3)
replace cg4 = L1.cg4 * (L4.`1' / L1.cg4)^(1/3) if year == 2020
gen epm_cg4_2018 = abs(cg4 - `1')/`1' if year == 2018

*tasa de crecimiento
gen tc3 = L1.`1' * ((L3.`1' / L2.`1') + (L2.`1' / L1.`1'))/2
replace tc3 = L1.tc3 * ((L3.`1' / L2.`1') + (L2.`1' / L1.tc3))/2 if year == 2020
gen epm_tc3_2018 = abs(tc3 - `1')/`1' if year == 2018
gen tc4 = L1.`1' * ((L4.`1' / L3.`1') + (L3.`1' / L2.`1') + (L2.`1' / L1.`1'))/3
replace tc4 = L1.tc4 * ((L4.`1' / L3.`1') + (L3.`1' / L2.`1') + (L2.`1' / L1.tc4))/3 if year == 2020
gen epm_tc4_2018 = abs(tc4 - `1')/`1' if year == 2018


capture drop ugel
encode CODOOII, gen(ugel)
summarize ugel
local ugel_max = r(max)

forvalues ugel = 1/`ugel_max' {
	display `ugel'
	*3 periodos log y no log
	reg `1' year if ugel == `ugel' & inrange(year, 2016, 2018)
	capture drop modelo_aux
	predict modelo_aux if ugel == `ugel', xb
	replace mco3 = modelo_aux if ugel == `ugel'

	reg ylog year if  ugel == `ugel' & inrange(year, 2016, 2018)
	drop modelo_aux
	predict modelo_aux if ugel == `ugel', xb
	replace mcoln3 = exp(modelo_aux) if ugel == `ugel'

	*4 periodos log y no log
	reg `1' year if ugel == `ugel' & inrange(year, 2015, 2018)
	drop modelo_aux
	predict modelo_aux if ugel == `ugel', xb
	replace mco4 = modelo_aux if ugel == `ugel'

	reg ylog year if  ugel == `ugel' & inrange(year, 2015, 2018)
	drop modelo_aux
	predict modelo_aux if ugel == `ugel', xb
	replace mcoln4 = exp(modelo_aux) if ugel == `ugel'
	
}

	*errores de prediccion 2018
	gen epm_mco3_2018 = abs(mco3 - `1')/`1' if year == 2018
	gen epm_mco4_2018 = abs(mco4 - `1')/`1' if year == 2018
	gen epm_mcoln3_2018 = abs(mcoln3 - `1')/`1' if year == 2018
	gen epm_mcoln4_2018 = abs(mcoln4 - `1')/`1' if year == 2018


end

