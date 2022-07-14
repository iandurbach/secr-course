# 
# ch = kruger.ch.count
# popn = kruger.popn
# mask = kruger.mask 
# model0 = fit0
# animalID = "92"
# contour_p = seq(0.1,0.9,0.2)
# covariate = NULL
# ggplot = FALSE

plot_ac <- function(ch, popn = NULL, mask, model0, animalID, contour_p = seq(0.1,0.9,0.2), covariate = NULL, ggplot = FALSE){
  
  animal = which(rownames(ch) == animalID)
  trueanimal = rownames(ch[,1,])[animal]
  if(!is.null(popn)) animal.ac = popn[trueanimal,] # True activity centre of this leopard
  animal.ch = subset(ch,subset=animal)
  # trapind = which(as.vector(animal.ch)>0)
  # traplocs = traps(ch)[trapind,]
  sigmahat = beta2natural(model0)["sigma","par"]
  lambda0 = beta2natural(model0)["lambda0","par"]
  # d2traps = as.vector(edist(animal.ac,traps(ch)))
  # closetraps = (d2traps<3*sigmahat)
  # d2traps = d2traps[closetraps]
  # captfreq = ch[animal,1,closetraps]
  
  xlim = range(traps(ch)$x) #[closetraps,]$x)
  ylim = range(traps(ch)$y) #[closetraps,]$y)
  
  trapind = which(as.vector(animal.ch)>0)
  traplocs = traps(ch)[trapind,]
  
  gg = NULL
  poly <- data.frame(x = as.numeric(), y = as.numeric())
  if(ggplot){
    
    cnt <- fxi.contour(model0, animal, SPDF = FALSE, plt = FALSE, nx=300, border = 5 * sigmahat, p = contour_p, drawlabels = FALSE)
    df <- data.frame(contour = names(cnt[[1]])[1], x = cnt[[1]][[1]]$x, y = cnt[[1]][[1]]$y)
    for(i in 2:length(cnt[[1]])){
      df <- rbind(df, data.frame(contour = names(cnt[[1]])[i], x = cnt[[1]][[i]]$x, y = cnt[[1]][[i]]$y))
    }
    
    if(!is.null(popn)){
      if(any(grepl("polygon",attributes(popn)))){
        poly <- (attributes(popn)$polygon)
        poly <- poly@polygons[[1]]@Polygons[[1]]@coords
        poly <- data.frame(x = poly[,1], y = poly[,2])
      }
    }
    
    animal.ch.df <- data.frame(x = traplocs$x, y = traplocs$y, text = as.character(animal.ch[trapind]))
    
    gg <- ggplot(mask, aes(x,y)) + geom_point(pch = "+", color = "gray90", size = 2) + coord_equal() + theme_minimal() +
      geom_path(data = poly) + 
      geom_point(data = traps(ch), col="black", size = 2, pch = 3) +
      geom_path(data = df, aes(group = contour), colour = "red") +
      geom_point(data = popn[trueanimal,], color = "black", size = 3) +
      geom_point(data = animal.ch.df, size = 8, shape = 21, fill = "white") +
      geom_text(data = animal.ch.df, aes(label = text), size = 8) +
      xlim(c(min(mask$x)-5000, max(mask$x)+5000)) + ylim(c(min(mask$y)-5000, max(mask$y)+5000)) +
      theme_void() 
    
  } else {
    
    par(mai=c(0.2,0.2,0.2,0.2))
    if(is.null(covariate)){
      plot(mask$x,mask$y,xlab="",ylab="",xaxt="n",yaxt="n", pch="+",col="gray90",asp=1)
    } else plot(mask, covariate = covariate, legend = FALSE)
    #if(!is.null(attributes(popn)$polygon)) plot(attributes(popn)$polygon,add=TRUE)
    plot(traps(ch),add=TRUE,detpar=list(col="black",cex=2))
    points(traplocs$x,traplocs$y,pch=19,col="white",cex=4)
    points(traplocs$x,traplocs$y,pch=1,col="black",cex=4)
    text(traplocs$x,traplocs$y,labels=as.character(animal.ch[trapind]),cex=2)
    fxi.contour(model0,animal,add=TRUE,col="red",nx=300, border = 5 * sigmahat, p = contour_p, drawlabels = FALSE)
    points(popn[trueanimal,],col="black",pch=19,cex=1.5)
    
  }
  
  return(gg)
}

