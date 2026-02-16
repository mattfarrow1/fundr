# Find most recent occurrence of a weekday

Returns the most recent date that falls on a specific day of the week.
Useful for finding dates like "last Friday" for file naming when
databases refresh on specific days.

## Usage

``` r
last_weekday(weekday, as_of = Sys.Date(), include_today = TRUE)
```

## Arguments

- weekday:

  Day of week: name (e.g., "Friday", "fri"), or number (1 = Sunday
  through 7 = Saturday, following R's convention).

- as_of:

  Reference date. Default is today.

- include_today:

  Logical. If TRUE (default) and `as_of` falls on the target weekday,
  returns `as_of`. If FALSE, returns the previous occurrence.

## Value

Date of the most recent occurrence of the specified weekday.

## Examples

``` r
# Find last Friday
last_weekday("Friday")
#> [1] "2026-02-13"

# Using abbreviation
last_weekday("fri")
#> [1] "2026-02-13"

# Using number (6 = Friday)
last_weekday(6)
#> [1] "2026-02-13"

# From a specific date
last_weekday("Friday", as_of = as.Date("2024-06-15"))
#> [1] "2024-06-14"
#> "2024-06-14"

# Exclude today even if it matches
last_weekday("Friday", as_of = as.Date("2024-06-14"),
             include_today = FALSE)
#> [1] "2024-06-07"
#> "2024-06-07"
```
