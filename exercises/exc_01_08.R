library(secr)

# read in detector data
traps <- read.traps(file = "kruger_traps.txt", 
                    detector = "count",
                    trapID = "Detector",
                    covnames = c("habitat.cov", "landscape", "water", "high.water", "dist.to.water", "km.to.water"))

# construct mask from the traps object, using type "trapbuffer"  
kruger.mask <- make.mask(traps = ____, buffer = ____, spacing = ____, type = ____)

# plot the mask
plot(kruger.mask)
plot(traps, add = TRUE)

# construct mask from the traps object, using type "traprect" 
kruger.mask.rect <- make.mask(traps = ____, buffer = ____, spacing = ____, type = ____)

# plot the mask
plot(kruger.mask.rect)
plot(traps, add = TRUE)
