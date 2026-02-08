# Not in operator

The negation of the `%in%` operator. Returns TRUE for elements of `x`
that are not in `table`.

## Usage

``` r
x %notin% table

x %!in% table
```

## Arguments

- x:

  Vector of values to check.

- table:

  Vector of values to check against.

## Value

Logical vector the same length as `x`.

## Examples

``` r
# Find values not in a set
c(1, 2, 3, 4, 5) %notin% c(2, 4)
#> [1]  TRUE FALSE  TRUE FALSE  TRUE
#> TRUE, FALSE, TRUE, FALSE, TRUE

# Filter data frame rows
df <- data.frame(status = c("Active", "Lapsed", "Active", "Never"))
df[df$status %notin% c("Lapsed", "Never"), ]
#> [1] "Active" "Active"
```
