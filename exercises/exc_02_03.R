library(secr)

load("data/kruger_data.Rdata")

# fitted last time: detection probability, HN form
leo.0.df.hn <- secr.fit(ch, mask = mask,
                        model=list(D~1, g0~1, sigma~1), 
                        detectfn="HN",
                        trace = FALSE)

# can also use a different function to model the shape of the relationship between det prob and distance
leo.0.df.hr <- secr.fit(ch, mask = mask,
                        model=list(D~1, g0~1, sigma~1), 
                        detectfn="HR",
                        trace = FALSE)

# plot
par(mfrow = c(1,2))
plot(leo.0.df.hn, xval = seq(0,12000,50), limits = TRUE)
plot(leo.0.df.hr, xval = seq(0,12000,50), limits = TRUE)

# model comparison, which is best
AIC(leo.0.df.hn, leo.0.df.hr)

# compare the model coefficients
coef(leo.0.df.hn) 
coef(leo.0.df.hr) 