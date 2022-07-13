library(secr)

# read in locations csv
traps_df <- read.csv(file = "data/kruger_traps_xy.csv", header = TRUE)

# make traps object from data frame
traps <- read.traps(data = traps_df, 
                    detector = "count",
                    trapID = "Detector")

# add a covariate with made up data
traps_df$CameraType <- sample(c("A", "B", "C"), nrow(traps), replace = TRUE)

# add a covariate called `CamTypeUsed` that contains the type of camera used (A, B, or C)
covariates(traps)$____ <- ____

# confirm covariate is there
names(____)
