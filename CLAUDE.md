# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Overview

fundr is an R package providing lightweight, tidyverse-compatible
utilities for fundraising and advancement analytics. The package has
minimal required dependencies (only base R for core functions) with
optional dependencies for plotting features.

## Development Commands

``` r
# Run all tests
devtools::test()

# Run a single test file
testthat::test_file("tests/testthat/test-fy_year.R")

# Check package (runs R CMD check)
devtools::check()

# Build documentation
devtools::document()

# Install package locally
devtools::install()

# Build pkgdown site
pkgdown::build_site()
```

## Architecture

### Dependency Philosophy

Core functions have zero dependencies beyond base R. Optional features
(plotting, fonts) use suggested packages and check availability at
runtime via `fundr_needs()` in `R/zzz-deps.R`. This pattern allows the
package to work in minimal environments while offering enhanced features
when packages like ggplot2, showtext, and sysfonts are installed.

### Key Modules

- **Fiscal Year Functions** (`R/fiscal_year.R`):
  [`fy_year()`](https://mattfarrow1.github.io/fundr/reference/fy_year.md),
  [`fy_label()`](https://mattfarrow1.github.io/fundr/reference/fy_label.md),
  [`fy_quarter()`](https://mattfarrow1.github.io/fundr/reference/fy_quarter.md) -
  Convert dates to fiscal year representations. Default fiscal year
  starts in July (month 7).

- **Data Normalization** (`R/normalize_phone.R`, `R/normalize_zip.R`):
  Clean and standardize phone numbers and ZIP codes. Both support
  strict/lenient parsing modes.

- **Plotting** (`R/theme_fundr.R`, `R/fonts.R`): ggplot2 theme and
  Google Fonts integration. These require suggested packages (ggplot2,
  showtext, sysfonts).

### Testing

Tests use testthat (edition 3). Test files mirror the structure of `R/`
files in `tests/testthat/`.
