/*******************************************************************************
Estimacion de matricula
Input data: SIAGIE, Padron, bloques_all

Output data: output\matricula_modelada_codmod_b
*******************************************************************************/
*Correr las rutas a usar:
		global ruta D:\Brenda GoogleDrive\Trabajo\Trabajo BID\BRENDA-documentos\OneDrive\Trabajo BID-onedrive\docentes\simulaciones\Calculos\Dofiles\BID -dofiles
		do "$ruta\rutas_mat.do"
		cd "$directory_b"
	
*EBR (LOS DEMAS NO TIENEN MATRI SIAGIE) SIN PRONOEI (NO ESTAN EN NORMA DE RACIONALIZACION) SIN PRIVADAS	
*ACTIVAS SEGUN PADRON
*ANEXO 0	
********************************************************************************
*SIAGIE 2017

	use "4. Student level\siagie-Input\data_2017", clear
	duplicates report id_persona
	duplicates report id_persona fecha_registro //cuando vemos la fecha ne la que la persona 
	gsort id_persona -fecha_registro
	duplicates tag id_persona, gen(dupli_persona)
	tab dupli_persona
	
	by id_persona: gen unique=_n //ya esta ordenado, de la fecha mas reciente a la mas antigua
	*unique sera 1 cuando sea la fecha mas reciente
	keep if unique==1
	*nos quedamos con los de la fecha de registro mas reciente, si la fecha de registro es la misma (44 casos)
	*es aleatorio

	gen dsc_grado_noespacio= subinstr(dsc_grado," ","",.)
	
	gen grado=.
	*inicial
	replace grado=2 if id_grado==1
	replace grado=3 if id_grado ==2 
	replace grado=3 if dsc_grado_noespacio=="Grupo3años"
	replace grado=4 if  dsc_grado_noespacio=="4años" 
	replace grado=4 if dsc_grado_noespacio=="Grupo4años"
	replace grado=5 if dsc_grado_noespacio=="5años"
	replace grado=5 if dsc_grado_noespacio=="Grupo5años"
	
	*primaria
	replace grado=6 if id_grado ==4 &  dsc_grado_noespacio=="PRIMERO"
	replace grado=7 if id_grado ==5 &  dsc_grado_noespacio=="SEGUNDO"
	replace grado=8 if id_grado ==6 &  dsc_grado_noespacio=="TERCERO"
	replace grado=9 if id_grado ==7 
	replace grado=10 if id_grado ==8
	replace grado=11 if  dsc_grado_noespacio =="SEXTO"
	
	*SECUNDARIA
	replace grado=12 if id_grado == 10
	replace grado=13 if id_grado == 11
	replace grado=14 if id_grado == 12
	replace grado=15 if id_grado == 13
	replace grado=16 if id_grado == 14
	
	rename id_anio year
	
	keep year id_persona grado cod_mod id_seccion
	
	tostring id_persona, replace format(%08.0f)
	tostring cod_mod, replace format(%07.0f)
	
	
	save output\siagie_2017.dta, replace 
	
	
	use output\siagie_2017.dta,clear
	gen matri_ef2017_ = 1
	tostring cod_mod, replace format(%07.0f)
	
	replace id_seccion="01" if id_seccion=="  "
	encode id_seccion, gen(n_sec)
	
	
	collapse (sum) matri_ef2017_ (max) n_sec, by(grado cod_mod)
	label data "Secciones y matricula por grado y codmod"
	save output\secc_efectiva_2017_b, replace
	
	use  output\secc_efectiva_2017_b, clear
	collapse (sum) n_sec_ef=n_sec, by(cod_mod)
	tab n_sec_ef
	label data "Secciones y matricula por codmod"
	save output\secc_efectiva_codmod_2017_b, replace
	
	
	use  output\secc_efectiva_2017_b, clear
	
	keep matri_ef2017_ cod_mod grado
	reshape wide matri_ef2017_, i(cod_mod) j(grado)
	
	label data "secciones y matricula por grado codmod wide"
	save output\matri_efectiva_2017_b, replace
	
*Tasas a usar: repitencia, desercion, traslado, migracion

