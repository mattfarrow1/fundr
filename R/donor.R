#' Calculate age from birthdate
#'
#' Computes age in whole years from a birthdate. Correctly handles
#' birthdays that haven't occurred yet in the current year.
#'
#' @param birthdate Date vector (or coercible via `as.Date()`).
#' @param as_of Reference date for age calculation. Default is today.
#'
#' @return Integer vector of ages in years. Returns NA for NA inputs
#'   or future birthdates.
#'
#' @family donor-analytics
#' @examples
#' # Basic usage
#' calc_age(as.Date("1980-06-15"))
#'
#' # Age as of a specific date
#' calc_age(as.Date("1980-06-15"), as_of = as.Date("2020-01-01"))
#' #> 39
#'
#' # Vectorized
#' birthdates <- as.Date(c("1980-01-15", "1990-06-20", "2000-12-01"))
#' calc_age(birthdates, as_of = as.Date("2024-06-01"))
#' #> 44, 33, 23
#'
#' @export
calc_age <- function(birthdate, as_of = Sys.Date()) {
  birthdate <- as.Date(birthdate)
  as_of <- as.Date(as_of)

  if (length(as_of) != 1L || is.na(as_of)) {
    fundr_abort(c(
      "`as_of` must be a single non-NA date.",
      "x" = if (length(as_of) != 1L) "Multiple values provided." else "Value is NA.",
      "i" = "Provide a single date like `as_of = Sys.Date()`."
    ))
  }

  n <- length(birthdate)
  out <- rep(NA_integer_, n)

  ok <- !is.na(birthdate)
  if (!any(ok)) return(out)

  bd <- birthdate[ok]

  # Extract year, month, day components
  bd_lt <- as.POSIXlt(bd)
  as_of_lt <- as.POSIXlt(as_of)

  # Calculate raw year difference
  years <- as_of_lt$year - bd_lt$year

  # Adjust for birthdays that haven't happened yet this year
  # Birthday hasn't happened if: (month < birth_month) OR
  # (month == birth_month AND day < birth_day)
  not_yet <- (as_of_lt$mon < bd_lt$mon) |
    (as_of_lt$mon == bd_lt$mon & as_of_lt$mday < bd_lt$mday)

  years[not_yet] <- years[not_yet] - 1L

  # Future birthdates get NA
  years[bd > as_of] <- NA_integer_

  out[ok] <- as.integer(years)
  out
}

