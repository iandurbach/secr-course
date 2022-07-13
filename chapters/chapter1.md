---
title: '1 - Introduction to Spatial Capture-Recapture Models'
description:
  'In this chapter you will learn how to fit a simple spatial capture-recapture (SCR) models to estimate animal abundance, using the secr package.'
prev: null
next: /chapter2
type: chapter
id: 1
---

<exercise id="1" title="Introduction" type="slides">

<slides source="chapter1_01_introduction">
</slides>

</exercise>

<exercise id="2" title="Reading detector data from a trapfile">

In these two exercises you will learn how to read in information about detectors from a *trapfile*. A trapfile is a text file that contains all detector information (always locations, and possibly covariates and effort/usage) and is in the format that `secr` wants. Of course this means that you need to prepare the trapfile beforehand. We'll also inspect and summarize the objects we create.

First let's look at a simple case where the trapfile contains only detector locations:

**Instructions**

Use the information below to read in the trapfile:
- The name of the trapfile is `kruger_traps_xy.txt`,
- The detector is a "count" detector (more on this later),
- Detector IDs are stored in a column called `Detector`,

<codeblock id="01_02_01">

This is a hint.

</codeblock>

Now let's see what happens when the trapfile also contains detector covariates:

**Instructions**

Use the information below to read in the trapfile:

- The name of the trapfile is `kruger_traps.txt`,
- Detector IDs are stored in a column called `Detector`,
- The detector is a "count" detector,
- There are 6 detector covariates, and these are in columns called `habitat.cov`, `landscape`, `water`, `high.water`, `dist.to.water`, and `km.to.water`.

<codeblock id="01_02_02">

This is a hint.

</codeblock>

</exercise>

<exercise id="3" title="Reading detector data from a dataframe">

Another way of reading in information about detectors is from a dataframe. The benefit of this way is that you don't need to go to the trouble of preparing the trapfile. If detector information is provided to you in csv format, for example, you just read it in, do any preprocessing you need directly in R, and then convert the dataframe to a traps object. This exercise shows you how to do this.

**Instructions**

- First read in the detector locations, which stored in a csv file called `kruger_traps_xy.csv`,
- Confirm that this is a dataframe using the `class` function, and have a look at the first 5 rows,
- Read in the detector information using `read.traps`. Note the change from the `file` option to `data` (since we are no longer reading in an external file).

<codeblock id="01_03_01">

This is a hint.

</codeblock>

A drawback to reading in detector data this way is that covariates are not currently supported. The exercise below shows you the problem. Run through the code and confirm that even though we tell `read.traps` that there are covariates, these are ignored. We'll need to manually add covariates -- covered the next section!

<codeblock id="01_03_02">

This is a hint.

</codeblock>

</exercise>

<exercise id="4" title="Adding detector covariates">

In this exercise you'll see how to add covariates to an existing traps object using the `covariates` function. This function can be also used to extract and replace covariate values.

**Instructions**

- Add a covariate called `CamTypeUsed` that contains the type of camera used,
- Confirm the covariate is indeed stored as part of the traps object.

<codeblock id="01_04">

This is a hint.

</codeblock>

</exercise>

<exercise id="5" title="Adding detector covariates from a spatial data source">

The previous exercise showed you how to add covariates if you already knew the values of these covariates at each detector. Often though, you might only have a spatial data source that covers the study area (like a raster or shape file), and you want to add detector covariates by "looking up" the value of the spatial covariate(s) at each detector. There are some very useful tools to help you do this built into `secr`. 

In this exercise you'll learn how to add the detector covariates from various kinds of spatial data sources using the `addCovariates` function.

**Instructions**
- Add the *habitat* covariate, which is stored in a raster called `habitat.tif`, by reading in the raster and then passing it to the `addCovariates` function using the `spatialdata` argument.
- Add the *landscape* covariate, which is stored in a `sf` dataframe saved in the file `landscape.Rds`, in much the same way as for *habitat*: read in the spatial data, and then pass it to the `addCovariates` function using the `spatialdata` argument. 
- All covariates related to water (*water*, *high.water*, *dist.to.water*, and *km.to.water*) are stored as layer in a shape file called `watervariables.shp`. Covariates in a shape file can be added directly by using the **filename** as the `spatialdata` argument, without needing to read in the data first. Add these covariates.
- Make a histogram summarizing the distance to water at detector locations.

<codeblock id="01_05">

This is a hint.

</codeblock>

</exercise>

<exercise id="6" title="Reading capture history data">

In `secr`, capture histories get stored as `capthist` objects. Somewhat confusingly, a "capture history" object has two components: (1) the capture data recording which animals were seen at each detector, and (2) detector data, in the form of a `traps` object like we have been working with. It's helpful to distinguish between capture **data** (just the detections) and capture **histories** (the detections, plus the detector data). 

In this exercise you will learn how to construct capture histories using the `make.capthist` function. This function has two main arguments, each reading in one of the components of a capture history:
- `captures`: a dataframe of capture records,
- `traps`: an object of class `traps` containing detector information

