# Format numbers as currency

Converts numeric values to formatted currency strings with proper
thousands separators and configurable decimal places. Handles NA values
and negative numbers gracefully.

## Usage

``` r
format_currency(
  x,
  prefix = "$",
  suffix = "",
  digits = 0L,
  big.mark = ",",
  decimal.mark = ".",
  negative = c("parens", "minus"),
  trim = TRUE
)
```

## Arguments

- x:

  Numeric vector to format.

- prefix:

  Currency symbol prefix. Default "\$".

- suffix:

  Currency symbol suffix. Default "".

- digits:

  Number of decimal places. Default 0 (whole dollars).

- big.mark:

  Thousands separator. Default ",".

- decimal.mark:

  Decimal separator. Default ".".

- negative:

  How to display negative numbers: "parens" for (\$100), "minus" for
  -\$100. Default "parens".

- trim:

  Logical; if TRUE, trims leading whitespace. Default TRUE.

## Value

Character vector of formatted currency strings.

## Examples

``` r
# Basic usage
format_currency(1234567)
#> [1] "$1,234,567"
#> "$1,234,567"

# With decimals
format_currency(1234.567, digits = 2)
#> [1] "$1,234.57"
#> "$1,234.57"

# Negative numbers
format_currency(-500)
#> [1] "($500)"
#> "($500)"

format_currency(-500, negative = "minus")
#> [1] "-$500"
#> "-$500"

# In a dplyr pipeline (using native pipe)
# df |>
#   mutate(gift_formatted = format_currency(gift_amount))
```
