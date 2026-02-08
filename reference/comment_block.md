# Format text as a code block comment

Formats text as a monospace-style code comment block. Useful for
creating visually distinct section headers in scripts.

## Usage

``` r
comment_block(text, width = 80L, char = "#", pad = 1L)
```

## Arguments

- text:

  Character string to format.

- width:

  Total width of the comment block. Default 80.

- char:

  Character to use for the border. Default "#".

- pad:

  Number of spaces to pad the text. Default 1.

## Value

Character string formatted as a comment block.

## Examples

``` r
# Create a section header
cat(comment_block("Data Import"))
#> # #############################################################################
#> #                                 Data Import                                  #
#> # #############################################################################
# ############################################################################
# #                              Data Import                                 #
# ############################################################################

# Shorter width
cat(comment_block("Setup", width = 40))
#> # #####################################
#> #                Setup                 #
#> # #####################################
```
