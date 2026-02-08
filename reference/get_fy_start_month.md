# Get default fiscal year start month

Returns the fiscal year start month from options, or the package default
(July = 7) if not set.

## Usage

``` r
get_fy_start_month()
```

## Value

Integer 1-12 representing the fiscal year start month.

## Examples

``` r
# Get current default
get_fy_start_month()
#> [1] 7

# After setting a different default
fundr_setup(fy_start_month = 1, quiet = TRUE)
get_fy_start_month()
#> [1] 1
#> 1
```
