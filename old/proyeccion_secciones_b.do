replace d01=1 if d01==0 
replace d02=1 if d02==0
replace d03=1 if d03==0
replace d04=1 if d04==0
replace d05=1 if d05==0
replace d06=1 if d06==0

gen inv_d01=1/d01
gen inv_d02=1/d02
gen inv_d03=1/d03
gen inv_d04=1/d04
gen inv_d05=1/d05
gen inv_d06=1/d06

gen ln_d01=ln(d01)
gen ln_d02=ln(d02)
gen ln_d03=ln(d03)
gen ln_d04=ln(d04)
gen ln_d05=ln(d05)
gen ln_d06=ln(d06)

gen inv_año=1/año
gen ln_año=ln(año)

regress inv_d01 inv_año
predict modelo1_01, xb
replace modelo1_01=1/modelo1_01
regress inv_d01 ln_año
predict modelo2_01, xb
replace modelo2_01=1/modelo2_01
regress inv_d01 año
predict modelo3_01, xb
replace modelo3_01=1/modelo3_01
regress ln_d01 inv_año
predict modelo4_01, xb
replace modelo4_01=exp(modelo4_01)
regress ln_d01 ln_año
predict modelo5_01, xb
replace modelo5_01=exp(modelo5_01)
regress ln_d01 año
predict modelo6_01, xb
replace modelo6_01=exp(modelo6_01)
regress d01 inv_año
predict modelo7_01, xb
regress d01 ln_año
predict modelo8_01, xb
regress d01 año
predict modelo9_01, xb

regress inv_d02 inv_año
predict modelo1_02, xb
replace modelo1_02=1/modelo1_02
regress inv_d02 ln_año
predict modelo2_02, xb
replace modelo2_02=1/modelo2_02
regress inv_d02 año
predict modelo3_02, xb
replace modelo3_02=1/modelo3_02
regress ln_d02 inv_año
predict modelo4_02, xb
replace modelo4_02=exp(modelo4_02)
regress ln_d02 ln_año
predict modelo5_02, xb
replace modelo5_02=exp(modelo5_02)
regress ln_d02 año
predict modelo6_02, xb
replace modelo6_02=exp(modelo6_02)
regress d02 inv_año
predict modelo7_02, xb
regress d02 ln_año
predict modelo8_02, xb
regress d02 año
predict modelo9_02, xb

regress inv_d03 inv_año
predict modelo1_03, xb
replace modelo1_03=1/modelo1_03
regress inv_d03 ln_año
predict modelo2_03, xb
replace modelo2_03=1/modelo2_03
regress inv_d03 año
predict modelo3_03, xb
replace modelo3_03=1/modelo3_03
regress ln_d03 inv_año
predict modelo4_03, xb
replace modelo4_03=exp(modelo4_03)
regress ln_d03 ln_año
predict modelo5_03, xb
replace modelo5_03=exp(modelo5_03)
regress ln_d03 año
predict modelo6_03, xb
replace modelo6_03=exp(modelo6_03)
regress d03 inv_año
predict modelo7_03, xb
regress d03 ln_año
predict modelo8_03, xb
regress d03 año
predict modelo9_03, xb

regress inv_d04 inv_año
predict modelo1_04, xb
replace modelo1_04=1/modelo1_04
regress inv_d04 ln_año
predict modelo2_04, xb
replace modelo2_04=1/modelo2_04
regress inv_d04 año
predict modelo3_04, xb
replace modelo3_04=1/modelo3_04
regress ln_d04 inv_año
predict modelo4_04, xb
replace modelo4_04=exp(modelo4_04)
regress ln_d04 ln_año
predict modelo5_04, xb
replace modelo5_04=exp(modelo5_04)
regress ln_d04 año
predict modelo6_04, xb
replace modelo6_04=exp(modelo6_04)
regress d04 inv_año
predict modelo7_04, xb
regress d04 ln_año
predict modelo8_04, xb
regress d04 año
predict modelo9_04, xb

