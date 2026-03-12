# Get weekday name from date

Returns the day of week name for a date.

## Usage

``` r
weekday_name(date, abbreviate = FALSE)
```

## Arguments

- date:

  Date vector (or coercible via
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- abbreviate:

  Logical. If TRUE, returns abbreviated name (e.g., "Fri"). If FALSE
  (default), returns full name (e.g., "Friday").

## Value

Character vector of weekday names.

## See also

Other date-utilities:
[`bucket_recency()`](https://mattfarrow1.github.io/fundr/reference/bucket_recency.md),
[`date_interval()`](https://mattfarrow1.github.io/fundr/reference/date_interval.md),
[`is_within()`](https://mattfarrow1.github.io/fundr/reference/is_within.md),
[`last_weekday()`](https://mattfarrow1.github.io/fundr/reference/last_weekday.md),
[`next_weekday()`](https://mattfarrow1.github.io/fundr/reference/next_weekday.md)

## Examples

``` r
weekday_name(as.Date("2024-06-14"))
#> [1] "Friday"
#> "Friday"

weekday_name(as.Date("2024-06-14"), abbreviate = TRUE)
#> [1] "Fri"
#> "Fri"
```
