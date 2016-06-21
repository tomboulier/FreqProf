# FreqProf
R package for Frequency Profiles

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/FreqProf)](http://cran.r-project.org/package=FreqProf)
[![CRAN_Downloads_Badge](http://cranlogs.r-pkg.org/badges/grand-total/FreqProf)](http://cranlogs.r-pkg.org/badges/grand-total/FreqProf)
[![Build Status](https://travis-ci.org/gitronald/FreqProf.svg?branch=master)](https://travis-ci.org/gitronald/FreqProf)

### The Frequency Profile
The frequency profile is a method for visualizing an individuals' behaviors in real time or post-hoc. This package provides tools for converting occurrence/nonoccurrence (binary) behavioral data into a frequency profile format, tools for plotting the frequency profile, and an interface for exploring frequency profiles.

![](https://i.imgur.com/9DvRzhW.png)


Frequency profiles can be customized through adjustments to three parameters: __window size__, __step size__, and __resolution__.
  
![](https://i.imgur.com/gtViBsB.jpg)

##### Window Size  
* Window size is a critically important parameter, and its optimal value will depend both on the application and the nature of the behaviors being observed.  Generally speaking, small window sizes are preferable when behavior changes frequently or when behavior occurs in short bursts, and large window sizes are preferable when behavior changes infrequently.  When scanning through an archive of behavioral data, one might increase the window size when behavior changes are infrequent and then decrease it when such changes are frequent or when one is searching for a brief behavioral event.
  
##### Step Size  
* Generally, one should also use a step size of 1; information loss is substantial with larger step sizes.

##### Resolution   
* Generally speaking, the resolution would be set to 1, which means that one is graphing the smallest possible time interval one has recorded.  This is especially important when one is observing behaviors that occur at a high frequency or when transitions from one behavior to another occur at a high frequency.  With low frequency behaviors, one would presumably lose little information by reducing resolution (that is, by collapsing one’s data into larger bins).

------

### Getting Started

``` {r}
# Install CRAN version:
install.packages("FreqProf")

# Or install Github (more recent, less stable, more fun) version:
devtools::install_github("gitronald/FreqProf")

# Load the package and data
library(FreqProf)
data(s58)
```

------

### runEx - Run interactive FreqProf example

* This package includes a user-friendly interface - using the "Shiny App" framework - allowing people with no prior R programming experience to input their data, utilize the visualization tools, explore the effects of manipulating the parameters, and download publication quality plots.

```{r}
>runEx()
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


  
```{r}
>freqprof(s58, window= round(0.25 * nrow(s58)), step = 1, resolution = 1, which= "sum")
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

### plot_freqprof - Plot frequency profiles
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


------

### 
* Generate sequence of dates 
  * Arguments: (startdate, number of dates, increment by day or week)

``` {r}
> generate_dates("2016-06-05", 31, by = "day")

```
```{r}
 [1] "2016-06-05" "2016-06-06" "2016-06-07" "2016-06-08" "2016-06-09" "2016-06-10" "2016-06-11" "2016-06-12"
 [9] "2016-06-13" "2016-06-14" "2016-06-15" "2016-06-16" "2016-06-17" "2016-06-18" "2016-06-19" "2016-06-20"
[17] "2016-06-21" "2016-06-22" "2016-06-23" "2016-06-24" "2016-06-25" "2016-06-26" "2016-06-27" "2016-06-28"
[25] "2016-06-29" "2016-06-30" "2016-07-01" "2016-07-02" "2016-07-03" "2016-07-04" "2016-07-05"

```

------

### Statistical Comparison Functions

### ks.testm - Kolmogorov-Smirnov test for multiple variable
* K-S test for multiple variables (of the same name) in separate data.frames

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

### cor.testm - Correlation test for multiple variables
* Correlation test for multiple variables (of the same name) in separate data.frames

```{r}
> cor.testm(s58, s59, method= "pearson")
```

```{r}
var cor ci.min ci.max p       stat   df       alt  method
1  V1   1      1      1 0        Inf 3090 two.sided pearson
2  V2   1      1      1 0        Inf 3090 two.sided pearson
3  V3   1      1      1 0 2637813758 3090 two.sided pearson
4  V4   1      1      1 0        Inf 3090 two.sided pearson
```
------

### Other Functions

##### Importing data
* `import_data()` - Interactive method for importing a csv, bin, or fpw file as a data.frame
* `read.bin` - Import a bin file to a data.frame
* `read.fpw` - Import a fpw file to a data.frame

##### Generating test data
* `generate_dates` - Generate a sequence of dates


Copyright American Institute for Behavioral Research and Technology (http://aibrt.org/).