regress inv_d05 inv_año
predict modelo1_05, xb
replace modelo1_05=1/modelo1_05
regress inv_d05 ln_año
predict modelo2_05, xb
replace modelo2_05=1/modelo2_05
regress inv_d05 año
predict modelo3_05, xb
replace modelo3_05=1/modelo3_05
regress ln_d05 inv_año
predict modelo4_05, xb
replace modelo4_05=exp(modelo4_05)
regress ln_d05 ln_año
predict modelo5_05, xb
replace modelo5_05=exp(modelo5_05)
regress ln_d05 año
predict modelo6_05, xb
replace modelo6_05=exp(modelo6_05)
regress d05 inv_año
predict modelo7_05, xb
regress d05 ln_año
predict modelo8_05, xb
regress d05 año
predict modelo9_05, xb

regress inv_d06 inv_año
predict modelo1_06, xb
replace modelo1_06=1/modelo1_06
regress inv_d06 ln_año
predict modelo2_06, xb
replace modelo2_06=1/modelo2_06
regress inv_d06 año
predict modelo3_06, xb
replace modelo3_06=1/modelo3_06
regress ln_d06 inv_año
predict modelo4_06, xb
replace modelo4_06=exp(modelo4_06)
regress ln_d06 ln_año
predict modelo5_06, xb
replace modelo5_06=exp(modelo5_06)
regress ln_d06 año
predict modelo6_06, xb
replace modelo6_06=exp(modelo6_06)
regress d06 inv_año
predict modelo7_06, xb
regress d06 ln_año
predict modelo8_06, xb
regress d06 año
predict modelo9_06, xb

gen error_m1_01=(d01-modelo1_01)^2 if año!=6 & año!=7
gen error_m2_01=(d01-modelo2_01)^2 if año!=6 & año!=7
gen error_m3_01=(d01-modelo3_01)^2 if año!=6 & año!=7
gen error_m4_01=(d01-modelo4_01)^2 if año!=6 & año!=7
gen error_m5_01=(d01-modelo5_01)^2 if año!=6 & año!=7
gen error_m6_01=(d01-modelo6_01)^2 if año!=6 & año!=7
gen error_m7_01=(d01-modelo7_01)^2 if año!=6 & año!=7
gen error_m8_01=(d01-modelo8_01)^2 if año!=6 & año!=7
gen error_m9_01=(d01-modelo9_01)^2 if año!=6 & año!=7

gen error_m1_02=(d02-modelo1_02)^2 if año!=6 & año!=7
gen error_m2_02=(d02-modelo2_02)^2 if año!=6 & año!=7
gen error_m3_02=(d02-modelo3_02)^2 if año!=6 & año!=7
gen error_m4_02=(d02-modelo4_02)^2 if año!=6 & año!=7
gen error_m5_02=(d02-modelo5_02)^2 if año!=6 & año!=7
gen error_m6_02=(d02-modelo6_02)^2 if año!=6 & año!=7
gen error_m7_02=(d02-modelo7_02)^2 if año!=6 & año!=7
gen error_m8_02=(d02-modelo8_02)^2 if año!=6 & año!=7
gen error_m9_02=(d02-modelo9_02)^2 if año!=6 & año!=7

gen error_m1_03=(d03-modelo1_03)^2 if año!=6 & año!=7
gen error_m2_03=(d03-modelo2_03)^2 if año!=6 & año!=7
gen error_m3_03=(d03-modelo3_03)^2 if año!=6 & año!=7
gen error_m4_03=(d03-modelo4_03)^2 if año!=6 & año!=7
gen error_m5_03=(d03-modelo5_03)^2 if año!=6 & año!=7
gen error_m6_03=(d03-modelo6_03)^2 if año!=6 & año!=7
gen error_m7_03=(d03-modelo7_03)^2 if año!=6 & año!=7
gen error_m8_03=(d03-modelo8_03)^2 if año!=6 & año!=7
gen error_m9_03=(d03-modelo9_03)^2 if año!=6 & año!=7

