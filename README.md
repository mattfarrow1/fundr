
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fundr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- [![CRAN status](https://www.r-pkg.org/badges/version/fundr)](https://CRAN.R-project.org/package=fundr) -->
<!-- badges: end -->

The goal of `fundr` is to provide lightweight, tidyverse-compatible
utilities for fundraising and advancement analytics, with minimal
required dependencies.

## Installation

You can install the development version of fundr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mattfarrow1/fundr")
```

## Examples

### Fiscal Year Helpers

``` r
library(fundr)

dates <- as.Date(c("2024-06-30", "2024-07-01"))

fy_year(dates, fy_start_month = 7)
#> [1] 2024 2025

fy_label(dates, fy_start_month = 7)
#> [1] "FY24" "FY25"

fy_quarter(dates, fy_start_month = 7)
#> [1] 4 1
```

### Optional: Load Google Fonts for Plotting

``` r
fundr_use_google_font("Montserrat", family = "montserrat")

ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point() +
  theme_fundr()
```
