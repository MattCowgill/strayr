
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

[![R build
status](https://github.com/mattcowgill/strayr/workflows/R-CMD-check/badge.svg)](https://github.com/mattcowgill/strayr/actions)
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

### Australian Public Holidays

This package includes the `auholidays` dataset from the [Australian
Public Holidays Dates Machine Readable
Dataset](https://data.gov.au/data/dataset/australian-holidays-machine-readable-dataset)
as well as a helper function `is_holiday`:

``` r
str(auholidays)
#> tibble [776 × 3] (S3: tbl_df/tbl/data.frame)
#>  $ Date        : Date[1:776], format: "2021-01-01" "2021-01-26" ...
#>  $ Name        : chr [1:776] "New Year's Day" "Australia Day" "Canberra Day" "Good Friday" ...
#>  $ Jurisdiction: chr [1:776] "ACT" "ACT" "ACT" "ACT" ...


is_holiday('2020-01-01')
#> [1] TRUE
is_holiday('2019-05-27', jurisdictions=c('ACT', 'TAS'))
#> [1] TRUE

h_df <- data.frame(dates = c('2020-01-01', '2020-01-10'))

h_df %>%
  mutate(IsHoliday = is_holiday(dates))
#>        dates IsHoliday
#> 1 2020-01-01      TRUE
#> 2 2020-01-10     FALSE
```