#' Classify donor status based on giving history
#'
#' Categorizes donors based on their last gift date relative to the current
#' fiscal year. This is fundamental for advancement reporting and outreach
#' segmentation.
#'
#' @param last_gift_date Date vector of most recent gift dates (or coercible
#'   via `as.Date()`). Use NA for constituents who have never given.
#' @param as_of Reference date for status calculation. Default is today.
#' @param fy_start_month Integer 1-12 indicating fiscal year start month.
#'   Default 7 (July).
#' @param lapsed_years Number of fiscal years with no gifts before a donor is
#'   considered "Lapsed". Default 5.
#' @param sybunt_years Number of fiscal years that qualify as SYBUNT. Default
#'   is `lapsed_years - 1` (so SYBUNT = 2 to lapsed_years). Set to a smaller
#'   value to narrow the SYBUNT window (e.g., `sybunt_years = 2` means only
#'   2-3 years ago counts as SYBUNT).
#' @param labels Named character vector to customize status labels. Names must
#'   be the default labels ("Active", "LYBUNT", "SYBUNT", "Lapsed", "Never")
#'   and values are replacements. Partial replacement is supported.
#'
#' @return Ordered factor with levels from most to least engaged. Default
#'   levels are: "Active", "LYBUNT", "SYBUNT", "Lapsed", "Never".
#'
#' @details
#' Default status definitions:
#' \itemize{
#'   \item \strong{Active}: Gave during the current fiscal year
#'   \item \strong{LYBUNT}: "Last Year But Unfortunately Not This" - gave
#'     last fiscal year but not yet this year
#'   \item \strong{SYBUNT}: "Some Year But Unfortunately Not This" - gave
#'     2+ fiscal years ago but within the SYBUNT threshold
#'   \item \strong{Lapsed}: Last gift was more than `lapsed_years` ago
#'   \item \strong{Never}: No gift on record (NA last_gift_date)
#' }
#'
#' @examples
#' # Assuming today is in FY2025 (July 2024 - June 2025)
#' dates <- as.Date(c(
#'   "2024-09-15",  # Active (current FY)
#'   "2024-03-01",  # LYBUNT (last FY)
#'   "2022-01-15",  # SYBUNT (2+ years ago)
#'   "2018-06-01",  # Lapsed (5+ years)
#'   NA             # Never
#' ))
#'
#' donor_status(dates, as_of = as.Date("2025-01-15"))
#'
#' # Narrower SYBUNT window (only 2-3 years counts as SYBUNT)
#' donor_status(dates, as_of = as.Date("2025-01-15"), sybunt_years = 2)
#'
#' # Custom labels
#' donor_status(dates, as_of = as.Date("2025-01-15"),
#'              labels = c("Active" = "Current", "Never" = "Non-Donor"))
#'
#' # In a dplyr pipeline (using native pipe)
#' # donors |>
#' #   mutate(status = donor_status(last_gift_date))
#'
#' @family donor-analytics
#' @export
donor_status <- function(
    last_gift_date,
    as_of = Sys.Date(),
    fy_start_month = 7L,
    lapsed_years = 5L,
    sybunt_years = NULL,
    labels = NULL
) {
  last_gift_date <- as.Date(last_gift_date)
  as_of <- as.Date(as_of)

  if (length(as_of) != 1L || is.na(as_of)) {
    fundr_abort(c(
      "`as_of` must be a single non-NA date.",
      "x" = if (length(as_of) != 1L) "Multiple values provided." else "Value is NA.",
      "i" = "Provide a single date like `as_of = Sys.Date()`."
    ))
  }

  fy_start_month <- fundr_check_month(fy_start_month)
  lapsed_years <- as.integer(lapsed_years)

  if (length(lapsed_years) != 1L || is.na(lapsed_years) || lapsed_years < 1L) {
    fundr_abort(c(
      "`lapsed_years` must be a single positive integer.",
      "x" = paste0("Got: ", lapsed_years),
      "i" = "Use a value like `lapsed_years = 5`."
    ))
  }

  # Default SYBUNT to lapsed_years - 1 (so SYBUNT covers 2 to lapsed_years)
  if (is.null(sybunt_years)) {
    sybunt_years <- lapsed_years - 1L
  } else {
    sybunt_years <- as.integer(sybunt_years)
    if (length(sybunt_years) != 1L || is.na(sybunt_years) || sybunt_years < 1L) {
      fundr_abort(c(
        "`sybunt_years` must be a single positive integer.",
        "x" = paste0("Got: ", sybunt_years),
        "i" = "Use a value like `sybunt_years = 3`."
      ))
    }
  }

  # The SYBUNT upper bound is 1 (LYBUNT) + sybunt_years
  sybunt_upper <- 1L + sybunt_years

  n <- length(last_gift_date)

  # Define default status labels (most to least engaged)
  default_labels <- c("Active", "LYBUNT", "SYBUNT", "Lapsed", "Never")
  status_labels <- default_labels

  # Apply custom labels if provided

  if (!is.null(labels)) {
    if (!is.character(labels) || is.null(names(labels))) {
      fundr_abort(c(
        "`labels` must be a named character vector.",
        "i" = 'Example: labels = c("Active" = "Current", "Never" = "Non-Donor")'
      ))
    }

    invalid_names <- setdiff(names(labels), default_labels)
    if (length(invalid_names) > 0) {
      fundr_abort(c(
        "Invalid names in `labels`.",
        "x" = paste0("Unknown: ", paste(invalid_names, collapse = ", ")),
        "i" = paste0("Valid names: ", paste(default_labels, collapse = ", "))
      ))
    }

    # Replace matching labels
    for (nm in names(labels)) {
      status_labels[default_labels == nm] <- labels[[nm]]
    }
  }

  out <- factor(rep(NA_character_, n), levels = status_labels, ordered = TRUE)

  # Never given
  never <- is.na(last_gift_date)
  out[never] <- status_labels[5]  # "Never" or custom

  ok <- !never
  if (!any(ok)) return(out)

  # Get fiscal years
  current_fy <- fy_year(as_of, fy_start_month)
  gift_fy <- fy_year(last_gift_date[ok], fy_start_month)

  # Calculate fiscal years since last gift
  fy_diff <- current_fy - gift_fy

  # Classify using default labels, then map to custom
  # Active: gave this fiscal year (diff == 0)
  # LYBUNT: gave last fiscal year (diff == 1)
  # SYBUNT: gave 2 to sybunt_upper years ago
  # Lapsed: gave more than sybunt_upper years ago

  status <- rep(status_labels[4], sum(ok))  # Default to "Lapsed"
  status[fy_diff == 0L] <- status_labels[1]  # "Active"
  status[fy_diff == 1L] <- status_labels[2]  # "LYBUNT"
  status[fy_diff >= 2L & fy_diff <= sybunt_upper] <- status_labels[3]  # "SYBUNT"
  status[fy_diff > sybunt_upper] <- status_labels[4]  # "Lapsed"

  out[ok] <- status
  out
}

