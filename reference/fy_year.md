# Fiscal year for a date

Fiscal year is returned as the year in which the fiscal period ends. For
example, with a July start (fy_start_month = 7), 2024-07-01 is FY2025.
With a January start (fy_start_month = 1), fiscal year matches the
calendar year.

## Usage

``` r
fy_year(date, fy_start_month = getOption("fundr.fy_start_month", 7L))
```

## Arguments

- date:

  A Date (or something coercible via as.Date()).

- fy_start_month:

  Integer 1-12. Default uses `getOption("fundr.fy_start_month", 7)`. Set
  session default with
  [`fundr_setup()`](https://mattfarrow1.github.io/fundr/reference/fundr_setup.md)
  or
  [`set_fy_start_month()`](https://mattfarrow1.github.io/fundr/reference/set_fy_start_month.md).

## Value

Integer fiscal year (e.g., 2026).

## See also

Other fiscal-year:
[`fy_label()`](https://mattfarrow1.github.io/fundr/reference/fy_label.md),
[`fy_quarter()`](https://mattfarrow1.github.io/fundr/reference/fy_quarter.md)

## Examples

``` r
# July fiscal year start (default)
fy_year(as.Date("2024-06-30"))
#> [1] 2024
fy_year(as.Date("2024-07-01"))
#> [1] 2025

# October fiscal year start (federal)
fy_year(as.Date("2024-10-01"), fy_start_month = 10)
#> [1] 2025

# Vectorized
dates <- as.Date(c("2024-06-30", "2024-07-01", "2025-01-15"))
fy_year(dates)
#> [1] 2024 2025 2025
```
