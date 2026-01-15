# Gift level reference table

A reference table of common ask amounts, formatted giving level labels,
and broader ask buckets useful for reporting and segmentation.

## Usage

``` r
fundr_gift_levels
```

## Format

A data frame with 14 rows and 3 variables:

- ask_amount:

  Numeric ask amount threshold.

- giving_level:

  Ordered factor label for the threshold (e.g., "\$1,000,000+").

- ask_bucket:

  Ordered factor bucket label (e.g., "\$1M to \$2.49M").

## Source

Internal conventions (fundr).
