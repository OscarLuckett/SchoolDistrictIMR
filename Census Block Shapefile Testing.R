library(sf)
library(dplyr)
library(foreign)

nycb_wo_dems.tx <- "data/nycb2010.shp"  


# I don't think we're using these lines:
#shp <- readOGR(dsn=nycb.tx, stringsAsFactor = F)
#coords <- coordinates(shp)


tx <- st_read(nycb.tx, stringsAsFactors=FALSE)
## Reading layer `Texas_VTD' from data source `/Users/bob/Downloads/Texas_Shapefile/Texas_VTD.shp' using driver `ESRI Shapefile'
## Simple feature collection with 8400 features and 21 fields
## geometry type:  POLYGON
## dimension:      XY
## bbox:           xmin: 372991.6 ymin: 412835.3 xmax: 1618133 ymax: 1594958
## epsg (SRID):    NA
## proj4string:    +proj=lcc +lat_1=34.91666666666666 +lat_2=27.41666666666667 +lat_0=31.16666666666667 +lon_0=-100 +x_0=1000000 +y_0=1000000 +datum=NAD83 +units=m +no_defs

tx_ll <- st_transform(tx, "+proj=longlat +ellps=WGS84 +datum=WGS84")

census_block_centers = st_coordinates(tx_ll) %>% as.data.frame() %>% 
  group_by(L3) %>% summarize(x = (min(X)+max(X))/2, y=(min(Y)+max(Y))/2)

census_block_info <- data.frame(tx_ll) %>% dplyr::select(BoroCode, BoroName, CB2010, CT2010, BCTCB2010, Shape_Area) 
census_blocks <- cbind(census_block_centers, census_block_info)

#https://gis.stackexchange.com/questions/9380/where-to-get-2010-census-block-data

#http://www2.census.gov/geo/tiger/TIGER2010BLKPOPHU/
#NY is state fp10 = 36

#https://www.kaggle.com/muonneutrino/new-york-city-census-data

block_level_demographics <- 
  read.dbf("data/NYCblocks10_PL2k_2010_plurality_change_CUNYCenterforUrbanResearch.dbf")
# take from here: https://www.urbanresearchmaps.org/plurality/blockmaps.htm

nycb.tx <- "data/NYCblocks10_PL2k_2010_plurality_change_CUNYCenterforUrbanResearch.shp"  

tx <- st_read(nycb.tx, stringsAsFactors=FALSE)
tx_ll <- st_transform(tx, "+proj=longlat +ellps=WGS84 +datum=WGS84")

census_block_centers = st_coordinates(tx_ll) %>% as.data.frame() %>% 
  group_by(L3) %>% summarize(x = (min(X)+max(X))/2, y=(min(Y)+max(Y))/2)

census_block_info <- data.frame(tx_ll) %>% dplyr::select(BoroCode, BoroName, CB2010, CT2010, BCTCB2010, Shape_Area) 
census_blocks <- cbind(census_block_centers, census_block_info)
