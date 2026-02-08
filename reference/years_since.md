# Calculate years since a date

Computes the number of years (as a decimal) between a date and a
reference date. Useful for calculating time since last gift, years of
giving, or other duration metrics.

## Usage

``` r
years_since(date, as_of = Sys.Date(), digits = 1L)
```

## Arguments

- date:

  Date vector (or coercible via
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- as_of:

  Reference date. Default is today.

- digits:

  Number of decimal places to round to. Default 1. Use NULL for no
  rounding.

## Value

Numeric vector of years. Negative values indicate future dates. Returns
NA for NA inputs.

## Examples

``` r
years_since(as.Date("2020-06-15"))
#> [1] 5.7

years_since(as.Date("2020-06-15"), as_of = as.Date("2024-06-15"))
#> [1] 4
#> 4.0

# Vectorized
dates <- as.Date(c("2020-01-01", "2022-06-15", "2023-09-01"))
years_since(dates, as_of = as.Date("2024-06-15"))
#> [1] 4.5 2.0 0.8
```
