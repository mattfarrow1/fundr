# Changelog

## fundr 0.3.0

### New Features

#### Flexible Gift and Rating Level Presets

- **[`gift_levels()`](https://mattfarrow1.github.io/fundr/reference/gift_levels.md)**:
  New helper function to get gift level presets appropriate for
  different organization sizes:

  - `"small"`: Annual fund focus, thresholds from \$1 to \$100K
  - `"medium"`: Leadership/major gifts, thresholds from \$1K to \$1M
  - `"large"`: Principal gifts, thresholds from \$100K to \$150M+
  - `"all"`: Comprehensive (all thresholds)
  - Also supports custom threshold selection via `include` parameter

- **[`rating_levels()`](https://mattfarrow1.github.io/fundr/reference/rating_levels.md)**:
  New helper function for rating level presets with
  organization-appropriate bucket assignments:

  - `"small"`: Major at \$25K+, Principal at \$250K+ (community
    foundations)
  - `"medium"`: Major at \$50K+, Principal at \$1M+ (mid-size orgs)
  - `"large"`: Major at \$100K+, Principal at \$5M+ (universities,
    hospitals)
  - Supports custom bucket mapping via `bucket_map` parameter

- **[`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md)**
  and
  **[`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md)**
  now accept preset strings directly:

  ``` r
  bucket_gift_level(amounts, levels = "small")
  bucket_rating_level(ratings, levels = "small")
  ```

#### Expanded Reference Data

- **`fundr_gift_levels`**: Now contains 23 comprehensive thresholds (up
  from 14), covering the full range from \$100 to \$150M+. Added
  thresholds: \$100, \$250, \$500, \$1K, \$2.5K, \$5K, \$10K, \$25K,
  \$50K.

- **`fundr_rating_levels`**: Now contains 16 thresholds (up from 15),
  with an additional \$5K threshold for more granularity at lower
  capacity levels.

#### Enhanced Donor Status Classification

- **[`donor_status()`](https://mattfarrow1.github.io/fundr/reference/donor_status.md)**
  gains two new parameters for greater flexibility:
  - `sybunt_years`: Control the SYBUNT window independently from
    `lapsed_years`. Default maintains backward compatibility (SYBUNT = 2
    to lapsed_years).
  - `labels`: Named character vector to customize status terminology
    (e.g., `c("Active" = "Current", "Never" = "Non-Donor")`).

### Documentation

- Updated “Bucketing Levels” vignette with comprehensive preset examples
  and comparison table.
- Updated “Donor Analytics” vignette with new
  [`donor_status()`](https://mattfarrow1.github.io/fundr/reference/donor_status.md)
  parameters.
- Improved function documentation with more examples.

------------------------------------------------------------------------

## fundr 0.2.0

### New Features

#### Sample Data

- Added `fundr_portfolio`, a synthetic dataset of 10,000 constituent
  records for demonstrating package functions and learning R/tidyverse.
  Includes realistic data quality variations (mixed date formats, varied
  phone/ZIP formatting, missing values).

#### Vignettes

- Added comprehensive vignettes covering key package functionality:
  - “Getting Started with fundr” - package overview
  - “Fiscal Years and Dates” - fiscal year functions and date utilities
  - “Donor Analytics” - donor classification and giving analysis
  - “Data Cleaning” - phone/ZIP normalization and case conversion
  - “Visualization” - themes, colors, and currency scales
  - “Bucketing Levels” - gift and rating level bucketing

#### Documentation

- Improved function documentation with more examples across all modules.
- Added package logo.

## fundr 0.1.0

### New Features

#### Donor Analytics

- [`calc_age()`](https://mattfarrow1.github.io/fundr/reference/calc_age.md)
  calculates constituent age from birth date.
- [`donor_status()`](https://mattfarrow1.github.io/fundr/reference/donor_status.md)
  classifies donors as Active/LYBUNT/SYBUNT/Lapsed/Never based on fiscal
  year giving.
- [`years_since()`](https://mattfarrow1.github.io/fundr/reference/years_since.md)
  computes years elapsed since a date.
- [`total_giving_years()`](https://mattfarrow1.github.io/fundr/reference/total_giving_years.md)
  and
  [`consecutive_giving_years()`](https://mattfarrow1.github.io/fundr/reference/consecutive_giving_years.md)
  track donor giving streaks.

#### Formatting

- [`format_currency()`](https://mattfarrow1.github.io/fundr/reference/format_currency.md)
  formats numbers as currency with thousands separators.
- [`format_currency_short()`](https://mattfarrow1.github.io/fundr/reference/format_currency_short.md)
  uses K/M/B suffixes for compact display.
- [`format_pct()`](https://mattfarrow1.github.io/fundr/reference/format_pct.md)
  formats numbers as percentages.

#### Date Utilities

- [`date_interval()`](https://mattfarrow1.github.io/fundr/reference/date_interval.md)
  calculates time between dates.
- [`bucket_recency()`](https://mattfarrow1.github.io/fundr/reference/bucket_recency.md)
  buckets dates by recency categories.
- [`is_within()`](https://mattfarrow1.github.io/fundr/reference/is_within.md)
  checks if a date falls within a time period.
- [`last_weekday()`](https://mattfarrow1.github.io/fundr/reference/last_weekday.md)
  and
  [`next_weekday()`](https://mattfarrow1.github.io/fundr/reference/next_weekday.md)
  find specific weekdays.
- [`weekday_name()`](https://mattfarrow1.github.io/fundr/reference/weekday_name.md)
  returns the name of a weekday.

#### Partial Dates

- [`parse_partial_date()`](https://mattfarrow1.github.io/fundr/reference/parse_partial_date.md)
  handles year-only and year-month dates.
- [`calc_age_partial()`](https://mattfarrow1.github.io/fundr/reference/calc_age_partial.md)
  calculates age from partial birth dates.
- [`date_precision()`](https://mattfarrow1.github.io/fundr/reference/date_precision.md)
  determines the precision of a date value.

#### File Utilities

- [`latest_file()`](https://mattfarrow1.github.io/fundr/reference/latest_file.md)
  finds the most recent file in a directory.
- [`read_latest()`](https://mattfarrow1.github.io/fundr/reference/read_latest.md)
  reads the most recent file matching a pattern.
- [`list_recent_files()`](https://mattfarrow1.github.io/fundr/reference/list_recent_files.md)
  lists files sorted by modification time.

#### Data Normalization

- [`normalize_phone()`](https://mattfarrow1.github.io/fundr/reference/normalize_phone.md)
  cleans and standardizes phone numbers.
- [`normalize_zip()`](https://mattfarrow1.github.io/fundr/reference/normalize_zip.md)
  cleans and standardizes ZIP codes.

#### Case Conversion

- [`to_snake_case()`](https://mattfarrow1.github.io/fundr/reference/to_snake_case.md),
  [`to_title_case()`](https://mattfarrow1.github.io/fundr/reference/to_title_case.md),
  [`to_camel_case()`](https://mattfarrow1.github.io/fundr/reference/to_camel_case.md)
  convert strings between formats.
- [`convert_names()`](https://mattfarrow1.github.io/fundr/reference/convert_names.md)
  converts column names to a specified case.

#### Bucketing Functions

- [`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md)
  maps gift amounts to categorical levels.
- [`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md)
  maps wealth ratings to categorical levels.
- Added `fundr_gift_levels` and `fundr_rating_levels` reference
  datasets.

#### Color Palettes

- [`fundr_colors()`](https://mattfarrow1.github.io/fundr/reference/fundr_colors.md)
  provides named hex colors.
- [`fundr_palette()`](https://mattfarrow1.github.io/fundr/reference/fundr_palette.md)
  returns palette vectors (primary, secondary, tertiary).
- [`scale_fill_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_fill_fundr.md)
  and
  [`scale_colour_fundr()`](https://mattfarrow1.github.io/fundr/reference/scale_colour_fundr.md)
  for ggplot2 discrete scales.

#### Currency Scales

- [`scale_y_currency()`](https://mattfarrow1.github.io/fundr/reference/scale_y_currency.md)
  and
  [`scale_x_currency()`](https://mattfarrow1.github.io/fundr/reference/scale_x_currency.md)
  format ggplot2 axes as currency.
- Support compact format via `short = TRUE` parameter.

#### SKY API Integration

- [`sky_connect()`](https://mattfarrow1.github.io/fundr/reference/sky_connect.md)
  establishes connection to Blackbaud SKY API.
- [`sky_get()`](https://mattfarrow1.github.io/fundr/reference/sky_get.md)
  and
  [`sky_get_all()`](https://mattfarrow1.github.io/fundr/reference/sky_get_all.md)
  fetch data from SKY API endpoints.
- [`sky_test()`](https://mattfarrow1.github.io/fundr/reference/sky_test.md)
  tests API connection.

#### Database Helpers

- [`db_connect()`](https://mattfarrow1.github.io/fundr/reference/db_connect.md)
  connects to SQL Server, PostgreSQL, MySQL, or SQLite.
- [`db_query()`](https://mattfarrow1.github.io/fundr/reference/db_query.md)
  executes queries and returns results.
- [`db_test()`](https://mattfarrow1.github.io/fundr/reference/db_test.md)
  tests database connection.

#### Utilities

- `%notin%` and `%!in%` operators for negated `%in%`.
- [`comment_block()`](https://mattfarrow1.github.io/fundr/reference/comment_block.md),
  [`comment_header()`](https://mattfarrow1.github.io/fundr/reference/comment_header.md),
  [`comment_divider()`](https://mattfarrow1.github.io/fundr/reference/comment_divider.md)
  format code comments.
- [`fundr_setup()`](https://mattfarrow1.github.io/fundr/reference/fundr_setup.md)
  configures R session for fundraising work.

#### Plotting

- [`theme_fundr()`](https://mattfarrow1.github.io/fundr/reference/theme_fundr.md)
  provides a clean ggplot2 theme.
- [`fundr_use_google_font()`](https://mattfarrow1.github.io/fundr/reference/fundr_use_google_font.md)
  loads Google Fonts for plots.
- [`legend_bottom()`](https://mattfarrow1.github.io/fundr/reference/legend_bottom.md)
  and
  [`legend_position()`](https://mattfarrow1.github.io/fundr/reference/legend_position.md)
  helpers for legend placement.

### Internal

- Added `fundr_needs()` for runtime dependency checking with helpful
  error messages.
- Zero required dependencies for core functions; optional packages
  enhance features.

## fundr 0.0.0.9000

- Initial development version.
- Added fiscal year helpers:
  [`fy_year()`](https://mattfarrow1.github.io/fundr/reference/fy_year.md),
  [`fy_quarter()`](https://mattfarrow1.github.io/fundr/reference/fy_quarter.md),
  [`fy_label()`](https://mattfarrow1.github.io/fundr/reference/fy_label.md).
- Added optional Google Fonts helper:
  [`fundr_use_google_font()`](https://mattfarrow1.github.io/fundr/reference/fundr_use_google_font.md).
- Added ggplot2 theme:
  [`theme_fundr()`](https://mattfarrow1.github.io/fundr/reference/theme_fundr.md).
