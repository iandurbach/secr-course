library(secr)

# load saved objects 'traps', 'ch', and 'mask'
load("kruger_data.RData")

# view model inputs: mask, capthist, traps
plot(mask) # this is plot.mask
plot(traps(ch), add = TRUE) # this is plot.traps
plot(ch, tracks = TRUE, add = TRUE) # this is plot.capthist

# fit model
leo.0 <- secr.fit(capthist = ch, 
                  mask = mask, 
                  model = list(D~1, g0~1, sigma~1), 
                  detectfn = "HN")

# examine output
coef(leo.0) # estimates on link scale
predict(leo.0) # estimates on natural scale
region.N(leo.0) # abundance estimates
