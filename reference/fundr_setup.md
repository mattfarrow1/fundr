# Configure R session for fundraising analytics

Sets common R options that make working with fundraising data easier,
particularly for less experienced R users. The most important setting
disables scientific notation so large dollar amounts display properly.

## Usage

``` r
fundr_setup(scipen = 999L, digits = 7L, fy_start_month = 7L, quiet = FALSE)
```

## Arguments

- scipen:

  Integer passed to `options(scipen = ...)`. Higher values make R less
  likely to use scientific notation. Default 999 effectively disables
  it. Set to 0 to restore R's default behavior.

- digits:

  Number of significant digits to display. Default 7.

- fy_start_month:

  Integer 1-12 indicating fiscal year start month. Default 7 (July). Set
  to 1 for calendar year fiscal periods. This sets the
  `fundr.fy_start_month` option.

- quiet:

  Logical; if TRUE, suppresses the startup message.

## Value

Invisibly returns a named list of the previous option values, which can
be passed to [`options()`](https://rdrr.io/r/base/options.html) to
restore them.

## Details

This function sets the following options:

- `scipen = 999`: Prevents scientific notation (e.g., displays 1000000
  instead of 1e+06)

- `digits`: Controls significant digits in output

- `fundr.fy_start_month`: Default fiscal year start month used by
  functions like
  [`fy_year()`](https://mattfarrow1.github.io/fundr/reference/fy_year.md)
  and
  [`donor_status()`](https://mattfarrow1.github.io/fundr/reference/donor_status.md)

Call `fundr_setup()` at the beginning of your script or in your
.Rprofile to ensure consistent behavior throughout your session.

## Examples

``` r
# Before setup: large numbers may show as scientific notation
format(1234567890)
#> [1] "1234567890"

# Configure session with July fiscal year (default)
old_opts <- fundr_setup()
#> fundr session configured:
#> - Scientific notation disabled (scipen = 999)
#> - Display digits: 7
#> - Fiscal year start month: 7 (July)

# Configure for calendar year fiscal periods
fundr_setup(fy_start_month = 1)
#> fundr session configured:
#> - Scientific notation disabled (scipen = 999)
#> - Display digits: 7
#> - Fiscal year start month: 1 (January)

# Now large numbers display normally
format(1234567890)
#> [1] "1234567890"

# Restore previous options if needed
options(old_opts)
```
