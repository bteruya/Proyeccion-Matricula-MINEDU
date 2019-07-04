/*******************************************************************************
					PROYECCIÓN DE MATRÍCULA
					Orden: 0
					Dofile: Master Dofile
					Input: Censo Escolar, Padrón Web, Nexus, Siagie
					
					Brenda Teruya
*******************************************************************************/
cd "D:\Brenda GoogleDrive\Trabajo\MINEDU_trabajo\Proyecciones"

*cargamos los programas
do "4. Codigos\Dofiles\Dofile_programs.do"

*replica las tablas de la introducción
do "4. Codigos\Dofiles\Dofile_1_Intro.do"

*prepara la bd
do "4. Codigos\Dofiles\Dofile_2_Dataprep.do"

*realiza las proyecciones
do "4. Codigos\Dofiles\Dofile_3_proyeccion.do"

erase  "4. Codigos\Output\Proyeccion.xls"
erase  "4. Codigos\Output\Tendencia.xlsx"
erase  "4. Codigos\Output\secciones.log"
shell rmdir "Datasets_intermedios" /s