#' Calculate years since a date
#'
#' Computes the number of years (as a decimal) between a date and a
#' reference date. Useful for calculating time since last gift,
#' years of giving, or other duration metrics.
#'
#' @param date Date vector (or coercible via `as.Date()`).
#' @param as_of Reference date. Default is today.
#' @param digits Number of decimal places to round to. Default 1.
#'   Use NULL for no rounding.
#'
#' @return Numeric vector of years. Negative values indicate future dates.
#'   Returns NA for NA inputs.
#'
#' @examples
#' years_since(as.Date("2020-06-15"))
#'
#' years_since(as.Date("2020-06-15"), as_of = as.Date("2024-06-15"))
#' #> 4.0
#'
#' # Vectorized
#' dates <- as.Date(c("2020-01-01", "2022-06-15", "2023-09-01"))
#' years_since(dates, as_of = as.Date("2024-06-15"))
#'
#' @family donor-analytics
#' @export
years_since <- function(date, as_of = Sys.Date(), digits = 1L) {
  date <- as.Date(date)
  as_of <- as.Date(as_of)

  if (length(as_of) != 1L || is.na(as_of)) {
    fundr_abort(c(
      "`as_of` must be a single non-NA date.",
      "x" = if (length(as_of) != 1L) "Multiple values provided." else "Value is NA.",
      "i" = "Provide a single date like `as_of = Sys.Date()`."
    ))
  }

  n <- length(date)
  out <- rep(NA_real_, n)

  ok <- !is.na(date)
  if (!any(ok)) return(out)

  # Calculate difference in days and convert to years
  # Using 365.25 to account for leap years
  days_diff <- as.numeric(difftime(as_of, date[ok], units = "days"))
  years <- days_diff / 365.25

  if (!is.null(digits)) {
    years <- round(years, digits = as.integer(digits))
  }

  out[ok] <- years
  out
}

