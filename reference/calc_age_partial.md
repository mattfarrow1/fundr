# Calculate age from partial birthdate

Extends
[`calc_age()`](https://mattfarrow1.github.io/fundr/reference/calc_age.md)
to work with partial dates. When only year or year-month is known, uses
mid-point assumptions for more accurate age estimation.

## Usage

``` r
calc_age_partial(birthdate, as_of = Sys.Date(), assume_midpoint = TRUE)
```

## Arguments

- birthdate:

  Character, numeric, or Date vector of birthdates. Partial dates
  (year-only, year-month) are accepted.

- as_of:

  Reference date for age calculation. Default is today.

- assume_midpoint:

  Logical. If TRUE (default), assumes midpoint for missing components
  (July 1 for year-only, 15th for month-only). If FALSE, uses January 1
  and 1st respectively.

## Value

Integer vector of ages in years. Returns NA for NA inputs, unparseable
dates, or future birthdates.

## Examples

``` r
# Year only - assumes July 1 as midpoint
calc_age_partial("1980")
#> [1] 45

# Year-month - assumes 15th as midpoint
calc_age_partial("1980-06")
#> [1] 45

# Full date
calc_age_partial("1980-06-15")
#> [1] 45

# Vectorized
calc_age_partial(c("1980", "1990-06", "2000-12-25"))
#> [1] 45 35 25
```
