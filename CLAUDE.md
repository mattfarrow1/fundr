# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Please reference Sarah Johnson's [Modern R Development Guide](https://gist.githubusercontent.com/sj-io/3828d64d0969f2a0f05297e59e6c15ad/raw/cbbd46f7ca76cb3aa5758a74341bff3c8d960ea3/CLAUDE.md) for best practices with R code and the Tidyverse.

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
