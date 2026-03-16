# Introduction to fundr

fundr is an R package providing lightweight, tidyverse-compatible
utilities for fundraising and advancement analytics. It’s designed with
minimal dependencies while offering powerful tools for common nonprofit
data tasks. \## Installation

``` r
# Install from GitHub
# install.packages("pak")
pak::pak("mattfarrow1/fundr")
```

## Quick Start

Load the package and set up your session:

``` r
library(fundr)

# Configure session for fundraising work
fundr_setup()
#> fundr session configured:
#> - Scientific notation disabled (scipen = 999)
#> - Display digits: 7
#> - Fiscal year start month: 7 (July)
```

[`fundr_setup()`](https://mattfarrow1.github.io/fundr/reference/fundr_setup.md)
disables scientific notation so large dollar amounts display properly
(e.g., `$1,000,000` instead of `1e+06`).

## Sample Data

fundr includes `fundr_portfolio`, a synthetic dataset of 10,000
constituent records for learning and testing:

``` r
dim(fundr_portfolio)
#> [1] 10000    47
names(fundr_portfolio)[1:15]
#>  [1] "constituent_id"      "household_id"        "household_position" 
#>  [4] "record_type"         "title"               "first_name"         
#>  [7] "middle_name"         "last_name"           "suffix"             
#> [10] "nickname"            "company_name"        "gender"             
#> [13] "dob"                 "relationship_status" "address_1"
```

The dataset includes individuals (singles and married couples) and
organizations with realistic data quality variations:

``` r
table(fundr_portfolio$record_type)
#> 
#>   Individual Organization 
#>         9200          800
```

## Package Overview

### Data Cleaning

**Phone normalization** - Clean messy phone numbers:

``` r
messy_phones <- c("(214) 555-1234", "972.555.4567", "1-817-555-8901")
normalize_phone(messy_phones)
#> [1] "214-555-1234" "972-555-4567" "817-555-8901"
```

**ZIP code normalization** - Standardize postal codes:

``` r
messy_zips <- c("75201-1234", "75201 5678", " 75201 ")
normalize_zip(messy_zips)
#> [1] "75201" "75201" "75201"
```

**Case conversion** - Convert between naming conventions:

``` r
to_snake_case("FirstName")
#> [1] "first_name"
to_title_case("first_name")
#> [1] "First Name"
```

### Fiscal Year Functions

Work with fiscal years (default July start):

``` r
dates <- as.Date(c("2024-06-30", "2024-07-01", "2025-01-15"))

fy_year(dates)
#> [1] 2024 2025 2025
fy_label(dates)
#> [1] "FY24" "FY25" "FY25"
fy_quarter(dates)
#> [1] 4 1 3
```

### Donor Analytics

Classify donors by recency:

``` r
last_gifts <- as.Date(c("2025-10-15", "2024-08-01", "2023-05-20", "2020-01-01", NA))
donor_status(last_gifts)
#> [1] Active LYBUNT SYBUNT Lapsed Never 
#> Levels: Active < LYBUNT < SYBUNT < Lapsed < Never
```

Calculate constituent age:

``` r
calc_age(as.Date("1985-03-15"))
#> [1] 41
```

### Currency Formatting

Format numbers as currency:

``` r
amounts <- c(1234.56, 1500000, 25000000)

format_currency(amounts)
#> [1] "$1,235"      "$1,500,000"  "$25,000,000"
format_currency_short(amounts)
#> [1] "$1.2K" "$1.5M" "$25M"
```

### Bucketing

Categorize gifts and ratings:

``` r
gift_amounts <- c(500, 50000, 1000000)
bucket_gift_level(gift_amounts, what = "giving_level")
#> [1] $.01+       $.01+       $1,000,000+
#> 14 Levels: $150,000,000+ < $100,000,000+ < $50,000,000+ < ... < No Amount
bucket_gift_level(gift_amounts, what = "ask_bucket")
#> [1] Less than $100K Less than $100K $1M to $2.49M  
#> 14 Levels: $150M+ < $100M to $149M < $50M to $99.9M < ... < No Amount
```

### Visualization (requires ggplot2)

fundr provides a custom theme, color palettes, and currency scales:

``` r
library(ggplot2)

ggplot(data, aes(x = year, y = amount)) +
geom_col(fill = fundr_colors("teal")) +
  scale_y_currency(short = TRUE) +
  theme_fundr()
```

## Learning More

Explore the other vignettes for deeper dives:

- [`vignette("data-cleaning")`](https://mattfarrow1.github.io/fundr/articles/data-cleaning.md) -
  Phone, ZIP, and case conversion
- [`vignette("fiscal-years-dates")`](https://mattfarrow1.github.io/fundr/articles/fiscal-years-dates.md) -
  Working with dates and fiscal years
- [`vignette("donor-analytics")`](https://mattfarrow1.github.io/fundr/articles/donor-analytics.md) -
  Analyzing the portfolio dataset
- [`vignette("visualization")`](https://mattfarrow1.github.io/fundr/articles/visualization.md) -
  Themes, colors, and scales

## Convenience Operators

fundr includes helpful operators:

``` r
# "not in" operator (opposite of %in%)
c("a", "b", "c") %notin% c("b", "d")
#> [1]  TRUE FALSE  TRUE
```

And comment formatting helpers for scripts:

``` r
comment_header("Data Import")
#> [1] "# Data Import ------------------------------------------------------------------"
comment_divider()
#> [1] "# =============================================================================="
```
