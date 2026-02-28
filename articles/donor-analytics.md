# Donor Analytics with fundr

This vignette demonstrates how to use fundr for common donor analytics
tasks, using the included `fundr_portfolio` dataset.

``` r
library(fundr)
fundr_setup()
#> fundr session configured:
#> - Scientific notation disabled (scipen = 999)
#> - Display digits: 7
#> - Fiscal year start month: 7 (July)
```

## The Portfolio Dataset

`fundr_portfolio` contains 10,000 synthetic constituent records:

``` r
dim(fundr_portfolio)
#> [1] 10000    47

# Record types
table(fundr_portfolio$record_type)
#> 
#>   Individual Organization 
#>         9200          800

# Donor vs non-donor
table(!is.na(fundr_portfolio$first_gift_date))
#> 
#> FALSE  TRUE 
#>  2999  7001
```

## Donor Status Classification

The
[`donor_status()`](https://mattfarrow1.github.io/fundr/reference/donor_status.md)
function classifies donors based on when they last gave:

- **Active**: Gave in the current fiscal year
- **LYBUNT**: Last Year But Unfortunately Not This (gave last FY, not
  this FY)
- **SYBUNT**: Some Year But Unfortunately Not This (gave 2 FYs ago)
- **Lapsed**: Gave more than 2 FYs ago
- **Never**: No giving history

``` r
# Classify based on last gift date
status <- donor_status(fundr_portfolio$last_gift_date)
table(status, useNA = "ifany")
#> status
#> Active LYBUNT SYBUNT Lapsed  Never 
#>   3691    184    680   2446   2999
```

### Understanding the Classification

``` r
# Sample dates to illustrate classification
sample_dates <- as.Date(c(
  "2025-10-15",  # Current FY - Active
  "2024-09-01",  # Last FY - LYBUNT
  "2023-12-15",  # Two FYs ago - SYBUNT
  "2020-06-30",  # Older - Lapsed
  NA             # No gift - Never
))

donor_status(sample_dates)
#> [1] Active LYBUNT SYBUNT Lapsed Never 
#> Levels: Active < LYBUNT < SYBUNT < Lapsed < Never
```

## Giving Analysis

### Gift Level Bucketing

Categorize gifts by amount using
[`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md):

``` r
# Sample gift amounts
gifts <- c(25, 100, 500, 1000, 5000, 25000, 100000, 1000000)

# Get giving level labels
bucket_gift_level(gifts, what = "giving_level")
#> [1] $.01+       $.01+       $.01+       $.01+       $.01+       $.01+      
#> [7] $100,000+   $1,000,000+
#> 14 Levels: $150,000,000+ < $100,000,000+ < $50,000,000+ < ... < No Amount

# Get broader buckets
bucket_gift_level(gifts, what = "ask_bucket")
#> [1] Less than $100K Less than $100K Less than $100K Less than $100K
#> [5] Less than $100K Less than $100K $100K to $249K  $1M to $2.49M  
#> 14 Levels: $150M+ < $100M to $149M < $50M to $99.9M < ... < No Amount
```

### Analyzing Portfolio Giving

``` r
# Bucket the largest gifts
fundr_portfolio$gift_level <- bucket_gift_level(
  fundr_portfolio$largest_gift_amount,
  what = "giving_level"
)

# Distribution (showing non-NA values)
gift_dist <- table(fundr_portfolio$gift_level)
gift_dist[gift_dist > 0]
#> 
#> $1,000,000+   $750,000+   $500,000+   $250,000+   $100,000+       $.01+ 
#>           3           1           5          16          52        6924
```

### Giving Summary Statistics

``` r
# Filter to donors only
donors <- fundr_portfolio[!is.na(fundr_portfolio$first_gift_date), ]

# Summary statistics
cat("Total Donors:", nrow(donors), "\n")
#> Total Donors: 7001
cat("Total Giving: $", format(sum(donors$total_giving, na.rm = TRUE), big.mark = ","), "\n")
#> Total Giving: $ 620,701,426
cat("Average Gift: $", format(mean(donors$largest_gift_amount, na.rm = TRUE), big.mark = ","), "\n")
#> Average Gift: $ 7,700.246
cat("Median Gift: $", format(median(donors$largest_gift_amount, na.rm = TRUE), big.mark = ","), "\n")
#> Median Gift: $ 1,125
```

## Prospect Analysis

### Research Ratings

The portfolio includes wealth/capacity ratings:

``` r
# Rating distribution
rating_dist <- table(fundr_portfolio$research_rating)
rating_dist
#> 
#>         A - $100M+ B - $50M to $99.9M C - $25M to $49.9M D - $10M to $24.9M 
#>                  1                  3                 11                 19 
#>   E - $5M to $9.9M F - $2.5M to $4.9M  G - $1M to $2.49M H - $500K to $999K 
#>                 52                111                187                305 
#> I - $250K to $499K J - $100K to $249K   K - $50K to $99K   L - $25K to $49K 
#>                474                849               2045               1805 
#>   M - $10K to $24K N - Less than $10K        U - Unrated 
#>               1455               1199               1484
```

### Rating Bucketing

Convert ratings to broader categories:

``` r
# Get rating buckets
fundr_portfolio$rating_bucket <- bucket_rating_level(
  fundr_portfolio$research_rating
)

table(fundr_portfolio$rating_bucket, useNA = "ifany")
#> 
#>  <NA> 
#> 10000
```

### Prospect Pipeline

Analyze the prospect pipeline:

``` r
# Prospects with assigned fundraisers
assigned <- fundr_portfolio[!is.na(fundr_portfolio$fundraiser), ]
cat("Assigned Prospects:", nrow(assigned), "\n\n")
#> Assigned Prospects: 3636

# Pipeline stages
table(assigned$prospect_status)
#> 
#>   Identification    Qualification      Cultivation     Solicitation 
#>               56              799             1156              667 
#>      Stewardship Disqualification 
#>              647               14
```

### Fundraiser Portfolios

``` r
# Prospects per fundraiser
table(fundr_portfolio$fundraiser, useNA = "ifany")
#> 
#>   Amanda Foster Christopher Lee David Rodriguez    James Wilson   Jennifer Chen 
#>             381             401             334             383             387 
#> Katherine Brown Marcus Thompson   Michael Davis Rachel Williams  Sarah Mitchell 
#>             320             378             375             337             340 
#>            <NA> 
#>            6364
```

## Currency Formatting

Use
[`format_currency()`](https://mattfarrow1.github.io/fundr/reference/format_currency.md)
and
[`format_currency_short()`](https://mattfarrow1.github.io/fundr/reference/format_currency_short.md)
for display:

``` r
amounts <- c(1234.56, 50000, 1500000, 25000000)

# Full format
format_currency(amounts)
#> [1] "$1,235"      "$50,000"     "$1,500,000"  "$25,000,000"

# Short format (K/M/B)
format_currency_short(amounts)
#> [1] "$1.2K" "$50K"  "$1.5M" "$25M"
```

### Percentage Formatting

``` r
rates <- c(0.156, 0.0234, 0.789)
format_pct(rates)
#> [1] "15.6%" "2.3%"  "78.9%"
format_pct(rates, digits = 1)
#> [1] "15.6%" "2.3%"  "78.9%"
```

## Constituent Age

Calculate ages from dates of birth:

``` r
# Using calc_age() for full dates
sample_dobs <- as.Date(c("1960-05-15", "1975-12-01", "1990-03-22"))
calc_age(sample_dobs)
#> [1] 65 50 35

# Using calc_age_partial() for varied formats (from portfolio)
sample_dobs_varied <- c("05/15/1960", "December 1975", "1990")
calc_age_partial(sample_dobs_varied)
#> [1] NA 50 35
```

### Age Distribution in Portfolio

``` r
# Calculate ages
ages <- calc_age_partial(fundr_portfolio$dob)

# Summary
summary(ages)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#>   21.00   44.00   54.00   54.05   64.00   95.00    6413

# Age buckets
age_buckets <- cut(ages,
  breaks = c(0, 30, 40, 50, 60, 70, 80, Inf),
  labels = c("Under 30", "30-39", "40-49", "50-59", "60-69", "70-79", "80+"),
  right = FALSE
)
table(age_buckets, useNA = "ifany")
#> age_buckets
#> Under 30    30-39    40-49    50-59    60-69    70-79      80+     <NA> 
#>      201      410      747      937      762      369      161     6413
```

## Giving Tenure

### Total Years Giving

``` r
# Distribution of giving tenure
table(donors$total_years_giving, useNA = "ifany")
#> 
#>   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20 
#> 193 355 375 340 389 332 348 293 267 303 303 268 230 219 224 244 207 234 218 179 
#>  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37 
#> 171 168 178 128 127 112 111  92  78  79  73  48  47  28  27  12   1
```

### Consecutive Years

``` r
# Recent donors with consecutive year streaks
recent_donors <- donors[!is.na(donors$consecutive_years_giving), ]
cat("Donors with active streaks:", nrow(recent_donors), "\n\n")
#> Donors with active streaks: 3875

# Streak distribution
table(recent_donors$consecutive_years_giving)
#> 
#>   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20 
#> 903 641 455 361 290 249 189 172 139  95  63  74  65  47  45  29  18  22  11   7
```

## Regional Analysis

The portfolio has geographic weighting toward Dallas/Fort Worth:

``` r
table(fundr_portfolio$region)
#> 
#>         Local         Texas      National International       Unknown 
#>          4992          2526          1790           499           193
```

### Giving by Region

``` r
# Average total giving by region
aggregate(total_giving ~ region, data = donors, FUN = mean, na.rm = TRUE)
#>          region total_giving
#> 1         Local     90078.73
#> 2         Texas    100897.23
#> 3      National     75724.48
#> 4 International     52271.56
#> 5       Unknown    106824.28
```

## Segmentation Example

Combine multiple attributes for donor segmentation:

``` r
# Create a high-value active donor segment
high_value_active <- fundr_portfolio[
  !is.na(fundr_portfolio$donor_status) &
  fundr_portfolio$donor_status == "Active" &
  !is.na(fundr_portfolio$largest_gift_amount) &
  fundr_portfolio$largest_gift_amount >= 10000,
]

cat("High-Value Active Donors:", nrow(high_value_active), "\n")
#> High-Value Active Donors: 449
cat("Total Giving: $", format(sum(high_value_active$total_giving, na.rm = TRUE), big.mark = ","), "\n")
#> Total Giving: $ 257,339,820
```

## Using dplyr (Optional)

If you prefer tidyverse workflows:

``` r
library(dplyr)

fundr_portfolio |>
  filter(!is.na(first_gift_date)) |>
  mutate(
    donor_status = donor_status(last_gift_date),
    gift_level = bucket_gift_level(largest_gift_amount),
    age = calc_age_partial(dob)
  ) |>
  group_by(donor_status) |>
  summarize(
    n = n(),
    total_giving = sum(total_giving, na.rm = TRUE),
    avg_age = mean(age, na.rm = TRUE)
  )
```

## Summary

| Function                                                                                                  | Purpose                        |
|-----------------------------------------------------------------------------------------------------------|--------------------------------|
| [`donor_status()`](https://mattfarrow1.github.io/fundr/reference/donor_status.md)                         | Classify donors by recency     |
| [`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md)               | Categorize gift amounts        |
| [`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md)           | Categorize wealth ratings      |
| [`calc_age()`](https://mattfarrow1.github.io/fundr/reference/calc_age.md)                                 | Calculate age from DOB         |
| [`calc_age_partial()`](https://mattfarrow1.github.io/fundr/reference/calc_age_partial.md)                 | Calculate age from partial DOB |
| [`format_currency()`](https://mattfarrow1.github.io/fundr/reference/format_currency.md)                   | Format as \$1,234.56           |
| [`format_currency_short()`](https://mattfarrow1.github.io/fundr/reference/format_currency_short.md)       | Format as \$1.2M               |
| [`format_pct()`](https://mattfarrow1.github.io/fundr/reference/format_pct.md)                             | Format as percentage           |
| [`years_since()`](https://mattfarrow1.github.io/fundr/reference/years_since.md)                           | Years since a date             |
| [`total_giving_years()`](https://mattfarrow1.github.io/fundr/reference/total_giving_years.md)             | Count distinct giving years    |
| [`consecutive_giving_years()`](https://mattfarrow1.github.io/fundr/reference/consecutive_giving_years.md) | Current giving streak          |