plot_detfunction <- function(model, seed = 1, nsim = 1000, nd = 200, modelname = NA){
  
  if(!(model$detectfn %in% c(0,1,14,15))) stop("Detection function not supported")
  
  sigmahat = unlist(detectpar(model))["sigma"]
  if(model$detectfn %in% c(14,15)){
    lambda0 = unlist(detectpar(model))["lambda0"]
    g0 = 1 - exp(-lambda0)
  } else if(model$detectfn %in% c(0,1)){
    g0 = unlist(detectpar(model))["g0"]
    lambda0 = -log(1 - g0)
  } 
  
  # ER HHR model
  
  # Parametric bootstrap to get encounter rate and detection function CI bounds
  mu = coefficients(model)[,1] # get the parameter estimates
  names(mu) = row.names(coefficients(model)) # give them their names
  set.seed(seed) # for reproducible results
  Sigma = model$beta.vcv # get their variance-covariance matrix
  nsim = nsim # number of Monte Carlo samples to draw
  nd = nd # number of distances for plotting
  pars = mvrnorm(nsim,mu,Sigma) # draw the Monte Carlo samples
  
  # define the encounter rate function
  lambdaHR = function(pars,d) 
    exp(pars["lambda0"])*(1-exp(-(d/exp(pars["sigma"]))^(-exp(pars["z"]))))
  lambdaHN = function(pars,d) 
    exp(pars["lambda0"])*exp(-0.5*(d/exp(pars["sigma"]))^2)
  df2lambdaHR = function(pars,d) {
    p = plogis(pars["g0"])*(1-exp(-(d/exp(pars["sigma"]))^(-exp(pars["z"]))))
    return(-log(1 - p))
  }
  df2lambdaHN = function(pars,d) {
    p = plogis(pars["g0"])*exp(-0.5*(d/exp(pars["sigma"]))^2)
    return(-log(1 - p))
  }
  
  # Calculate the point estimates of the encounter rate and associated detection function
  dmax = 5*sigmahat
  d = seq(0,dmax,length=nd)
  if(model$detectfn == 14){
    lambda.est = lambdaHN(mu,d)
    p.est = 1 - exp(-lambda.est)
  } else if (model$detectfn == 15){
    lambda.est = lambdaHR(mu,d)
    p.est = 1 - exp(-lambda.est)
  } else if (model$detectfn == 0){
    lambda.est = df2lambdaHN(mu,d)
    p.est = 1 - exp(-lambda.est)
  } else if (model$detectfn == 1){
    lambda.est = df2lambdaHR(mu,d)
    p.est = 1 - exp(-lambda.est)
  } 
  
  # Calculate the function values for each simulated set of beta parameters
  p.ests = lambda.ests = matrix(rep(NA,nd*nsim),nrow=nsim) # Variables to hold the values
  if(model$detectfn == 14){
    for(i in 1:nsim) {
      lambda.ests[i,] = lambdaHN(pars[i,],d)
      p.ests[i,] = 1 - exp(-lambda.ests[i,])
    }
  } else if (model$detectfn == 15){
    for(i in 1:nsim) {
      lambda.ests[i,] = lambdaHR(pars[i,],d)
      p.ests[i,] = 1 - exp(-lambda.ests[i,])
    }
  } else if (model$detectfn == 0){
    for(i in 1:nsim) {
      lambda.ests[i,] = df2lambdaHN(pars[i,],d)
      p.ests[i,] = 1 - exp(-lambda.ests[i,])
    }
  } else if (model$detectfn == 1){
    for(i in 1:nsim) {
      lambda.ests[i,] = df2lambdaHR(pars[i,],d)
      p.ests[i,] = 1 - exp(-lambda.ests[i,])
    }
  } 
  
  # confidence bounds pointwise over distance, of the functions
  lambda.lower = lambda.upper = p.lower = p.upper = d*0 # variables to hold the CI bounds
  for(i in 1:nd) { # loop through estimates, calculating the bounds
    lambda.lower[i] = quantile(lambda.ests[,i],probs=0.025)
    lambda.upper[i] = quantile(lambda.ests[,i],probs=0.975)
    p.lower[i] = quantile(p.ests[,i],probs=0.025)
    p.upper[i] = quantile(p.ests[,i],probs=0.975)
  }
  
  df_detfun = data.frame(d = d, d.est = p.est, d.lcl = p.lower, d.ucl = p.upper,
                         e.est = lambda.est, e.lcl = lambda.lower, e.ucl = lambda.upper, modelname = modelname)
  
  return(df_detfun)
  
}

