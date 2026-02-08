# Calculate total years of giving

Counts the number of distinct fiscal years in which a donor gave. Useful
for loyalty metrics and donor recognition programs.

## Usage

``` r
total_giving_years(gift_dates, fy_start_month = 7L)
```

## Arguments

- gift_dates:

  Date vector of gift dates (or coercible via
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- fy_start_month:

  Integer 1-12 indicating fiscal year start month. Default 7 (July).

## Value

Integer count of distinct fiscal years with giving.

## Examples

``` r
# Gifts in multiple years
gifts <- as.Date(c("2020-01-15", "2020-06-01", "2021-03-15",
                   "2023-09-01", "2023-12-25"))
total_giving_years(gifts)
#> [1] 3
#> 3

# Single gift
total_giving_years(as.Date("2024-01-01"))
#> [1] 1
#> 1
```
