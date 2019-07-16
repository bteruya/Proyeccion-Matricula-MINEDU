/*******************************************************************************
					PROYECCIÓN DE VARIABLES EDUCATIVAS
					Orden: 4
					Dofile: Data para mapas
					Brenda Teruya
*******************************************************************************/
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"

use "3. Data\1. UGEL Level\00_Modulo 0\modulo_0.dta", clear

keep if m0_p01 == 2 //solo UGEL
rename cod_id codooii
rename (m0_p13a m0_p13b) (lon_x lat_y)
keep codooii lon_x lat_y 

tempfile censoug
save `censoug'

import excel using "4. Codigos\Output\Mapa.xls", sheet("doc_total") firstrow clear
merge 1:1 codooii using `censoug'
