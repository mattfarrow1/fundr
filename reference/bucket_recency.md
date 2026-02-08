# Bucket dates by recency

Categorizes dates into recency buckets relative to a reference date.
Supports both calendar year and fiscal year bucketing.

## Usage

``` r
bucket_recency(
  date,
  as_of = Sys.Date(),
  buckets = c(0, 1, 2, 5),
  labels = NULL,
  use_fiscal = FALSE,
  fy_start_month = 7L
)
```

## Arguments

- date:

  Date vector (or coercible via
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- as_of:

  Reference date for recency calculation. Default is today.

- buckets:

  Numeric vector of year boundaries for buckets. Default `c(0, 1, 2, 5)`
  creates buckets: "This year", "Last year", "2-5 years ago", "5+ years
  ago".

- labels:

  Character vector of bucket labels. Must be one longer than `buckets`
  to include the final "X+ years ago" label. Default NULL generates
  labels automatically.

- use_fiscal:

  Logical. If TRUE, uses fiscal year for bucketing. If FALSE (default),
  uses calendar year.

- fy_start_month:

  Integer 1-12 for fiscal year start month. Default 7 (July). Only used
  if `use_fiscal = TRUE`.

## Value

Ordered factor of recency bucket labels.

## Examples

``` r
# Calendar year buckets
dates <- as.Date(c("2024-06-15", "2023-03-01", "2020-12-25", "2015-01-01"))
bucket_recency(dates, as_of = as.Date("2024-06-15"))
#> [1] This year     Last year     2-4 years ago 5+ years ago 
#> 5 Levels: This year < Last year < 2-4 years ago < ... < 5+ years ago

# Fiscal year buckets
bucket_recency(dates, as_of = as.Date("2024-06-15"), use_fiscal = TRUE)
#> [1] This year     Last year     2-4 years ago 5+ years ago 
#> 5 Levels: This year < Last year < 2-4 years ago < ... < 5+ years ago

# Custom buckets
bucket_recency(dates, as_of = as.Date("2024-06-15"),
               buckets = c(0, 1, 3, 10),
               labels = c("Current year", "Last year", "1-3 years",
                          "3-10 years", "10+ years"))
#> [1] Current year Last year    1-3 years    1-3 years   
#> Levels: Current year < Last year < 1-3 years < 3-10 years < 10+ years
```
