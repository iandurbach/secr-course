library(secr)

# read in capture data
captures_df <- read.csv(file = "data/kruger_capthist.csv")

# inspect first five rows, note the sex covariate
names(captures_df)

# read in detector data
traps <- read.traps(file = "data/kruger_traps.txt", 
                    detector = "count",
                    trapID = "Detector",
                    covnames = c("habitat.cov", "landscape", "water", "high.water", "dist.to.water", "km.to.water"))

# make capthist object
ch <- make.capthist(captures = ____, traps = ____, covnames = ____)

# check if any errors found
verify(____)

# summarize capture history
summary(____)

# more brief summary
summary(____, terse = TRUE)