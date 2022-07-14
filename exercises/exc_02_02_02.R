library(secr)

load("data/kruger_data.RData")

# plots detection probabilities and CIs, but automatically transforms encounter
# rate to detection probability
plot(leo.0.df.hn, xval = xrange, limits = TRUE)
plot(leo.0.er.hn, xval = xrange, limits = TRUE)


