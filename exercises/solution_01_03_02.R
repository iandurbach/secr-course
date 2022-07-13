library(secr)

# read in locations csv
traps_df <- read.csv(file = "data/kruger_traps_xy.csv", header = TRUE)

# add a covariate with made up data
traps_df$CameraType <- sample(c("A", "B", "C"), nrow(traps), replace = TRUE)

# make traps object from data frame
traps <- read.traps(data = traps_df, 
                    detector = "count",
                    trapID = "Detector",
                    covnames = "CameraType")

# traps covariates are empty
names(covariates(traps))
