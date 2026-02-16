# Find next occurrence of a weekday

Returns the next date that falls on a specific day of the week.

## Usage

``` r
next_weekday(weekday, as_of = Sys.Date(), include_today = TRUE)
```

## Arguments

- weekday:

  Day of week: name (e.g., "Monday", "mon"), or number (1 = Sunday
  through 7 = Saturday).

- as_of:

  Reference date. Default is today.

- include_today:

  Logical. If TRUE (default) and `as_of` falls on the target weekday,
  returns `as_of`. If FALSE, returns the next occurrence.

## Value

Date of the next occurrence of the specified weekday.

## Examples

``` r
# Find next Monday
next_weekday("Monday")
#> [1] "2026-02-16"

# From a specific date
next_weekday("Monday", as_of = as.Date("2024-06-14"))
#> [1] "2024-06-17"
#> "2024-06-17"
```
