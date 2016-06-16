# FreqProf
R package for Frequency Profiles

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/FreqProf)](http://cran.r-project.org/package=FreqProf)
[![CRAN_Downloads_Badge](http://cranlogs.r-pkg.org/badges/grand-total/FreqProf)](http://cranlogs.r-pkg.org/badges/grand-total/FreqProf)
[![Build Status](https://travis-ci.org/gitronald/FreqProf.svg?branch=master)](https://travis-ci.org/gitronald/FreqProf)

### Brief Summary
This package aims at computing and plotting frequency profiles - a method for visualizing the behavior of individuals in real time or post-hoc. It serves two functions, 1) to convert binary behavioral observation data into a frequency profile data format, and 2) to plot this data according to three paramaters. The three parameters are 1) window size, 2) step size, and 3) resolution. At one extreme, the parameters produce a cumulative record plot, at the other, they produce a barcode plot. This package includes a user-friendly interface - using the "Shiny App" framework - allowing people with no prior R programming experience to easily input their data, utilize the visualization tools, explore the effects of manipulating the parameters, and download publication quality plots. The FreqProf package also includes functions that allow the importation of data encoded in .bin, .fpw, and .csv formats.

Example frequency profile: 

![](https://i.imgur.com/9DvRzhW.png)

### Getting Started
Install the current version of the package by using `devtools::install_github("AIBRT/FreqProf")`, and then start the 
Shiny App example with `runEx()` after you've installed the package.

------
------
### generate_dates - Generate a sequence of dates
* Generate sequence of dates 
  * Arguments: (startdate, number of dates, increment by day or week)

``` {r}
>generate_dates("2016-06-05", 31, by = "day")

```
```{r}
 [1] "2016-06-05" "2016-06-06" "2016-06-07" "2016-06-08" "2016-06-09" "2016-06-10" "2016-06-11" "2016-06-12"
 [9] "2016-06-13" "2016-06-14" "2016-06-15" "2016-06-16" "2016-06-17" "2016-06-18" "2016-06-19" "2016-06-20"
[17] "2016-06-21" "2016-06-22" "2016-06-23" "2016-06-24" "2016-06-25" "2016-06-26" "2016-06-27" "2016-06-28"
[25] "2016-06-29" "2016-06-30" "2016-07-01" "2016-07-02" "2016-07-03" "2016-07-04" "2016-07-05"

```
------
### import_data - read a csv, bin, or fpw file and import it as a data.frame
* Select a file from pop up window (or specify file manually) to produce data.frame
* data.frame ready to be converted into freqprof class (see function {freqprof})
```{r}
>import_data()
```
OR
``` {r}
>import_data("inst/extdata/S58-1-1.bin")
```

```{r}
  V1 V2 V3 V4
1  1  0  0  0
2  0  0  0  0
3  0  0  0  0
4  0  0  0  0
5  0  0  0  0
6  0  0  0  0
```
------
### read.bin - Creates data.frame from a bin file
* Produces data.frame with raw data

```{r}
>read.bin("inst/extdata/S58-1-1.bin")
```

```{r}
  V1 V2 V3 V4
1  1  0  0  0
2  0  0  0  0
3  0  0  0  0
4  0  0  0  0
5  0  0  0  0
6  0  0  0  0
```
* If you have a file with extension .fpw you can use the function read.fpw

------
### ks.testm - Kolmogorov-Smirnov test for multiple variable
* K-S test for multiple variables (of the same name) in separate data.frames
  * Arguments: (data1, data2 with same variables as data1, vector with names of variables)

```{r}
> ks.testm(s58, s59, v)
```

```{r}
  vars D P
1   V1 0 1
2   V2 0 1
3   V3 0 1
4   V4 0 1
```
------
###cor.testm - Correlation test for multiple variables
* Correlation test for multiple variables (of the same name) in separate data.frames
  * Arguments: (data1, data2 with same variables as data1, correlation method spearman or pearson)

```{r}
>cor.testm(s58, s59, method= "pearson")
```

```{r}
var cor ci.min ci.max p       stat   df       alt  method
1  V1   1      1      1 0        Inf 3090 two.sided pearson
2  V2   1      1      1 0        Inf 3090 two.sided pearson
3  V3   1      1      1 0 2637813758 3090 two.sided pearson
4  V4   1      1      1 0        Inf 3090 two.sided pearson
```

------
### runEx - Run interactive FreqProf example
* Choose file and interact with frequency profile

```{r}
>runEx
```
![](https://i.imgur.com/zjvcQVn.png)
------
### freqprof - Convert data to moving sum/proportion
* Converts binary data to a list with information needed to create a frequency profile
* Arguments:
  data.behavior- data.frame with binary data 
  window- size of window as a proportion of dataset
  step- the number of bins a window advances at a time
  resolution- the time interval in which data is being recorded
  which- data as a sum or proportion

![](https://i.imgur.com/gtViBsB.jpg)
  
```{r}
>freqprof(s58, window= .25, step = 1, resolution = 1, which= "sum")
```


```{r}
$window
[1] 773

$step
[1] 1

$resolution
[1] 1

$raw.data
  V1 V2 V3 V4
1  1  0  0  0
2  0  0  0  0
3  0  0  0  0
4  0  0  0  0
5  0  0  0  0
6  0  0  0  0

$type
[1] "sum"

$data
    time panels V1 V2 V3 V4
1      0      1  0  0  0  0
2      1      1  1  0  0  0
3      2      1  1  0  0  0
4      3      1  1  0  0  0
5      4      1  1  0  0  0
6      5      1  1  0  0  0

```
------
###plot_freqprof - Plot frequency profiles
* Use plot_freqprof to plot frequency profile data generated from freqprof
* Arguments: 
  data.freqprof- data created by freqprof function
  yAxis- a string labeling the y axis
  xAxisUnits- a string indicating x-axis units, defaults to "sec"
  panel.in-if FALSE the first panel of the frequency profile, the window moving in, is not plotted
  panel.out- if FALSE the third panel of the frequency profile, the window backing out, is not plotted
  gg- if TRUE, will use ggplot2 package to plot frequency profiles
  multiPlot- if TRUE will plot each behavior in its own panel
  tick.every- spacing between plot tick marks.By default, N/30, where N is the number of time units
  label.every- label every X ticks, where X = label.every. By default, label.every = 3
```{r}
>> plot_freqprof(FPdata, gg = FALSE, multiPlot  = FALSE)
```
![](https://i.imgur.com/0nDqSD4.png)

Copyright American Institute for Behavioral Research and Technology (http://aibrt.org/).