# Rating level reference table

A comprehensive reference table of wealth/capacity rating levels,
numeric thresholds, and broader rating buckets commonly used in
fundraising analytics. Covers ratings from Unrated through \$100M+
capacity.

## Usage

``` r
fundr_rating_levels
```

## Format

A data frame with 16 rows and 3 variables:

- rating_value:

  Numeric threshold representing the rating level.

- rating_level:

  Ordered factor rating label (e.g., "A - \$100M+").

- rating_bucket:

  Ordered factor grouping (Principal, Major, Mid-Level, Annual,
  Unrated).

## Source

Internal conventions (fundr).

## Details

Use
[`rating_levels()`](https://mattfarrow1.github.io/fundr/reference/rating_levels.md)
to get preset subsets with bucket assignments appropriate for your
organization:

- "small": Major at \$25K+, Principal at \$250K+

- "medium": Major at \$50K+, Principal at \$1M+

- "large": Major at \$100K+, Principal at \$5M+

## See also

[`rating_levels()`](https://mattfarrow1.github.io/fundr/reference/rating_levels.md),
[`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md)
