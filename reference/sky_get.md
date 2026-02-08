# Make GET request to SKY API

Sends a GET request to the SKY API and returns the parsed response.

## Usage

``` r
sky_get(conn, endpoint, params = list(), ...)
```

## Arguments

- conn:

  A SKY API connection created by
  [`sky_connect()`](https://mattfarrow1.github.io/fundr/reference/sky_connect.md).

- endpoint:

  API endpoint path (e.g., "constituent/v1/constituents").

- params:

  Named list of query parameters.

- ...:

  Additional arguments passed to httr.

## Value

Parsed JSON response as a list or data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
conn <- sky_connect(
  subscription_key = Sys.getenv("SKY_API_KEY"),
  access_token = Sys.getenv("SKY_API_TOKEN")
)

# Get constituents
result <- sky_get(conn, "constituent/v1/constituents",
                  params = list(limit = 100))
} # }
```
