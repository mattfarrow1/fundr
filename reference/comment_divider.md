# Format text as a section divider

Creates a visual divider line for separating code sections.

## Usage

``` r
comment_divider(char = "=", width = 80L)
```

## Arguments

- char:

  Character to use for the divider. Default "=".

- width:

  Total width of the divider. Default 80.

## Value

Character string formatted as a divider.

## Examples

``` r
cat(comment_divider())
#> # ==============================================================================
# # ========================================================================
```
