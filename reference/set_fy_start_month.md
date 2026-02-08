# Set default fiscal year start month

Convenience function to change the default fiscal year start month
without calling
[`fundr_setup()`](https://mattfarrow1.github.io/fundr/reference/fundr_setup.md).

## Usage

``` r
set_fy_start_month(month)
```

## Arguments

- month:

  Integer 1-12 indicating fiscal year start month.

## Value

Invisibly returns the previous value.

## Examples

``` r
# Set to calendar year
set_fy_start_month(1)

# Set to October (federal fiscal year)
set_fy_start_month(10)
```
