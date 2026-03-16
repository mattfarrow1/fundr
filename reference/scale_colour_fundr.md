# Discrete colour scale using fundr palettes

Discrete colour scale using fundr palettes

## Usage

``` r
scale_colour_fundr(
  palette = c("primary", "secondary", "tertiary"),
  direction = 1,
  ...
)

scale_color_fundr(
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
[`scale_fill_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_fill_fundr.md)

## Examples

``` r
library(ggplot2)

# Scatter plot with fundr colors
ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
  geom_point(size = 3) +
  scale_colour_fundr("secondary")


# US spelling also works
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  scale_color_fundr("tertiary")
```