*1. Desercion
	use  input\sit_final_cons_new.dta, clear
	drop if year ==2012 //este ano solo tiene pronoei
	keep if  unique 		
	keep cod_mod grado id_persona fecnac year sit_final nombres apellimat apellipat dni sexo
	

	tostring cod_mod id_persona, replace
	replace cod_mod = "0"*(7-strlen(cod_mod)) + cod_mod 
	replace id_persona = "0"*(8-strlen(id_persona)) + id_persona
	
	append using output\siagie_2017.dta
	sort id_persona year
		bys id_persona: gen  drop_den =  (grado < 16)  & year < 2017
		
	sort id_persona year
		bys id_persona: gen  drop = grado[_n+1] == . & (grado < 16) & year < 2017


	merge m:1 cod_mod using input\bloques_all , keepusing( bloque)
	keep if _merge==3 // el _merge==1 se debe  a los pronoei y especiales
	drop if bloque==.
	drop _m
	
	
		preserve 

		use input\padronhyperdeluxe201711.dta, clear //CAMBIAR POR EL PADRON ESCOLAR ACTUAL
		keep if anexo==0
		gen dpto_cod=substr(codgeo, 1, 2)
		gen prov_cod=substr(codgeo, 1, 4)
		drop if gestion==3 //no privadas porque no entran en el calculo de siagie
		drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
		drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion
		
		
		tempfile padron_cod
		save `padron_cod', replace
				
		restore
		merge m:1 cod_mod using `padron_cod' , keepusing(  d_dpto d_prov d_dist ///
		dpto_cod prov_cod gestion codgeo nivel niv_mod area_censo)
		keep if _merge==3 //publicas, EBR sin PRONOEI
		recode area_censo (0=2) (1=0) , gen (rural)
		replace rural=1 if rural==2
		save output\desercion_id.dta , replace
