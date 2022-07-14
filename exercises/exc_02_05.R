library(secr)
library(MASS)
library(ggplot2)

source("data/more-utilities.R")
load("data/kruger_data.Rdata")

# what detector covariates do we have
names(covariates(traps(ch)))

# look at landscape covariate, a factor
table(covariates(traps(ch))[,"landscape"])

# look at dist.to.water, numeric
hist(covariates(traps(ch))[,"dist.to.water"])

# try different encounter rate models
er.hn.fit.dm0 <- secr.fit(ch, mask = mask,
                          model = list(D~1, lambda0~1, sigma~1), 
                          detectfn="HHN")

er.hn.fit.dm1 <- secr.fit(ch, mask = mask,
                          model=list(D~1, lambda0~landscape, sigma~1), 
                          detectfn="HHN", 
                          start = er.hn.fit.dm0)

er.hn.fit.dm2 <- secr.fit(ch, mask = mask,
                          model=list(D~1, lambda0~km.to.water, sigma~1), 
                          detectfn="HHN", 
                          start = er.hn.fit.dm0)

er.hn.fit.dm3 <- secr.fit(ch, mask = mask,
                          model=list(D~1, lambda0~landscape + km.to.water, sigma~1), 
                          detectfn="HHN", 
                          start = er.hn.fit.dm0)

# model comparison, which is best
AIC(er.hn.fit.dm0, er.hn.fit.dm1, er.hn.fit.dm2, er.hn.fit.dm3)

# inspect best model, look at what affects baseline encounter rate
coef(er.hn.fit.dm2)

# plot effects of detector function covariates
x1 <- plot_detfunction_with_covs(model = er.hn.fit.dm2, lambdacols = c(2,3), lambda_x = c(1,0), modelname = "0km to water")
x2 <- plot_detfunction_with_covs(model = er.hn.fit.dm2, lambdacols = c(2,3), lambda_x = c(1,2), modelname = "2km to water")
x3 <- plot_detfunction_with_covs(model = er.hn.fit.dm2, lambdacols = c(2,3), lambda_x = c(1,4), modelname = "4km to water")
x4 <- plot_detfunction_with_covs(model = er.hn.fit.dm2, lambdacols = c(2,3), lambda_x = c(1,6), modelname = "6km to water")
x_d2w <- rbind(x1, x2, x3, x4)

p2 <- ggplot(x_d2w, aes(x = d/1000, y = e.est)) + geom_line() + 
  geom_ribbon(aes(ymin = e.lcl, ymax = e.ucl), alpha = 0.2) + 
  facet_wrap(~modelname,ncol = 4) +
  xlab("Distance (km)") + ylab("Encounter rate") + theme_bw(base_size = 12) +
  theme(panel.grid = element_blank())

p2
