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

  A levels table like `fundr_rating_levels`.

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
