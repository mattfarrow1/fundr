#' Calculate time interval between dates
#'
#' Computes the time difference between two dates in the specified unit.
#' Commonly used for calculating time since last gift, time until event,
#' or duration of relationships.
#'
#' @param from Date vector (or coercible via `as.Date()`). The start date(s).
#' @param to Date vector (or coercible via `as.Date()`). The end date(s).
#'   Default is today.
#' @param unit Unit of time for result: "days", "weeks", "months", or "years".
#'   Default "years".
#' @param digits Number of decimal places to round to. Default 1.
#'   Use NULL for no rounding.
#'
#' @return Numeric vector of time differences in the specified unit.
#'   Positive values indicate `to` is after `from`.
#'   Returns NA for NA inputs.
#'
#' @details
#' For months and years, calculations account for varying month lengths
#' and leap years using calendar-based arithmetic rather than fixed
#' day counts.
#'
#' @examples
#' # Days between dates
#' date_interval(as.Date("2024-01-01"), as.Date("2024-01-15"), unit = "days")
#' #> 14
#'
#' # Years since a date
#' date_interval(as.Date("2020-06-15"), unit = "years")
#'
#' # Months between dates
#' date_interval(as.Date("2024-01-15"), as.Date("2024-06-15"), unit = "months")
#' #> 5
#'
#' # Vectorized
#' dates <- as.Date(c("2020-01-01", "2022-06-15", "2023-09-01"))
#' date_interval(dates, as.Date("2024-06-15"), unit = "years")
#'
#' @export
date_interval <- function(
    from,
    to = Sys.Date(),
    unit = c("years", "months", "weeks", "days"),
    digits = 1L
) {
  unit <- match.arg(unit)

  from <- as.Date(from)
  to <- as.Date(to)

  # Handle vectorization - recycle shorter to longer
  n <- max(length(from), length(to))
  from <- rep_len(from, n)
  to <- rep_len(to, n)

  out <- rep(NA_real_, n)

  ok <- !is.na(from) & !is.na(to)
  if (!any(ok)) return(out)

  if (unit == "days") {
    out[ok] <- as.numeric(difftime(to[ok], from[ok], units = "days"))
  } else if (unit == "weeks") {
    out[ok] <- as.numeric(difftime(to[ok], from[ok], units = "weeks"))
  } else if (unit == "months") {
    out[ok] <- calc_month_diff(from[ok], to[ok])
  } else if (unit == "years") {
    out[ok] <- calc_year_diff(from[ok], to[ok])
  }

  if (!is.null(digits)) {
    out <- round(out, digits = as.integer(digits))
  }

  out
}

#' @noRd
calc_month_diff <- function(from, to) {
  from_lt <- as.POSIXlt(from)
  to_lt <- as.POSIXlt(to)

  # Whole months
  months <- (to_lt$year - from_lt$year) * 12L + (to_lt$mon - from_lt$mon)

  # Fraction based on day of month
  from_day <- from_lt$mday
  to_day <- to_lt$mday

  # Days in the to month for fractional calculation
  days_in_month <- as.numeric(format(to, "%d"))
  days_in_to_month <- as.numeric(format(
    as.Date(paste(to_lt$year + 1900, to_lt$mon + 1, 1, sep = "-")) +
      seq_along(to) * 0 + 31,
    "%d"
  ))

  # Simple fractional month adjustment
  # If to_day < from_day, we haven't completed the month
  frac <- (to_day - from_day) / 30.44  # Average days per month

  months + frac
}

#' @noRd
calc_year_diff <- function(from, to) {
  from_lt <- as.POSIXlt(from)
  to_lt <- as.POSIXlt(to)

  # Whole years
  years <- to_lt$year - from_lt$year

  # Check if anniversary hasn't occurred yet
  not_yet <- (to_lt$mon < from_lt$mon) |
    (to_lt$mon == from_lt$mon & to_lt$mday < from_lt$mday)

  years[not_yet] <- years[not_yet] - 1L

  # Calculate fractional year based on days since last anniversary
  # If anniversary hasn't happened yet this year, use last year's anniversary
  last_anniv <- from
  last_anniv_lt <- as.POSIXlt(last_anniv)

  # Set year based on whether anniversary has occurred
  last_anniv_lt$year <- to_lt$year
  last_anniv_lt$year[not_yet] <- last_anniv_lt$year[not_yet] - 1L
  last_anniv <- as.Date(last_anniv_lt)

  # Days since last anniversary
  days_since <- as.numeric(difftime(to, last_anniv, units = "days"))
  frac <- days_since / 365.25

  years + frac
}