gen error_m1_04=(d04-modelo1_04)^2 if año!=6 & año!=7
gen error_m2_04=(d04-modelo2_04)^2 if año!=6 & año!=7
gen error_m3_04=(d04-modelo3_04)^2 if año!=6 & año!=7
gen error_m4_04=(d04-modelo4_04)^2 if año!=6 & año!=7
gen error_m5_04=(d04-modelo5_04)^2 if año!=6 & año!=7
gen error_m6_04=(d04-modelo6_04)^2 if año!=6 & año!=7
gen error_m7_04=(d04-modelo7_04)^2 if año!=6 & año!=7
gen error_m8_04=(d04-modelo8_04)^2 if año!=6 & año!=7
gen error_m9_04=(d04-modelo9_04)^2 if año!=6 & año!=7

gen error_m1_05=(d05-modelo1_05)^2 if año!=6 & año!=7
gen error_m2_05=(d05-modelo2_05)^2 if año!=6 & año!=7
gen error_m3_05=(d05-modelo3_05)^2 if año!=6 & año!=7
gen error_m4_05=(d05-modelo4_05)^2 if año!=6 & año!=7
gen error_m5_05=(d05-modelo5_05)^2 if año!=6 & año!=7
gen error_m6_05=(d05-modelo6_05)^2 if año!=6 & año!=7
gen error_m7_05=(d05-modelo7_05)^2 if año!=6 & año!=7
gen error_m8_05=(d05-modelo8_05)^2 if año!=6 & año!=7
gen error_m9_05=(d05-modelo9_05)^2 if año!=6 & año!=7

gen error_m1_06=(d06-modelo1_06)^2 if año!=6 & año!=7
gen error_m2_06=(d06-modelo2_06)^2 if año!=6 & año!=7
gen error_m3_06=(d06-modelo3_06)^2 if año!=6 & año!=7
gen error_m4_06=(d06-modelo4_06)^2 if año!=6 & año!=7
gen error_m5_06=(d06-modelo5_06)^2 if año!=6 & año!=7
gen error_m6_06=(d06-modelo6_06)^2 if año!=6 & año!=7
gen error_m7_06=(d06-modelo7_06)^2 if año!=6 & año!=7
gen error_m8_06=(d06-modelo8_06)^2 if año!=6 & año!=7
gen error_m9_06=(d06-modelo9_06)^2 if año!=6 & año!=7

egen p_error_m1_01=sum(error_m1_01)
egen p_error_m2_01=sum(error_m2_01)
egen p_error_m3_01=sum(error_m3_01)
egen p_error_m4_01=sum(error_m4_01)
egen p_error_m5_01=sum(error_m5_01)
egen p_error_m6_01=sum(error_m6_01)
egen p_error_m7_01=sum(error_m7_01)
egen p_error_m8_01=sum(error_m8_01)
egen p_error_m9_01=sum(error_m9_01)

egen p_error_m1_02=sum(error_m1_02)
egen p_error_m2_02=sum(error_m2_02)
egen p_error_m3_02=sum(error_m3_02)
egen p_error_m4_02=sum(error_m4_02)
egen p_error_m5_02=sum(error_m5_02)
egen p_error_m6_02=sum(error_m6_02)
egen p_error_m7_02=sum(error_m7_02)
egen p_error_m8_02=sum(error_m8_02)
egen p_error_m9_02=sum(error_m9_02)

egen p_error_m1_03=sum(error_m1_03)
egen p_error_m2_03=sum(error_m2_03)
egen p_error_m3_03=sum(error_m3_03)
egen p_error_m4_03=sum(error_m4_03)
egen p_error_m5_03=sum(error_m5_03)
egen p_error_m6_03=sum(error_m6_03)
egen p_error_m7_03=sum(error_m7_03)
egen p_error_m8_03=sum(error_m8_03)
egen p_error_m9_03=sum(error_m9_03)

