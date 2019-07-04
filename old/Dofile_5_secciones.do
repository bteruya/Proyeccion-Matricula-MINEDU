/*******************************************************************************
					PROYECCIÓN DE VARIABLES EDUCATIVAS
					Orden: 5
					Dofile: secciones
					Brenda Teruya
*******************************************************************************/
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"

log using "4. Codigos\Output\secciones.txt" , replace text
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

export excel CODOOII year `var' metodo metodo_ue ue exp1 ma   using "4. Codigos\Output\Proyeccion_porUGEL.xls", ///
	sheet("`var'") sheetreplace firstrow(varlabels)

collapse (sum) ue `var' exp1 ma ///
	epm_ma2018 epm_exp2018 ep	m_ue2018, by(year)

export excel using "4. Codigos\Output\Proyeccion.xls", ///
	sheet("`var'") sheetreplace firstrow(variables)
	
}

log close
