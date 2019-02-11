
<!-- README.md is generated from README.Rmd. Please edit that file -->

# strayr

<!-- badges: start -->

[![Build
Status](https://travis-ci.org/MattCowgill/strayr.svg?branch=master)](https://travis-ci.org/MattCowgill/strayr)
[![codecov
status](https://img.shields.io/codecov/c/github/mattcowgill/strayr.svg)](https://codecov.io/gh/MattCowgill/strayr)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

<!-- badges: end -->

## Overview

strayr is a simple tool to wrangle messy Australian state names and/or
abbreviations into a consistent format.

## Installation

Install from GitHub with:

``` r
# if you don't have devtools installed, first run:
# install.packages("devtools")
devtools::install_github("mattcowgill/strayr")
```

## Examples

Let’s start with a character vector that includes some misspelled State
names, some correctly spelled state names, as well as some abbreviations
both malformed and correctly formed.

``` r

x <- c("western Straya", "w. A ", "new soth wailes", "SA", "tazz", "Victoria",
       "northn territy")
```

To convert this character vector to a vector of abbreviations for State
names, simply use the `strayr()` function:

``` r
library(strayr)
strayr(x)
#> [1] "WA"  "WA"  "NSW" "SA"  "Tas" "Vic" "NT"
```

If you want full names for the states rather than abbreviations:

``` r

strayr(x, to = "state_name")
#> [1] "Western Australia"  "Western Australia"  "New South Wales"   
#> [4] "South Australia"    "Tasmania"           "Victoria"          
#> [7] "Northern Territory"
```

By default, `strayr()` uses fuzzy or approximate string matching to
match the elements in your character vector to state
names/abbreviations. If you only want to permit exact matching, you can
disable fuzzy matching. This means you will never get false matches, but
you will also fail to match misspelled state names or malformed
abbreviations; you’ll get an `NA` if no match can be found.

``` r
 strayr(x, fuzzy_match = FALSE)
#> [1] NA    NA    NA    "SA"  NA    "Vic" NA
```

If your data is in a data frame, `strayr()` works well within a
`dplyr::mutate()` call:

``` r

 x_df <- data.frame(state = x, stringsAsFactors = FALSE)

library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
 x_df %>% 
   mutate(state_abbr = strayr(state))
#>             state state_abbr
#> 1  western Straya         WA
#> 2           w. A          WA
#> 3 new soth wailes        NSW
#> 4              SA         SA
#> 5            tazz        Tas
#> 6        Victoria        Vic
#> 7  northn territy         NT
```
