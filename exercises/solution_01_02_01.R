library(secr)

traps <- read.traps(file = "data/kruger_traps_xy.txt", 
                    detector = "count",
                    trapID = "Detector")

head(traps)
summary(traps)