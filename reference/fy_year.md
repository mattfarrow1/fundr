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
