#install.packages("tidyverse")
library(readr)
library(dplyr)
library(readxl)
MRPdata <- read_xls('raw_data/EPH_usu_2_Trim_2017_xls/2017.2.copy.xls')
MRPdata_b <- read_xls('raw_data/EPH_usu_3_Trim_2017_xls/2017.3.copy.xls')

MRPdata_merge <- bind_rows(MRPdata, MRPdata_b)

mrpanalysis <- MRPdata_merge %>% 
  select(CODUSU, REGION, CH03, CH05, NIVEL_ED) %>% 
  rename(hh_id = CODUSU, region=REGION, family_relation = CH03, dob = CH05, edu_attain = NIVEL_ED) %>% 
  tibble::rowid_to_column("id")
save(mrpanalysis, file="mrpanalysis.RData")
head(mrpanalysis)

#marp
#create data set on dads == 1 
dad_mrp <- mrpanalysis %>% filter(family_relation == 1) %>% 
  mutate(dad_edu = edu_attain)

#mom's data 
mom_mrp <- mrpanalysis %>% 
  filter(family_relation == 2) %>% 
  mutate(mom_edu = edu_attain)


mrp_fam_merge <- mrpanalysis %>%  left_join(dad_mrp) %>% left_join(mom_mrp) 

save(mrp_fam_merge, file="mrp_fam_merge.Rdata")

head(mrp_fam_merge)

group_by(hh_id) %>% fill(dad_edu)


# need to grab NIVEL_ED from parents (CHO3 1 and 2 ) to children,
# if CHO3 == 1 o 2 copy NIVEL_ED to children in household
# what about the perc?entiles
glimpse(mrpanalysis)
