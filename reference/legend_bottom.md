# Move legend to bottom of plot

A convenience function that returns a theme element to place the legend
at the bottom of a ggplot. Commonly used in reports where horizontal
space is limited.

## Usage

``` r
legend_bottom(
  direction = c("horizontal", "vertical"),
  justify = c("center", "left", "right"),
  box = c("vertical", "horizontal"),
  title_position = c("top", "left", "right", "bottom")
)
```

## Arguments

- direction:

  Legend direction: "horizontal" (default) or "vertical".

- justify:

  Legend justification: "center" (default), "left", or "right".

- box:

  How to arrange multiple legends: "horizontal" or "vertical" (default).

- title_position:

  Position of legend title: "top" (default), "left", "right", or
  "bottom".

## Value

A ggplot2 theme object that can be added to a plot.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)

# Basic usage
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point() +
  legend_bottom()

# Horizontal legend with left justification
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point() +
  legend_bottom(justify = "left")
} # }
```
