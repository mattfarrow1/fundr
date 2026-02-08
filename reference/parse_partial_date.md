# Parse partial dates (year-only or year-month)

Handles dates that are incomplete, such as birth dates that only have
year and month, or just year. Returns a Date object using sensible
defaults for missing components.

## Usage

``` r
parse_partial_date(
  x,
  day_default = 1L,
  month_default = 1L,
  year_min = 1900L,
  year_max = NULL
)
```

## Arguments

- x:

  Character or numeric vector of partial dates. Accepts formats like:

  - Year only: "1980", 1980

  - Year-month: "1980-06", "1980/06", "06/1980", "Jun 1980", "June 1980"

  - Full dates are passed through: "1980-06-15"

- day_default:

  Day to use when only year-month is provided. Default 1.

- month_default:

  Month to use when only year is provided. Default 1 (January).

- year_min:

  Minimum valid year. Default 1900. Values below this return NA.

- year_max:

  Maximum valid year. Default is current year + 1.

## Value

Date vector. Returns NA for unparseable values or years outside the
valid range.

## Examples

``` r
# Year only
parse_partial_date("1980")
#> [1] "1980-01-01"
#> "1980-01-01"

# Year-month
parse_partial_date("1980-06")
#> [1] "1980-06-01"
#> "1980-06-01"

parse_partial_date("Jun 1980")
#> [1] "1980-06-01"
#> "1980-06-01"

# Full dates pass through
parse_partial_date("1980-06-15")
#> [1] "1980-06-15"
#> "1980-06-15"

# Vectorized
parse_partial_date(c("1980", "1990-06", "2000-12-25"))
#> [1] "1980-01-01" "1990-06-01" "2000-12-25"
```
