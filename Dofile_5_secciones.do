/*******************************************************************************
					PROYECCIÓN DE VARIABLES EDUCATIVAS
					Orden: 5
					Dofile: secciones
					Brenda Teruya
*******************************************************************************/
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"

*-------------------------------Secciones---------------------------------------

foreach var of varlist seccion_4* {
use "3. Data\Datasets_intermedios\matricula_secciones_peru_2013-2018.dta",  clear

keep `var' CODOOII year
codebook `var'

*programa que proyecta según ma y exp
p1_exp_ma `var'

*programa que proyecta según MCO por UGEL
p2_metodo_ue `var'

global epm epm_ma2018 epm_exp2018 epm_ue2018 

p3_eleccion $epm 

preserve 

collapse (sum) ue `var' exp1 ma ///
	epm_ma2018 epm_exp2018 epm_ue2018, by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("`var'") sheetreplace firstrow(variables)

restore
export excel CODOOII year `var' metodo metodo_ue ue exp1 ma   using "4. Codigos\Output\Proyeccion_porUGEL.xls", ///
	sheet("`var'") sheetreplace firstrow(varlabels)
	
}

