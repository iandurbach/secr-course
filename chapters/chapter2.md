---
title: '2 - Modelling animal encounter rates'
description:
  'SCR models jointly model animal density and detectability. In this chapter, you will learn how to model animal encounter rates, or detectability, through the estimation of the detection or encounter rate function.'
prev: /chapter1
next: /chapter3
type: chapter
id: 2
---

<exercise id="1" title="Interpreting the detection function">

The detection function quantifies the rate at which the probability of detecting an animal at a detector decreases as the distance between the detector and the animal's activity center increases. 

In the last exercise we fit a SCR model with a half-normal detection function, which is given by $g(d)=g_0\exp(-d^2/(2\sigma^2))$ and has free parameters $g_0$ and $\sigma$. You also saw what these parameters mean. In this exercise you'll revisit that example and plot the detection function, which might make those interpretations a bit clearer.

<codeblock id="02_01">

This is a hint.

</codeblock>

</exercise>

<exercise id="2" title="Detection probability or hazard rate">

The process of detecting animals at traps can be formulated in terms of detection probability (the probability of detecting an animal at least once) or encounter rate (the number of detections during the survey). The two formulations are interchangeable, in the sense that you can get the one quantity from the other (the relationship is g0 = 1 - exp(-lambda0)). This means that in practice it should make no real difference which formulation you choose.

<codeblock id="02_02_01">

This is a hint.

</codeblock>

The `detectfn` function doesn't plot confidence intervals, so if we want those we need to use `plot` (which calls `plot.secr`) with argument `limits = TRUE`. This function automatically transforms encounter rates to detection probabilities, so you will always get probabilities on the horizontal axis, even if you are fitting an encounter rate function in `secr.fit`.

<codeblock id="02_02_02">

This is a hint.

</codeblock>

</exercise>


<exercise id="3" title="Types of detection functions">

In the previous practicals we used a detection function called the half-normal, which has free parameters `g_0` and `sigma`. But we could choose just about any function we like, so long as it is is decreasing in distance, stays positive, and has some biological plausibility. Another option, for example, is a function somewhat confusingly called the hazard rate function (because we are still modelling detection probability, not hazard rates). It is given by *g(d)=g0(1-exp(-(d/sigma)^{-z}))* and has three free parameters, `g_0`, `sigma`, and `z`. There are a few other functions that get used, but these two are the most common.

Let's fit each of these in turn 

<codeblock id="02_03">

This is a hint.

</codeblock>

We can use AIC to see which one gives the best fit to the data, adjusting for model complexity. A smaller AIC is better. We can also plot the two fitted detection functions to see how they differ. The hazard rate detection function has a flat "shelf" close to the activity centre, where detection probabilities are constant, before dropping off. That's what it needs the extra parameter for. Whether this is useful or not depends on the study species and it's environment.

</exercise>

<exercise id="4" title="Survey effort">

Sometimes not all the detectors will be fully operational for the entire survey du- ration (for example a camera trap can fail and need to be repaired). In such cases the detector data should include a usage covariate that indicates when the different detectors were operational. For traditional SCR models this covariate needs to contain the same number of columns as occasions. 

<codeblock id="02_04">

This is a hint.

</codeblock>

</exercise>

<exercise id="5" title="Adding detector covariates">

So far we have always assumed that the baseline encounter rate is constant across all detectors. In this exercise you will learn how to let the baseline encounter depend on the values of covariates at detectors. 

<codeblock id="02_05">

This is a hint.

</codeblock>

</exercise>