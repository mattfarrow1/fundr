#' Parse partial dates (year-only or year-month)
#'
#' Handles dates that are incomplete, such as birth dates that only have
#' year and month, or just year. Returns a Date object using sensible
#' defaults for missing components.
#'
#' @param x Character or numeric vector of partial dates. Accepts formats like:
#'   - Year only: "1980", 1980
#'   - Year-month: "1980-06", "1980/06", "06/1980", "Jun 1980", "June 1980"
#'   - Full dates are passed through: "1980-06-15"
#' @param day_default Day to use when only year-month is provided. Default 1.
#' @param month_default Month to use when only year is provided. Default 1 (January).
#' @param year_min Minimum valid year. Default 1900. Values below this return NA.
#' @param year_max Maximum valid year. Default is current year + 1.
#'
#' @return Date vector. Returns NA for unparseable values or years outside
#'   the valid range.
#'
#' @examples
#' # Year only
#' parse_partial_date("1980")
#' #> "1980-01-01"
#'
#' # Year-month
#' parse_partial_date("1980-06")
#' #> "1980-06-01"
#'
#' parse_partial_date("Jun 1980")
#' #> "1980-06-01"
#'
#' # Full dates pass through
#' parse_partial_date("1980-06-15")
#' #> "1980-06-15"
#'
#' # Vectorized
#' parse_partial_date(c("1980", "1990-06", "2000-12-25"))
#'
#' @export
parse_partial_date <- function(
    x,
    day_default = 1L,
    month_default = 1L,
    year_min = 1900L,
    year_max = NULL
) {
  if (is.null(year_max)) {
    year_max <- as.integer(format(Sys.Date(), "%Y")) + 1L
  }

  day_default <- as.integer(day_default)
  month_default <- as.integer(month_default)
  year_min <- as.integer(year_min)
  year_max <- as.integer(year_max)

  # Validate defaults

  if (day_default < 1L || day_default > 31L) {
    stop("`day_default` must be between 1 and 31.", call. = FALSE)
  }
  if (month_default < 1L || month_default > 12L) {
    stop("`month_default` must be between 1 and 12.", call. = FALSE)
  }

  x <- as.character(x)
  n <- length(x)
  out <- rep(as.Date(NA), n)

  ok <- !is.na(x) & nzchar(trimws(x))
  if (!any(ok)) return(out)

  for (i in which(ok)) {
    val <- trimws(x[i])
    parsed <- parse_single_partial_date(val, day_default, month_default)
    if (!is.na(parsed)) {
      year <- as.integer(format(parsed, "%Y"))
      if (year >= year_min && year <= year_max) {
        out[i] <- parsed
      }
    }
  }

  out
}

#' Internal parser for single partial date value
#' @noRd
parse_single_partial_date <- function(val, day_default, month_default) {
  # Try as full date first
  result <- tryCatch(as.Date(val), error = function(e) NA)
  if (!is.na(result)) return(result)

  # Try year only (4 digits)
  if (grepl("^\\d{4}$", val)) {
    year <- as.integer(val)
    return(as.Date(paste(year, month_default, day_default, sep = "-")))
  }

  # Try YYYY-MM or YYYY/MM
  if (grepl("^\\d{4}[-/]\\d{1,2}$", val)) {
    parts <- strsplit(val, "[-/]")[[1]]
    year <- as.integer(parts[1])
    month <- as.integer(parts[2])
    if (month >= 1L && month <= 12L) {
      return(as.Date(paste(year, month, day_default, sep = "-")))
    }
  }

  # Try MM/YYYY or MM-YYYY
  if (grepl("^\\d{1,2}[-/]\\d{4}$", val)) {
    parts <- strsplit(val, "[-/]")[[1]]
    month <- as.integer(parts[1])
    year <- as.integer(parts[2])
    if (month >= 1L && month <= 12L) {
      return(as.Date(paste(year, month, day_default, sep = "-")))
    }
  }

  # Try "Mon YYYY" or "Month YYYY" (e.g., "Jun 1980", "June 1980")
  month_names <- c(
    "jan", "feb", "mar", "apr", "may", "jun",
    "jul", "aug", "sep", "oct", "nov", "dec"
  )
  month_full <- c(
    "january", "february", "march", "april", "may", "june",
    "july", "august", "september", "october", "november", "december"
  )

  val_lower <- tolower(val)

  # Pattern: Month YYYY
  for (m in seq_along(month_names)) {
    pattern_short <- paste0("^", month_names[m], "\\s*\\d{4}$")
    pattern_full <- paste0("^", month_full[m], "\\s*\\d{4}$")

    if (grepl(pattern_short, val_lower) || grepl(pattern_full, val_lower)) {
      year <- as.integer(gsub("[^0-9]", "", val))
      return(as.Date(paste(year, m, day_default, sep = "-")))
    }
  }

  # Pattern: YYYY Month
  for (m in seq_along(month_names)) {
    pattern_short <- paste0("^\\d{4}\\s*", month_names[m], "$")
    pattern_full <- paste0("^\\d{4}\\s*", month_full[m], "$")

    if (grepl(pattern_short, val_lower) || grepl(pattern_full, val_lower)) {
      year <- as.integer(gsub("[^0-9]", "", val))
      return(as.Date(paste(year, m, day_default, sep = "-")))
    }
  }

  NA
}

