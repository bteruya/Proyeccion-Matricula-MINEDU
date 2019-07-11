# Proyecciones
Estos archivos proyectan variables educativas (matricula, docentes, secciones) del Perú

## Dofile_programs
Contiene las subrutinas, debe ser ejecutado antes de realizar las estimaciones de docentes
matrícula y secciones. Se ejecuta dentro del dofile master.

## Dofile_0_Master
Ejecuta todos los dofiles en el orden establecido para replicar el análisis

## Dofile_1_Intro
Crea la data sobre las tablas introductorias
En particular la evolución de variables educativas en el tiempo a partir del Censo Educativo

## Dofile_2_Dataprep
Prepara los datasets de cuarto de primaria y secundaria. Si se desea ampliar para otros 
grados hay que cambiar aquí el dataset.

## Dofile_3_proyeccion
Crea las estimaciones de los docentes, secciones y matrícula a través del método medias móviles, suavización exponencial 
y el método de la UE anterior. Para matrícula se añade CSR y método BID grado a grado.

