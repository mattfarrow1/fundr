# Palette function for ggplot2 discrete scales

Creates a function that returns `n` colors from a fundr palette. Used
internally by
[`scale_fill_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_fill_fundr.md)
and
[`scale_colour_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_colour_fundr.md).

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

## See also

Other colors:
[`fundr_colors()`](https://mattfarrow1.github.io/fundr/reference/fundr_colors.md),
[`fundr_palette()`](https://mattfarrow1.github.io/fundr/reference/fundr_palette.md),
[`scale_colour_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_colour_fundr.md),
[`scale_fill_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_fill_fundr.md)

## Examples

``` r
# Create a palette function
pal <- fundr_pal("secondary")

# Get 3 colors from the palette
pal(3)
#> [1] "#ff8d78" "#933195" "#00a8bf"

# Reverse the palette direction
pal_rev <- fundr_pal("secondary", direction = -1)
pal_rev(3)
#> [1] "#d0ced5" "#101921" "#963ac7"
```
