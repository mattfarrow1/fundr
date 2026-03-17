# Bucket wealth/capacity values using fundr_rating_levels

Maps numeric rating values to the nearest threshold in
`fundr_rating_levels`.

## Usage

``` r
bucket_rating_level(
  rating_value,
  levels = fundr_rating_levels,
  value_col = "rating_value",
  level_col = "rating_level",
  bucket_col = "rating_bucket",
  what = c("rating_level", "rating_bucket"),
  na_value = NA
)
```

## Arguments

- rating_value:

  Numeric vector of rating values (capacity/wealth estimate).

- levels:

  A levels table like `fundr_rating_levels`, or a preset name ("small",
  "medium", "large", "all"). See
  [`rating_levels()`](https://mattfarrow1.github.io/fundr/reference/rating_levels.md)
  for details on presets.

- value_col:

  Name of the numeric threshold column.

- level_col:

  Name of the rating level label column.

- bucket_col:

  Name of the rating bucket column.

- what:

  Which label to return: "rating_level" or "rating_bucket".

- na_value:

  Value to return when `rating_value` is NA or cannot be bucketed.

## Value

A factor (ordered if the source column is ordered), or character if
source is character.

## See also

[`rating_levels()`](https://mattfarrow1.github.io/fundr/reference/rating_levels.md)
for creating custom level tables

Other bucketing:
[`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md),
[`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md),
[`rating_levels()`](https://mattfarrow1.github.io/fundr/reference/rating_levels.md)

## Examples

``` r
# Bucket capacity ratings into levels
ratings <- c(25000, 75000, 500000, 5000000, 150000000, NA)
bucket_rating_level(ratings)
#> [1] L - $25K to $49.9K K - $50K to $99.9K H - $500K to $999K E - $5M to $9.9M  
#> [5] A - $100M+         <NA>              
#> 16 Levels: A - $100M+ < B - $50M to $99.9M < ... < U - Unrated

# Use a preset for smaller organizations
bucket_rating_level(ratings, levels = "small")
#> [1] L - $25K to $49.9K L - $25K to $49.9K I - $250K to $499K E - $5M to $9.9M  
#> [5] C - $25M to $49.9M <NA>              
#> 8 Levels: C - $25M to $49.9M < E - $5M to $9.9M < ... < U - Unrated

# Return broader rating buckets instead
bucket_rating_level(ratings, what = "rating_bucket")
#> [1] Mid-Level Mid-Level Major     Principal Principal <NA>     
#> Levels: Principal < Major < Mid-Level < Annual < Unrated

# Vectorized for use in data frames
# df |> mutate(rating = bucket_rating_level(estimated_capacity))
```
