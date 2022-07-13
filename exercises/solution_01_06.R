library(secr)

# read in capture data
captures_df <- read.csv(file = "kruger_capthist.csv")

# inspect first five rows, note the sex covariate
names(captures_df)

# read in detector data
traps <- read.traps(file = "kruger_traps.txt", 
                    detector = "count",
                    trapID = "Detector",
                    covnames = c("habitat.cov", "landscape", "water", "high.water", "dist.to.water", "km.to.water"))

# make capthist object
ch <- make.capthist(captures = captures_df, traps = traps, covnames = "sex")

# check if any errors found
verify(ch)

# summarize capture history
summary(ch)

# more brief summary
summary(ch, terse = TRUE)