egen p_error_m1_04=sum(error_m1_04)
egen p_error_m2_04=sum(error_m2_04)
egen p_error_m3_04=sum(error_m3_04)
egen p_error_m4_04=sum(error_m4_04)
egen p_error_m5_04=sum(error_m5_04)
egen p_error_m6_04=sum(error_m6_04)
egen p_error_m7_04=sum(error_m7_04)
egen p_error_m8_04=sum(error_m8_04)
egen p_error_m9_04=sum(error_m9_04)

egen p_error_m1_05=sum(error_m1_05)
egen p_error_m2_05=sum(error_m2_05)
egen p_error_m3_05=sum(error_m3_05)
egen p_error_m4_05=sum(error_m4_05)
egen p_error_m5_05=sum(error_m5_05)
egen p_error_m6_05=sum(error_m6_05)
egen p_error_m7_05=sum(error_m7_05)
egen p_error_m8_05=sum(error_m8_05)
egen p_error_m9_05=sum(error_m9_05)

egen p_error_m1_06=sum(error_m1_06)
egen p_error_m2_06=sum(error_m2_06)
egen p_error_m3_06=sum(error_m3_06)
egen p_error_m4_06=sum(error_m4_06)
egen p_error_m5_06=sum(error_m5_06)
egen p_error_m6_06=sum(error_m6_06)
egen p_error_m7_06=sum(error_m7_06)
egen p_error_m8_06=sum(error_m8_06)
egen p_error_m9_06=sum(error_m9_06)

replace p_error_m1_01=p_error_m1_01/5
replace p_error_m2_01=p_error_m2_01/5
replace p_error_m3_01=p_error_m3_01/5
replace p_error_m4_01=p_error_m4_01/5
replace p_error_m5_01=p_error_m5_01/5
replace p_error_m6_01=p_error_m6_01/5
replace p_error_m7_01=p_error_m7_01/5
replace p_error_m8_01=p_error_m8_01/5
replace p_error_m9_01=p_error_m9_01/5

replace p_error_m1_02=p_error_m1_02/5
replace p_error_m2_02=p_error_m2_02/5
replace p_error_m3_02=p_error_m3_02/5
replace p_error_m4_02=p_error_m4_02/5
replace p_error_m5_02=p_error_m5_02/5
replace p_error_m6_02=p_error_m6_02/5
replace p_error_m7_02=p_error_m7_02/5
replace p_error_m8_02=p_error_m8_02/5
replace p_error_m9_02=p_error_m9_02/5

replace p_error_m1_03=p_error_m1_03/5
replace p_error_m2_03=p_error_m2_03/5
replace p_error_m3_03=p_error_m3_03/5
replace p_error_m4_03=p_error_m4_03/5
replace p_error_m5_03=p_error_m5_03/5
replace p_error_m6_03=p_error_m6_03/5
replace p_error_m7_03=p_error_m7_03/5
replace p_error_m8_03=p_error_m8_03/5
replace p_error_m9_03=p_error_m9_03/5

replace p_error_m1_04=p_error_m1_04/5
replace p_error_m2_04=p_error_m2_04/5
replace p_error_m3_04=p_error_m3_04/5
replace p_error_m4_04=p_error_m4_04/5
replace p_error_m5_04=p_error_m5_04/5
replace p_error_m6_04=p_error_m6_04/5
replace p_error_m7_04=p_error_m7_04/5
replace p_error_m8_04=p_error_m8_04/5
replace p_error_m9_04=p_error_m9_04/5

replace p_error_m1_05=p_error_m1_05/5
replace p_error_m2_05=p_error_m2_05/5
replace p_error_m3_05=p_error_m3_05/5
replace p_error_m4_05=p_error_m4_05/5
replace p_error_m5_05=p_error_m5_05/5
replace p_error_m6_05=p_error_m6_05/5
replace p_error_m7_05=p_error_m7_05/5
replace p_error_m8_05=p_error_m8_05/5
replace p_error_m9_05=p_error_m9_05/5

