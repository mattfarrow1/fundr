# Data Cleaning with fundr

Fundraising databases often contain inconsistent data entry. fundr
provides tools to normalize phone numbers, ZIP codes, and convert
between naming conventions.

``` r
library(fundr)
```

## Phone Number Normalization

The
[`normalize_phone()`](https://mattfarrow1.github.io/fundr/reference/normalize_phone.md)
function handles the many ways phone numbers get entered:

``` r
messy_phones <- c(
  "(214) 555-1234",
  "972.555.4567",
  "817-555-8901",
  "1-469-555-0123",
  "+1 (214) 555-9876",
  "2145557890",
  "214/555-4321"
)

normalize_phone(messy_phones)
#> [1] "214-555-1234" "972-555-4567" "817-555-8901" "469-555-0123" "214-555-9876"
#> [6] "214-555-7890" "214-555-4321"
```

### Output Formats

Choose your preferred output format:

``` r
phone <- "(214) 555-1234"

# Dashed format (default)
normalize_phone(phone, format = "dash")
#> [1] "214-555-1234"

# Digits only
normalize_phone(phone, format = "digits")
#> [1] "2145551234"

# E.164 international format
normalize_phone(phone, format = "e164")
#> [1] "+12145551234"
```

### Handling Extensions

``` r
phones_with_ext <- c(
  "214-555-1234 x100",
  "972-555-4567 ext. 200",
  "817-555-8901 extension 300"
)

# Drop extensions (default)
normalize_phone(phones_with_ext)
#> [1] "214-555-1234" "972-555-4567" "817-555-8901"

# Keep extensions
normalize_phone(phones_with_ext, keep_extension = TRUE)
#> [1] "214-555-1234 x100" "972-555-4567 x200" "817-555-8901 x300"
```

### Strict vs. Lenient Mode

By default,
[`normalize_phone()`](https://mattfarrow1.github.io/fundr/reference/normalize_phone.md)
requires exactly 10 digits. Use `strict = FALSE` to attempt salvaging
numbers with extra digits:

``` r
problematic <- c("12145551234", "0012145551234")

# Strict mode - returns NA for invalid
normalize_phone(problematic, strict = TRUE)
#> [1] "214-555-1234" NA

# Lenient mode - takes last 10 digits
normalize_phone(problematic, strict = FALSE)
#> [1] "214-555-1234" "214-555-1234"
```

### 7-Digit Numbers

Some databases store local numbers without area codes:

``` r
local_numbers <- c("555-1234", "5554567")

# By default, 7-digit numbers are invalid
normalize_phone(local_numbers)
#> [1] NA NA

# Allow 7-digit numbers
normalize_phone(local_numbers, allow_7 = TRUE)
#> [1] "555-1234" "555-4567"
```

## ZIP Code Normalization

The
[`normalize_zip()`](https://mattfarrow1.github.io/fundr/reference/normalize_zip.md)
function standardizes US ZIP codes and ZIP+4:

``` r
messy_zips <- c(
  "75201",
  "75201-1234",
  "752011234",
  "75201 5678",
  " 75201 "
)

normalize_zip(messy_zips)
#> [1] "75201" "75201" "75201" "75201" "75201"
```

### Output Formats

``` r
zip <- "75201-1234"

# 5-digit only (default)
normalize_zip(zip, format = "zip5")
#> [1] "75201"

# ZIP+4 when available
normalize_zip(zip, format = "zip9")
#> [1] "75201-1234"

# Raw digits
normalize_zip(zip, format = "digits")
#> [1] "752011234"
```

### Strict vs. Lenient Mode

``` r
problematic_zips <- c("7520112345", "0075201")

# Strict mode
normalize_zip(problematic_zips, strict = TRUE)
#> [1] NA NA

# Lenient mode - salvages valid portions
normalize_zip(problematic_zips, strict = FALSE)
#> [1] "75201" "00752"
```

## Case Conversion

Convert strings between common naming conventions:

``` r
# Snake case (database columns)
to_snake_case("FirstName")
#> [1] "first_name"
to_snake_case("lastName")
#> [1] "last_name"
to_snake_case("Date of Birth")
#> [1] "date_of_birth"

# Title case (display labels)
to_title_case("first_name")
#> [1] "First Name"
to_title_case("date_of_birth")
#> [1] "Date Of Birth"

# Camel case (programming)
to_camel_case("first_name")
#> [1] "firstName"
to_camel_case("date of birth")
#> [1] "dateOfBirth"
```

### Converting Data Frame Column Names

Use
[`convert_names()`](https://mattfarrow1.github.io/fundr/reference/convert_names.md)
to transform all column names at once:

``` r
df <- data.frame(
  `First Name` = "John",
  `Last Name` = "Smith",
  `Date of Birth` = "1980-01-15",
  check.names = FALSE
)

names(df)
#> [1] "First Name"    "Last Name"     "Date of Birth"

# Convert to snake_case
df_snake <- convert_names(df, case = "snake")
names(df_snake)
#> [1] "first_name"    "last_name"     "date_of_birth"

# Convert to title case
df_title <- convert_names(df_snake, case = "title")
names(df_title)
#> [1] "First Name"    "Last Name"     "Date Of Birth"
```

## Working with the Portfolio Dataset

The `fundr_portfolio` dataset intentionally includes messy phone numbers
and ZIP codes for practicing cleanup:

``` r
# Sample of messy phone numbers
sample_phones <- fundr_portfolio$phone_number[!is.na(fundr_portfolio$phone_number)][1:8]
sample_phones
#> [1] "512.375.2067"      "(713) 891-0940"    "+1 (361) 882-5883"
#> [4] "+1 (817) 622-3340" "361-4636998"       "409/512-0230"     
#> [7] "254/490-8249"      "+1 (210) 891-3829"

# Clean them
normalize_phone(sample_phones)
#> [1] "512-375-2067" "713-891-0940" "361-882-5883" "817-622-3340" "361-463-6998"
#> [6] "409-512-0230" "254-490-8249" "210-891-3829"
```

``` r
# Sample of messy ZIP codes
sample_zips <- fundr_portfolio$zip[!is.na(fundr_portfolio$zip)][1:8]
sample_zips
#> [1] "75219-9418" "78701 4888" "77005-7098" "73102 7081" " 77005 "   
#> [6] "75099-3876" " 75205 "    "77005"

# Clean them
normalize_zip(sample_zips)
#> [1] "75219" "78701" "77005" "73102" "77005" "75099" "75205" "77005"
```

### Cleaning the Full Dataset

Here’s how you might clean the entire portfolio using dplyr:

``` r
library(dplyr)

portfolio_clean <- fundr_portfolio |>
  mutate(
    phone_clean = normalize_phone(phone_number),
    zip_clean = normalize_zip(zip, format = "zip5")
  )
```

Or with base R:

``` r
# Create a copy
portfolio_clean <- fundr_portfolio

# Clean phone and ZIP
portfolio_clean$phone_clean <- normalize_phone(portfolio_clean$phone_number)
portfolio_clean$zip_clean <- normalize_zip(portfolio_clean$zip, format = "zip5")

# Check results
head(portfolio_clean[!is.na(portfolio_clean$phone_number),
                     c("phone_number", "phone_clean", "zip", "zip_clean")])
#>        phone_number  phone_clean        zip zip_clean
#> 1      512.375.2067 512-375-2067 75219-9418     75219
#> 2    (713) 891-0940 713-891-0940 78701 4888     78701
#> 3 +1 (361) 882-5883 361-882-5883 77005-7098     77005
#> 4 +1 (817) 622-3340 817-622-3340 73102 7081     73102
#> 5       361-4636998 361-463-6998     77005      77005
#> 6      409/512-0230 409-512-0230 75099-3876     75099
```

## Handling Invalid Values

Both normalization functions return `NA` by default for invalid values.
You can customize this:

``` r
invalid_phones <- c("123", "not-a-phone", "")

# Default - returns NA
normalize_phone(invalid_phones)
#> [1] NA NA NA

# Custom invalid value
normalize_phone(invalid_phones, invalid = "INVALID")
#> [1] "INVALID" "INVALID" "INVALID"
```

## Summary

| Function                                                                                | Purpose                         | Key Options                                     |
|-----------------------------------------------------------------------------------------|---------------------------------|-------------------------------------------------|
| [`normalize_phone()`](https://mattfarrow1.github.io/fundr/reference/normalize_phone.md) | Standardize phone numbers       | `format`, `strict`, `allow_7`, `keep_extension` |
| [`normalize_zip()`](https://mattfarrow1.github.io/fundr/reference/normalize_zip.md)     | Standardize ZIP codes           | `format`, `strict`                              |
| [`to_snake_case()`](https://mattfarrow1.github.io/fundr/reference/to_snake_case.md)     | Convert to snake_case           | \-                                              |
| [`to_title_case()`](https://mattfarrow1.github.io/fundr/reference/to_title_case.md)     | Convert to Title Case           | \-                                              |
| [`to_camel_case()`](https://mattfarrow1.github.io/fundr/reference/to_camel_case.md)     | Convert to camelCase            | \-                                              |
| [`convert_names()`](https://mattfarrow1.github.io/fundr/reference/convert_names.md)     | Convert data frame column names | `to`                                            |
