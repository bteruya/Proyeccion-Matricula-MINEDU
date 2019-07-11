merge m:1 cod_mod using `CE_2018_padron', gen(x) keepusing(gestion d_gestion niv_mod d_niv_mod) update
tab _m x ,m
drop if x == 2
drop x _m



