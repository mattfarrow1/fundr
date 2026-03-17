# Bucketing gift levels and rating levels

fundr includes reference tables for common gift/ask levels and wealth
rating levels, plus helpers to bucket numeric values into consistent
labels. The bucketing functions support presets for different
organization sizes, from small community foundations to large
universities. \## Gift Level Bucketing

The `fundr_gift_levels` table contains comprehensive thresholds from \$1
to \$150M+:

``` r
library(fundr)

# View all available thresholds
fundr_gift_levels
#>    ask_amount  giving_level     ask_bucket
#> 1     0.0e+00     No Amount      No Amount
#> 2     1.0e-02           $1+ Less than $100
#> 3     1.0e+02         $100+   $100 to $249
#> 4     2.5e+02         $250+   $250 to $499
#> 5     5.0e+02         $500+   $500 to $999
#> 6     1.0e+03       $1,000+   $1K to $2.4K
#> 7     2.5e+03       $2,500+ $2.5K to $4.9K
#> 8     5.0e+03       $5,000+   $5K to $9.9K
#> 9     1.0e+04      $10,000+ $10K to $24.9K
#> 10    2.5e+04      $25,000+ $25K to $49.9K
#> 11    5.0e+04      $50,000+ $50K to $99.9K
#> 12    1.0e+05     $100,000+ $100K to $249K
#> 13    2.5e+05     $250,000+ $250K to $499K
#> 14    5.0e+05     $500,000+ $500K to $749K
#> 15    7.5e+05     $750,000+ $750K to $999K
#> 16    1.0e+06   $1,000,000+  $1M to $2.49M
#> 17    2.5e+06   $2,500,000+ $2.5M to $4.9M
#> 18    5.0e+06   $5,000,000+   $5M to $9.9M
#> 19    1.0e+07  $10,000,000+ $10M to $24.9M
#> 20    2.5e+07  $25,000,000+ $25M to $49.9M
#> 21    5.0e+07  $50,000,000+ $50M to $99.9M
#> 22    1.0e+08 $100,000,000+ $100M to $149M
#> 23    1.5e+08 $150,000,000+         $150M+
```

### Using Presets

Different organizations have different gift level needs. Use
[`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md)
to get a preset appropriate for your shop:

``` r
# Small shop: annual fund focus ($1 to $100K)
gift_levels("small")
#>    ask_amount giving_level     ask_bucket
#> 1     0.0e+00    No Amount      No Amount
#> 2     1.0e-02          $1+ Less than $100
#> 3     1.0e+02        $100+   $100 to $249
#> 4     2.5e+02        $250+   $250 to $499
#> 5     5.0e+02        $500+   $500 to $999
#> 6     1.0e+03      $1,000+   $1K to $2.4K
#> 7     2.5e+03      $2,500+ $2.5K to $4.9K
#> 8     5.0e+03      $5,000+   $5K to $9.9K
#> 9     1.0e+04     $10,000+ $10K to $24.9K
#> 10    2.5e+04     $25,000+ $25K to $49.9K
#> 11    5.0e+04     $50,000+ $50K to $99.9K
#> 12    1.0e+05    $100,000+ $100K to $249K

# Medium shop: leadership/major gifts ($1K to $1M)
gift_levels("medium")
#>    ask_amount giving_level     ask_bucket
#> 1     0.0e+00    No Amount      No Amount
#> 2     1.0e-02          $1+ Less than $100
#> 3     1.0e+03      $1,000+   $1K to $2.4K
#> 4     5.0e+03      $5,000+   $5K to $9.9K
#> 5     1.0e+04     $10,000+ $10K to $24.9K
#> 6     2.5e+04     $25,000+ $25K to $49.9K
#> 7     5.0e+04     $50,000+ $50K to $99.9K
#> 8     1.0e+05    $100,000+ $100K to $249K
#> 9     2.5e+05    $250,000+ $250K to $499K
#> 10    5.0e+05    $500,000+ $500K to $749K
#> 11    1.0e+06  $1,000,000+  $1M to $2.49M

# Large shop: principal gifts ($100K to $150M+)
gift_levels("large")
#>    ask_amount  giving_level     ask_bucket
#> 1     0.0e+00     No Amount      No Amount
#> 2     1.0e-02           $1+ Less than $100
#> 3     1.0e+05     $100,000+ $100K to $249K
#> 4     2.5e+05     $250,000+ $250K to $499K
#> 5     5.0e+05     $500,000+ $500K to $749K
#> 6     7.5e+05     $750,000+ $750K to $999K
#> 7     1.0e+06   $1,000,000+  $1M to $2.49M
#> 8     2.5e+06   $2,500,000+ $2.5M to $4.9M
#> 9     5.0e+06   $5,000,000+   $5M to $9.9M
#> 10    1.0e+07  $10,000,000+ $10M to $24.9M
#> 11    2.5e+07  $25,000,000+ $25M to $49.9M
#> 12    5.0e+07  $50,000,000+ $50M to $99.9M
#> 13    1.0e+08 $100,000,000+ $100M to $149M
#> 14    1.5e+08 $150,000,000+         $150M+
```

### Bucketing Gift Amounts

Use
[`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md)
to categorize gift amounts:

