#install.packages("tidyverse")
library(readr)
library(dplyr)
library(readxl)
library(tidyr)

#merge them together
# read data in
MRPdata <- read_xls('raw_data/EPH_usu_2_Trim_2017_xls/2017.2.copy.xls')
MRPdata_b <- read_xls('raw_data/EPH_usu_3_Trim_2017_xls/2017.3.copy.xls')

# merge them together
MRPdata_merge <- bind_rows(MRPdata, MRPdata_b)

#select and rename the variables/columns you want to work with 
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
        smmetropercapfaminclevel = PDECCFR, metropercapfaminclevel = ADECCFR) 
View(mrpanalysis)
glimpse(mrpanalysis)

#load("/Users/chloebergsma-safar/Downloads/mrpanalysis (1).RData")

#we can save the dataframe in an R native data format
#save(mrpanalysis, file="mrpanalysis.RData")

#the below would load a dataframe you saved with save()
#the idea here is you'll want to read, clean, prep the data, save() it, then you can load it when
#you are ready for analysis 
#load('mrpanalysis.RData')

#takes a bit to run, but this sequence creates the mom and dad education vars based on family_relation
#then groups the data by household and fills out those mom_edu & dad_edu vars by household
# so each household will have a mom and dad education level with those values
mrpan_mom_dad <- mrpanalysis %>% 
  mutate(dad_edu = ifelse(famrelation == 1, edlevelachieve, NA),
         mom_edu = ifelse(famrelation == 2, edlevelachieve, NA)) %>% 
  group_by(hhid) %>% 
  fill(dad_edu, mom_edu) %>% 
  fill(dad_edu, mom_edu, .direction = "up")

save(mrpan_mom_dad, file="mrpan_mom_dad.Rdata")

# need to grab NIVEL_ED from parents (CHO3 1 and 2 ) to children,
# if CHO3 == 1 o 2 copy NIVEL_ED to children in household
# what about the perc?entiles
