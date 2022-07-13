library(secr)

# read in data frame from mask text file (NOT secr at this stage)
kruger.mask_df <- read.table(file = "data/kruger_mask.txt", header = TRUE, stringsAsFactors = TRUE)

# confirm its a dataframe
class(kruger.mask_df)

# inspect first 5 rows
head(kruger.mask_df)

# check mask spacing in x and y direction
diff(sort(unique(kruger.mask_df$x))) # x
diff(sort(unique(kruger.mask_df$y))) # y

# construct mask from data frame, include spacing if known  
kruger.mask <- read.mask(data = kruger.mask_df, spacing = 1223)

# check covariates are there
names(covariates(kruger.mask))
