# Ensure a Google Font is available for plotting

Downloads/registers a Google Font via sysfonts and enables showtext
rendering so the font works reliably across devices.

## Usage

``` r
fundr_use_google_font(
  name = "Montserrat",
  family = "montserrat",
  enable_showtext = TRUE,
  ...
)
```

## Arguments

- name:

  Google Fonts family name (e.g., "Montserrat")

- family:

  The family name you'll reference in ggplot2 (e.g., "montserrat")

- enable_showtext:

  If TRUE, calls showtext::showtext_auto()

- ...:

  Passed to sysfonts::font_add_google() (e.g., db_cache = TRUE)

## Value

Invisibly returns the family name.

## See also

Other theme:
[`legend_bottom()`](https://mattfarrow1.github.io/fundr/reference/legend_bottom.md),
[`legend_position()`](https://mattfarrow1.github.io/fundr/reference/legend_position.md),
[`theme_fundr()`](https://mattfarrow1.github.io/fundr/reference/theme_fundr.md)

## Examples

``` r
# Load the default Montserrat font
fundr_use_google_font()

# Load a different Google Font
fundr_use_google_font("Roboto", "roboto")
```
