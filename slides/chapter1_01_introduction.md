---
type: slides
---

# Introduction to Spatial Capture-Recapture Models

Notes: Hi and welcome to the course! My name is Ian Durbach, and I'm a statistical ecologist working at the Centre for Research into Ecological and Environmental Modelling at the University of St Andrews on methods for estimating wildlife population sizes, and the factors that influence these. This course will teach you the basics of spatial capture-recapture methods and show you how you can use these to answer various questions about animal population density. 

---

# Spatial capture-recapture

<img src="footer-img.jpg" alt="This image is in /static" width="100%">

Notes: Spatial capture-recapture (SCR) models are commonly used to estimate animal abundance and distribution from surveys that use detectors at fixed locations to record the presence of marked animals at those locations, in the form of spatial capture histories. 

Detection data can be collected by camera traps, hair snares and scat surveys, live-capture traps, area searches, or acoustic detectors, with presence recorded accordingly as an image, DNA sample, animal, or audio recording. 

SCR combines a model for the spatial distribution of animal activity centers (the population model) with a model for the detection process (the detection model). SCR methods jointly estimate the parameters of these two processes. 

---

#  Population model

<p align="center">
<img src="popmodel.png" alt="This image is in /static" width="70%">
</p>

Notes: The population model is a spatial point process that quantifies expected animal activity centre density at all points in the survey region. The intensity of the point process is the density of the animal population. 

Animal activity centres are assumed to be generated by a homogenous or inhomogeneous Poisson process. A homogeneous Poisson process is one in which activity centres are uniformly distributed in space. In an inhomogeneous Poisson process the intensity varies over space, commonly as a function of spatially-varying covariates.

---

# Detection model

<img src="detmodel.png" alt="This image is in /static" width="100%">

Notes: The detection model quantifies the probability of detecting an animal, given it's activity center location and the locations of the detectors. A central feature of all SCR models is you are more likely to see an animal at a detector if it's activity center is close by. The probability of detecting an animal at a detector decreases as the distance between the animal's activity center and the detector increases. 

The detection model is a function that captures this basic relationship. There's nothing that tells us exactly what this decreasing function should look like. Like with many statistical models, progress involves two steps. First, we select some functional form to model the relationship. This is an equation with some free parameters. Second, we use some estimation routine to choose values for those free parameters that give us, in some sense, the best fit to our observed data.

A common detection function shown here is the half-normal, which is given by $g(d)=g_0\exp(-d^2/(2\sigma^2))$ and has free parameters $g_0$ and $\sigma$. But we could choose just about any function we like, so long as it is is decreasing in distance, stays positive, and has some biological plausibility. 

---

# Data needed for SCR

- Detector data
- Capture history data
- Mask data

Notes: SCR requires three basic kinds of data, each of which can have covariates attached to it. 

---

# Detector data

<img src="krugertraps.jpg" alt="This image is in /static" width="100%">

Notes: Basic detector data contains a unique identifier and spatial coordinates for each detector. Additional data can contain information on detector covariates or detector usage (where this varies between detectors).

---

# Capture history data

<p align="center">
<img src="krugerch.jpg" alt="This image is in /static" width="60%">
</p>

Notes: Capture history data is usually organised at one detection per row. Each detection records (i) an individual identifier, (ii) a detector identifier, (which must also appear in the detector data), and (iii) an occasion number (or the exact detection time for continuous-time models). Additional data can record further information on animal-specific covariates (such as weight or sex).

---

# Mask data

<img src="krugermask.jpg" alt="This image is in /static" width="100%">

Notes: Mask data (also often called a mesh, state space, or integration space) this defines the region of space that includes all possible locations for the activity centre of any individual that was detected. For computational convenience, this region is specified as a mesh of discrete points in space, although there are in reality an infinite number of points in any region. The basic data consists of spatial coordinates for each mesh point. Additional columns can record (usually spatially-varying) covariates associated with each mesh point.

---

# R package **secr** 

Model fitting:
```r
leo.0 <- secr.fit(capthist = kruger.ch, mask = kruger.mask,
    model = list(D ~ 1, g0 ~ 1, sigma ~ 1), detectfn = "HN")
```

Results:
```r
## N animals       :  64  
## N detections    :  148 
## N occasions     :  1 
## Count model     :  Poisson 
## Mask area       :  322208 ha 
## 
## Fitted (real) parameters evaluated at base levels of covariates 
##        link     estimate  SE.estimate          lcl          ucl
## D       log 4.681149e-04 6.440155e-05 3.579281e-04 6.122224e-04
## g0    logit 5.354950e-01 5.946649e-02 4.191288e-01 6.481209e-01
## sigma   log 3.664063e+03 2.396034e+02 3.223739e+03 4.164530e+03
```

Notes: This course uses the R package secr, which implements maximum likelihood estimation of a wide variety of SCR models. The secr package is *very* comprehensive, and we'll only scratch the surface. In particular there are often many ways of doing something, and we'll often just look at one, usually the one that I'm more familiar with or that I think is easier.

This slide shows how to fit a simple SCR model in secr, with the secr.fit function, and some of the results you can get from a fitted model. If you're familiar to R then various parts of this may look familar, but don't worry about the details - we will go into all this in much more detail in the sections and exercises to come. 

The first part of the results contains descriptive information about the survey and model settings -- things like number of detectors, number of detected animals, the area of the mask region, and so on.

Then comes a table of parameters. The D estimate is average animal density throughout the survey region delimited by the habitat mask - this is 4.68\times 10^{-4} animals per hectare, equivalent to 4.68 animals per 100km2. 

The g0 estimate is the estimated probability that an animal whose activity centre is at a detector is seen at least once at that detector during a survey occasion. This probability is 0.535. 

Finally, the movement parameter sigma is 3664m. There are various ways to interpret this, but one way is as an effective upper bound on how far animals range from their activity centres. Our results say that there'd be only a small chance of detecting an animal 3*sigma = 10.99km or more from it's activity centre. It's reasonable to infer that the reason for this is that animals only rarely range as far as that.

---
