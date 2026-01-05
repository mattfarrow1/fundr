fundr_check_month <- function(fy_start_month) {
  fy_start_month <- as.integer(fy_start_month)

  if (length(fy_start_month) != 1L || is.na(fy_start_month) ||
      fy_start_month < 1L || fy_start_month > 12L) {
    stop("`fy_start_month` must be a single integer between 1 and 12.", call. = FALSE)
  }

  fy_start_month
}

#' Fiscal year for a date
#'
#' Fiscal year is returned as the year in which the fiscal period ends.
#' For example, with a July start (fy_start_month = 7), 2024-07-01 is FY2025.
#' With a January start (fy_start_month = 1), fiscal year matches the calendar year.
#'
#' @param date A Date (or something coercible via as.Date()).
#' @param fy_start_month Integer 1-12. Default 7 = July fiscal year start.
#' @return Integer fiscal year (e.g., 2026).
#' @export
fy_year <- function(date, fy_start_month = 7L) {
  fy_start_month <- fundr_check_month(fy_start_month)

  date <- as.Date(date)
  out <- rep(NA_integer_, length(date))
  ok <- !is.na(date)

  if (any(ok)) {
    lt <- as.POSIXlt(date[ok])
    y <- lt$year + 1900L
    m <- lt$mon + 1L

    if (fy_start_month == 1L) {
      out[ok] <- y
    } else {
      out[ok] <- y + as.integer(m >= fy_start_month)
    }
  }

  out
}

#' Fiscal year label for a date
#'
#' @param date A Date (or something coercible via as.Date()).
#' @param fy_start_month Integer 1-12. Default 7 = July fiscal year start.
#' @param prefix Prefix for the label (default "FY").
#' @param short If TRUE, uses 2-digit year (e.g., "FY26"); otherwise "FY2026".
#' @return Character vector of fiscal year labels.
#' @export
fy_label <- function(date, fy_start_month = 7L, prefix = "FY", short = TRUE) {
  y <- fy_year(date, fy_start_month)

  out <- rep(NA_character_, length(y))
  ok <- !is.na(y)

  if (any(ok)) {
    if (isTRUE(short)) {
      out[ok] <- paste0(prefix, substr(as.character(y[ok]), 3, 4))
    } else {
      out[ok] <- paste0(prefix, y[ok])
    }
  }

  out
}

#' Fiscal quarter for a date
#'
#' Quarters are numbered 1-4 within the fiscal year defined by `fy_start_month`.
#'
#' @param date A Date (or something coercible via as.Date()).
#' @param fy_start_month Integer 1-12. Default 7 = July fiscal year start.
#' @return Integer vector (1-4).
#' @export
fy_quarter <- function(date, fy_start_month = 7L) {
  fy_start_month <- fundr_check_month(fy_start_month)

  date <- as.Date(date)
  out <- rep(NA_integer_, length(date))
  ok <- !is.na(date)

  if (any(ok)) {
    lt <- as.POSIXlt(date[ok])
    m <- lt$mon + 1L
    q <- ((m - fy_start_month) %% 12) %/% 3 + 1L
    out[ok] <- as.integer(q)
  }

  out
}
