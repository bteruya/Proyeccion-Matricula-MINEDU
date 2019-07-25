#Archivo que importa datos desde spss hacia stata
library(here)
library(foreign)
library(janitor)
library(tidyverse)


ruta_file <- c("..", "..", "..", "3. Data", "1. UGEL Level")

#"\3. Data\1. UGEL Level\00_Modulo 0\MODULO 0.sav"

modulo_0 <- read.spss(here("..", "..", "..", "3. Data", "1. UGEL Level",
                           "00_Modulo 0", "MODULO 0.sav"),
                      to.data.frame = TRUE) %>%
  clean_names() 

write.dta(modulo_0, file = here("..", "..",  "..","3. Data", "1. UGEL Level",
              "00_Modulo 0", "modulo_0.dta"))

modulo_0 %>% 
  count(m0_p04, m0_p01)