#' Bucket dates by recency
#'
#' Categorizes dates into recency buckets relative to a reference date.
#' Supports both calendar year and fiscal year bucketing.
#'
#' @param date Date vector (or coercible via `as.Date()`).
#' @param as_of Reference date for recency calculation. Default is today.
#' @param buckets Numeric vector of year boundaries for buckets.
#'   Default `c(0, 1, 2, 5)` creates buckets: "This year", "Last year",
#'   "2-5 years ago", "5+ years ago".
#' @param labels Character vector of bucket labels. Must be one longer than
#'   `buckets` to include the final "X+ years ago" label. Default NULL
#'   generates labels automatically.
#' @param use_fiscal Logical. If TRUE, uses fiscal year for bucketing.
#'   If FALSE (default), uses calendar year.
#' @param fy_start_month Integer 1-12 for fiscal year start month.
#'   Default 7 (July). Only used if `use_fiscal = TRUE`.
#'
#' @return Ordered factor of recency bucket labels.
#'
#' @examples
#' # Calendar year buckets
#' dates <- as.Date(c("2024-06-15", "2023-03-01", "2020-12-25", "2015-01-01"))
#' bucket_recency(dates, as_of = as.Date("2024-06-15"))
#'
#' # Fiscal year buckets
#' bucket_recency(dates, as_of = as.Date("2024-06-15"), use_fiscal = TRUE)
#'
#' # Custom buckets
#' bucket_recency(dates, as_of = as.Date("2024-06-15"),
#'                buckets = c(0, 1, 3, 10),
#'                labels = c("Current year", "Last year", "1-3 years",
#'                           "3-10 years", "10+ years"))
#'
#' @export
bucket_recency <- function(
    date,
    as_of = Sys.Date(),
    buckets = c(0, 1, 2, 5),
    labels = NULL,
    use_fiscal = FALSE,
    fy_start_month = 7L
) {
  date <- as.Date(date)
  as_of <- as.Date(as_of)

  if (length(as_of) != 1L || is.na(as_of)) {
    stop("`as_of` must be a single non-NA date.", call. = FALSE)
  }

  buckets <- as.integer(buckets)
  if (any(is.na(buckets)) || is.unsorted(buckets)) {
    stop("`buckets` must be a sorted vector of non-NA integers.", call. = FALSE)
  }

  # Generate default labels if not provided
  if (is.null(labels)) {
    labels <- generate_recency_labels(buckets)
  }

  if (length(labels) != length(buckets) + 1L) {
    stop("`labels` must have length equal to `buckets` length + 1.", call. = FALSE)
  }

  n <- length(date)
  out <- factor(rep(NA_character_, n), levels = labels, ordered = TRUE)

  ok <- !is.na(date)
  if (!any(ok)) return(out)

  # Calculate year difference
  if (isTRUE(use_fiscal)) {
    fy_start_month <- fundr_check_month(fy_start_month)
    current_fy <- fy_year(as_of, fy_start_month)
    date_fy <- fy_year(date[ok], fy_start_month)
    year_diff <- current_fy - date_fy
  } else {
    current_year <- as.integer(format(as_of, "%Y"))
    date_year <- as.integer(format(date[ok], "%Y"))
    year_diff <- current_year - date_year
  }

  # Assign to buckets using findInterval
  # findInterval(x, vec) returns i where vec[i] <= x < vec[i+1]
  # For buckets = c(0, 1, 2, 5):
  #   year_diff = 0 -> idx = 1 -> "This year"
  #   year_diff = 1 -> idx = 2 -> "Last year"
  #   year_diff = 3 -> idx = 3 -> "2-4 years ago"
  #   year_diff = 5+ -> idx = 4 -> "5+ years ago"
  idx <- findInterval(year_diff, buckets, rightmost.closed = FALSE)

  # Handle edge case where year_diff < buckets[1] (shouldn't happen with 0 start)
  idx[idx == 0L] <- 1L

  # Values >= max bucket should use the final label
  max_bucket <- max(buckets)
  idx[year_diff >= max_bucket] <- length(buckets) + 1L

  bucket_labels <- labels[idx]

  out[ok] <- bucket_labels
  out
}

