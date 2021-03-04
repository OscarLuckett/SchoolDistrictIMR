
install.packages("sf")

library(sf)
library(dplyr)

nycb.tx <- "data/nycb2010.shp"        
shp <- readOGR(dsn=nycb.tx, stringsAsFactor = F)
coords <- coordinates(shp)


tx <- st_read(nycb.tx, stringsAsFactors=FALSE)
## Reading layer `Texas_VTD' from data source `/Users/bob/Downloads/Texas_Shapefile/Texas_VTD.shp' using driver `ESRI Shapefile'
## Simple feature collection with 8400 features and 21 fields
## geometry type:  POLYGON
## dimension:      XY
## bbox:           xmin: 372991.6 ymin: 412835.3 xmax: 1618133 ymax: 1594958
## epsg (SRID):    NA
## proj4string:    +proj=lcc +lat_1=34.91666666666666 +lat_2=27.41666666666667 +lat_0=31.16666666666667 +lon_0=-100 +x_0=1000000 +y_0=1000000 +datum=NAD83 +units=m +no_defs

tx_ll <- st_transform(tx, "+proj=longlat +ellps=WGS84 +datum=WGS84")

head(st_coordinates(tx_ll))

nrow(st_coordinates(tx_ll))

str(tx)
View(st_coordinates(tx_ll))
group_by((st_coordinates(tx_ll)))

census_block_centers = st_coordinates(tx_ll) %>% as.data.frame() %>% group_by(L3) %>% summarize(x = mean(X), y=mean(Y))

View(census_block_centers)