replace p_error_m1_06=p_error_m1_06/5
replace p_error_m2_06=p_error_m2_06/5
replace p_error_m3_06=p_error_m3_06/5
replace p_error_m4_06=p_error_m4_06/5
replace p_error_m5_06=p_error_m5_06/5
replace p_error_m6_06=p_error_m6_06/5
replace p_error_m7_06=p_error_m7_06/5
replace p_error_m8_06=p_error_m8_06/5
replace p_error_m9_06=p_error_m9_06/5

gen minimo_01=min(p_error_m1_01,p_error_m2_01,p_error_m3_01,p_error_m4_01,p_error_m5_01,p_error_m6_01,p_error_m7_01,p_error_m8_01,p_error_m9_01)
gen minimo_02=min(p_error_m1_02,p_error_m2_02,p_error_m3_02,p_error_m4_02,p_error_m5_02,p_error_m6_02,p_error_m7_02,p_error_m8_02,p_error_m9_02)
gen minimo_03=min(p_error_m1_03,p_error_m2_03,p_error_m3_03,p_error_m4_03,p_error_m5_03,p_error_m6_03,p_error_m7_03,p_error_m8_03,p_error_m9_03)
gen minimo_04=min(p_error_m1_04,p_error_m2_04,p_error_m3_04,p_error_m4_04,p_error_m5_04,p_error_m6_04,p_error_m7_04,p_error_m8_04,p_error_m9_04)
gen minimo_05=min(p_error_m1_05,p_error_m2_05,p_error_m3_05,p_error_m4_05,p_error_m5_05,p_error_m6_05,p_error_m7_05,p_error_m8_05,p_error_m9_05)
gen minimo_06=min(p_error_m1_06,p_error_m2_06,p_error_m3_06,p_error_m4_06,p_error_m5_06,p_error_m6_06,p_error_m7_06,p_error_m8_06,p_error_m9_06)

gen modelo_01="modelo1" if minimo_01==p_error_m1_01
replace modelo_01="modelo2" if minimo_01==p_error_m2_01
replace modelo_01="modelo3" if minimo_01==p_error_m3_01
replace modelo_01="modelo4" if minimo_01==p_error_m4_01
replace modelo_01="modelo5" if minimo_01==p_error_m5_01
replace modelo_01="modelo6" if minimo_01==p_error_m6_01
replace modelo_01="modelo7" if minimo_01==p_error_m7_01
replace modelo_01="modelo8" if minimo_01==p_error_m8_01
replace modelo_01="modelo9" if minimo_01==p_error_m9_01

gen modelo_02="modelo1" if minimo_02==p_error_m1_02
replace modelo_02="modelo2" if minimo_02==p_error_m2_02
replace modelo_02="modelo3" if minimo_02==p_error_m3_02
replace modelo_02="modelo4" if minimo_02==p_error_m4_02
replace modelo_02="modelo5" if minimo_02==p_error_m5_02
replace modelo_02="modelo6" if minimo_02==p_error_m6_02
replace modelo_02="modelo7" if minimo_02==p_error_m7_02
replace modelo_02="modelo8" if minimo_02==p_error_m8_02
replace modelo_02="modelo9" if minimo_02==p_error_m9_02

gen modelo_03="modelo1" if minimo_03==p_error_m1_03
replace modelo_03="modelo2" if minimo_03==p_error_m2_03
replace modelo_03="modelo3" if minimo_03==p_error_m3_03
replace modelo_03="modelo4" if minimo_03==p_error_m4_03
replace modelo_03="modelo5" if minimo_03==p_error_m5_03
replace modelo_03="modelo6" if minimo_03==p_error_m6_03
replace modelo_03="modelo7" if minimo_03==p_error_m7_03
replace modelo_03="modelo8" if minimo_03==p_error_m8_03
replace modelo_03="modelo9" if minimo_03==p_error_m9_03