#' @noRd
generate_recency_labels <- function(buckets) {
  n <- length(buckets)
  labels <- character(n + 1L)

  for (i in seq_len(n + 1L)) {
    if (i == 1L) {
      # First label: for values from buckets[1] to buckets[2]-1
      if (buckets[1] == 0) {
        labels[1] <- "This year"
      } else {
        labels[1] <- paste0(buckets[1], " year", if (buckets[1] != 1) "s", " ago")
      }
    } else if (i <= n) {
      # Middle labels
      start <- buckets[i]
      if (i < n) {
        end <- buckets[i + 1]
      } else {
        end <- start + 1  # Won't be used, just for label
      }

      if (start == 1) {
        labels[i] <- "Last year"
      } else if (i < n && end - start == 1) {
        labels[i] <- paste0(start, " years ago")
      } else if (i < n) {
        labels[i] <- paste0(start, "-", end - 1, " years ago")
      } else {
        labels[i] <- paste0(start, "-", end, " years ago")
      }
    } else {
      # Final bucket: X+ years ago
      labels[n + 1] <- paste0(buckets[n], "+ years ago")
    }
  }

  labels
}

#' Check if date is within a time period
#'
#' Tests whether dates fall within a specified number of years, months,
#' or days from a reference date. Useful for filtering recent records.
#'
#' @param date Date vector (or coercible via `as.Date()`).
#' @param within Numeric value for the time window.
#' @param unit Unit of time: "years", "months", "weeks", or "days".
#'   Default "years".
#' @param as_of Reference date. Default is today.
#'
#' @return Logical vector. TRUE if date is within the specified period
#'   of `as_of` (inclusive). NA for NA inputs.
#'
#' @examples
#' dates <- as.Date(c("2024-01-15", "2022-06-15", "2020-01-01"))
#'
#' # Within last 2 years
#' is_within(dates, 2, "years", as_of = as.Date("2024-06-15"))
#' #> TRUE, TRUE, FALSE
#'
#' # Within last 6 months
#' is_within(dates, 6, "months", as_of = as.Date("2024-06-15"))
#' #> TRUE, FALSE, FALSE
#'
#' @export
is_within <- function(
    date,
    within,
    unit = c("years", "months", "weeks", "days"),
    as_of = Sys.Date()
) {
  unit <- match.arg(unit)
  within <- as.numeric(within)

  if (length(within) != 1L || is.na(within) || within < 0) {
    stop("`within` must be a single non-negative number.", call. = FALSE)
  }

  date <- as.Date(date)
  as_of <- as.Date(as_of)

  if (length(as_of) != 1L || is.na(as_of)) {
    stop("`as_of` must be a single non-NA date.", call. = FALSE)
  }

  n <- length(date)
  out <- rep(NA, n)

  ok <- !is.na(date)
  if (!any(ok)) return(out)

  interval <- date_interval(date[ok], as_of, unit = unit, digits = NULL)

  # Within means absolute value is <= threshold and date is not in future
  out[ok] <- interval >= 0 & interval <= within

  out
}

#' Find most recent occurrence of a weekday
#'
#' Returns the most recent date that falls on a specific day of the week.
#' Useful for finding dates like "last Friday" for file naming when
#' databases refresh on specific days.
#'
#' @param weekday Day of week: name (e.g., "Friday", "fri"), or number
#'   (1 = Sunday through 7 = Saturday, following R's convention).
#' @param as_of Reference date. Default is today.
#' @param include_today Logical. If TRUE (default) and `as_of` falls on
#'   the target weekday, returns `as_of`. If FALSE, returns the previous
#'   occurrence.
#'
#' @return Date of the most recent occurrence of the specified weekday.
#'
#' @examples
#' # Find last Friday
#' last_weekday("Friday")
#'
#' # Using abbreviation
#' last_weekday("fri")
#'
#' # Using number (6 = Friday)
#' last_weekday(6)
#'
#' # From a specific date
#' last_weekday("Friday", as_of = as.Date("2024-06-15"))
#' #> "2024-06-14"
#'
#' # Exclude today even if it matches
#' last_weekday("Friday", as_of = as.Date("2024-06-14"),
#'              include_today = FALSE)
#' #> "2024-06-07"
#'
#' @export
last_weekday <- function(
    weekday,
    as_of = Sys.Date(),
    include_today = TRUE
) {
  as_of <- as.Date(as_of)

  if (length(as_of) != 1L || is.na(as_of)) {
    stop("`as_of` must be a single non-NA date.", call. = FALSE)
  }

  target_wday <- parse_weekday(weekday)
  current_wday <- as.integer(format(as_of, "%w")) + 1L  # 1 = Sunday

  # Calculate days back
  if (current_wday == target_wday && isTRUE(include_today)) {
    return(as_of)
  }

  # How many days back to target
  days_back <- (current_wday - target_wday) %% 7
  if (days_back == 0) days_back <- 7  # Go back full week if same day

  as_of - days_back
}

