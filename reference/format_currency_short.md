# Format currency in compact notation

Formats large currency values using K (thousands), M (millions), or B
(billions) suffixes. Useful for chart labels and summary tables where
space is limited.

## Usage

``` r
format_currency_short(
  x,
  prefix = "$",
  digits = 1L,
  threshold = 1000,
  negative = c("minus", "parens")
)
```

## Arguments

- x:

  Numeric vector to format.

- prefix:

  Currency symbol prefix. Default "\$".

- digits:

  Number of decimal places for the shortened number. Default 1.

- threshold:

  Minimum absolute value to apply shortening. Values below this are
  formatted as regular currency. Default 1000.

- negative:

  How to display negative numbers: "parens" or "minus". Default "minus"
  (more common in compact formats).

## Value

Character vector of formatted currency strings.

## Examples

``` r
format_currency_short(1500000)
#> [1] "$1.5M"
#> "$1.5M"

format_currency_short(250000)
#> [1] "$250K"
#> "$250K"

format_currency_short(500)
#> [1] "$500"
#> "$500"

format_currency_short(c(1000, 50000, 2500000, 1000000000))
#> [1] "$1K"   "$50K"  "$2.5M" "$1B"  
#> "$1K" "$50K" "$2.5M" "$1B"
```
