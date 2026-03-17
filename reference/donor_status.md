# Classify donor status based on giving history

Categorizes donors based on their last gift date relative to the current
fiscal year. This is fundamental for advancement reporting and outreach
segmentation.

## Usage

``` r
donor_status(
  last_gift_date,
  as_of = Sys.Date(),
  fy_start_month = 7L,
  lapsed_years = 5L,
  sybunt_years = NULL,
  labels = NULL
)
```

## Arguments

- last_gift_date:

  Date vector of most recent gift dates (or coercible via
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)). Use NA for
  constituents who have never given.

- as_of:

  Reference date for status calculation. Default is today.

- fy_start_month:

  Integer 1-12 indicating fiscal year start month. Default 7 (July).

- lapsed_years:

  Number of fiscal years with no gifts before a donor is considered
  "Lapsed". Default 5.

- sybunt_years:

  Number of fiscal years that qualify as SYBUNT. Default is
  `lapsed_years - 1` (so SYBUNT = 2 to lapsed_years). Set to a smaller
  value to narrow the SYBUNT window (e.g., `sybunt_years = 2` means only
  2-3 years ago counts as SYBUNT).

- labels:

  Named character vector to customize status labels. Names must be the
  default labels ("Active", "LYBUNT", "SYBUNT", "Lapsed", "Never") and
  values are replacements. Partial replacement is supported.

## Value

Ordered factor with levels from most to least engaged. Default levels
are: "Active", "LYBUNT", "SYBUNT", "Lapsed", "Never".

## Details

Default status definitions:

- **Active**: Gave during the current fiscal year

- **LYBUNT**: "Last Year But Unfortunately Not This" - gave last fiscal
  year but not yet this year

- **SYBUNT**: "Some Year But Unfortunately Not This" - gave 2+ fiscal
  years ago but within the SYBUNT threshold

- **Lapsed**: Last gift was more than `lapsed_years` ago

- **Never**: No gift on record (NA last_gift_date)

## See also

Other donor-analytics:
[`calc_age()`](https://mattfarrow1.github.io/fundr/reference/calc_age.md),
[`consecutive_giving_years()`](https://mattfarrow1.github.io/fundr/reference/consecutive_giving_years.md),
[`total_giving_years()`](https://mattfarrow1.github.io/fundr/reference/total_giving_years.md),
[`years_since()`](https://mattfarrow1.github.io/fundr/reference/years_since.md)

## Examples

``` r
# Assuming today is in FY2025 (July 2024 - June 2025)
dates <- as.Date(c(
  "2024-09-15",  # Active (current FY)
  "2024-03-01",  # LYBUNT (last FY)
  "2022-01-15",  # SYBUNT (2+ years ago)
  "2018-06-01",  # Lapsed (5+ years)
  NA             # Never
))

donor_status(dates, as_of = as.Date("2025-01-15"))
#> [1] Active LYBUNT SYBUNT Lapsed Never 
#> Levels: Active < LYBUNT < SYBUNT < Lapsed < Never

# Narrower SYBUNT window (only 2-3 years counts as SYBUNT)
donor_status(dates, as_of = as.Date("2025-01-15"), sybunt_years = 2)
#> [1] Active LYBUNT SYBUNT Lapsed Never 
#> Levels: Active < LYBUNT < SYBUNT < Lapsed < Never

# Custom labels
donor_status(dates, as_of = as.Date("2025-01-15"),
             labels = c("Active" = "Current", "Never" = "Non-Donor"))
#> [1] Current   LYBUNT    SYBUNT    Lapsed    Non-Donor
#> Levels: Current < LYBUNT < SYBUNT < Lapsed < Non-Donor

# In a dplyr pipeline (using native pipe)
# donors |>
#   mutate(status = donor_status(last_gift_date))
```
