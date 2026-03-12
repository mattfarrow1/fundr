# Discrete fill scale using fundr palettes

Discrete fill scale using fundr palettes

## Usage

``` r
scale_fill_fundr(
  palette = c("primary", "secondary", "tertiary"),
  direction = 1,
  ...
)
```

## Arguments

- palette:

  Palette name: "primary", "secondary", or "tertiary".

- direction:

  If 1, use palette order; if -1, reverse.

- ...:

  Passed to ggplot2::discrete_scale().

## See also

Other colors:
[`fundr_colors()`](https://mattfarrow1.github.io/fundr/reference/fundr_colors.md),
[`fundr_pal()`](https://mattfarrow1.github.io/fundr/reference/fundr_pal.md),
[`fundr_palette()`](https://mattfarrow1.github.io/fundr/reference/fundr_palette.md),
[`scale_colour_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_colour_fundr.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)

# Bar chart with fundr fill colors
ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  scale_fill_fundr("secondary")

# Reverse palette direction
ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  scale_fill_fundr("tertiary", direction = -1)
} # }
```
