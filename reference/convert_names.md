# Convert data frame column names

Convenience function to convert all column names in a data frame to a
specified case format.

## Usage

``` r
convert_names(df, case = c("snake", "title", "camel"))
```

## Arguments

- df:

  A data frame.

- case:

  Target case: "snake", "title", or "camel".

## Value

Data frame with renamed columns.

## Examples

``` r
df <- data.frame(FirstName = "John", LastName = "Doe")
convert_names(df, "snake")
#>   first_name last_name
#> 1       John       Doe
#> Columns: first_name, last_name

df <- data.frame(first_name = "John", last_name = "Doe")
convert_names(df, "title")
#>   First Name Last Name
#> 1       John       Doe
#> Columns: First Name, Last Name
```
