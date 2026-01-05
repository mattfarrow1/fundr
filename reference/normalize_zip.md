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