The dataframe of capture records can be in two possible formats. In "XY" format each detection records the x- and y-coordinates where the detection was made. In "trapID" format each detection records the ID or name of the detector where the detection was made. The format is specified using the `fmt` option. "XY" format is useful when sampling is by line transect or area searches, but for static detectors like camera traps the two formats are equivalent, and we stick with the slightly simpler "trapID" format.

**Instructions**
- Make a *capthist* object by passing in the necessary inputs to `make.capthist`.
- Confirm the class of the object you created, verify that there are no (obvious) errors, and summarize the capture history.

<codeblock id="01_06">

This is a hint.

</codeblock>

</exercise>

<exercise id="7" title="Reading mask data from a file or dataframe">

In the next few sections we'll look at different ways of reading in and manipulating a mask, also called a mesh, state space, or integration space. 

In `secr`, a mask is just a regular grid of points that defines the region of space that includes all possible locations for the activity center of any individual that could have been detected. The two main choices we need to make are (a) how big does our mask need to be before we can say there is extremely little chance of detecting an animal with an activity center beyond the mask? (b) how far apart should mask points be spaced? 

Conceptually, mask data is a bit trickier than detector data or capture data, because whereas the last two have an clear "existence" out there in the real world -- real cameras, real animals -- the mask is just something that we need in order to do the numerical calculations we need to do to fit the SCR model. There's no objective correct or best mask. Bigger, finer masks give better approximations to the SCR likelihood, but are slow (sometimes much slower) to run.

That's conceptually. Practically, reading in and manipulating mask data works in much the same way as we saw for detector data. Masks can be read in from a text file or created from a dataframe, and covariates can be added directly, or from a spatial data source.

Let's first look at how to read in mask data from a text file.

**Instructions**

Use the information below to read in the mask data:
- Mask data is stored in `kruger_mask.txt`. Read this data in using the `file` argument of the `read.mask` function.
- Note that `header = TRUE` to indicate the first row contains variable names, and `stringAsFactors = TRUE` so that any categorical covariates are read in as factors.
- Plot the mask.
- Check if there are any mask covariates.
- Plot the `landscape` covariate.

<codeblock id="01_07_01">

This is a hint.

</codeblock>

Now we'll look at turning a dataframe into a mask.

**Instructions**

- Use `read.table` to read in the mask data stored in `kruger_mask.txt`. Again, set `header = TRUE` and `stringAsFactors = TRUE`. This creates a dataframe.
- (Optional) Work out the spacing between mask points in x and y directions.
- Construct the mask from the dataframe, using the `data` argument (similar to what was done for detectors). Include the spacing if known, otherwise remove this option and `secr` will work it out for you (this slows things down, sometimes a lot). 
- Confirm that mask covariates have been retained (unlike what happened for detector data).

<codeblock id="01_07_02">

This is a hint.

</codeblock>


</exercise>

<exercise id="8" title="Making mask data from a traps object">

Yet another way to make a mask is by adding some kind of buffer region around detectors. This is different to anything we saw for detector data, and the rationale behind it is that, as mentioned before, the mask should contain all activity center locations that are close enough to detectors that the chance of detection is non-negligible. Thus it makes sense that the mask is dependent on detectors locations in some way.

In this exercise you'll learn how to construct a mask from detector locations using the `make.mask` function.

**Instructions**

- Construct a mask from the traps object created in the first few lines of code. Set the buffer width to 10000, the mask spacing to 1500 (more on this in the next exercise), and the buffer type to "trapbuffer". 
- Plot the mask as well as the detectors.
- Construct a mask from the traps object. Keep the buffer and spacing as before, but set the buffer type to "traprect".
- Plot the mask as well as the detectors.
- Can you see what the difference between the "trapbuffer" and "traprect" masks are? There are other buffering options too, see `?make.mask` for details.

<codeblock id="01_08">

This is a hint.

</codeblock>

</exercise>

<exercise id="9" title="Choosing a mask buffer width and spacing">

With some experience it is usually possible to choose reasonable buffer widths and mask spacing with using an understanding of the species being studied and the principles of SCR. But there are some helper functions provided by `secr` to assist with these choices if needed, and in this exercise you'll learn about them.

Buffer widths should be large enough that animals with activity centers off the mask have a negligible probability of detection. The exact buffer used will depend on the spatial scale of detection, and therefore the spatial scale of animal movement. Using a large buffer is advised, but a very large buffer will slow down model fitting (the number of mask points increases roughly quadratically with buffer width). A rough rule of thumb sometimes advised is 4 times the `sigma` parameter of the detection function. 

The `autoini` function provides "a quick and dirty" (in the words of the secr documentation) estimate of sigma that doesn't require any model fitting or prior knowledge, but tends to underestimate sigma (again, according to secr documentation). The `suggest.buffer` is a function that uses a slightly more involved calculation to provide a suggested buffer width given a capture history and a detection function. 

