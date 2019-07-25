merge m:1 cod_mod using `CE_2018_padron', gen(x) keepusing(gestion d_gestion niv_mod d_niv_mod) update
tab _m x ,m
drop if x == 2
drop x _m


*Dataset para expandir codooii y luego proyectar 2019 y 2020
use "3. Data\Datasets_intermedios\matri_tasas_2020_MCO.dta" , clear
keep if year == 2020
keep codooii
expand 2
bys codooii : gen year = _n
replace year = 2018 + year




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



keep CODOOII year `var'
keep if inrange(year, 2014,2018)
reshape wide `var' , ///
	i(CODOOII) j(year)
export excel using "4. Codigos\Output\Proyeccion_actual_UE.xls", ///
	sheet("`var'") sheetreplace firstrow(variables)
