# Changelog

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

------------------------------------------------------------------------

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
