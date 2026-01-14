# Palette function for ggplot2 discrete scales

Palette function for ggplot2 discrete scales

## Usage

``` r
fundr_pal(palette = c("primary", "secondary", "tertiary"), direction = 1)
```

## Arguments

- palette:

  Palette name: "primary", "secondary", or "tertiary".

- direction:

  If 1, use palette order; if -1, reverse.

## Value

A function that takes `n` and returns `n` colors.
