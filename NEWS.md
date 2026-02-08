# fundr 0.1.0

## New Features

### Donor Analytics
- `calc_age()` calculates constituent age from birth date.
- `donor_status()` classifies donors as Active/LYBUNT/SYBUNT/Lapsed/Never based on fiscal year giving.
- `years_since()` computes years elapsed since a date.
- `total_giving_years()` and `consecutive_giving_years()` track donor giving streaks.

### Formatting
- `format_currency()` formats numbers as currency with thousands separators.
- `format_currency_short()` uses K/M/B suffixes for compact display.
- `format_pct()` formats numbers as percentages.

### Date Utilities
- `date_interval()` calculates time between dates.
- `bucket_recency()` buckets dates by recency categories.
- `is_within()` checks if a date falls within a time period.
- `last_weekday()` and `next_weekday()` find specific weekdays.
- `weekday_name()` returns the name of a weekday.

### Partial Dates
- `parse_partial_date()` handles year-only and year-month dates.
- `calc_age_partial()` calculates age from partial birth dates.
- `date_precision()` determines the precision of a date value.

### File Utilities
- `latest_file()` finds the most recent file in a directory.
- `read_latest()` reads the most recent file matching a pattern.
- `list_recent_files()` lists files sorted by modification time.

### Data Normalization
- `normalize_phone()` cleans and standardizes phone numbers.
- `normalize_zip()` cleans and standardizes ZIP codes.

### Case Conversion
- `to_snake_case()`, `to_title_case()`, `to_camel_case()` convert strings between formats.
- `convert_names()` converts column names to a specified case.

### Bucketing Functions
- `bucket_gift_level()` maps gift amounts to categorical levels.
- `bucket_rating_level()` maps wealth ratings to categorical levels.
- Added `fundr_gift_levels` and `fundr_rating_levels` reference datasets.

### Color Palettes
- `fundr_colors()` provides named hex colors.
- `fundr_palette()` returns palette vectors (primary, secondary, tertiary).
- `scale_fill_fundr()` and `scale_colour_fundr()` for ggplot2 discrete scales.

### Currency Scales
- `scale_y_currency()` and `scale_x_currency()` format ggplot2 axes as currency.
- Support compact format via `short = TRUE` parameter.

### SKY API Integration
- `sky_connect()` establishes connection to Blackbaud SKY API.
- `sky_get()` and `sky_get_all()` fetch data from SKY API endpoints.
- `sky_test()` tests API connection.

### Database Helpers
- `db_connect()` connects to SQL Server, PostgreSQL, MySQL, or SQLite.
- `db_query()` executes queries and returns results.
- `db_test()` tests database connection.

### Utilities
- `%notin%` and `%!in%` operators for negated `%in%`.
- `comment_block()`, `comment_header()`, `comment_divider()` format code comments.
- `fundr_setup()` configures R session for fundraising work.

### Plotting
- `theme_fundr()` provides a clean ggplot2 theme.
- `fundr_use_google_font()` loads Google Fonts for plots.
- `legend_bottom()` and `legend_position()` helpers for legend placement.

## Internal
- Added `fundr_needs()` for runtime dependency checking with helpful error messages.
- Zero required dependencies for core functions; optional packages enhance features.

---
# fundr 0.0.0.9000

- Initial development version.
- Added fiscal year helpers: `fy_year()`, `fy_quarter()`, `fy_label()`.
- Added optional Google Fonts helper: `fundr_use_google_font()`.
- Added ggplot2 theme: `theme_fundr()`.