gen modelo_04="modelo1" if minimo_04==p_error_m1_04
replace modelo_04="modelo2" if minimo_04==p_error_m2_04
replace modelo_04="modelo3" if minimo_04==p_error_m3_04
replace modelo_04="modelo4" if minimo_04==p_error_m4_04
replace modelo_04="modelo5" if minimo_04==p_error_m5_04
replace modelo_04="modelo6" if minimo_04==p_error_m6_04
replace modelo_04="modelo7" if minimo_04==p_error_m7_04
replace modelo_04="modelo8" if minimo_04==p_error_m8_04
replace modelo_04="modelo9" if minimo_04==p_error_m9_04

gen modelo_05="modelo1" if minimo_05==p_error_m1_05
replace modelo_05="modelo2" if minimo_05==p_error_m2_05
replace modelo_05="modelo3" if minimo_05==p_error_m3_05
replace modelo_05="modelo4" if minimo_05==p_error_m4_05
replace modelo_05="modelo5" if minimo_05==p_error_m5_05
replace modelo_05="modelo6" if minimo_05==p_error_m6_05
replace modelo_05="modelo7" if minimo_05==p_error_m7_05
replace modelo_05="modelo8" if minimo_05==p_error_m8_05
replace modelo_05="modelo9" if minimo_05==p_error_m9_05

gen modelo_06="modelo1" if minimo_06==p_error_m1_06
replace modelo_06="modelo2" if minimo_06==p_error_m2_06
replace modelo_06="modelo3" if minimo_06==p_error_m3_06
replace modelo_06="modelo4" if minimo_06==p_error_m4_06
replace modelo_06="modelo5" if minimo_06==p_error_m5_06
replace modelo_06="modelo6" if minimo_06==p_error_m6_06
replace modelo_06="modelo7" if minimo_06==p_error_m7_06
replace modelo_06="modelo8" if minimo_06==p_error_m8_06
replace modelo_06="modelo9" if minimo_06==p_error_m9_06

gen cantidad_01=modelo1_01 if modelo_01=="modelo1"
replace cantidad_01=modelo2_01 if modelo_01=="modelo2"
replace cantidad_01=modelo3_01 if modelo_01=="modelo3"
replace cantidad_01=modelo4_01 if modelo_01=="modelo4"
replace cantidad_01=modelo5_01 if modelo_01=="modelo5"
replace cantidad_01=modelo6_01 if modelo_01=="modelo6"
replace cantidad_01=modelo7_01 if modelo_01=="modelo7"
replace cantidad_01=modelo8_01 if modelo_01=="modelo8"
replace cantidad_01=modelo9_01 if modelo_01=="modelo9"

gen cantidad_02=modelo1_02 if modelo_02=="modelo1"
replace cantidad_02=modelo2_02 if modelo_02=="modelo2"
replace cantidad_02=modelo3_02 if modelo_02=="modelo3"
replace cantidad_02=modelo4_02 if modelo_02=="modelo4"
replace cantidad_02=modelo5_02 if modelo_02=="modelo5"
replace cantidad_02=modelo6_02 if modelo_02=="modelo6"
replace cantidad_02=modelo7_02 if modelo_02=="modelo7"
replace cantidad_02=modelo8_02 if modelo_02=="modelo8"
replace cantidad_02=modelo9_02 if modelo_02=="modelo9"

gen cantidad_03=modelo1_03 if modelo_03=="modelo1"
replace cantidad_03=modelo2_03 if modelo_03=="modelo2"
replace cantidad_03=modelo3_03 if modelo_03=="modelo3"
replace cantidad_03=modelo4_03 if modelo_03=="modelo4"
replace cantidad_03=modelo5_03 if modelo_03=="modelo5"
replace cantidad_03=modelo6_03 if modelo_03=="modelo6"
replace cantidad_03=modelo7_03 if modelo_03=="modelo7"
replace cantidad_03=modelo8_03 if modelo_03=="modelo8"
replace cantidad_03=modelo9_03 if modelo_03=="modelo9"

