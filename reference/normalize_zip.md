# Normalize postal (ZIP) codes

Normalizes US ZIP codes to either 5-digit ("12345") or ZIP+4
("12345-6789") format by removing punctuation and whitespace. Postal
codes are treated as character strings; leading zeros are preserved.

## Usage

``` r
normalize_zip(
  postal,
  format = c("zip5", "zip9", "digits"),
  invalid = NA_character_,
  strict = TRUE,
  na_if_blank = TRUE
)
```

## Arguments

- postal:

  Character vector of postal codes.

- format:

  Output format: "zip5" (always 5 digits), "zip9" (ZIP+4 when
  available), or "digits" (raw digits, 5 or 9).

- invalid:

  Value to return for invalid postal codes.

- strict:

  Logical; if TRUE, only accept exactly 5 or 9 digits after cleaning. If
  FALSE, will attempt to salvage by taking the first 5 digits when at
  least 5 are present, and the first 9 digits when at least 9 are
  present.

- na_if_blank:

  Logical; if TRUE, blank/whitespace-only inputs become `invalid`.

## Value

A character vector of normalized postal codes.

## See also

Other normalization:
[`normalize_phone()`](https://mattfarrow1.github.io/fundr/reference/normalize_phone.md)

## Examples

``` r
zips <- c("12345", "12345-6789", "12345 6789", "  12345  ")

# Default 5-digit format
normalize_zip(zips)
#> [1] "12345" "12345" "12345" "12345"

# ZIP+4 format (preserves 9-digit codes)
normalize_zip(zips, format = "zip9")
#> [1] "12345"      "12345-6789" "12345-6789" "12345"     

# Raw digits
normalize_zip(zips, format = "digits")
#> [1] "12345"     "123456789" "123456789" "12345"    

# Preserve leading zeros
normalize_zip("01234")
#> [1] "01234"
```
