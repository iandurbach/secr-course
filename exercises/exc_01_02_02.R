library(secr)

traps <- read.traps(file = "data/____", 
                    detector = "count",
                    trapID = "____",
                    covnames = c("____", "landscape", "water", "high.water", "dist.to.water", "km.to.water"))

head(traps)
head(covariates(traps))
summary(traps)