gen cantidad_04=modelo1_04 if modelo_04=="modelo1"
replace cantidad_04=modelo2_04 if modelo_04=="modelo2"
replace cantidad_04=modelo3_04 if modelo_04=="modelo3"
replace cantidad_04=modelo4_04 if modelo_04=="modelo4"
replace cantidad_04=modelo5_04 if modelo_04=="modelo5"
replace cantidad_04=modelo6_04 if modelo_04=="modelo6"
replace cantidad_04=modelo7_04 if modelo_04=="modelo7"
replace cantidad_04=modelo8_04 if modelo_04=="modelo8"
replace cantidad_04=modelo9_04 if modelo_04=="modelo9"

gen cantidad_05=modelo1_05 if modelo_05=="modelo1"
replace cantidad_05=modelo2_05 if modelo_05=="modelo2"
replace cantidad_05=modelo3_05 if modelo_05=="modelo3"
replace cantidad_05=modelo4_05 if modelo_05=="modelo4"
replace cantidad_05=modelo5_05 if modelo_05=="modelo5"
replace cantidad_05=modelo6_05 if modelo_05=="modelo6"
replace cantidad_05=modelo7_05 if modelo_05=="modelo7"
replace cantidad_05=modelo8_05 if modelo_05=="modelo8"
replace cantidad_05=modelo9_05 if modelo_05=="modelo9"

gen cantidad_06=modelo1_06 if modelo_06=="modelo1"
replace cantidad_06=modelo2_06 if modelo_06=="modelo2"
replace cantidad_06=modelo3_06 if modelo_06=="modelo3"
replace cantidad_06=modelo4_06 if modelo_06=="modelo4"
replace cantidad_06=modelo5_06 if modelo_06=="modelo5"
replace cantidad_06=modelo6_06 if modelo_06=="modelo6"
replace cantidad_06=modelo7_06 if modelo_06=="modelo7"
replace cantidad_06=modelo8_06 if modelo_06=="modelo8"
replace cantidad_06=modelo9_06 if modelo_06=="modelo9"

egen prom_d01=sum(d01)
egen prom_d02=sum(d02)
egen prom_d03=sum(d03)
egen prom_d04=sum(d04)
egen prom_d05=sum(d05)
egen prom_d06=sum(d06)

replace prom_d01=prom_d01/5
replace prom_d02=prom_d02/5
replace prom_d03=prom_d03/5
replace prom_d04=prom_d04/5
replace prom_d05=prom_d05/5
replace prom_d06=prom_d06/5

replace minimo_01=(minimo_01^.5)/ prom_d01
replace minimo_02=(minimo_02^.5)/ prom_d02
replace minimo_03=(minimo_03^.5)/ prom_d03
replace minimo_04=(minimo_04^.5)/ prom_d04
replace minimo_05=(minimo_05^.5)/ prom_d05
replace minimo_06=(minimo_06^.5)/ prom_d06

replace d01= cantidad_01 if año==6|año==7
replace d02= cantidad_02 if año==6|año==7
replace d03= cantidad_03 if año==6|año==7
replace d04= cantidad_04 if año==6|año==7
replace d05= cantidad_05 if año==6|año==7
replace d06= cantidad_06 if año==6|año==7

replace d01=round(d01*(1+minimo_01))
replace d02=round(d02*(1+minimo_02))
replace d03=round(d03*(1+minimo_03))
replace d04=round(d04*(1+minimo_04))
replace d05=round(d05*(1+minimo_05))
replace d06=round(d06*(1+minimo_06))

keep codooii año d01 d02 d03 d04 d05 d06 minimo_01 minimo_02 minimo_03 minimo_04 minimo_05 minimo_06 modelo_01 modelo_02 modelo_03 modelo_04 modelo_05 modelo_06
keep if año==6|año==7
