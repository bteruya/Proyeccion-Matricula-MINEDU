# Proyecciones
Estos archivos proyectan variables educativas (matricula, docentes, secciones) del Perú

## Dofile_0_Master
Ejecuta todos los dofiles en el orden establecido para replicar el análisis

## Dofile_programs
Contiene las subrutinas, debe ser ejecutado antes de realizar las estimaciones de docentes
matrícula y secciones. Se ejecuta dentro del dofile master.

## Dofile_1_Intro
Crea la data sobre las tablas introductorias
En particular la evolución de variables educativas en el tiempo a partir del Censo Educativo

## Dofile_2_Dataprep
Prepara los datasets de cuarto de primaria y secundaria. Si se desea ampliar para otros 
grados hay que cambiar aquí el dataset. Ademas calcula el numero de aprobados y desaprobados a partir del Censo Educativo, asi como las 
tasas a partir del SIAGIE (desercion, migracion, desaprobacion)

## Dofile_3_proyeccion
Crea las estimaciones de los docentes, seccionesy matrícula a través de los método: medias móviles, suavización exponencial,
el método de la UE anterior MCO UGEL por UGEL, UE 7 metodos, aprobacion y desaprobacion, CSR y método BID grado a grado (exponencial y MCO).

## Old
Versiones anteriores de los dofiles, no interesa verlos

## Graficos
Contiene como hacer los graficos adicionales del error de prediccion por tipo de UGEL, georreferenciado, entre otros.