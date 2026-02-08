# Move legend to a specific position

A convenience function that returns a theme element to control legend
position in ggplot2 plots.

## Usage

``` r
legend_position(
  position = c("bottom", "top", "left", "right", "none"),
  direction = NULL,
  box = c("vertical", "horizontal")
)
```

## Arguments

- position:

  Legend position: "bottom", "top", "left", "right", or "none".

- direction:

  Legend direction: "horizontal" or "vertical". Defaults to horizontal
  for bottom/top, vertical for left/right.

- box:

  How to arrange multiple legends: "horizontal" or "vertical".

## Value

A ggplot2 theme object that can be added to a plot.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)

# Legend on the right (default ggplot behavior)
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point() +
  legend_position("right")

# Remove legend
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point() +
  legend_position("none")
} # }
```
