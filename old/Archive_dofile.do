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
