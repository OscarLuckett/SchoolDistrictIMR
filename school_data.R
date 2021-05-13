library(data.table)
mem <- fread("data/ccd_membership_data.csv")
library(dplyr)
mem_ny <- mem %>% filter(ST=="NY")
save(mem_ny, file="mem_ny.RData")
just_one_school <- mem_ny %>% filter(NCESSCH==360000104498)
View(just_one_school)



school_info <- fread("data/ccd_school_info.csv")
ny_school_info <- school_info %>% filter(MSTATE=="NY")
brooklyn_school_info <- ny_school_info %>% filter(MCITY=="BROOKLYN")

#total <- merge(data frameA,data frameB,by="ID")

brooklyn_with_mem_info <- merge(mem_ny, brooklyn_school_info, by="NCESSCH")

brooklyn_middle_school_mem_info <- brooklyn_with_mem_info %>% filter(GRADE %in%
                  c("Grade 6", "Grade 7", "Grade 8"))

View(brooklyn_middle_school_mem_info)

brooklyn_school_race_eth_nums <- brooklyn_middle_school_mem_info %>% group_by(NCESSCH, RACE_ETHNICITY) %>% 
  summarize(school_name = first(SCH_NAME.x), student_counts = sum(STUDENT_COUNT))

save(brooklyn_school_race_eth_nums, file="brooklyn_school_race_eth_nums.RData")
