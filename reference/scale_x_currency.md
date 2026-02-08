# Currency scale for ggplot2 x-axis

Formats x-axis labels as currency values. See
[`scale_y_currency()`](https://mattfarrow1.github.io/fundr/reference/scale_y_currency.md)
for details on parameters.

## Usage

``` r
scale_x_currency(
  prefix = "$",
  suffix = "",
  big.mark = ",",
  decimal.mark = ".",
  digits = 0L,
  short = FALSE,
  short_digits = 1L,
  negative = c("minus", "parens"),
  ...
)
```

## Arguments

- prefix:

  Currency symbol prefix. Default "\$".

- suffix:

  Currency symbol suffix. Default "".

- big.mark:

  Thousands separator. Default ",".

- decimal.mark:

  Decimal separator. Default ".".

- digits:

  Number of decimal places. Default 0.

- short:

  Logical; if TRUE, use compact notation (K/M/B). Default FALSE.

- short_digits:

  Decimal places for compact notation. Default 1.

- negative:

  How to display negative numbers: "parens" or "minus". Default "minus".

- ...:

  Additional arguments passed to
  [`ggplot2::scale_y_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html).

## Value

A ggplot2 scale object.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)

df <- data.frame(
  revenue = c(500000, 1000000, 1500000, 2000000),
  profit = c(50000, 120000, 180000, 250000)
)

ggplot(df, aes(revenue, profit)) +
  geom_point() +
  scale_x_currency(short = TRUE) +
  scale_y_currency(short = TRUE)
} # }
```
