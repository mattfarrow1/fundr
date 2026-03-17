# Get rating level thresholds

Returns a subset of `fundr_rating_levels` based on a preset or custom
thresholds. Use this to get levels appropriate for your organization's
capacity rating scale.

## Usage

``` r
rating_levels(
  preset = c("all", "small", "medium", "large"),
  include = NULL,
  bucket_map = NULL
)
```

## Arguments

- preset:

  A preset name: "small", "medium", "large", or "all" (default).

  - "small": Major at \$25K+, Principal at \$250K+ (community
    foundations)

  - "medium": Major at \$50K+, Principal at \$1M+ (mid-size orgs)

  - "large": Major at \$100K+, Principal at \$5M+ (universities,
    hospitals)

  - "all": All available thresholds (comprehensive)

- include:

  Numeric vector of specific thresholds to include. If provided,
  overrides `preset`. Values must exist in
  `fundr_rating_levels$rating_value`.

- bucket_map:

  Named character vector mapping thresholds to buckets. Names should be
  threshold values (as character), values should be bucket names
  ("Principal", "Major", "Mid-Level", "Annual", "Unrated"). Only used
  with `include`.

## Value

A data frame with columns `rating_value`, `rating_level`, and
`rating_bucket`, suitable for use with
[`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md).

## See also

Other bucketing:
[`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md),
[`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md),
[`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md)

## Examples

``` r
# Get small shop levels
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

# Get large shop levels
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

# Get all levels
rating_levels()
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

# Custom selection with custom bucket assignments
rating_levels(
  include = c(0, 1, 10000, 50000, 250000),
  bucket_map = c("0" = "Unrated", "1" = "Annual", "10000" = "Mid-Level",
                 "50000" = "Major", "250000" = "Principal")
)
#>   rating_value       rating_level rating_bucket
#> 1            0        U - Unrated       Unrated
#> 2            1  O - Less than $5K        Annual
#> 3        10000 M - $10K to $24.9K     Mid-Level
#> 4        50000 K - $50K to $99.9K         Major
#> 5       250000 I - $250K to $499K     Principal

# Use with bucket_rating_level()
ratings <- c(5000, 50000, 500000)
bucket_rating_level(ratings, levels = rating_levels("small"))
#> [1] N - $5K to $9.9K   L - $25K to $49.9K I - $250K to $499K
#> 8 Levels: C - $25M to $49.9M < E - $5M to $9.9M < ... < U - Unrated
```
