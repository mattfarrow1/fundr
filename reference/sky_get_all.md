# Get all pages from SKY API endpoint

Handles pagination to retrieve all records from a SKY API endpoint.

## Usage

``` r
sky_get_all(
  conn,
  endpoint,
  params = list(),
  limit = 500L,
  max_records = NULL,
  verbose = TRUE
)
```

## Arguments

- conn:

  A SKY API connection created by
  [`sky_connect()`](https://mattfarrow1.github.io/fundr/reference/sky_connect.md).

- endpoint:

  API endpoint path.

- params:

  Named list of query parameters.

- limit:

  Records per page. Default 500 (max allowed).

- max_records:

  Maximum total records to retrieve. Default NULL (all).

- verbose:

  If TRUE, prints progress messages.

## Value

Combined data frame of all records.

## Examples

``` r
if (FALSE) { # \dontrun{
conn <- sky_connect(
  subscription_key = Sys.getenv("SKY_API_KEY"),
  access_token = Sys.getenv("SKY_API_TOKEN")
)

# Get all constituents (handles pagination automatically)
all_constituents <- sky_get_all(conn, "constituent/v1/constituents")
} # }
```
