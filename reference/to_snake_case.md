# Convert strings to snake_case

Converts strings from various formats (TitleCase, camelCase, etc.) to
snake_case. Useful for standardizing column names.

## Usage

``` r
to_snake_case(x)
```

## Arguments

- x:

  Character vector to convert.

## Value

Character vector in snake_case.

## Examples

``` r
to_snake_case("FirstName")
#> [1] "first_name"
#> "first_name"

to_snake_case("firstName")
#> [1] "first_name"
#> "first_name"

to_snake_case(c("GiftAmount", "DonorID", "LastGiftDate"))
#> [1] "gift_amount"    "donor_id"       "last_gift_date"
#> "gift_amount", "donor_id", "last_gift_date"

# Already snake_case passes through
to_snake_case("gift_amount")
#> [1] "gift_amount"
#> "gift_amount"
```
