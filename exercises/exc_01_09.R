library(secr)

# read in a RDS file containing the capthist we made before
ch <- readRDS(file = "data/kruger-ch.Rds")

# quick and dirty estimate of sigma, making a mask on the fly
qnd <- autoini(capthist = ____, mask = make.mask(traps = traps(ch), buffer = 10000, spacing = 1500))
qnd

# a reasonable buffer width is 4 * sigma
qnd$sigma * 4

# suggest.buffer can also suggest a reasonable buffer
suggest.buffer(object = ____, detectfn = "HN")

# a conservative but reasonable spacing is 0.6 sigma
qnd$sigma * 0.6
