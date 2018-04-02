#install.packages("tidyverse")
library(readr)
library(dplyr)
library(readxl)

#read data in
MRPdata <- read_xls('raw_data/EPH_usu_2_Trim_2017_xls/2017.2.copy.xls')
MRPdata_b <- read_xls('raw_data/EPH_usu_3_Trim_2017_xls/2017.3.copy.xls')

#merge them together
MRPdata_merge <- bind_rows(MRPdata, MRPdata_b)

mrpanalysis <- MRPdata_merge %>% 
  select(CODUSU, REGION, MAS_500, AGLOMERADO, CH03, CH06,
         CH10:CH12, CH16, NIVEL_ED, DECIFR, RDECIFR, GDECIFR,
         PDECIFR, ADECIFR, DECCFR, RDECCFR, GDECCFR, PDECCFR, ADECCFR) %>%
  rename(hhid = CODUSU, bigmetroarea = MAS_500, metroarea = AGLOMERADO,
        famrelation = CH03, age = CH06, attendEd = CH10, typeEd = CH11, 
        levelEd = CH12, residence = CH16, edlevelachieve = NIVEL_ED,
        totfaminclevel = DECIFR, regfaminclevel = RDECIFR, 
        lgmetrofaminclevel = GDECIFR, smmetrofaminclevel = PDECIFR,
        metrofaminclevel = ADECIFR, percaptotfaminclevel = DECCFR,
        regpercapfaminclevel = RDECCFR, lgmetropercapfaminlevel = GDECCFR, 
        smmetropercapfaminclevel = PDECCFR, metropercapfaminclevel = ADECCFR) %>% 
  filter(age >= 18 & age <= 23)
View(mrpanalysis)

load("/Users/chloebergsma-safar/Downloads/mrpanalysis (1).RData")

# need to grab NIVEL_ED from parents (CHO3 1 and 2 ) to children,
# if CHO3 == 1 o 2 copy NIVEL_ED to children in household
# what about the percentiles