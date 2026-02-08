# Format text as a simple comment header

Formats text as a simple single-line comment header.

## Usage

``` r
comment_header(text, char = "-", width = 80L)
```

## Arguments

- text:

  Character string to format.

- char:

  Character to use for decoration. Default "-".

- width:

  Total width of the header. Default 80.

## Value

Character string formatted as a comment header.

## Examples

``` r
cat(comment_header("Load Libraries"))
#> # Load Libraries ---------------------------------------------------------------
# # Load Libraries --------------------------------------------------------
```