``` r
amounts <- c(250, 1000, 5000, 25000, 100000, 1000000, NA)

# Using comprehensive levels (default)
bucket_gift_level(amounts, what = "giving_level")
#> [1] $250+       $1,000+     $5,000+     $25,000+    $100,000+   $1,000,000+
#> [7] <NA>       
#> 23 Levels: $150,000,000+ < $100,000,000+ < $50,000,000+ < ... < No Amount

# Using a preset for smaller gift ranges
bucket_gift_level(amounts, levels = "small", what = "giving_level")
#> [1] $250+     $1,000+   $5,000+   $25,000+  $100,000+ $100,000+ <NA>     
#> 12 Levels: $100,000+ < $50,000+ < $25,000+ < $10,000+ < $5,000+ < ... < No Amount

# Get broader bucket labels
bucket_gift_level(amounts, levels = "small", what = "ask_bucket")
#> [1] $250 to $499   $1K to $2.4K   $5K to $9.9K   $25K to $49.9K $100K to $249K
#> [6] $100K to $249K <NA>          
#> 12 Levels: $100K to $249K < $50K to $99.9K < ... < No Amount
```

### Custom Thresholds

You can also select specific thresholds:

``` r
# Custom selection of thresholds
my_levels <- gift_levels(include = c(0, 0.01, 1000, 5000, 25000, 100000))
my_levels
#>   ask_amount giving_level     ask_bucket
#> 1    0.0e+00    No Amount      No Amount
#> 2    1.0e-02          $1+ Less than $100
#> 3    1.0e+03      $1,000+   $1K to $2.4K
#> 4    5.0e+03      $5,000+   $5K to $9.9K
#> 5    2.5e+04     $25,000+ $25K to $49.9K
#> 6    1.0e+05    $100,000+ $100K to $249K

bucket_gift_level(c(500, 2500, 50000), levels = my_levels)
#> [1] $1+      $1,000+  $25,000+
#> Levels: $100,000+ < $25,000+ < $5,000+ < $1,000+ < $1+ < No Amount
```

## Rating Level Bucketing

The `fundr_rating_levels` table contains wealth/capacity rating
thresholds:

``` r
# View all available thresholds
fundr_rating_levels
#>    rating_value       rating_level rating_bucket
#> 1       0.0e+00        U - Unrated       Unrated
#> 2       1.0e+00  O - Less than $5K        Annual
#> 3       5.0e+03   N - $5K to $9.9K        Annual
#> 4       1.0e+04 M - $10K to $24.9K        Annual
#> 5       2.5e+04 L - $25K to $49.9K     Mid-Level
#> 6       5.0e+04 K - $50K to $99.9K     Mid-Level
#> 7       1.0e+05 J - $100K to $249K         Major
#> 8       2.5e+05 I - $250K to $499K         Major
#> 9       5.0e+05 H - $500K to $999K         Major
#> 10      1.0e+06  G - $1M to $2.49M         Major
#> 11      2.5e+06 F - $2.5M to $4.9M         Major
#> 12      5.0e+06   E - $5M to $9.9M     Principal
#> 13      1.0e+07 D - $10M to $24.9M     Principal
#> 14      2.5e+07 C - $25M to $49.9M     Principal
#> 15      5.0e+07 B - $50M to $99.9M     Principal
#> 16      1.0e+08         A - $100M+     Principal
```

### Using Presets

Rating level presets adjust where the bucket boundaries fall (what
counts as “Major” vs “Mid-Level”):

``` r
# Small shop: Major at $25K+, Principal at $250K+
rating_levels("small")
#>   rating_value       rating_level rating_bucket
#> 1      0.0e+00        U - Unrated       Unrated
#> 2      1.0e+00  O - Less than $5K        Annual
#> 3      5.0e+03   N - $5K to $9.9K     Mid-Level
#> 4      2.5e+04 L - $25K to $49.9K         Major
#> 5      2.5e+05 I - $250K to $499K     Principal
#> 6      1.0e+06  G - $1M to $2.49M     Principal
#> 7      5.0e+06   E - $5M to $9.9M     Principal
#> 8      2.5e+07 C - $25M to $49.9M     Principal

# Large shop: Major at $100K+, Principal at $5M+
rating_levels("large")
#>    rating_value       rating_level rating_bucket
#> 1       0.0e+00        U - Unrated       Unrated
#> 2       1.0e+00  O - Less than $5K        Annual
#> 3       5.0e+03   N - $5K to $9.9K        Annual
#> 4       1.0e+04 M - $10K to $24.9K        Annual
#> 5       2.5e+04 L - $25K to $49.9K     Mid-Level
#> 6       5.0e+04 K - $50K to $99.9K     Mid-Level
#> 7       1.0e+05 J - $100K to $249K         Major
#> 8       2.5e+05 I - $250K to $499K         Major
#> 9       5.0e+05 H - $500K to $999K         Major
#> 10      1.0e+06  G - $1M to $2.49M         Major
#> 11      2.5e+06 F - $2.5M to $4.9M         Major
#> 12      5.0e+06   E - $5M to $9.9M     Principal
#> 13      1.0e+07 D - $10M to $24.9M     Principal
#> 14      2.5e+07 C - $25M to $49.9M     Principal
#> 15      5.0e+07 B - $50M to $99.9M     Principal
#> 16      1.0e+08         A - $100M+     Principal
```

