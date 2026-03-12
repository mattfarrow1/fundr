# fundr colors

Named hex colors used by fundr palettes.

## Usage

``` r
fundr_colors(...)
```

## Arguments

- ...:

  Optional color names to return (e.g., "teal", "magenta"). If omitted,
  returns all colors.

## Value

A named character vector of hex color codes.

## See also

Other colors:
[`fundr_pal()`](https://mattfarrow1.github.io/fundr/reference/fundr_pal.md),
[`fundr_palette()`](https://mattfarrow1.github.io/fundr/reference/fundr_palette.md),
[`scale_colour_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_colour_fundr.md),
[`scale_fill_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_fill_fundr.md)

## Examples

``` r
# Get all available colors
fundr_colors()
#>         red       white       peach     magenta        teal        aqua 
#>   "#ff0000"   "#f2ebe7"   "#ff8d78"   "#933195"   "#00a8bf"   "#97c2a3" 
#> bright blue      violet        pink      purple       black        gray 
#>   "#327fef"   "#8c84e3"   "#ed86e0"   "#963ac7"   "#101921"   "#d0ced5" 
#>       brown      orange      yellow       green 
#>   "#7d3f16"   "#ed8c00"   "#f2ce00"   "#909b44" 

# Get specific colors by name
fundr_colors("teal", "magenta")
#>      teal   magenta 
#> "#00a8bf" "#933195" 

# Use in base R plotting
barplot(1:3, col = fundr_colors("teal", "peach", "purple"))

```
