# Fiscal year label for a date

Fiscal year label for a date

## Usage

``` r
fy_label(
  date,
  fy_start_month = getOption("fundr.fy_start_month", 7L),
  prefix = "FY",
  short = TRUE
)
```

## Arguments

- date:

  A Date (or something coercible via as.Date()).

- fy_start_month:

  Integer 1-12. Default uses `getOption("fundr.fy_start_month", 7)`.

- prefix:

  Prefix for the label (default "FY").

- short:

  If TRUE, uses 2-digit year (e.g., "FY26"); otherwise "FY2026".

## Value

Character vector of fiscal year labels.

## See also

Other fiscal-year:
[`fy_quarter()`](https://mattfarrow1.github.io/fundr/reference/fy_quarter.md),
[`fy_year()`](https://mattfarrow1.github.io/fundr/reference/fy_year.md)

## Examples

``` r
dates <- as.Date(c("2024-06-30", "2024-07-01"))

# Default short format
fy_label(dates)
#> [1] "FY24" "FY25"

# Full year format
fy_label(dates, short = FALSE)
#> [1] "FY2024" "FY2025"

# Custom prefix
fy_label(dates, prefix = "Fiscal ")
#> [1] "Fiscal 24" "Fiscal 25"
```