#' Calculate age from partial birthdate
#'
#' Extends [calc_age()] to work with partial dates. When only year or
#' year-month is known, uses mid-point assumptions for more accurate
#' age estimation.
#'
#' @param birthdate Character, numeric, or Date vector of birthdates.
#'   Partial dates (year-only, year-month) are accepted.
#' @param as_of Reference date for age calculation. Default is today.
#' @param assume_midpoint Logical. If TRUE (default), assumes midpoint for
#'   missing components (July 1 for year-only, 15th for month-only).
#'   If FALSE, uses January 1 and 1st respectively.
#'
#' @return Integer vector of ages in years. Returns NA for NA inputs,
#'   unparseable dates, or future birthdates.
#'
#' @examples
#' # Year only - assumes July 1 as midpoint
#' calc_age_partial("1980")
#'
#' # Year-month - assumes 15th as midpoint
#' calc_age_partial("1980-06")
#'
#' # Full date
#' calc_age_partial("1980-06-15")
#'
#' # Vectorized
#' calc_age_partial(c("1980", "1990-06", "2000-12-25"))
#'
#' @export
calc_age_partial <- function(
    birthdate,
    as_of = Sys.Date(),
    assume_midpoint = TRUE
) {
  as_of <- as.Date(as_of)

  if (length(as_of) != 1L || is.na(as_of)) {
    stop("`as_of` must be a single non-NA date.", call. = FALSE)
  }

  # Determine defaults based on midpoint assumption
  if (isTRUE(assume_midpoint)) {
    day_default <- 15L
    month_default <- 7L
  } else {
    day_default <- 1L
    month_default <- 1L
  }

  # Handle already-Date inputs
  if (inherits(birthdate, "Date")) {
    parsed <- birthdate
  } else {
    parsed <- parse_partial_date(
      birthdate,
      day_default = day_default,
      month_default = month_default
    )
  }

  # Use existing calc_age function
  calc_age(parsed, as_of = as_of)
}

#' Extract precision level from partial date string
#'
#' Determines whether a date string represents a full date, year-month,
#' or year-only value. Useful for data quality assessment.
#'
#' @param x Character vector of date strings.
#'
#' @return Factor with levels "year", "year-month", "full", NA for
#'   unparseable values.
#'
#' @examples
#' date_precision(c("1980", "1980-06", "1980-06-15", "invalid"))
#' #> year, year-month, full, NA
#'
#' @export
date_precision <- function(x) {
  x <- as.character(x)
  n <- length(x)

  levels <- c("year", "year-month", "full")
  out <- factor(rep(NA_character_, n), levels = levels)

  ok <- !is.na(x) & nzchar(trimws(x))
  if (!any(ok)) return(out)

  for (i in which(ok)) {
    val <- trimws(x[i])
    out[i] <- detect_date_precision(val)
  }

  out
}

#' @noRd
detect_date_precision <- function(val) {
  # Check if it's year-only (4 digits)
  if (grepl("^\\d{4}$", val)) {
    return("year")
  }

  # Check if it's YYYY-MM or similar year-month formats
  if (grepl("^\\d{4}[-/]\\d{1,2}$", val) ||
      grepl("^\\d{1,2}[-/]\\d{4}$", val)) {
    return("year-month")
  }

  # Check for month name patterns
  month_pattern <- "(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec|january|february|march|april|june|july|august|september|october|november|december)"
  if (grepl(paste0("^", month_pattern, "\\s*\\d{4}$"), tolower(val)) ||
      grepl(paste0("^\\d{4}\\s*", month_pattern, "$"), tolower(val))) {
    return("year-month")
  }

  # Try parsing as full date
  result <- tryCatch(as.Date(val), error = function(e) NA)
  if (!is.na(result)) {
    return("full")
  }

  NA_character_
}
