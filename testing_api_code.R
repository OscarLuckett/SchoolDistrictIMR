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
register_google(key = "AIzaSyCZDb3ZnRyXamMyjj3kBywZR0fU8Dis6Qs")


# create a list of London pubs
pubs <- c("The Angel, Bermondsey", "The Churchill Arms, Notting Hill", "The Auld Shillelagh, Stoke Newington", "The Sekforde, Clerkenwell", "The Dove, Hammersmith", "The Crown and Sugar Loaf, Fleet Street", "The Lamb, Holborn", "Prince of Greenwich, Greenwich", "Ye Olde Mitre, Hatton Garden", "The Glory, Haggerston", "The Blue Posts, Soho", "The Old Bank of England, Fleet Street")
pubs_df <- data.frame(Pubs = pubs, stringsAsFactors = FALSE)

# run the geocode function from ggmap package
pubs_ggmap <- geocode(location = pubs, output = "more", source = "google")
pubs_ggmap <- cbind(pubs_df, pubs_ggmap)