### Bucketing Ratings

``` r
ratings <- c(10000, 50000, 250000, 1000000, 10000000)

# Using comprehensive levels
bucket_rating_level(ratings, what = "rating_bucket")
#> [1] Annual    Mid-Level Major     Major     Principal
#> Levels: Principal < Major < Mid-Level < Annual < Unrated

# Using small shop preset (lower thresholds for Major/Principal)
bucket_rating_level(ratings, levels = "small", what = "rating_bucket")
#> [1] Mid-Level Major     Principal Principal Principal
#> Levels: Principal < Major < Mid-Level < Annual < Unrated

# Using large shop preset
bucket_rating_level(ratings, levels = "large", what = "rating_bucket")
#> [1] Annual    Mid-Level Major     Major     Principal
#> Levels: Principal < Major < Mid-Level < Annual < Unrated
```

### Custom Bucket Assignments

For full control, create custom bucket mappings:

``` r
# Custom thresholds with custom bucket assignments
my_ratings <- rating_levels(
  include = c(0, 1, 10000, 50000, 250000),
  bucket_map = c(
    "0" = "Unrated",
    "1" = "Annual",
    "10000" = "Mid-Level",
    "50000" = "Major",
    "250000" = "Principal"
  )
)
my_ratings
#>   rating_value       rating_level rating_bucket
#> 1            0        U - Unrated       Unrated
#> 2            1  O - Less than $5K        Annual
#> 3        10000 M - $10K to $24.9K     Mid-Level
#> 4        50000 K - $50K to $99.9K         Major
#> 5       250000 I - $250K to $499K     Principal
```

## Working with a Data Frame

These functions work well in both base R and dplyr workflows:

``` r
df <- data.frame(
  donor_id = 1:6,
  ask_amount = c(0, 500, 5000, 50000, 250000, 1000000),
  capacity_value = c(0, 8000, 25000, 100000, 500000, 5000000)
)

# Using small shop presets
df$gift_level <- bucket_gift_level(df$ask_amount, levels = "small")
df$rating_bucket <- bucket_rating_level(df$capacity_value,
                                         levels = "small",
                                         what = "rating_bucket")
df
#>   donor_id ask_amount capacity_value gift_level rating_bucket
#> 1        1          0              0  No Amount       Unrated
#> 2        2        500           8000      $500+     Mid-Level
#> 3        3       5000          25000    $5,000+         Major
#> 4        4      50000         100000   $50,000+         Major
#> 5        5     250000         500000  $100,000+     Principal
#> 6        6    1000000        5000000  $100,000+     Principal
```

### With dplyr (Optional)

``` r
library(dplyr)

df |>
  mutate(
    gift_level = bucket_gift_level(ask_amount, levels = "small"),
    rating_bucket = bucket_rating_level(capacity_value,
                                         levels = "small",
                                         what = "rating_bucket")
  )
```

## Choosing the Right Preset

| Preset     | Gift Levels       | Rating Buckets                        | Best For                                    |
|------------|-------------------|---------------------------------------|---------------------------------------------|
| `"small"`  | \$1 to \$100K     | Major at \$25K+, Principal at \$250K+ | Community foundations, small nonprofits     |
| `"medium"` | \$1K to \$1M      | Major at \$50K+, Principal at \$1M+   | Mid-size organizations                      |
| `"large"`  | \$100K to \$150M+ | Major at \$100K+, Principal at \$5M+  | Universities, hospitals, large institutions |
| `"all"`    | Comprehensive     | Default buckets                       | Custom filtering                            |

## Summary

| Function                                                                                        | Purpose                              |
|-------------------------------------------------------------------------------------------------|--------------------------------------|
| [`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md)                 | Get gift level presets               |
| [`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md)     | Categorize gift amounts              |
| [`rating_levels()`](https://mattfarrow1.github.io/fundr/reference/rating_levels.md)             | Get rating level presets             |
| [`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md) | Categorize wealth ratings            |
| `fundr_gift_levels`                                                                             | Comprehensive gift threshold table   |
| `fundr_rating_levels`                                                                           | Comprehensive rating threshold table |
