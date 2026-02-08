# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

fundr is an R package providing lightweight, tidyverse-compatible utilities for fundraising and advancement analytics. The package has minimal required dependencies (only base R for core functions) with optional dependencies for plotting features.

## Development Commands

```r
# Run all tests
devtools::test()

# Run a single test file
testthat::test_file("tests/testthat/test-fy_year.R")

# Check package (runs R CMD check)
devtools::check()

# Build documentation
devtools::document()

# Install package locally
devtools::install()

# Build pkgdown site
pkgdown::build_site()
```

## Architecture

### Dependency Philosophy

Core functions have zero dependencies beyond base R. Optional features (plotting, fonts) use suggested packages and check availability at runtime via `fundr_needs()` in `R/zzz-deps.R`. This pattern allows the package to work in minimal environments while offering enhanced features when packages like ggplot2, showtext, and sysfonts are installed.

### Key Modules

- **Fiscal Year Functions** (`R/fiscal_year.R`): `fy_year()`, `fy_label()`, `fy_quarter()` - Convert dates to fiscal year representations. Default fiscal year starts in July (month 7).

- **Data Normalization** (`R/normalize_phone.R`, `R/normalize_zip.R`): Clean and standardize phone numbers and ZIP codes. Both support strict/lenient parsing modes.

- **Session Setup** (`R/setup.R`): `fundr_setup()` - Configure R session for fundraising work. Disables scientific notation so large dollar amounts display properly.

- **Formatting** (`R/format.R`): `format_currency()`, `format_currency_short()`, `format_pct()` - Format numbers as currency strings with proper thousands separators. Short format uses K/M/B suffixes for compact display.

- **Donor Analytics** (`R/donor.R`): `calc_age()`, `donor_status()`, `years_since()`, `total_giving_years()`, `consecutive_giving_years()` - Calculate constituent age, classify donors as Active/LYBUNT/SYBUNT/Lapsed/Never based on fiscal year giving, compute years since a date, and track giving streaks.

- **Bucketing Functions** (`R/buckets.R`): `bucket_gift_level()`, `bucket_rating_level()` - Map numeric values to categorical levels using reference data tables. Uses `findInterval()` for threshold matching. Reference data stored in `data/` as `.rda` files.

- **Color Palettes** (`R/colors.R`): `fundr_colors()`, `fundr_palette()`, `scale_fill_fundr()`, `scale_colour_fundr()` - Named hex colors and ggplot2 discrete scales. Three palettes: primary (2 colors), secondary (10 colors), tertiary (4 colors).

- **Currency Scales** (`R/scales.R`): `scale_y_currency()`, `scale_x_currency()` - ggplot2 continuous scales that format axis labels as currency. Supports full format ($1,234,567) and compact format ($1.2M) via `short = TRUE`.

- **Plotting** (`R/theme_fundr.R`, `R/fonts.R`): ggplot2 theme and Google Fonts integration. These require suggested packages (ggplot2, showtext, sysfonts). Includes `legend_bottom()` and `legend_position()` helpers.

- **Partial Dates** (`R/partial_date.R`): `parse_partial_date()`, `calc_age_partial()`, `date_precision()` - Handle year-only and year-month dates commonly seen with birth dates.

- **Date Utilities** (`R/date_utils.R`): `date_interval()`, `bucket_recency()`, `is_within()`, `last_weekday()`, `next_weekday()`, `weekday_name()` - Calculate time between dates, bucket by recency, and find specific weekdays.

- **File Utilities** (`R/files.R`): `latest_file()`, `read_latest()`, `list_recent_files()` - Find and read the most recent files in a directory.

- **Case Conversion** (`R/case_convert.R`): `to_snake_case()`, `to_title_case()`, `to_camel_case()`, `convert_names()` - Convert strings and column names between case formats.

- **Utilities** (`R/utils.R`): `%notin%`, `%!in%`, `comment_block()`, `comment_header()`, `comment_divider()` - Convenience operators and comment formatting helpers.

- **SKY API** (`R/sky_api.R`): `sky_connect()`, `sky_get()`, `sky_get_all()`, `sky_test()` - Integration with Blackbaud SKY API for Raiser's Edge NXT. Requires httr and jsonlite.

- **Database** (`R/database.R`): `db_connect()`, `db_query()`, `db_test()` - Database connection helpers for SQL Server, PostgreSQL, MySQL, and SQLite.

### Reference Data

- `fundr_gift_levels` - Thresholds for donor giving levels (e.g., "$1,000,000+")
- `fundr_rating_levels` - Thresholds for wealth/capacity ratings (e.g., "A - $100M+")

Data preparation scripts are in `data-raw/`. Run them to regenerate `.rda` files after changes.

### Design Patterns

- All functions are fully vectorized and handle NA values gracefully
- Bucketing functions preserve factor levels/ordering from source data
- Optional dependencies checked at runtime via `fundr_needs()` with helpful error messages
- Functions return character vectors by default; factors returned when source column is a factor

### Testing

Tests use testthat (edition 3). Test files mirror the structure of `R/` files in `tests/testthat/`.

## Feature Wishlist

### [P0] High Priority

- [x] Add support for handling dates that are only year & month or just years. These are most commonly seen with birth dates. → `parse_partial_date()`, `calc_age_partial()`, `date_precision()`
- [x] Add code to calculate the time period (days, months, years) between two dates. Most frequently this will be used between a date in the past and today. → `date_interval()`
- [x] Add code to put dates into buckets by their recency (this year, last year, last **n** years). This should have an option to calculate by calendar year or fiscal year. → `bucket_recency()`, `is_within()`
- [x] Add code for reading the most recent file inside a specified folder → `latest_file()`, `read_latest()`, `list_recent_files()`

### [P1] Medium Priority

- [x] Add code to reformat large numbers with "K", "B", and "M" as appropriate. → Already exists: `format_currency_short()`
- [x] Add code to calculate the total number of years of giving → `total_giving_years()`
- [x] Add code to calculate the number of consecutive years of giving, going back from the last fiscal year. → `consecutive_giving_years()`
- [x] Add code for calculating a specific day of the week. For example, my SQL databases refresh on Fridays. I often want to use that date in the file names the analyses I'm saving out so I know when the data is from. → `last_weekday()`, `next_weekday()`, `weekday_name()`
- [x] While the default for my fiscal year scripts is to use July as the start year, my personal fiscal year starts in January. Is there way to support that? Perhaps in `setup.R`? → `fundr_setup(fy_start_month = 1)`, `get_fy_start_month()`, `set_fy_start_month()`
- [x] Add functionality to convert column names to and from snake_case and TitleCase → `to_snake_case()`, `to_title_case()`, `to_camel_case()`, `convert_names()`
- [x] Add code for putting the legend on the bottom of a plot with a ggplot object → `legend_bottom()`, `legend_position()`

### [P2] Low Priority

- [x] Add code for pulling data from SKY API → `sky_connect()`, `sky_get()`, `sky_get_all()`, `sky_test()`
- [x] Add code for building database connections → `db_connect()`, `db_query()`, `db_test()`
- [x] Add shortcut code for "not in" → `%notin%`, `%!in%`
- [x] Add commenting formatting (ala monospaced) → `comment_block()`, `comment_header()`, `comment_divider()`
