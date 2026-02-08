# Calculate time interval between dates

Computes the time difference between two dates in the specified unit.
Commonly used for calculating time since last gift, time until event, or
duration of relationships.

## Usage

``` r
date_interval(
  from,
  to = Sys.Date(),
  unit = c("years", "months", "weeks", "days"),
  digits = 1L
)
```

## Arguments

- from:

  Date vector (or coercible via
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)). The start
  date(s).

- to:

  Date vector (or coercible via
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)). The end date(s).
  Default is today.

- unit:

  Unit of time for result: "days", "weeks", "months", or "years".
  Default "years".

- digits:

  Number of decimal places to round to. Default 1. Use NULL for no
  rounding.

## Value

Numeric vector of time differences in the specified unit. Positive
values indicate `to` is after `from`. Returns NA for NA inputs.

## Details

For months and years, calculations account for varying month lengths and
leap years using calendar-based arithmetic rather than fixed day counts.

## Examples

``` r
# Days between dates
date_interval(as.Date("2024-01-01"), as.Date("2024-01-15"), unit = "days")
#> [1] 14
#> 14

# Years since a date
date_interval(as.Date("2020-06-15"), unit = "years")
#> [1] 5.7

# Months between dates
date_interval(as.Date("2024-01-15"), as.Date("2024-06-15"), unit = "months")
#> [1] 5
#> 5

# Vectorized
dates <- as.Date(c("2020-01-01", "2022-06-15", "2023-09-01"))
date_interval(dates, as.Date("2024-06-15"), unit = "years")
#> [1] 4.5 2.0 0.8

# In a dplyr pipeline (using native pipe)
# gifts |>
#   mutate(years_ago = date_interval(gift_date, unit = "years"))
```