plot_detfunction_with_covs <- function(model, seed = 1, nsim = 1000, nd = 200, modelname = NA, lambdacols = c(3), lambda_x = c(1)){
  
  if(!(model$detectfn %in% c(0,1,14,15))) stop("Detection function not supported")
  
  parnames <- row.names(coefficients(model))
  detectpart <- !grepl("^D", parnames)
  detpar <- as.list(model$fit$par[detectpart])
  detparnames <- row.names(coefficients(model))[detectpart]
  names(detpar) <- detparnames
  
  sigmahat = exp(unlist(detpar)["sigma"])
  # if(model$detectfn %in% c(14,15)){
  #   lambda0 = sum(unlist(detpar)[lambdapar])
  #   g0 = 1 - exp(-lambda0)
  # } else if(model$detectfn %in% c(0,1)){
  #   g0 = sum(unlist(detpar)[lambdapar])
  #   lambda0 = -log(1 - g0)
  # } 
  # 
  # ER HHR model
  
  # Parametric bootstrap to get encounter rate and detection function CI bounds
  mu = coefficients(model)[,1] # get the parameter estimates
  names(mu) = row.names(coefficients(model)) # give them their names
  set.seed(seed) # for reproducible results
  Sigma = model$beta.vcv # get their variance-covariance matrix
  nsim = nsim # number of Monte Carlo samples to draw
  nd = nd # number of distances for plotting
  pars = mvrnorm(nsim,mu,Sigma) # draw the Monte Carlo samples
  
  # define the encounter rate function
  lambdaHR = function(pars,d) 
    exp(sum(lambda_x * pars[lambdacols]))*(1-exp(-(d/exp(pars["sigma"]))^(-exp(pars["z"]))))
  lambdaHN = function(pars,d) 
    exp(sum(lambda_x * pars[lambdacols]))*exp(-0.5*(d/exp(pars["sigma"]))^2)
  df2lambdaHR = function(pars,d) {
    p = plogis(pars["g0"])*(1-exp(-(d/exp(pars["sigma"]))^(-exp(pars["z"]))))
    return(-log(1 - p))
  }
  df2lambdaHN = function(pars,d) {
    p = plogis(pars["g0"])*exp(-0.5*(d/exp(pars["sigma"]))^2)
    return(-log(1 - p))
  }
  
  # Calculate the point estimates of the encounter rate and associated detection function
  dmax = 5*sigmahat
  d = seq(0,dmax,length=nd)
  if(model$detectfn == 14){
    lambda.est = lambdaHN(mu,d)
    p.est = 1 - exp(-lambda.est)
  } else if (model$detectfn == 15){
    lambda.est = lambdaHR(mu,d)
    p.est = 1 - exp(-lambda.est)
  } else if (model$detectfn == 0){
    lambda.est = df2lambdaHN(mu,d)
    p.est = 1 - exp(-lambda.est)
  } else if (model$detectfn == 1){
    lambda.est = df2lambdaHR(mu,d)
    p.est = 1 - exp(-lambda.est)
  } 
  
  # Calculate the function values for each simulated set of beta parameters
  p.ests = lambda.ests = matrix(rep(NA,nd*nsim),nrow=nsim) # Variables to hold the values
  if(model$detectfn == 14){
    for(i in 1:nsim) {
      lambda.ests[i,] = lambdaHN(pars[i,],d)
      p.ests[i,] = 1 - exp(-lambda.ests[i,])
    }
  } else if (model$detectfn == 15){
    for(i in 1:nsim) {
      lambda.ests[i,] = lambdaHR(pars[i,],d)
      p.ests[i,] = 1 - exp(-lambda.ests[i,])
    }
  } else if (model$detectfn == 0){
    for(i in 1:nsim) {
      lambda.ests[i,] = df2lambdaHN(pars[i,],d)
      p.ests[i,] = 1 - exp(-lambda.ests[i,])
    }
  } else if (model$detectfn == 1){
    for(i in 1:nsim) {
      lambda.ests[i,] = df2lambdaHR(pars[i,],d)
      p.ests[i,] = 1 - exp(-lambda.ests[i,])
    }
  } 
  
  # confidence bounds pointwise over distance, of the functions
  lambda.lower = lambda.upper = p.lower = p.upper = d*0 # variables to hold the CI bounds
  for(i in 1:nd) { # loop through estimates, calculating the bounds
    lambda.lower[i] = quantile(lambda.ests[,i],probs=0.025)
    lambda.upper[i] = quantile(lambda.ests[,i],probs=0.975)
    p.lower[i] = quantile(p.ests[,i],probs=0.025)
    p.upper[i] = quantile(p.ests[,i],probs=0.975)
  }
  
  df_detfun = data.frame(d = d, d.est = p.est, d.lcl = p.lower, d.ucl = p.upper,
                         e.est = lambda.est, e.lcl = lambda.lower, e.ucl = lambda.upper, modelname = modelname)
  
  return(df_detfun)
  
}

