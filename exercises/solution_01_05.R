library(secr)

# read in text file with detector locations 
traps.xy <- read.traps(file = "data/kruger_traps_xy.txt", detector = "count", trapID = "Detector")

# read in habitat covariate, a raster 
habitat <- raster(x = "data/habitat.tif")
class(habitat)
# add covariate at detector locations
traps <- addCovariates(object = traps.xy, spatialdata = habitat)

# read in landscape covariate, an sf data frame stored in it's own Rds file
landscape <- readRDS(file = "data/landscape.Rds")
class(landscape)
# add covariate at detector locations
traps <- addCovariates(object = traps, spatialdata = landscape)

# all water variables, from a shape file
traps <- addCovariates(object = traps, spatialdata = "data/watervariables.shp")

# look at what covariates you have
names(covariates(traps))

# rename any covariates you want to
names(covariates(traps))[4:6] <- c("high.water", "dist.to.water", "km.to.water")

# make a histogram summarizing the distance to water at detector locations
hist(covariates(traps)$dist.to.water)

