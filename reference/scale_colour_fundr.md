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