# model = fit2
# othercovs = NULL
# mask = kruger.mask
# varyingcov = "landscape"
# n.out = 100

plot_density_covs <- function(model, mask, varyingcov, othercovs = NULL, n.out = 100){
  
  if(varyingcov == "x"){
    covariates(mask)$x <- mask$x
  }
  
  if(varyingcov == "y"){
    covariates(mask)$y <- mask$y
  }
  
  varyingcov_class <- class(covariates(mask)[,varyingcov])
  
  if(varyingcov_class == "numeric"){
    minX <- min(covariates(mask)[,varyingcov])
    maxX <- max(covariates(mask)[,varyingcov])
    val = seq(minX, maxX, length.out = n.out)    
  } else if (varyingcov_class == "factor"){
    val = levels(covariates(mask)[,varyingcov])
  } else {stop("Covariate type must be numeric or factor")}

  allcovs <- c(list(val), othercovs)
  names(allcovs) <- c(varyingcov, names(othercovs))
  
  preddf <- expand.grid(allcovs,
                        stringsAsFactors = TRUE,
                        KEEP.OUT.ATTRS = FALSE)
  
  if(varyingcov == "x"){
    temp <- predictDsurface(model, mask, cl.D = TRUE)
    Dpred <- data.frame(x = covariates(mask)$x, estimate = covariates(temp)[, "D.0"], lcl = covariates(temp)[, "lcl.0"], ucl = covariates(temp)[, "ucl.0"])
    Dpred <- distinct(Dpred)
  } else  if(varyingcov == "y"){
    temp <- predictDsurface(model, mask, cl.D = TRUE)
    Dpred <- data.frame(y = covariates(mask)$y, estimate = covariates(temp)[, "D.0"], lcl = covariates(temp)[, "lcl.0"], ucl = covariates(temp)[, "ucl.0"])
    Dpred <- distinct(Dpred)
  } else {
    Dhatlist = predict(model, newdata=preddf, realnames="D")
    Dpred <- cbind(preddf, do.call(rbind, Dhatlist)) 
  }
  
  return(Dpred)
}

# model = op.fit
# form2 = list("D~1", "g0~1", "sigma~1")
# detectfn = "HN"

openpopscr_to_scr <- function(ScrModel, ScrData, form, detectfn){
  
  if(sum(grepl("g0",names(op.fit$par()))) == 1){
    g0 <- ScrModel$get_par("g0", k = 1, j = 1)
  } else if(sum(grepl("g0",names(op.fit$par()))) == 1){
    lambda0 <- ScrModel$get_par("lambda0", k = 1, j = 1)
  } else stop("Detection function not supported")
  sig <- ScrModel$get_par("sigma", k = 1, j = 1)
  d <- ScrModel$get_par("D")
  op.to.secr <- secr.fit(ScrData$capthist(), mask=ScrData$mesh(), model=form, detectfn=detectfn,
                         start = list(g0 = g0, sigma = sig, D = d/100), method = "none")
  return(op.to.secr)
}

g0tolam0 <- function(g0) -log(1-g0)
lam0tog0 <- function(lam0) 1-exp(-lam0)
invlogit <- function(x){exp(x)/(exp(x) + 1)}
