# Convert strings to Title Case

Converts strings from snake_case or other formats to Title Case. Useful
for creating readable labels from column names.

## Usage

``` r
to_title_case(x, strict = TRUE)
```

## Arguments

- x:

  Character vector to convert.

- strict:

  Logical. If TRUE (default), converts entirely to Title Case. If FALSE,
  only capitalizes the first letter of each word, preserving other
  capitalization.

## Value

Character vector in Title Case.

## Examples

``` r
to_title_case("first_name")
#> [1] "First Name"
#> "First Name"

to_title_case("gift_amount")
#> [1] "Gift Amount"
#> "Gift Amount"

to_title_case(c("donor_id", "last_gift_date", "total_giving"))
#> [1] "Donor Id"       "Last Gift Date" "Total Giving"  
#> "Donor Id", "Last Gift Date", "Total Giving"

# Already Title Case passes through
to_title_case("First Name")
#> [1] "First Name"
#> "First Name"
```
