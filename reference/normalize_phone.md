# Normalize phone numbers

Normalizes phone numbers by removing punctuation and formatting them
into a consistent representation.

## Usage

``` r
normalize_phone(
  phone,
  format = c("dash", "digits", "e164"),
  country = "US",
  invalid = NA_character_,
  allow_7 = FALSE,
  keep_extension = FALSE,
  extension_sep = " x",
  strip_leading_country = TRUE,
  na_if_blank = TRUE,
  strict = TRUE
)
```

## Arguments

- phone:

  Character vector of phone numbers.

- format:

  Output format: "dash" (XXX-XXX-XXXX), "digits", "e164".

- country:

  Country code for e164 format (currently only "US").

- invalid:

  Value to return for invalid phone numbers.

- allow_7:

  Logical; if TRUE, allow 7-digit numbers and format as XXX-XXXX (dash)
  or digits.

- keep_extension:

  Logical; if TRUE, retain extensions (e.g., x123).

- extension_sep:

  Separator used when appending extensions (default " x").

- strip_leading_country:

  Logical; if TRUE, strips leading "1" from 11-digit US numbers.

- na_if_blank:

  Logical; if TRUE, blank/whitespace-only inputs become `invalid`.

- strict:

  Logical; When strict = TRUE, numbers must be 10 digits (or 7 digits if
  allow_7 = TRUE).

## Value

A character vector of normalized phone numbers.
