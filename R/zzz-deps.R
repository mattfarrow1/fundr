fundr_needs <- function(pkg, hint = NULL) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    msg <- paste0(
      "This function requires the optional package '", pkg, "'.\n",
      "Install it with: install.packages('", pkg, "')"
    )
    if (!is.null(hint)) msg <- paste0(msg, "\n\n", hint)
    fundr_abort(msg)
  }
  invisible(TRUE)
}

#' Abort with informative error message
#'
#' Uses cli::cli_abort() when available for formatted messages,
#' falls back to stop() otherwise.
#'
#' @param message Error message (can use cli formatting if cli available).
#' @param ... Additional arguments passed to cli_abort or ignored.
#' @param call The call to report in the error. Default NULL shows no call.
#' @noRd
fundr_abort <- function(message, ..., call = NULL) {
 if (requireNamespace("cli", quietly = TRUE)) {
    cli::cli_abort(message, ..., call = call)
  } else {
    stop(message, call. = FALSE)
  }
}

#' Create a data frame, using tibble when available
#'
#' Returns a tibble if the tibble package is installed, otherwise
#' a base R data.frame.
#'
#' @param ... Arguments passed to tibble::tibble() or data.frame().
#' @noRd
fundr_df <- function(...) {
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::tibble(...)
  } else {
    data.frame(..., stringsAsFactors = FALSE)
  }
}
