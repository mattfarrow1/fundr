# Bucket gift ask amounts using fundr_gift_levels

Maps numeric ask amounts to the nearest threshold in
`fundr_gift_levels`. Returns labels such as "\$1,000,000+" and/or
broader buckets.

## Usage

``` r
bucket_gift_level(
  ask_amount,
  levels = fundr_gift_levels,
  value_col = "ask_amount",
  giving_level_col = "giving_level",
  bucket_col = "ask_bucket",
  what = c("giving_level", "ask_bucket"),
  na_value = NA
)
```

## Arguments

- ask_amount:

  Numeric vector of ask amounts.

- levels:

  A levels table like `fundr_gift_levels`, or a preset name ("small",
  "medium", "large", "all"). See
  [`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md)
  for details on presets.

- value_col:

  Name of the numeric threshold column.

- giving_level_col:

  Name of the giving level label column.

- bucket_col:

  Name of the bucket label column.

- what:

  Which label to return: "giving_level" or "ask_bucket".

- na_value:

  Value to return when `ask_amount` is NA or cannot be bucketed.

## Value

A factor (ordered if the source column is ordered), or character if
source is character.

## See also

[`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md)
for creating custom level tables

Other bucketing:
[`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md),
[`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md),
[`rating_levels()`](https://mattfarrow1.github.io/fundr/reference/rating_levels.md)

## Examples

``` r
# Bucket gift amounts into giving levels
amounts <- c(500, 5000, 25000, 100000, 1500000, NA)
bucket_gift_level(amounts)
#> [1] $500+       $5,000+     $25,000+    $100,000+   $1,000,000+ <NA>       
#> 23 Levels: $150,000,000+ < $100,000,000+ < $50,000,000+ < ... < No Amount

# Use a preset for smaller gift ranges
bucket_gift_level(amounts, levels = "small")
#> [1] $500+     $5,000+   $25,000+  $100,000+ $100,000+ <NA>     
#> 12 Levels: $100,000+ < $50,000+ < $25,000+ < $10,000+ < $5,000+ < ... < No Amount

# Return broader ask buckets instead
bucket_gift_level(amounts, what = "ask_bucket")
#> [1] $500 to $999   $5K to $9.9K   $25K to $49.9K $100K to $249K $1M to $2.49M 
#> [6] <NA>          
#> 23 Levels: $150M+ < $100M to $149M < $50M to $99.9M < ... < No Amount

# Vectorized for use in data frames
# df |> mutate(level = bucket_gift_level(gift_amount))
```
