# Fiscal quarter for a date

Quarters are numbered 1-4 within the fiscal year defined by
`fy_start_month`.

## Usage

``` r
fy_quarter(date, fy_start_month = 7L)
```

## Arguments

- date:

  A Date (or something coercible via as.Date()).

- fy_start_month:

  Integer 1-12. Default 7 = July fiscal year start.

## Value

Integer vector (1-4).
