# Test SKY API connection

Verifies that the SKY API credentials are valid by making a test
request.

## Usage

``` r
sky_test(conn)
```

## Arguments

- conn:

  A SKY API connection created by
  [`sky_connect()`](https://mattfarrow1.github.io/fundr/reference/sky_connect.md).

## Value

TRUE if connection is valid, otherwise throws an error.

## Examples

``` r
if (FALSE) { # \dontrun{
conn <- sky_connect(
  subscription_key = Sys.getenv("SKY_API_KEY"),
  access_token = Sys.getenv("SKY_API_TOKEN")
)

sky_test(conn)
#> TRUE
} # }
```
