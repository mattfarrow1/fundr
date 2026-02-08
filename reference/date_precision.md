# Extract precision level from partial date string

Determines whether a date string represents a full date, year-month, or
year-only value. Useful for data quality assessment.

## Usage

``` r
date_precision(x)
```

## Arguments

- x:

  Character vector of date strings.

## Value

Factor with levels "year", "year-month", "full", NA for unparseable
values.

## Examples

``` r
date_precision(c("1980", "1980-06", "1980-06-15", "invalid"))
#> [1] year       year-month full       <NA>      
#> Levels: year year-month full
#> year, year-month, full, NA
```
