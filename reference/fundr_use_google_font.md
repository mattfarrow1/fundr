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
