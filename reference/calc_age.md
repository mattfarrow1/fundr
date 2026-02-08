# Calculate age from birthdate

Computes age in whole years from a birthdate. Correctly handles
birthdays that haven't occurred yet in the current year.

## Usage

``` r
calc_age(birthdate, as_of = Sys.Date())
```

## Arguments

- birthdate:

  Date vector (or coercible via
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- as_of:

  Reference date for age calculation. Default is today.

## Value

Integer vector of ages in years. Returns NA for NA inputs or future
birthdates.

## Examples

``` r
# Basic usage
calc_age(as.Date("1980-06-15"))
#> [1] 45

# Age as of a specific date
calc_age(as.Date("1980-06-15"), as_of = as.Date("2020-01-01"))
#> [1] 39
#> 39

# Vectorized
birthdates <- as.Date(c("1980-01-15", "1990-06-20", "2000-12-01"))
calc_age(birthdates, as_of = as.Date("2024-06-01"))
#> [1] 44 33 23
#> 44, 33, 23
```
