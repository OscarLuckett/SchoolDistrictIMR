school_data <- read.csv("data/ccd_public_school_data_20192020.csv")

library(dplyr)
library(ggmap)
library(tmaptools)
library(RCurl)
library(jsonlite)
library(tidyverse)
library(leaflet)
library(mapproj)
library(ggplot2)

bklyn_schools <- school_data %>% 
  filter(City=="BROOKLYN")

bklyn_schools <- bklyn_schools %>% 
  mutate(full_address = paste(Street.Address,City, State, ZIP, sep=", "))

schools_df <- data.frame(school = bklyn_schools$full_address, stringsAsFactors = FALSE)

# run the geocode function from ggmap package
register_google(key = Sys.getenv("R_API_KEY"))

schools_ggmap <- geocode(location = bklyn_schools$full_address, output = "more", source = "google")
schools_ggmap <- cbind(bklyn_schools, schools_ggmap)

library(ggmap)
brooklyn_map <- get_googlemap(center = c(-74.004744,40.6477643),zoom=12, 
                       key=Sys.getenv("R_API_KEY"))

bounds <- as.numeric(attr(brooklyn_map,"bb"))

library(ggvoronoi)

schools_ggmap %>% mutate(x=east, y=north)

map <-
  ggmap(brooklyn_map,base_layer = ggplot(data=schools_ggmap,aes(x=east,y=north))) +
  xlim(-73.5,-74.5)+ylim(40,41)+
  coord_map(ylim=bounds[c(1,3)],xlim=bounds[c(2,4)]) +
  theme_minimal() +
  theme(axis.text=element_blank(),
        axis.title=element_blank())

# https://www.google.com/maps/place/Brooklyn,+NY/@40.6477643,-74.004744,12z/data=!4m5!3m4!1s0x89c24416947c2109:0x82765c7404007886!8m2!3d40.6781784!4d-73.9441579https://www.google.com/maps/place/Brooklyn,+NY/@40.6477643,-74.004744,12z/data=!4m5!3m4!1s0x89c24416947c2109:0x82765c7404007886!8m2!3d40.6781784!4d-73.9441579_map <- get_googlemap(center = c(-84.7398373,39.507306),zoom=15, 
#                             key=Sys.getenv("R_API_KEY"))

