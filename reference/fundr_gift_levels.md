# Gift level reference table

A comprehensive reference table of gift amount thresholds, formatted
giving level labels, and broader ask buckets useful for reporting and
segmentation. Covers the full range from annual fund (\$100+) to
principal gifts (\$150M+).

## Usage

``` r
fundr_gift_levels
```

## Format

A data frame with 23 rows and 3 variables:

- ask_amount:

  Numeric ask amount threshold.

- giving_level:

  Ordered factor label for the threshold (e.g., "\$1,000,000+").

- ask_bucket:

  Ordered factor bucket label (e.g., "\$1M to \$2.49M").

## Source

Internal conventions (fundr).

## Details

Use
[`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md)
to get preset subsets appropriate for your organization:

- "small": Annual fund focus, \$1 to \$100K

- "medium": Leadership/major gifts, \$1K to \$1M

- "large": Principal gifts, \$100K to \$150M+

## See also

[`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md),
[`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md)
