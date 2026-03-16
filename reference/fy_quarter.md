# Fiscal quarter for a date

Quarters are numbered 1-4 within the fiscal year defined by
`fy_start_month`.

## Usage

``` r
fy_quarter(date, fy_start_month = getOption("fundr.fy_start_month", 7L))
```

## Arguments

- date:

  A Date (or something coercible via as.Date()).

- fy_start_month:

  Integer 1-12. Default uses `getOption("fundr.fy_start_month", 7)`.

## Value

Integer vector (1-4).

## See also

Other fiscal-year:
[`fy_label()`](https://mattfarrow1.github.io/fundr/reference/fy_label.md),
[`fy_year()`](https://mattfarrow1.github.io/fundr/reference/fy_year.md)

## Examples

``` r
# July fiscal year: Q1 starts in July
fy_quarter(as.Date("2024-07-15"))
#> [1] 1
fy_quarter(as.Date("2024-10-15"))
#> [1] 2

# Vectorized
dates <- as.Date(c("2024-07-01", "2024-10-01", "2025-01-01", "2025-04-01"))
fy_quarter(dates)
#> [1] 1 2 3 4
```
