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
  lapsed_years = 5L
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

  Number of years with no gifts before a donor is considered "Lapsed".
  Default 5.

## Value

Ordered factor with levels: "Active", "LYBUNT", "SYBUNT", "Lapsed",
"Never" (from most to least engaged).

## Details

Status definitions:

- **Active**: Gave during the current fiscal year

- **LYBUNT**: "Last Year But Unfortunately Not This" - gave last fiscal
  year but not yet this year

- **SYBUNT**: "Some Year But Unfortunately Not This" - gave 2+ fiscal
  years ago but within the lapsed threshold

- **Lapsed**: Last gift was more than `lapsed_years` ago

- **Never**: No gift on record (NA last_gift_date)

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

# In a dplyr pipeline (using native pipe)
# donors |>
#   mutate(status = donor_status(last_gift_date))
```
