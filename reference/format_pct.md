# Format numbers as percentages

Converts numeric values (assumed to be proportions 0-1) to formatted
percentage strings.

## Usage

``` r
format_pct(x, digits = 1L, symbol = TRUE, multiply = TRUE)
```

## Arguments

- x:

  Numeric vector to format (values between 0 and 1).

- digits:

  Number of decimal places. Default 1.

- symbol:

  Logical; if TRUE, append "%" symbol. Default TRUE.

- multiply:

  Logical; if TRUE, multiply by 100 (for proportions). If FALSE, assume
  x is already a percentage. Default TRUE.

## Value

Character vector of formatted percentage strings.

## See also

Other formatting:
[`format_currency()`](https://mattfarrow1.github.io/fundr/reference/format_currency.md),
[`format_currency_short()`](https://mattfarrow1.github.io/fundr/reference/format_currency_short.md)

## Examples

``` r
format_pct(0.4567)
#> [1] "45.7%"
#> "45.7%"

format_pct(0.4567, digits = 0)
#> [1] "46%"
#> "46%"

format_pct(45.67, multiply = FALSE)
#> [1] "45.7%"
#> "45.7%"
```
