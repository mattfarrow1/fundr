# Convert strings to camelCase

Converts strings from snake_case or other formats to camelCase.

## Usage

``` r
to_camel_case(x)
```

## Arguments

- x:

  Character vector to convert.

## Value

Character vector in camelCase.

## Examples

``` r
to_camel_case("first_name")
#> [1] "firstName"
#> "firstName"

to_camel_case("gift_amount")
#> [1] "giftAmount"
#> "giftAmount"
```