#' Calculate total years of giving
#'
#' Counts the number of distinct fiscal years in which a donor gave.
#' Useful for loyalty metrics and donor recognition programs.
#'
#' @param gift_dates Date vector of gift dates (or coercible via `as.Date()`).
#' @param fy_start_month Integer 1-12 indicating fiscal year start month.
#'   Default 7 (July).
#'
#' @return Integer count of distinct fiscal years with giving.
#'
#' @examples
#' # Gifts in multiple years
#' gifts <- as.Date(c("2020-01-15", "2020-06-01", "2021-03-15",
#'                    "2023-09-01", "2023-12-25"))
#' total_giving_years(gifts)
#' #> 3
#'
#' # Single gift
#' total_giving_years(as.Date("2024-01-01"))
#' #> 1
#'
#' @family donor-analytics
#' @export
total_giving_years <- function(gift_dates, fy_start_month = 7L) {
  gift_dates <- as.Date(gift_dates)

  ok <- !is.na(gift_dates)
  if (!any(ok)) return(0L)

  fy_start_month <- fundr_check_month(fy_start_month)
  gift_fys <- fy_year(gift_dates[ok], fy_start_month)

  length(unique(gift_fys))
}

#' Calculate consecutive years of giving
#'
#' Counts the number of consecutive fiscal years of giving, going back
#' from a reference fiscal year. Useful for streak tracking and
#' recognition programs.
#'
#' @param gift_dates Date vector of gift dates (or coercible via `as.Date()`).
#' @param as_of Reference date for calculation. Default is today.
#' @param fy_start_month Integer 1-12 indicating fiscal year start month.
#'   Default 7 (July).
#' @param include_current Logical. If TRUE (default), includes the current
#'   fiscal year in the streak count if donor gave this year.
#'
#' @return Integer count of consecutive fiscal years of giving.
#'   Returns 0 if donor has no gifts or if streak is broken.
#'
#' @details
#' The streak counts backwards from the reference fiscal year. If there's
#' a gap in giving, the streak resets. For example, with gifts in FY2024,
#' FY2023, and FY2021 (as of FY2024), the consecutive count is 2 (not 3)
#' because FY2022 is missing.
#'
#' @examples
#' # Consecutive giving FY2022, FY2023, FY2024
#' gifts <- as.Date(c("2021-09-01", "2022-09-01", "2023-09-01"))
#' consecutive_giving_years(gifts, as_of = as.Date("2024-01-15"))
#' #> 3
#'
#' # Gap in FY2023 breaks the streak
#' gifts <- as.Date(c("2021-09-01", "2023-09-01"))
#' consecutive_giving_years(gifts, as_of = as.Date("2024-01-15"))
#' #> 1
#'
#' # No gift this year, streak includes last year back
#' gifts <- as.Date(c("2021-09-01", "2022-09-01"))
#' consecutive_giving_years(gifts, as_of = as.Date("2024-01-15"),
#'                          include_current = FALSE)
#' #> 0
#'
#' @family donor-analytics
#' @export
consecutive_giving_years <- function(
    gift_dates,
    as_of = Sys.Date(),
    fy_start_month = 7L,
    include_current = TRUE
) {
  gift_dates <- as.Date(gift_dates)
  as_of <- as.Date(as_of)

  if (length(as_of) != 1L || is.na(as_of)) {
    fundr_abort(c(
      "`as_of` must be a single non-NA date.",
      "x" = if (length(as_of) != 1L) "Multiple values provided." else "Value is NA.",
      "i" = "Provide a single date like `as_of = Sys.Date()`."
    ))
  }

  ok <- !is.na(gift_dates)
  if (!any(ok)) return(0L)

  fy_start_month <- fundr_check_month(fy_start_month)

  # Get fiscal years
  current_fy <- fy_year(as_of, fy_start_month)
  gift_fys <- unique(sort(fy_year(gift_dates[ok], fy_start_month), decreasing = TRUE))

  # Start from current or previous FY
  start_fy <- if (isTRUE(include_current)) current_fy else current_fy - 1L

  # Count consecutive years going backwards
  count <- 0L
  check_fy <- start_fy

  for (fy in gift_fys) {
    if (fy == check_fy) {
      count <- count + 1L
      check_fy <- check_fy - 1L
    } else if (fy < check_fy) {
      # Gap detected - stop counting
      break
    }
    # If fy > check_fy, skip (future or already counted)
  }

  count
}
