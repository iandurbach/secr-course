# Example #1
# Goals: 
#  - fit a very basic SCR model (uniform everything) 
#  - examine some output 
# Data: Kruger leopards

library(secr)

load("data/krugerdata.RData")

## view model inputs: mask, capthist, traps
plot(kruger.mask) # this is plot.mask
plot(traps(kruger.ch.bin), add = TRUE) # this is plot.traps
plot(kruger.ch.bin, tracks = TRUE, add = TRUE) # this is plot.capthist

# fit model
leo.0 <- secr.fit(kruger.ch.count, mask = kruger.mask, model=list(____,____), detectfn="HN")

# examine output
coef(leo.0) # link scale
predict(leo.0) # natural scale
derived(leo.0)
predict(leo.0)["D",] # explain difference with derived
region.N(leo.0) 