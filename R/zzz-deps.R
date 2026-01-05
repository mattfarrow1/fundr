fundr_needs <- function(pkg, hint = NULL) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    msg <- paste0(
      "This function requires the optional package '", pkg, "'.\n",
      "Install it with: install.packages('", pkg, "')"
    )
    if (!is.null(hint)) msg <- paste0(msg, "\n\n", hint)
    stop(msg, call. = FALSE)
  }
  invisible(TRUE)
}
