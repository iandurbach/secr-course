library(secr)

traps <- read.traps(file = "____", 
                    detector = "count",
                    trapID = "____",
                    covnames = c("____", "landscape", "water", "high.water", "dist.to.water", "km.to.water"))

head(traps)
summary(traps)