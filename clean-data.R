#install.packages("tidyverse")
library(readr)
library(dplyr)
library(readxl)
MRPdata <- read_xls('raw_data/EPH_usu_2_Trim_2017_xls/2017.2.copy.xls')
MRPdata_b <- read_xls('raw_data/EPH_usu_3_Trim_2017_xls/2017.3.copy.xls')

MRPdata_merge <- bind_rows(MRPdata, MRPdata_b)

mrpanalysis <- MRPdata_merge %>% 
  select(CODUSU, REGION, MAS_500, AGLOMERADO, CH03, CH05:CH06,
         CH10:CH12, CH16, NIVEL_ED, DECIFR, RDECIFR, GDECIFR,
         PDECIFR, ADECIFR, DECCFR, RDECCFR, GDECCFR, PDECCFR, ADECCFR) %>% 
  filter(CH06 >= 18 & CH06 <= 23)

# need to grab NIVEL_ED from parents (CHO3 1 and 2 ) to children,
# if CHO3 == 1 o 2 copy NIVEL_ED to children in household