********************************************************************************
	*robustez de bd 
	use  output\desercion_id.dta ,clear
	sort id_persona year
	by id_persona: gen year_next=year[_n+1] if year<2017
	by id_persona: gen resta=year_next-year
	br if resta!=1 & resta!=.
	tab drop if resta>1 & resta!=.
	
	*****Tasa de desercion de 6Р de primaria a 1Рsecundaria***************
	use  output\desercion_id.dta ,clear
	
	keep if grado==11
	*no hay ano 2018 entonces no hay desercion 2017 porque no hay contra que comparar
	drop if year==2017
	collapse (sum) drop* (first) d_dpto d_prov dpto_cod prov_cod  , by( bloque year grado)
	
	
	gen  r_drop11_ = drop/drop_den
	sort d_prov year grado	
	collapse (first) d_dpto d_prov  (mean) r_drop11_, by( prov_cod)
	sort d_dpto d_prov   	
	label var r_drop11_ "Tasa desercion 6to primaria x provincia entre años 2013 y 2017"
	
	save output\drop_6to_bloque.dta, replace
	
	********Tasa de desercion promedio de primaria y secundaria (sin 6Э1Щ a nivel de provincia******
	use  output\desercion_id.dta ,clear
	gen agregado=.
	replace agregado=1 if grado<11 // primaria
	replace agregado=2 if grado>11 // secundaria
	drop if agregado==. //botar 6to primaria
	
	collapse (sum)  drop* (first) d_dpto d_prov prov_cod   , by(year	bloque agregado) //promediando todos los a;os
	gen  r_drop = drop/drop_den

	collapse (first) d_dpto d_prov  (mean) r_drop, by( prov_cod  agregado )
	sort d_dpto d_prov   agregado
	
	label var r_drop "Tasa desercion prim/sec x provincia"
	
	save output\drop_prov ,replace	
		
	*drop provincia 
	use output\drop_prov, clear
	reshape wide r_drop , i( prov_cod) j(agregado)
	save output\deser_prov_wide, replace
	
*2. Repitencia
	
	use  input\sit_final_cons_new.dta, clear
	
	tab unique year
	keep if  unique 		
	keep cod_mod grado id_persona fecnac year sit_final nombres apellimat apellipat dni sexo nivel
	
	keep if grado>=7 & grado <=16 //de 3ro a 11mo (LO CAMBIÊ POR SEGUNDO!!)
 
	tostring cod_mod id_persona, replace
	
	replace cod_mod = "0"*(7-strlen(cod_mod)) + cod_mod 
	
	replace id_persona = "0"*(8-strlen(id_persona)) + id_persona
	
	merge m:1 cod_mod using input\bloques_all , keepusing( bloque)
	keep if _merge==3 //hay codigos modulares sin bloque
	drop if bloque==. //porque!
	cap drop _merge
	
	preserve
	
	use input\padronhyperdeluxe201711.dta, clear
	gen dpto_cod=substr(codgeo, 1, 2)
	gen prov_cod=substr(codgeo, 1, 4)
	keep if anexo==0
	tempfile padron_cod
	drop if gestion==3 //no privadas porque no entran en el calculo de siagie
	drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
	drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion
	save `padron_cod'
	
	restore
	merge m:1 cod_mod using `padron_cod' , keepusing( area_censo d_dpto d_prov d_dist dpto_cod prov_cod codgeo)
	keep if _merge==3
	recode area_censo (0=2) (1=0) , gen (rural)
	replace rural=1 if rural==2
	
	gen desaprobado=1 if sit_final==2
	gen matri=1
	drop if grado==16
	

	cap drop agregado
	gen agregado=.
	replace agregado=1 if grado<=11 
	replace agregado=2 if grado>11
	
	save output\repitencia_id.dta , replace
	
	*-----------------------------------------------------------
	use output\repitencia_id.dta , clear

	collapse  (sum)  desaprobado matri  (first) d_dpto d_prov d_dist dpto_cod prov_cod, by( year bloque agregado ) //todoso los a;os	

	gen tasa_desapr= desaprobado/matri
   collapse  (mean) tasa_desapr (first)   d_dpto d_prov, by(  prov_cod  agregado)	
	
	label var tasa_desapr "Tasa repitencia por provincia prim/sec"
	save output\rep_prov.dta , replace
	
	
	*repitencia provincia 1 primaria
	use output\rep_prov.dta, clear
	reshape wide tasa_desapr , i( prov_cod) j(agregado)
	save output\desapro_prov_desapro, replace
	
	
*3. Traslado migracion
		*no hay migracion de quinto de secundaria
	use  input\sit_final_cons_new.dta, clear
	drop if year ==2012 //este ano solo tiene pronoei
	keep if  unique 		
	keep cod_mod grado id_persona fecnac year sit_final nombres apellimat apellipat dni sexo
	

	tostring cod_mod id_persona, replace
	replace cod_mod = "0"*(7-strlen(cod_mod)) + cod_mod 
	replace id_persona = "0"*(8-strlen(id_persona)) + id_persona
	
	append using output\siagie_2017.dta
		
        keep if year>=2013
		keep if grado>=6 & grado<16 
     
		tostring cod_mod id_persona, replace
		
		replace cod_mod = "0"*(7-strlen(cod_mod)) + cod_mod 
		
		replace id_persona = "0"*(8-strlen(id_persona)) + id_persona
		
 		merge m:1 cod_mod using input\bloques_all , keepusing( bloque)
		keep if _merge==3
        drop if bloque==.
		drop _merge
		
		preserve
		
		use input\padronhyperdeluxe201711.dta, clear
		keep if anexo==0
		gen dpto_cod=substr(codgeo, 1, 2)
		gen prov_cod=substr(codgeo, 1, 4)
		drop if gestion==3 //no privadas porque no entran en el calculo de siagie
		drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
		drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion
		tempfile padron_cod
		save `padron_cod', replace
				
		restore
		
		
        merge m:1 cod_mod using `padron_cod' , keepusing( area_censo d_dpto d_prov d_dist dpto_cod prov_cod codgeo)
        keep if _merge==3
		recode area_censo (0=2) (1=0) , gen (rural)
		replace rural=1 if rural==2
	
	
		sort id_persona year
		
			bys id_persona: gen  tras = bloque[_n] != bloque[_n+1]  & year<2017  & grado[_n+1] != . 
	
	bys id_persona:  gen bloque_mas= bloque[_n+1]	if tras==1
	
	gen tras_mas= 1 if bloque_mas!=.
		label data "data con dummy que dice si la persona se traslado entre 2013-2017"
		save output\tras_trasmas_id.dta, replace

	
	
**********+***********calculo del Traslado en sexto de primaria*****************************
	use output\tras_trasmas_id.dta, clear
	keep if grado==11
	preserve
	
	drop if bloque_mas==.
	drop bloque tras
	rename bloque_mas bloque
	collapse  (sum)  tras_mas  , by(year bloque grado)	// tras_mas es el bloque hacia donde se van
	
	tempfile entradas_grado
	save `entradas_grado'
	
	restore
	
	gen matri=1
	 
	collapse  (sum)  tras  matri (first)  d_prov d_dist dpto_cod prov_cod codgeo, by(year bloque grado)	
         
	 cap drop _merge
	 merge 1:1 year bloque grado using `entradas_grado'
	 
	 drop _merge
	 sort bloque grado
	
	
	mvencode tras*, mv(0) override
	drop if bloque==.
	isid bloque year
	
	
	gen f_neto11_= (tras_mas-tras)
	
	gen tasa_tras_11=f_neto11_/matri

	collapse (mean) f_neto11_ tasa_tras_11, by(prov_cod)
	
	*lectura de los grados: tras salio del grado 11 del bloque x ,tras_mas recibio del grado 11 de otro bloque
	label data "Flujo neto de traslado por provincia todos los años para 6to primaria"
	save output\tras_6to.dta , replace
    
	
**********+***********c⭣ulo de la tasa de traslado en primaria y secundaria(sin 6Э1Щ a nivel provincial*****************************
	use  output\tras_trasmas_id.dta, clear
 
	gen matri=1
		
	drop if grado==11 | grado==16
	
	gen agregado=.
	replace agregado=1 if grado<11
	replace agregado=2 if grado>11
	
	preserve
	
	drop if bloque_mas==.
	drop bloque tras
	rename bloque_mas bloque
	collapse  (sum)  tras_mas  (first)  d_prov d_dist dpto_cod prov_cod codgeo, by( year bloque agregado )	//todos los a;os	
	
	tempfile entradas_v2
	save `entradas_v2' , replace
	
	restore
	
	
	collapse  (sum)  tras matri (first)  d_prov d_dist d_dpto dpto_cod prov_cod codgeo, by( year bloque agregado)	
         
	  cap drop _merge
	 merge 1:1 year bloque agregado using `entradas_v2'  // no cruzan por los grado no coinciden
	 
	 drop _merge
	 sort bloque 
	 
	 mvencode tras*, mv(0) override
	 gen flujo_neto= tras_mas -tras
	 
	gen tasa_tras= flujo_neto/matri
	 
	 save output\tras_bloque.dta , replace
	 
	 collapse  (mean) tasa_tras (first)  d_dist d_dpto  d_prov , by( prov_cod agregado)	
	 
	 sort  d_prov d_dist agregado
	 drop d_dist
	 
	 label data "Tasa traslado por provincia y nivel: prim/sec promediada por a;os 2013-2017"
	 save output\tras_prov.dta , replace

	 
	*traslado 1 primaria
	use output\tras_prov, clear
	drop d_dpto
	reshape wide tasa_tras , i( prov_cod) j(agregado)
	save output\prov_tras_wide, replace


********************************************************************************
*participacion de cod mod en el bloque
	
	use  input\sit_final_cons_new.dta, clear
	keep if  unique 		
	tostring cod_mod, replace format(%07.0f)
	tostring id_persona, replace format(%08.0f)
	
	append using output\siagie_2017
	gen matri=1
	collapse (sum) matri , by (year cod_mod grado) 
	label var matri "matricula por colegio de c/grado todos los años"
	reshape wide matri, i(year cod_mod) j(grado)
	save output\matri_year_grado.dta, replace
	
	use output\matri_year_grado.dta, clear
	merge m:1 cod_mod using input\bloques_all, keepusing(bloque) // hay varios a;os
	keep if _merge==3 //1 colegios sin bloque, 2 bloques sin matricula
	drop _merge
	preserve 
	
	use input\padronhyperdeluxe201711.dta, clear
	keep if anexo==0
	gen dpto_cod=substr(codgeo, 1, 2)
	gen prov_cod=substr(codgeo, 1, 4)
	drop if gestion==3 //no privadas porque no entran en el calculo de siagie
	drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
	drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion

	tempfile padron_cod
	save `padron_cod', replace
			
	restore
	merge m:1 cod_mod using `padron_cod',keepusing(niv_mod) 
	keep if _merge==3 //padron sin bloque o matricula
	
	drop matri2
	
	
	cap drop _merge
	
	forvalues x =3/16 {
	bys bloque year: egen tot_`x' = total(matri`x')
	gen part_`x' = matri`x'/tot_`x'
	mvencode part_`x', mv(0) override
	}
	drop tot_* matri*
	duplicates report cod_mod year
	collapse (mean) part_* (first) bloque, by(cod_mod) //promedio por a;os
	save output\part_codmod_02jul18, replace
	
	*----------------------------------------------
	use  input\sit_final_cons_new.dta, clear
	keep if  unique 		
	tostring cod_mod, replace format(%07.0f)
	tostring id_persona, replace format(%08.0f)
	
	append using output\siagie_2017
	keep if grado==6
	gen matri=1
	
	collapse (sum) matri , by (cod_mod year) 
	preserve 
	
	use input\padronhyperdeluxe201711.dta, clear
	keep if anexo==0
	gen dpto_cod=substr(codgeo, 1, 2)
	gen prov_cod=substr(codgeo, 1, 4)
	drop if gestion==3 //no privadas porque no entran en el calculo de siagie
	drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
	drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion

	tempfile padron_cod
	save `padron_cod', replace
			
	restore
	merge m:1 cod_mod using `padron_cod',keepusing(niv_mod prov_cod dpto_cod) 
	keep if _merge==3 //padron sin bloque o matricula
	drop _m
	merge m:1 cod_mod using input\bloques_all, keepusing(bloque) 
	keep if _merge==3 //1 colegios sin bloque, 2 bloques sin matricula
	drop _merge
	
	collapse (sum) matri, by(bloque year)
	drop if bloque==.
	reshape wide matri, i(bloque) j(year) 
	reshape long //para llenar los missings y tener un panel balanceado. igual tengo missing
	*pero tengo el año y bloque y un missing de observacion. antes no tenia esa observacion
	
	xtset bloque year
	xtreg matri L1.matri ,fe //para comparar los modelos
	estimates store matrife
	
	xtabond matri, lags(1) artests(2) small vce(robust) // aqui poner tssmooth exponential
	estimates store matriabond
	estat abond
	xtabond2 matri L(1/2).matri , gmm(L(1/2).matri ) robust
	estimates store matriabond2
	outreg2 [matri*] using "$graph_b\matri.xls", replace
	
	replace matri=0 if matri==.  //0 cuando no tenga matricula
	tsappend, add(13)	//de aqui al 2030
		
		forecast create, replace
		forecast estimates matriabond2 	
		forecast solve, begin(2018) end(2030) actual prefix(s_)
	save output\matri_bloque_1roprim.dta, replace
		
		
	use output\matri_bloque_1roprim.dta, clear
	replace matri=s_matri if year>=2018 
	replace matri=0 if matri<0 //cuando se va la matricula que sea cero
	drop _est_matrife s_matri _est_matriabond
	reshape wide matri , i(bloque) j(year) 
	
	rename matri* matri*_6
	preserve
	use input\bloques_all, clear
	duplicates drop bloque, force
	tempfile bloque
	save `bloque'
	restore
	merge 1:1 bloque using `bloque'
	keep if _merge==3 //1 colegios sin bloque, 2 bloques sin matricula
	drop _merge
	
	preserve 
	
	use input\padronhyperdeluxe201711.dta, clear
	keep if anexo==0
	gen dpto_cod=substr(codgeo, 1, 2)
	gen prov_cod=substr(codgeo, 1, 4)
	drop if gestion==3 //no privadas porque no entran en el calculo de siagie
	drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
	drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion

	tempfile padron_cod
	save `padron_cod', replace
			
	restore
	merge m:1 cod_mod using `padron_cod',keepusing(niv_mod prov_cod dpto_cod) 
	keep if _merge==3 //padron sin bloque o matricula
	
	save output\matri_bloque_1roprim_wide.dta, replace
	*---------------------------------------------------------------------------
	use  output\matri_year_grado.dta, clear //matricula 2016 por bloques
	
	tostring cod_mod, replace format(%07.0f)
	merge m:1 cod_mod using input\bloques_all, keepusing(bloque) 
	keep if _merge==3 //1 colegios sin bloque, 2 bloques sin matricula
	drop _merge
	preserve 
	
	use input\padronhyperdeluxe201711.dta, clear
	keep if anexo==0
	tempfile padron_cod
	drop if gestion==3 //no privadas porque no entran en el calculo de siagie
	drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
	drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion
	save `padron_cod', replace
			
	restore
	merge m:1 cod_mod using `padron_cod',keepusing(niv_mod cod_car) 
	keep if _merge==3 //padron sin bloque o matricula
	drop _m

	keep if year==2017
	
	rename matri matri2017_
	collapse (sum)  matri2017_, by(bloque grado)
	
	label var matri2017_ "Matri por a;o y bloque de cada colegio"
	reshape wide matri2017_, i(bloque) j(grado)
	mvencode matri2017_*, mv(0) override
	save output\matri_bloque, replace
	*---------------------------------------------------------------------------
	use  output\matri_year_grado.dta, clear //matricula 2016 por bloques
	keep if grado<=6 
	preserve 
	
	use input\padronhyperdeluxe201711.dta, clear
	keep if anexo==0
	gen dpto_cod=substr(codgeo, 1, 2)
	drop if gestion==3 //no privadas porque no entran en el calculo de siagie
	drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
	drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion
	
	tempfile padron_cod
	save `padron_cod', replace
			
	restore
	merge m:1 cod_mod using `padron_cod',keepusing(dpto_cod niv_mod) 
	drop if _m!=3 //hay 70 alumnos sin cod_mod, los he buscado en el padron y efectivamente no existe ese codmod en escale
	drop _m

	merge m:1 cod_mod using input\bloques_all
	keep if _m==3
	drop _m
	
	collapse (sum) matri, by (grado bloque) //todos los a;os
	rename matri cobertura_
	reshape wide cobertura_, i(bloque) j (grado)
	replace cobertura_2=cobertura_2/cobertura_6
	replace cobertura_3=cobertura_3/cobertura_6
	replace cobertura_4=cobertura_4/cobertura_6
	replace cobertura_5=cobertura_5/cobertura_6
	drop cobertura_6
	mvencode cobertura_*, mv(0) override
	save output\cobertura.dta, replace
	
	
	
********************************************************************************	
	**BASES DE FLUJOS Y MERGE CON INPUTS
	
	use output\matri_bloque_1roprim_wide, clear
	merge m:1 prov_cod using output\deser_prov_wide, keep(1 3) nogen keepusing(r_drop* )
	merge m:1 prov_cod using output\prov_tras_wide, keep(1 3) nogen 
	merge m:1 prov_cod using output\desapro_prov_desapro, keep(1 3) nogen 
	merge m:1 prov_cod using output\tras_6to.dta , keep(1 3) nogen 
	merge m:1 prov_cod using output\drop_6to_bloque.dta , keep(1 3) nogen 
	merge 1:1 bloque using output\matri_bloque, keep(3) nogen
	merge 1:1 bloque using output\cobertura, keep(1 3) nogen
	
	save output\modelito_b, replace
	
********************************************************************************	
	use output\modelito_b, clear
	
	forval a = 17/29 {
	local b = `a'+1 
	
	gen matri20`b'_7 = matri20`a'_6*(1 - r_drop1  + tasa_tras1)+matri20`a'_7*tasa_desapr1
	
	forval x = 7/10 {
	local y = `x' + 1
	gen matri20`b'_`y' = matri20`a'_`x'*(1 - r_drop1 - tasa_desapr1 + tasa_tras1) + matri20`a'_`y'*tasa_desapr1
	}
	
	gen matri20`b'_12 = matri20`a'_11*(1 - r_drop11_ - tasa_desapr1)+f_neto11_+  matri20`a'_12*tasa_desapr2
	forval x = 12/15{
	local y = `x'+1
	gen matri20`b'_`y' = matri20`a'_`x'*(1 - r_drop2  + tasa_tras2 - tasa_desapr2) + matri20`a'_`y'*tasa_desapr2
	}
	
	forval x = 3/5 {
	gen matri20`b'_`x' = matri20`b'_6 * cobertura_`x'
	replace matri20`b'_`x' = matri20`a'_`x' if matri20`b'_`x' == 0
	}	
	egen matri20`b'_pri = rowtotal(matri20`b'_6 matri20`b'_7 matri20`b'_8 matri20`b'_9 ///
		matri20`b'_10 matri20`b'_11)
	egen matri20`b'_sec =rowtotal(matri20`b'_12 matri20`b'_13 matri20`b'_14 ///
		matri20`b'_15 matri20`b'_16)
	egen matri20`b'_ini = rowtotal(matri20`b'_3 matri20`b'_4 matri20`b'_5)
	
	
	}
	
	save output\matricula_modelada_b_04jul18, replace
	
*-------------------------------------------------------------------------------
	*matricula por codigo modular
	*pasas de bloques a codigo modular segun la participacion del codmod en el bloque
	use output\part_codmod_02jul18, clear
	
	merge m:1 bloque using output\matricula_modelada_b_04jul18, keepusing(matri*) 
	keep if _merge ==3 //3709 bloques sin matri
	drop _merge
	drop matri*ini matri*pri matri*sec
	rename matri* grado*
	
	*qui {
	forval y = 2017/2030 { 
	forval x = 3/16{
	gen matri`y'_`x' = grado`y'_`x'*part_`x'
	}
	
	
	egen matri`y'_ini = rowtotal(matri`y'_3 matri`y'_4 matri`y'_5)
	egen matri`y'_pri = rowtotal(matri`y'_6 matri`y'_7 matri`y'_8 matri`y'_9 ///
		matri`y'_10 matri`y'_11)
	egen matri`y'_sec = rowtotal(matri`y'_12 matri`y'_13 matri`y'_14 matri`y'_15 ///
		matri`y'_16 )
	
	egen matri`y' = rowtotal(matri`y'_ini matri`y'_pri matri`y'_sec)
	}
	
	drop grado* 
	
	recode matri* (min/0=0)
	
	tabstat matri???? , stat (sum) 
	*bys niv_mod: tabstat matri????, stat(sum) 
	save output\matricula_modelada_codmod_b_04jul18, replace
	
	
	*------------------------------------------
	use output\matricula_modelada_codmod_b_04jul18, clear
	keep matri???? cod_mod niv_mod
	reshape long matri , i(cod_mod) j(year)
	
	tabstat matri, stat(sum) by(year)
	
	
	preserve
	
	use input\padronhyperdeluxe201711.dta, clear
	keep if anexo==0
	gen dpto_cod=substr(codgeo, 1, 2)
	gen prov_cod=substr(codgeo, 1, 4)
	drop if gestion==3 //no privadas porque no entran en el calculo de siagie
	drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
	drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion

	tempfile padron_cod
	save `padron_cod', replace
			
	restore
	merge m:1 cod_mod using `padron_cod'
	keep if _m==3 //7331 codigos sin matricula
	drop _m
	
	collapse (sum) matri, by(year area_censo)
	reshape wide matri, i(year) j(area_censo)
	
*chequear que el salto 2016-2017 sea real!
	use input\padronhyperdeluxe201711.dta, clear
	
	keep if anexo==0
	gen dpto_cod=substr(codgeo, 1, 2)
	gen prov_cod=substr(codgeo, 1, 4)
	drop if gestion==3 //no privadas porque no entran en el calculo de siagie
	drop if nivel==. //quitar todo lo NO EBR (EBA EBE CETPRO)
	drop if niv_mod ==15 //NO PRONOEI porque no entra en norma de racionalizacion
	drop niv_mod
	keep cod_mod area_censo nivel
	
	preserve
	
	use output\siagie_append, clear
	gen matri=1
	collapse (sum) matri, by(year cod_mod)
	drop if year==2012
	
	reshape wide matri, i(cod_mod) j(year)
	save output\siagie_append_wide, replace
	
	restore 
	merge 1:1 cod_mod using output\siagie_append_wide
	keep if _m==3
	drop _m
	merge 1:1 cod_mod using output\matricula_modelada_codmod_b_04jul18
	keep if _m==3
	drop _m
	rename matri???? matri_b????
	
	keep matri_b???? cod_mod area_censo nivel
	reshape long matri_b, i(cod_mod) j(year)
	sort cod_mod year 
	by cod_mod: replace matri=0 if matri[_n-1]==0
	
	tabstat matri, stat(sum) by(year)
	tabstat matri if nivel==3, stat(sum) by(year)
	
	preserve
	collapse (sum) matri, by(year area_censo)
	reshape wide matri, i(year) j(area_censo)

	restore
	preserve
	collapse (sum) matri, by(year area_censo nivel)
	rename matri_b matri_b_n
	reshape wide matri_b_n ,i(year area_censo) j(nivel)
	rename matri_b_n? matri_b_n_?urb
	reshape wide matri_b_n_?urb ,i(year ) j(area_censo)
	
	
	
	restore
	reshape wide
	
	save output\matri_b, replace
	
	use output\matricula_modelada_codmod, clear
	keep cod_mod matri????
	tempfile matri_minedu
	save `matri_minedu', replace
	
	use output\matri_b, clear
	merge 1:1 cod_mod using `matri_minedu'
	keep if _m==3
	drop _m
	reshape long matri matri_b ,i(cod_mod) j(year)
	
	
	tabstat matri, stat(sum) by(year)
	
	
	
	

