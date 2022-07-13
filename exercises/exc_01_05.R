library(secr)

# read in text file with detector locations 
traps.xy <- read.traps(file = "kruger_traps_xy.txt", detector = "count", trapID = "Detector")

# read in habitat covariate, a raster 
habitat <- raster(x = "habitat.tif")
class(habitat)
# add covariate at detector locations
traps <- addCovariates(object = traps.xy, spatialdata = ____)

# read in landscape covariate, an sf data frame stored in it's own Rds file
landscape <- readRDS(file = "landscape.Rds")
class(landscape)
# add covariate at detector locations
traps <- addCovariates(object = traps, spatialdata = ____)

# all water variables, from a shape file
traps <- addCovariates(object = traps, spatialdata = ____)

# look at what covariates you have
names(covariates(traps))

# rename any covariates you want to
names(covariates(traps))[4:6] <- c("high.water", "dist.to.water", "km.to.water")

# make a histogram summarizing the distance to water at detector locations
hist(____)