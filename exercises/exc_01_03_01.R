library(secr)

# read in locations csv
traps_df <- read.csv(file = "data/____", header = TRUE)

# check what class this is
class(____)

# inspect first 5 rows
____

# make traps object from data frame
traps <- read.traps(data = ____, 
                    detector = "count",
                    trapID = "Detector")

head(traps)
summary(traps)