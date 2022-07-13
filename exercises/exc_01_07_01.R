library(secr)

# read in mask with covariates already added
kruger.mask <- read.mask(file = ____, header = TRUE, stringsAsFactors = TRUE)

# check its a mask
class(kruger.mask)

# plot the mask
____

# check what covariates there are
names(____)

# plot the landscape covariate
plot(____, covariate = 'landscape', dots = FALSE)
