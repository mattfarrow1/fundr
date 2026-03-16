# Working with Fiscal Years and Dates

Nonprofits typically operate on fiscal years that don’t align with the
calendar year. fundr provides comprehensive tools for working with
fiscal years, partial dates (common with birth dates), and other date
utilities.

``` r
library(fundr)
```

## Fiscal Year Functions

Most educational institutions and many nonprofits use a July 1 - June 30
fiscal year. fundr defaults to this convention.

### Basic Fiscal Year Conversion

``` r
# Key dates around fiscal year boundary
dates <- as.Date(c("2024-06-30", "2024-07-01", "2025-01-15", "2025-06-30"))

# Get the fiscal year number
fy_year(dates)
#> [1] 2024 2025 2025 2025

# Get a formatted label
fy_label(dates)
#> [1] "FY24" "FY25" "FY25" "FY25"

# Get the fiscal quarter
fy_quarter(dates)
#> [1] 4 1 3 4
```

Note that June 30, 2024 is in FY24, while July 1, 2024 starts FY25.

### Customizing the Fiscal Year Start

If your organization uses a different fiscal year, specify the starting
month:

``` r
date <- as.Date("2024-10-15")

# July start (default)
fy_year(date, fy_start_month = 7)
#> [1] 2025

# October start (federal fiscal year)
fy_year(date, fy_start_month = 10)
#> [1] 2025

# January start (calendar year)
fy_year(date, fy_start_month = 1)
#> [1] 2024
```

### Setting a Global Default

