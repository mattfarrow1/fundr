# fundr palettes

Returns a vector of hex colors from one of the fundr palettes.

## Usage

``` r
fundr_palette(palette = c("primary", "secondary", "tertiary"))
```

## Arguments

- palette:

  Palette name: "primary", "secondary", or "tertiary".

## Value

An unnamed character vector of hex color codes.

## See also

Other colors:
[`fundr_colors()`](https://mattfarrow1.github.io/fundr/reference/fundr_colors.md),
[`fundr_pal()`](https://mattfarrow1.github.io/fundr/reference/fundr_pal.md),
[`scale_colour_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_colour_fundr.md),
[`scale_fill_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_fill_fundr.md)

## Examples

``` r
# Get the primary palette (2 colors)
fundr_palette("primary")
#> [1] "#ff0000" "#f2ebe7"

# Get the secondary palette (10 colors)
fundr_palette("secondary")
#>  [1] "#ff8d78" "#933195" "#00a8bf" "#97c2a3" "#327fef" "#8c84e3" "#ed86e0"
#>  [8] "#963ac7" "#101921" "#d0ced5"

# Get the tertiary palette (4 colors)
fundr_palette("tertiary")
#> [1] "#7d3f16" "#ed8c00" "#f2ce00" "#909b44"
```
