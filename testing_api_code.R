# install packages
install.packages("ggmap")
install.packages("tmaptools")
install.packages("RCurl")
install.packages("jsonlite")
install.packages("tidyverse")
install.packages("leaflet")
# load packages
library(ggmap)
library(tmaptools)
library(RCurl)
library(jsonlite)
library(tidyverse)
library(leaflet)

# replace "api_key" with your API key
register_google(key = Sys.getenv("R_API_KEY"))


# create a list of London pubs
pubs <- c("The Angel, Bermondsey", "The Churchill Arms, Notting Hill", "The Auld Shillelagh, Stoke Newington", "The Sekforde, Clerkenwell", "The Dove, Hammersmith", "The Crown and Sugar Loaf, Fleet Street", "The Lamb, Holborn", "Prince of Greenwich, Greenwich", "Ye Olde Mitre, Hatton Garden", "The Glory, Haggerston", "The Blue Posts, Soho", "The Old Bank of England, Fleet Street")
pubs_df <- data.frame(Pubs = pubs, stringsAsFactors = FALSE)

# run the geocode function from ggmap package
pubs_ggmap <- geocode(location = pubs, output = "more", source = "google")
pubs_ggmap <- cbind(pubs_df, pubs_ggmap)

# extract the coordinates of London pubs
pubs_ggmap_crd <- list()
for (i in 1:dim(pubs_ggmap)[1]) {
  lon <- pubs_ggmap$lon[i]
  lat <- pubs_ggmap$lat[i]
  pubs_ggmap_crd[[i]] <- c(lon, lat)
}

# reverse geocode the coordinates and save them to the list
pubs_ggmap_address <- list()
for (i in 1:length(pubs_ggmap_crd)) {
  pub <- pubs[i]
  crd <- pubs_ggmap_crd[[i]]
  address <- revgeocode(location = crd, output = "address")
  pubs_ggmap_address[[i]] <- list(pub, crd, address)
}

# print the details of the first pub
pubs_ggmap_address[[1]]

# modifying some search requests
pubs_m <- pubs
pubs_m[pubs_m=="The Crown and Sugar Loaf, Fleet Street"] <- "The Crown and Sugar Loaf"
pubs_m[pubs_m=="Ye Olde Mitre, Hatton Garden"] <- "Ye Olde Mitre"
pubs_m_df <- data.frame(Pubs = pubs_m, stringsAsFactors = FALSE)

# geocoding the London pubs
# "bar" is special phrase added to limit the search
pubs_tmaptools <- geocode_OSM(paste(pubs_m, "bar", sep = " "),
                              details = TRUE, as.data.frame = TRUE)

# extracting from the result only coordinates and address
pubs_tmaptools <- pubs_tmaptools[, c("lat", "lon", "display_name")]
pubs_tmaptools <- cbind(Pubs = pubs_m_df[-10, ], pubs_tmaptools)

# print the results
pubs_tmaptools


###### maps

library(ggmap)

oxford_map <- get_googlemap(center = c(-84.7398373,39.507306),zoom=18, 
                            key=Sys.getenv("R_API_KEY"))

bounds <- as.numeric(attr(oxford_map,"bb"))

library(ggvoronoi)
map <-
  ggmap(oxford_map,base_layer = ggplot(data=oxford_bikes,aes(x,y))) +
  xlim(-85,-84)+ylim(39,40)+
  coord_map(ylim=bounds[c(1,3)],xlim=bounds[c(2,4)]) +
  theme_minimal() +
  theme(axis.text=element_blank(),
        axis.title=element_blank())

library(mapproj)

map + geom_path(stat="voronoi",alpha=.085,size=.25) +
  geom_point(color="blue",size=.25)
