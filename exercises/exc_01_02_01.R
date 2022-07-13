library(secr)

traps <- read.traps(file = "data/____", 
                    detector = "count",
                    trapID = "____")

head(traps)
summary(traps)