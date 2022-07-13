library(secr)

# read in mask with covariates already added
kruger.mask <- read.mask(file = "kruger_mask.txt", header = TRUE, stringsAsFactors = TRUE)

# check its a mask
class(kruger.mask)

# plot the mask
plot(kruger.mask)

# check what covariates there are
names(covariates(kruger.mask))

# plot the landscape covariate
plot(kruger.mask, covariate = 'landscape', dots = FALSE)
