library(secr)

# read in locations csv
traps_df <- read.csv(file = "kruger_traps_xy.csv", header = TRUE)

# check what class this is
class(traps_df)

# inspect first 5 rows
head(traps_df)

# make traps object from data frame
traps <- read.traps(data = traps_df, 
                    detector = "count",
                    trapID = "Detector")

head(traps)
summary(traps)