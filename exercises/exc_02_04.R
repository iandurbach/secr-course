library(secr)

load("data/GrizzlyBear.Rdata")

# traps objects have usage attributes
tail(attr(traps(bearCH), "usage"))
tail(usage(traps(bearCH)))

# check how many occasions each detector on for
trap_effort <- usage(traps(bearCH))
apply(trap_effort, 1, sum)
# check how many detectors were on for each occasion
apply(trap_effort, 2, sum)

# usage will be automatically included by secr.fit

# fit model D ~ 1 with usage as in survey
fit0 <- secr.fit(bearCH, mask = GBmask,
                 model=list(D~1,lambda0~1,sigma~1), detectfn="HHN")

# manuall set all traps to always on and refit same model
bearCH1 <- bearCH
usage(traps(bearCH1)) <- matrix(1, nrow = 124, ncol = 4)
fit1 <- secr.fit(bearCH1, mask = GBmask, 
                 model=list(D~1,lambda0~1,sigma~1), detectfn="HHN",
                 start = fit0)

predict(fit0)
predict(fit1) 
# lower baseline encounter rate if ignore fact that traps were not always working