The number of mask points increases as mask spacing decreases. Mask spacing that is too large will result in a poor approximation of the SCR likelihood, while mask spacing that is too small slows down model fitting. Simulation experiments (reported in the secr documentation) suggest that results are reasonably robust to the choice of mask spacing, so long as this is less than 1 sigma. A conservative guideline is to use a mask spacing around 0.6 sigma. Again, `autoini` can be used to work out what value this is. 

**Instructions**

- Read in `kruger_ch.Rds`, which contains the `capthist` object we created in a previous exercise.
- Use `autoini` and `suggest.buffer` to assess whether the buffer width of 10,000 used in the previous exercise was reasonable.
- Use `autoini` to assess whether the mask spacing of 1,500 used in the previous exercise was reasonable.

<codeblock id="01_09">

This is a hint.

</codeblock>

</exercise>

<exercise id="10" title="Adding covariates to a mask">

Masks covariates can be added in exactly the same way as we did earlier for detector covariates: either directly using `covariates`, or from a spatial data source using `addCovariates`. In this exercise you'll use both these functions to add covariates to a mask.

**Instructions**
- Add the *habitat* covariate directly, using the covariate values stored in the `kruger.mask_df` dataframe. 
- Add the *landscape* covariate, which is stored in a `sf` dataframe saved in the file `landscape.Rds`.  
- Add the four covariates related to water (*water*, *high.water*, *dist.to.water*, and *km.to.water*), which are stored as layers in a shape file called `watervariables.shp`. 
- Make a histogram summarizing the distance to water at mask points.

<codeblock id="01_10">

This is a hint.

</codeblock>

</exercise>

<exercise id="11" title="Fitting a model, finally!">

In `secr` SCR models are fit with the `secr.fit` function. In this exercise you'll use `secr.fit` to fit a very simple model, one that assumes that animal density is constant across the survey region and that the only factor that affects detection probability is distance from activity center. 

Previously you saw how to read in or make the three data inputs to the SCR model: detector data, capture histories, and a mask. To avoid having to construct these each time, these have been saved in the file `kruger_data.RData`. 

**Instructions**
The first part of the code below summarizes and plots the various SCR inputs. It's always a good idea to do this to check everything seems reasonable before starting with model fitting. 

Then, fit the SCR model by completing these four arguments to `secr.fit`:

- `capthist`, a capthist object that includes the capture data and detector layout. Here this is in the object called `ch`.
- `mask`, a mask object that contains the study region and any habitat covariates. This is in the object called `mask`.
- `detectfn`, a code or string that tells `secr` which detection or encounter rate function to use. Use a half-normal detection function by specifying option `"HN"`.
- `model`, a list of formulae specifying how the various components of the SECR model are to be modelled. These use regular syntax for formulae in R, for example `y~x` specifies that `y` is modeled as a linear function of `x`. Here there are three parameters: animal density `D`, and the two parameters of the half-normal detection function `g0` and `sigma`, all of which are modelled as constant.

Once you've fitted the model, inspect the output provided by the functions `coef`, which provides model estimates on the link scale, `predict`, which provides estimates on the natural scale, and `region.N`, which estimates abundance over the mask.

<codeblock id="01_11">

This is a hint.

</codeblock>

Here are a few questions to test your understanding. 

1 - What is the mean density of leopards per 100km<sup>2</sup>?

<choice>
<opt text="-7.669">

This is the mean density on the link scale. You need to backtransform from the link (log) scale.

</opt>

<opt text="4.68 * 10<sup>-4</sup>">

This is the mean density per hectare, the default in `secr`.

</opt>

<opt text="4.68" correct="true">

</opt>

</choice>

2 - How would you interpret the estimate `g0=0.535`?

<choice>
<opt text="Leopards have on average a 53.5% chance of being detected at least once during the survey.">

This is "pdot", not "g0". 

</opt>

<opt text="There is a 53.5% chance of detecting a leopard with an activity centre at a detector at least once during the survey." correct="true">

The `g0` parameter is the detection probability for an animal whose activity centre is *at a distance of zero* from a detector.

</opt>

<opt text="A leopard with an activity centre at a detector is expected to be detected 0.535 times during the survey.">

This is the interpretation of the baseline hazard (or encounter) rate. It's only valid if we fit a encounter rate model (with `lambda0` replacing `g0` in `secr.fit`. More on this in the next chapter. 

</opt>

</choice>

3 - What is the best estimate of the number of leopards present in the survey region at the time of survey?

<choice>

<opt text="154.5" correct = "true">

This is "realised abundance": it gives the expected number of activity centers in this realisation of the Poisson process that the SCR model assumes generates activity centers.

</opt>

<opt text="150.8">

Not quite. This is "expected abundance". SCR assumes that activity centers are generated by a Poisson process - both the number of activity centers and their locations are random. Expected abundance is the average number of activity centers we would expect to get if we generated many realisations of this process (each realization representing a potential leopard population).

</opt>

<opt text="64">

This is the number of leopards detected during the survey. The number of leopards present in the survey region is almost certainly more than this, because we don't expect to detect all leopards.

</opt>

</choice>


</exercise>
