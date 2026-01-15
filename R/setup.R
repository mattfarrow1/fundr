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
#' }
#'
#' Call `fundr_setup()` at the beginning of your script or in your .Rprofile
#' to ensure consistent behavior throughout your session.
#'
#' @examples
#' # Before setup: large numbers may show as scientific notation
#' format(1234567890)
#'
#' # Configure session
#' old_opts <- fundr_setup()
#'
#' # Now large numbers display normally
#' format(1234567890)
#'
#' # Restore previous options if needed
#' options(old_opts)
#'
#' @export
fundr_setup <- function(
    scipen = 999L,
    digits = 7L,
    quiet = FALSE
) {
  old <- options(
    scipen = as.integer(scipen),
    digits = as.integer(digits)
  )

  if (!isTRUE(quiet)) {
    message("fundr session configured:")
    message("- Scientific notation disabled (scipen = ", scipen, ")")
    message("- Display digits: ", digits)
  }

  invisible(old)
}
