# Check if date is within a time period

Tests whether dates fall within a specified number of years, months, or
days from a reference date. Useful for filtering recent records.

## Usage

``` r
is_within(
  date,
  within,
  unit = c("years", "months", "weeks", "days"),
  as_of = Sys.Date()
)
```

## Arguments

- date:

  Date vector (or coercible via
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- within:

  Numeric value for the time window.

- unit:

  Unit of time: "years", "months", "weeks", or "days". Default "years".

- as_of:

  Reference date. Default is today.

## Value

Logical vector. TRUE if date is within the specified period of `as_of`
(inclusive). NA for NA inputs.

## See also

Other date-utilities:
[`bucket_recency()`](https://mattfarrow1.github.io/fundr/reference/bucket_recency.md),
[`date_interval()`](https://mattfarrow1.github.io/fundr/reference/date_interval.md),
[`last_weekday()`](https://mattfarrow1.github.io/fundr/reference/last_weekday.md),
[`next_weekday()`](https://mattfarrow1.github.io/fundr/reference/next_weekday.md),
[`weekday_name()`](https://mattfarrow1.github.io/fundr/reference/weekday_name.md)

## Examples

``` r
dates <- as.Date(c("2024-01-15", "2022-06-15", "2020-01-01"))

# Within last 2 years
is_within(dates, 2, "years", as_of = as.Date("2024-06-15"))
#> [1]  TRUE  TRUE FALSE
#> TRUE, TRUE, FALSE

# Within last 6 months
is_within(dates, 6, "months", as_of = as.Date("2024-06-15"))
#> [1]  TRUE FALSE FALSE
#> TRUE, FALSE, FALSE
```
