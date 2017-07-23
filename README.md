![](raster/logo-readme.png)

[![Travis-CI Build Status](https://travis-ci.org/wlandau/wildcard.svg?branch=master)](https://travis-ci.org/wlandau/wildcard)
[![codecov.io](https://codecov.io/github/wlandau/wildcard/coverage.svg?branch=master)](https://codecov.io/github/wlandau/wildcard?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/wildcard)](http://cran.r-project.org/package=wildcard)



# wildcard

The wildcard package is a templating mechanism for data frames in R. Wildcards are placeholders for text, and you can evaluate them to generate new data frames from templates. 

```r
library(wildcard)
myths <- data.frame(myth = c("Bigfoot", "UFO", "Loch Ness Monster"), 
                    claim = c("various", "day", "day"), 
                    note = c("various", "pictures", "reported day"))
myths

##                myth   claim         note
## 1           Bigfoot various      various
## 2               UFO     day     pictures
## 3 Loch Ness Monster     day reported day

wildcard(myths, wildcard = "day", values = c("today", "yesterday"))

##                myth     claim               note
## 1           Bigfoot   various            various
## 2               UFO     today           pictures
## 3               UFO yesterday           pictures
## 4 Loch Ness Monster     today     reported today
## 5 Loch Ness Monster yesterday reported yesterday
```

# Installation

First, ensure that [R](https://www.r-project.org/) is installed. To install the [latest CRAN release](https://CRAN.R-project.org/package=wildcard), run

```r
install.packages("wildcard")
```

To install the development version, get the [devtools](https://CRAN.R-project.org/package=devtools) package and then run 

```r
devtools::install_github("wlandau/wildcard", build = TRUE)
```

If you specify a tag, you can install a GitHub release.

```r
devtools::install_github("wlandau/wildcard@v1.0.1", build = TRUE)
```

# Tutorial

See the package vignette.

```r
vignette(package = "wildcard")
vignette("wildcard")
```

# Troubleshooting

You can submit questions, bug reports, and feature requests to the [issue tracker](https://github.com/wlandau/wildcard/issues). Please take care to search for duplicates first, even among the closed issues.

# Usage

Try out the following or see the [CRAN vignette](https://cran.r-project.org/web/packages/wildcard/vignettes/wildcard.html) for the output.

## `wildcard()`

```r
library(wildcard)
myths <- data.frame(myth = c("Bigfoot", "UFO", "Loch Ness Monster"), 
                    claim = c("various", "day", "day"), 
                    note = c("various", "pictures", "reported day"))
wildcard(myths, wildcard = "day", values = c("today", "yesterday"))
wildcard(myths, wildcard = "day", values = c("today", "yesterday"), expand = FALSE)
locations <- data.frame(myth = c("Bigfoot", "UFO", "Loch Ness Monster"), origin = "where")
rules <- list(where = c("North America", "various", "Scotland"), UFO = c("spaceship", "saucer"))
wildcard(locations, rules = rules, expand = c(FALSE, TRUE))
numbers <- data.frame(x = 4, y = 3, z = 4444, w = 4.434)
wildcard(numbers, wildcard = 4, values = 7)
```

## `expandrows()`

```r
df <- data.frame(ID = c("24601", "Javert", "Fantine"), 
                 fate = c("fulfillment", "confusion", "misfortune"))
expandrows(df, n = 2, type = "each")
expandrows(df, n = 2, type = "times")
```

## `nofactors()`

```r
class(iris$Species)
str(iris)
out <- nofactors(iris)
class(out$Species)
str(out)
```
