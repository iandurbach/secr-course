library(secr)

set.seed(567)

# read in locations csv
traps_df <- read.csv(file = "data/kruger_traps_xy.csv", header = TRUE)

# make traps object from data frame
traps <- read.traps(data = traps_df, 
                    detector = "count",
                    trapID = "Detector")

# add a covariate with made up data
traps_df$CameraType <- sample(c("A", "B", "C"), nrow(traps), replace = TRUE)

# add a covariate called `CamTypeUsed` that contains the type of camera used (A or B)
covariates(traps)$CamTypeUsed <- traps_df$CameraType

# confirm covariate is there
names(covariates(traps))