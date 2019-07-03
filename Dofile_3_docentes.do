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
 
tabstat doc_ue, stat(sum) by(year)
graph bar (sum) doc_ue , over(year)
replace epm_ma2018 = epm_ma2018/221
replace epm_exp2018 = epm_exp2018/221
replace epm_ue2018 = epm_ue2018/221

collapse (sum) doc_ue doc_total doc_exp1 doc_ma ///
	$epm , by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("Docentes") sheetreplace firstrow(variables)



