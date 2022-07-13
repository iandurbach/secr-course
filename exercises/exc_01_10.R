library(secr)

# read in data frame from mask text file
kruger.mask_df <- read.table(file = "kruger_mask.txt", header = TRUE, stringsAsFactors = TRUE)

# make a data frame with just the x and y coords
kruger.mask_xy <- data.frame(x = kruger.mask_df$x, y = kruger.mask_df$y)

# construct mask  
kruger.mask <- read.mask(data = kruger.mask_xy, spacing = 1223)

# check no covariates 
names(covariates(kruger.mask))

# add habitat covariate directly from the habitat.cov variable in kruger.mask_df
____ <- ____

# add landscape covariate from spatial data source
landscape <- readRDS(file = "landscape.Rds")
____ <- addCovariates(____, ____)

# add all water covariates from spatial data source "watervariables.shp"
____ <- addCovariates(____, ____)

# make a histogram summarizing the distance to water at mask points
hist(____)