Use
[`fundr_setup()`](https://mattfarrow1.github.io/fundr/reference/fundr_setup.md)
to set your organization’s fiscal year start globally:

``` r
# Set fiscal year to start in October
fundr_setup(fy_start_month = 10)

# Now all fiscal year functions use October
fy_year(as.Date("2024-10-15"))  # Returns 2025
```

### Fiscal Year Labels

[`fy_label()`](https://mattfarrow1.github.io/fundr/reference/fy_label.md)
provides human-readable fiscal year labels:

``` r
dates <- as.Date(c("2024-08-15", "2025-02-20"))

# Default short format (FY25, FY26)
fy_label(dates)
#> [1] "FY25" "FY25"

# With custom prefix
fy_label(dates, prefix = "Fiscal ")
#> [1] "Fiscal 25" "Fiscal 25"

# Full year format
fy_label(dates, short = FALSE)
#> [1] "FY2025" "FY2025"
```

### Fiscal Quarters

[`fy_quarter()`](https://mattfarrow1.github.io/fundr/reference/fy_quarter.md)
returns the fiscal quarter (1-4):

``` r
# Sample dates throughout fiscal year 2025
dates <- as.Date(c(
  "2024-07-15",  # Q1
  "2024-10-15",  # Q2
  "2025-01-15",  # Q3
  "2025-04-15"   # Q4
))

fy_quarter(dates)
#> [1] 1 2 3 4
```

## Partial Dates

Birth dates in fundraising databases often have incomplete information -
sometimes only the year, or year and month. fundr handles these
gracefully.

### Parsing Partial Dates

``` r
# Various date formats from the portfolio
dob_samples <- c(
  "03/15/1985",      # Full date
  "March 1985",      # Month and year
  "1985",            # Year only
  "1985-03-15",      # ISO format
  "03-15-85"         # Two-digit year
)

parse_partial_date(dob_samples)
#> [1] NA           "1985-03-01" "1985-01-01" "1985-03-15" NA
```

### Date Precision

Determine what level of precision each date has:

``` r
dob_samples <- c("03/15/1985", "March 1985", "1985", NA)

date_precision(dob_samples)
#> [1] <NA>       year-month year       <NA>      
#> Levels: year year-month full
```

### Calculating Age with Partial Dates

[`calc_age_partial()`](https://mattfarrow1.github.io/fundr/reference/calc_age_partial.md)
calculates age from potentially incomplete dates:

``` r
dob_samples <- c("03/15/1985", "March 1985", "1985")

calc_age_partial(dob_samples)
#> [1] NA 41 40
```

For year-only dates, the function assumes mid-year (July 1) for the
calculation.

### Working with Portfolio DOBs

The portfolio dataset includes dates in various formats:

``` r
# Sample DOBs from the portfolio
sample_dobs <- fundr_portfolio$dob[!is.na(fundr_portfolio$dob)][1:10]
sample_dobs
#>  [1] "1950"          "1979"          "12-09-1966"    "February 1962"
#>  [5] "01/12/65"      "04/10/73"      "May 19, 1948"  "1972"         
#>  [9] "06/25/1941"    "04-20-1972"

# Parse them
parsed <- parse_partial_date(sample_dobs)
parsed
#>  [1] "1950-01-01" "1979-01-01" NA           "1962-02-01" NA          
#>  [6] NA           NA           "1972-01-01" NA           NA

# Check precision
date_precision(sample_dobs)
#>  [1] year       year       full       year-month <NA>       <NA>      
#>  [7] <NA>       year       <NA>       <NA>      
#> Levels: year year-month full
```

## Date Utilities

fundr includes several helpful date utility functions.

### Time Intervals

Calculate time between dates:

``` r
start <- as.Date("2020-01-15")
end <- as.Date("2024-06-30")

date_interval(start, end, unit = "years")
#> [1] 4.5
date_interval(start, end, unit = "months")
#> [1] 53.5
date_interval(start, end, unit = "days")
#> [1] 1628
```

### Years Since

Calculate years since a date (useful for giving recency):

``` r
last_gift_dates <- as.Date(c("2024-01-15", "2022-06-30", "2018-03-01"))

years_since(last_gift_dates)
#> [1] 2.2 3.7 8.0
```

### Recency Bucketing

Categorize dates by how recent they are:

``` r
dates <- as.Date(c("2025-12-01", "2024-06-15", "2022-01-01", "2018-06-30"))

bucket_recency(dates)
#> [1] Last year     2-4 years ago 2-4 years ago 5+ years ago 
#> 5 Levels: This year < Last year < 2-4 years ago < ... < 5+ years ago
```

### Checking Date Ranges

Test if dates fall within a specified range:

``` r
dates <- as.Date(c("2024-01-15", "2024-06-30", "2025-01-15"))

# Within last 6 months?
is_within(dates, within = 6, unit = "months")
#> [1] FALSE FALSE FALSE

# Within last 2 years?
is_within(dates, within = 2, unit = "years")
#> [1] FALSE  TRUE  TRUE
```

### Finding Weekdays

Useful for scheduling and reporting:

``` r
date <- as.Date("2025-02-28")

# What day is this?
weekday_name(date)
#> [1] "Friday"

# Find next Monday
next_weekday("Monday", as_of = date)
#> [1] "2025-03-03"

# Find last Friday
last_weekday("Friday", as_of = date)
#> [1] "2025-02-28"
```

## Practical Examples

### Fiscal Year Giving Summary

``` r
# Add fiscal year to giving data
portfolio_fy <- fundr_portfolio
portfolio_fy$last_gift_fy <- fy_year(portfolio_fy$last_gift_date)

# Count donors by fiscal year
table(portfolio_fy$last_gift_fy, useNA = "ifany")
#> 
#> 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 
#>    4    7   18   25   25   41   36   35   50   53   56   51   76   68   88   76 
#> 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 
#>   77   91  106  109  125  110  118  134  122  137  137  147  165  159  153  177 
#> 2023 2024 2025 2026 <NA> 
#>  170  180  184 3691 2999
```

### Age Distribution

``` r
# Calculate ages from DOBs
ages <- calc_age_partial(fundr_portfolio$dob)

# Summary statistics
summary(ages)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#>    21.0    44.0    54.0    54.1    64.0    95.0    6413
```

### Donor Recency Analysis

``` r
# Categorize donors by recency
recency <- bucket_recency(fundr_portfolio$last_gift_date)
table(recency, useNA = "ifany")
#> recency
#>     This year     Last year 2-4 years ago 5-6 years ago  5+ years ago 
#>          3587           196           543             0          2675 
#>          <NA> 
#>          2999
```

## Summary

| Function                                                                                      | Purpose                                          |
|-----------------------------------------------------------------------------------------------|--------------------------------------------------|
| [`fy_year()`](https://mattfarrow1.github.io/fundr/reference/fy_year.md)                       | Convert date to fiscal year number               |
| [`fy_label()`](https://mattfarrow1.github.io/fundr/reference/fy_label.md)                     | Convert date to fiscal year label (e.g., “FY25”) |
| [`fy_quarter()`](https://mattfarrow1.github.io/fundr/reference/fy_quarter.md)                 | Get fiscal quarter (1-4)                         |
| [`parse_partial_date()`](https://mattfarrow1.github.io/fundr/reference/parse_partial_date.md) | Parse dates with varying precision               |
| [`date_precision()`](https://mattfarrow1.github.io/fundr/reference/date_precision.md)         | Determine date precision level                   |
| [`calc_age_partial()`](https://mattfarrow1.github.io/fundr/reference/calc_age_partial.md)     | Calculate age from partial dates                 |
| [`date_interval()`](https://mattfarrow1.github.io/fundr/reference/date_interval.md)           | Calculate time between dates                     |
| [`years_since()`](https://mattfarrow1.github.io/fundr/reference/years_since.md)               | Years elapsed since a date                       |
| [`bucket_recency()`](https://mattfarrow1.github.io/fundr/reference/bucket_recency.md)         | Categorize by recency                            |
| [`is_within()`](https://mattfarrow1.github.io/fundr/reference/is_within.md)                   | Check if within time range                       |
| [`last_weekday()`](https://mattfarrow1.github.io/fundr/reference/last_weekday.md)             | Find previous occurrence of weekday              |
| [`next_weekday()`](https://mattfarrow1.github.io/fundr/reference/next_weekday.md)             | Find next occurrence of weekday                  |
| [`weekday_name()`](https://mattfarrow1.github.io/fundr/reference/weekday_name.md)             | Get day of week name                             |
