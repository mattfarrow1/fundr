# Test database connection

Verifies that a database connection is valid.

## Usage

``` r
db_test(conn)
```

## Arguments

- conn:

  A DBI connection object.

## Value

TRUE if connection is valid, FALSE otherwise.

## Examples

``` r
if (FALSE) { # \dontrun{
conn <- db_connect(driver = "sqlite", database = "test.db")
db_test(conn)
#> TRUE
} # }
```
