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

  A levels table like `fundr_gift_levels`.

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
