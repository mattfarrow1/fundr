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
