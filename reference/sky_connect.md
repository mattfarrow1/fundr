# Create SKY API connection

Sets up authentication for Blackbaud's SKY API. Requires a subscription
key and OAuth token. See Blackbaud Developer Portal for setup
instructions.

## Usage

``` r
sky_connect(
  subscription_key,
  access_token,
  base_url = "https://api.sky.blackbaud.com"
)
```

## Arguments

- subscription_key:

  Your SKY API subscription key.

- access_token:

  OAuth 2.0 access token.

- base_url:

  Base URL for the API. Default is the production endpoint.

## Value

A list containing connection parameters, used by other SKY API
functions.

## Details

To obtain credentials:

1.  Register at developer.blackbaud.com

2.  Create an application and note the subscription key

3.  Complete OAuth flow to get access token

Store credentials securely using environment variables:

    # In .Renviron
    SKY_API_KEY=your_subscription_key
    SKY_API_TOKEN=your_access_token

## Examples

``` r
if (FALSE) { # \dontrun{
# Using environment variables
conn <- sky_connect(
  subscription_key = Sys.getenv("SKY_API_KEY"),
  access_token = Sys.getenv("SKY_API_TOKEN")
)

# Get constituents
constituents <- sky_get(conn, "constituent/v1/constituents")
} # }
```
