#' Configure R session for fundraising analytics
#'
#' Sets common R options that make working with fundraising data easier,
#' particularly for less experienced R users. The most important setting
#' disables scientific notation so large dollar amounts display properly.
#'
#' @param scipen Integer passed to `options(scipen = ...)`. Higher values make
#'   R less likely to use scientific notation. Default 999 effectively disables
#'   it. Set to 0 to restore R's default behavior.
#' @param digits Number of significant digits to display. Default 7.
#' @param fy_start_month Integer 1-12 indicating fiscal year start month.
#'   Default 7 (July). Set to 1 for calendar year fiscal periods.
#'   This sets the `fundr.fy_start_month` option.
#' @param quiet Logical; if TRUE, suppresses the startup message.
#'
#' @return Invisibly returns a named list of the previous option values,
#'   which can be passed to `options()` to restore them.
#'
#' @details
#' This function sets the following options:
#' \itemize{
#'   \item \code{scipen = 999}: Prevents scientific notation (e.g., displays
#'     1000000 instead of 1e+06)
#'   \item \code{digits}: Controls significant digits in output
#'   \item \code{fundr.fy_start_month}: Default fiscal year start month
#'     used by functions like `fy_year()` and `donor_status()`
#' }
#'
#' Call `fundr_setup()` at the beginning of your script or in your .Rprofile
#' to ensure consistent behavior throughout your session.
#'
#' @examples
#' # Save current options
#' old_opts <- options()
#'
#' # Configure session with July fiscal year (default)
#' fundr_setup(quiet = TRUE)
#'
#' # Large numbers now display without scientific notation
#' format(1234567890)
#'
#' # Restore previous options
#' options(old_opts)
#'
#' @export
fundr_setup <- function(
    scipen = 999L,
    digits = 7L,
    fy_start_month = 7L,
    quiet = FALSE
) {
  # Validate fiscal year month
  fy_start_month <- fundr_check_month(fy_start_month)

  old <- options(
    scipen = as.integer(scipen),
    digits = as.integer(digits),
    fundr.fy_start_month = fy_start_month
  )

  if (!isTRUE(quiet)) {
    message("fundr session configured:")
    message("- Scientific notation disabled (scipen = ", scipen, ")")
    message("- Display digits: ", digits)
    message("- Fiscal year start month: ", fy_start_month, " (",
            month.name[fy_start_month], ")")
  }

  invisible(old)
}

#' Get default fiscal year start month
#'
#' Returns the fiscal year start month from options, or the package default
#' (July = 7) if not set.
#'
#' @return Integer 1-12 representing the fiscal year start month.
#'
#' @examples
#' # Get current default (7 = July unless changed)
#' get_fy_start_month()
#'
#' @export
get_fy_start_month <- function() {
  opt <- getOption("fundr.fy_start_month", default = 7L)
  as.integer(opt)
}

#' Set default fiscal year start month
#'
#' Convenience function to change the default fiscal year start month
#' without calling `fundr_setup()`.
#'
#' @param month Integer 1-12 indicating fiscal year start month.
#'
#' @return Invisibly returns the previous value.
#'
#' @examples
#' # Save current setting
#' old_month <- getOption("fundr.fy_start_month")
#'
#' # Set to October (federal fiscal year)
#' set_fy_start_month(10)
#' get_fy_start_month()
#'
#' # Restore previous setting
#' if (!is.null(old_month)) options(fundr.fy_start_month = old_month)
#'
#' @export
set_fy_start_month <- function(month) {
  month <- fundr_check_month(month)
  old <- options(fundr.fy_start_month = month)
  invisible(old$fundr.fy_start_month)
}
