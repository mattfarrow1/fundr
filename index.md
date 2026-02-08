# fundr

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

## Features

### Fiscal Year Helpers

Convert dates to fiscal year representations. Default fiscal year starts
in July (month 7).

``` r
library(fundr)

dates <- as.Date(c("2024-06-30", "2024-07-01"))

fy_year(dates)
#> [1] 2024 2025

fy_label(dates)
#> [1] "FY24" "FY25"

fy_quarter(dates)
#> [1] 4 1
```

### Currency Formatting

Format numbers as currency with proper thousands separators. Use compact
notation for large values.

``` r
format_currency(1234567)
#> [1] "$1,234,567"

format_currency(-500)
#> [1] "($500)"

format_currency_short(c(1500, 50000, 2500000))
#> [1] "$1.5K" "$50K" "$2.5M"

format_pct(0.4567)
#> [1] "45.7%"
```

### Donor Analytics

Classify donors based on giving history and calculate engagement
metrics.

``` r
# Donor status classification
dates <- as.Date(c("2024-09-15", "2024-03-01", "2022-01-15", NA))
donor_status(dates, as_of = as.Date("2025-01-15"))
#> [1] Active LYBUNT SYBUNT Never
#> Levels: Active < LYBUNT < SYBUNT < Lapsed < Never

# Calculate age
calc_age(as.Date("1980-06-15"), as_of = as.Date("2024-06-01"))
#> [1] 43

# Years since last gift
years_since(as.Date("2020-06-15"), as_of = as.Date("2024-06-15"))
#> [1] 4
```

### Data Normalization

Clean and standardize phone numbers and ZIP codes.

``` r
normalize_phone(c("(555) 123-4567", "555.987.6543", "1-800-555-0199"))
#> [1] "555-123-4567" "555-987-6543" "800-555-0199"

normalize_zip(c("12345-6789", "12345", "1234"))
#> [1] "12345" "12345" NA
```

### Gift Level Bucketing

Map gift amounts to categorical levels using built-in reference data.

``` r
bucket_gift_level(c(500, 5000, 50000, 1000000))
#> [1] $1-$999 $1,000-$9,999 $10,000-$99,999 $1,000,000+
```

### ggplot2 Integration

Color palettes, currency scales, and a custom theme (requires ggplot2).

``` r
library(ggplot2)

ggplot(mtcars, aes(wt, mpg)) +
geom_point() +
scale_y_currency(short = TRUE) +
theme_fundr()
```

### Additional Utilities

- **Date utilities**:
  [`date_interval()`](https://mattfarrow1.github.io/fundr/reference/date_interval.md),
  [`bucket_recency()`](https://mattfarrow1.github.io/fundr/reference/bucket_recency.md),
  [`last_weekday()`](https://mattfarrow1.github.io/fundr/reference/last_weekday.md)
- **File helpers**:
  [`latest_file()`](https://mattfarrow1.github.io/fundr/reference/latest_file.md),
  [`read_latest()`](https://mattfarrow1.github.io/fundr/reference/read_latest.md)
- **Case conversion**:
  [`to_snake_case()`](https://mattfarrow1.github.io/fundr/reference/to_snake_case.md),
  [`to_title_case()`](https://mattfarrow1.github.io/fundr/reference/to_title_case.md),
  [`convert_names()`](https://mattfarrow1.github.io/fundr/reference/convert_names.md)
- **SKY API**:
  [`sky_connect()`](https://mattfarrow1.github.io/fundr/reference/sky_connect.md),
  [`sky_get()`](https://mattfarrow1.github.io/fundr/reference/sky_get.md)
  for Blackbaud integration
- **Database helpers**:
  [`db_connect()`](https://mattfarrow1.github.io/fundr/reference/db_connect.md),
  [`db_query()`](https://mattfarrow1.github.io/fundr/reference/db_query.md)
  for SQL Server, PostgreSQL, MySQL, SQLite
