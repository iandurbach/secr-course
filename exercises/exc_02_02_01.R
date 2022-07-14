library(secr)

load("data/kruger_data.RData")

# detection probability, HN form
leo.0.df.hn <- secr.fit(ch, mask = mask,
                        model=list(D~1, g0~1, sigma~1), detectfn="HN")

# encounter rate model, HN form
leo.0.er.hn <- secr.fit(ch, mask = mask,
                        model=list(D~1, lambda0~1, sigma~1), detectfn="HHN")

# plot detection and encounter rate functions
xrange <- seq(from = 0, to = 12000, length.out=200)
par(mfrow = c(2,2))

detectfnplot(leo.0.df.hn$detectfn, 
             pars = detectpar(leo.0.df.hn),
             hazard = FALSE,
             xval = xrange, ylab = "Detection probability", ylim = c(0,1), main = "DP model")

detectfnplot(leo.0.er.hn$detectfn, 
             pars = detectpar(leo.0.er.hn), 
             hazard = FALSE,
             xval = xrange, ylab = "Detection probability", ylim = c(0,1), main = "ER model")

detectfnplot(leo.0.df.hn$detectfn, 
             pars = detectpar(leo.0.df.hn),
             hazard = TRUE,
             xval = xrange, ylab = "Encounter rate", ylim = c(0,1), main = "DP model")

detectfnplot(leo.0.er.hn$detectfn, 
             pars = detectpar(leo.0.er.hn), 
             hazard = TRUE,
             xval = xrange, ylab = "Encounter rate", ylim = c(0,1), main = "ER model")


