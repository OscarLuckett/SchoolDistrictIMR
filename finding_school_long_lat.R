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
brooklyn_map <- get_googlemap(center = c(-73.95,40.6477643),zoom=11, 
                       key=Sys.getenv("R_API_KEY"))

bounds <- as.numeric(attr(brooklyn_map,"bb"))

library(ggvoronoi)

#save(schools_ggmap, file="schools_ggmap.RData")
load("schools_ggmap.RData")



schools_ggmap %>% ggplot(aes(Low.Grade.))+geom_bar()

schools_ggmap <- schools_ggmap %>% mutate(low_grade = as.numeric(as.character(Low.Grade.)))
schools_ggmap <- schools_ggmap %>% mutate(high_grade = as.numeric(as.character(High.Grade.)))

schools_ggmap <- schools_ggmap %>% mutate(low_grade = ifelse(Low.Grade.=="PK",-1, low_grade))
schools_ggmap <- schools_ggmap %>% mutate(low_grade = ifelse(Low.Grade.=="KG",0, low_grade))

schools_ggmap <- schools_ggmap %>% mutate(high_grade = ifelse(High.Grade.=="PK",-1, high_grade))
schools_ggmap <- schools_ggmap %>% mutate(high_grade = ifelse(High.Grade.=="KG",0, high_grade))

MS_schools_ggmap = schools_ggmap %>% filter (low_grade <= 8 , high_grade>= 6)

MS_schools_ggmap <- MS_schools_ggmap %>% mutate(student_pop = as.numeric(Students.))
MS_schools_ggmap <- MS_schools_ggmap %>% mutate(student_p_grade = student_pop / (high_grade - low_grade + 1))

view(MS_schools_ggmap)

schools_ggmap <- schools_ggmap %>% mutate(x=lon, y=lat) 
schools_ggmap <- schools_ggmap %>% dplyr::select(-lat, -lon)

school_locations <- schools_ggmap %>% dplyr::select(x,y) %>% unique()

map <-ggmap(ggmap=brooklyn_map,
        base_layer = ggplot(data=school_locations,aes(x,y))) +
  coord_map(ylim=bounds[c(1,3)],xlim=bounds[c(2,4)]) +
  theme(axis.text=element_blank(),
        axis.title=element_blank())

# https://www.google.com/maps/place/Brooklyn,+NY/@40.6477643,-74.004744,12z/data=!4m5!3m4!1s0x89c24416947c2109:0x82765c7404007886!8m2!3d40.6781784!4d-73.9441579https://www.google.com/maps/place/Brooklyn,+NY/@40.6477643,-74.004744,12z/data=!4m5!3m4!1s0x89c24416947c2109:0x82765c7404007886!8m2!3d40.6781784!4d-73.9441579_map <- get_googlemap(center = c(-84.7398373,39.507306),zoom=15, 
#                             key=Sys.getenv("R_API_KEY"))

map + geom_path(stat="voronoi",alpha=.1,size=.25) +
  geom_point(color="blue",size=.25)

brooklyn_diagram <- voronoi_polygon(school_locations,x="x",y="y")

library(sp)
oscars_house <- SpatialPointsDataFrame(cbind(long=-73.9945385,lat=40.6912433),
                                   data=data.frame(name="Oscars"))

oscars_house %over% brooklyn_diagram


map + geom_path(data=fortify_voronoi(brooklyn_diagram),aes(x,y,group=group),
                alpha=.1,size=1) +
  coord_map(xlim=c(-73.9945385-.015,-73.9945385+.015),ylim=c(40.6912433-.015,40.6912433+.015)) +
  geom_point(data=data.frame(oscars_house),aes(long,lat),color="red",size=2) +
  geom_point(size=1.5,stroke=1, shape=21,color="black",fill="white") +
  geom_point(data=oscars_house %over% brooklyn_diagram,aes(x,y),color="blue",size=2)