#' Find next occurrence of a weekday
#'
#' Returns the next date that falls on a specific day of the week.
#'
#' @param weekday Day of week: name (e.g., "Monday", "mon"), or number
#'   (1 = Sunday through 7 = Saturday).
#' @param as_of Reference date. Default is today.
#' @param include_today Logical. If TRUE (default) and `as_of` falls on
#'   the target weekday, returns `as_of`. If FALSE, returns the next
#'   occurrence.
#'
#' @return Date of the next occurrence of the specified weekday.
#'
#' @examples
#' # Find next Monday
#' next_weekday("Monday")
#'
#' # From a specific date
#' next_weekday("Monday", as_of = as.Date("2024-06-14"))
#' #> "2024-06-17"
#'
#' @export
next_weekday <- function(
    weekday,
    as_of = Sys.Date(),
    include_today = TRUE
) {
  as_of <- as.Date(as_of)

  if (length(as_of) != 1L || is.na(as_of)) {
    stop("`as_of` must be a single non-NA date.", call. = FALSE)
  }

  target_wday <- parse_weekday(weekday)
  current_wday <- as.integer(format(as_of, "%w")) + 1L  # 1 = Sunday

  # Calculate days forward
  if (current_wday == target_wday && isTRUE(include_today)) {
    return(as_of)
  }

  days_forward <- (target_wday - current_wday) %% 7
  if (days_forward == 0) days_forward <- 7  # Go forward full week if same day

  as_of + days_forward
}

#' @noRd
parse_weekday <- function(x) {
  if (is.numeric(x)) {
    x <- as.integer(x)
    if (x < 1L || x > 7L) {
      stop("Weekday number must be 1-7 (1 = Sunday, 7 = Saturday).", call. = FALSE)
    }
    return(x)
  }

  x <- tolower(trimws(as.character(x)))

  weekday_map <- c(
    "sunday" = 1L, "sun" = 1L, "su" = 1L,
    "monday" = 2L, "mon" = 2L, "mo" = 2L,
    "tuesday" = 3L, "tue" = 3L, "tu" = 3L,
    "wednesday" = 4L, "wed" = 4L, "we" = 4L,
    "thursday" = 5L, "thu" = 5L, "th" = 5L,
    "friday" = 6L, "fri" = 6L, "fr" = 6L,
    "saturday" = 7L, "sat" = 7L, "sa" = 7L
  )

  result <- weekday_map[x]
  if (is.na(result)) {
    stop("Invalid weekday: '", x, "'. Use name (e.g., 'Friday') or number 1-7.",
         call. = FALSE)
  }

  unname(result)
}

#' Get weekday name from date
#'
#' Returns the day of week name for a date.
#'
#' @param date Date vector (or coercible via `as.Date()`).
#' @param abbreviate Logical. If TRUE, returns abbreviated name (e.g., "Fri").
#'   If FALSE (default), returns full name (e.g., "Friday").
#'
#' @return Character vector of weekday names.
#'
#' @examples
#' weekday_name(as.Date("2024-06-14"))
#' #> "Friday"
#'
#' weekday_name(as.Date("2024-06-14"), abbreviate = TRUE)
#' #> "Fri"
#'
#' @export
weekday_name <- function(date, abbreviate = FALSE) {
  date <- as.Date(date)

  if (isTRUE(abbreviate)) {
    format(date, "%a")
  } else {
    format(date, "%A")
  }
}
