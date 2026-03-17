# Get gift level thresholds

Returns a subset of `fundr_gift_levels` based on a preset or custom
thresholds. Use this to get levels appropriate for your organization's
gift size distribution.

## Usage

``` r
gift_levels(preset = c("all", "small", "medium", "large"), include = NULL)
```

## Arguments

- preset:

  A preset name: "small", "medium", "large", or "all" (default).

  - "small": Annual fund focus, thresholds from \$1 to \$100K

  - "medium": Leadership/major gifts, thresholds from \$1K to \$1M

  - "large": Principal gifts, thresholds from \$100K to \$150M+

  - "all": All available thresholds (comprehensive)

- include:

  Numeric vector of specific thresholds to include. If provided,
  overrides `preset`. Values must exist in
  `fundr_gift_levels$ask_amount`.

## Value

A data frame with columns `ask_amount`, `giving_level`, and
`ask_bucket`, suitable for use with
[`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md).

## See also

Other bucketing:
[`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md),
[`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md),
[`rating_levels()`](https://mattfarrow1.github.io/fundr/reference/rating_levels.md)

## Examples

``` r
# Get small shop levels (annual fund focus)
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

# Get large shop levels (principal gifts)
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

# Get all levels
gift_levels()
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

# Custom selection of thresholds
gift_levels(include = c(0, 0.01, 1000, 10000, 100000))
#>   ask_amount giving_level     ask_bucket
#> 1      0e+00    No Amount      No Amount
#> 2      1e-02          $1+ Less than $100
#> 3      1e+03      $1,000+   $1K to $2.4K
#> 4      1e+04     $10,000+ $10K to $24.9K
#> 5      1e+05    $100,000+ $100K to $249K

# Use with bucket_gift_level()
amounts <- c(500, 5000, 25000, 100000)
bucket_gift_level(amounts, levels = gift_levels("small"))
#> [1] $500+     $5,000+   $25,000+  $100,000+
#> 12 Levels: $100,000+ < $50,000+ < $25,000+ < $10,000+ < $5,000+ < ... < No Amount
```
