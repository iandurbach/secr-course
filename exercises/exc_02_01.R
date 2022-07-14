library(secr)

load("data/kruger_data.RData")

# detection probability, HN form
leo.0.df.hn <- secr.fit(ch, mask = mask,
                        model=list(D~1, g0~1, sigma~1), detectfn="HN", 
                        trace = FALSE)

plot(leo.0.df.hn, xval = seq(0,12000,500), limits = TRUE)
