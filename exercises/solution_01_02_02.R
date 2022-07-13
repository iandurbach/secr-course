library(secr)

traps <- read.traps(file = "kruger_traps.txt", 
                    detector = "count",
                    trapID = "Detector",
                    covnames = c("habitat.cov", "landscape", "water", "high.water", "dist.to.water", "km.to.water"))

head(traps)
summary(traps)