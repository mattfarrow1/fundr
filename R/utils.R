#' Not in operator
#'
#' The negation of the `%in%` operator. Returns TRUE for elements of `x`
#' that are not in `table`.
#'
#' @param x Vector of values to check.
#' @param table Vector of values to check against.
#'
#' @return Logical vector the same length as `x`.
#'
#' @examples
#' # Find values not in a set
#' c(1, 2, 3, 4, 5) %notin% c(2, 4)
#' #> TRUE, FALSE, TRUE, FALSE, TRUE
#'
#' # Filter data frame rows
#' df <- data.frame(status = c("Active", "Lapsed", "Active", "Never"))
#' df[df$status %notin% c("Lapsed", "Never"), ]
#'
#' @name notin
#' @rdname notin
#' @export
`%notin%` <- function(x, table) {
  !(x %in% table)
}

#' @rdname notin
#' @export
`%!in%` <- function(x, table) {
  !(x %in% table)
}

#' Format text as a code block comment
#'
#' Formats text as a monospace-style code comment block. Useful for
#' creating visually distinct section headers in scripts.
#'
#' @param text Character string to format.
#' @param width Total width of the comment block. Default 80.
#' @param char Character to use for the border. Default "#".
#' @param pad Number of spaces to pad the text. Default 1.
#'
#' @return Character string formatted as a comment block.
#'
#' @examples
#' # Create a section header
#' cat(comment_block("Data Import"))
#' # ############################################################################
#' # #                              Data Import                                 #
#' # ############################################################################
#'
#' # Shorter width
#' cat(comment_block("Setup", width = 40))
#'
#' @export
comment_block <- function(text, width = 80L, char = "#", pad = 1L) {
  text <- as.character(text)
  width <- as.integer(width)
  pad <- as.integer(pad)

  # Create border line
  border <- paste0(char, " ", paste(rep(char, width - 3), collapse = ""))

  # Calculate text centering
  text_width <- nchar(text)
  total_pad <- width - 4 - text_width  # 4 = "# " at start and " #" at end
  left_pad <- total_pad %/% 2
  right_pad <- total_pad - left_pad

  if (total_pad < 2) {
    # Text too long, just wrap it
    text_line <- paste0(char, " ", text, " ", char)
  } else {
    text_line <- paste0(
      char, " ",
      paste(rep(" ", left_pad), collapse = ""),
      text,
      paste(rep(" ", right_pad), collapse = ""),
      " ", char
    )
  }

  paste(border, text_line, border, sep = "\n")
}

#' Format text as a simple comment header
#'
#' Formats text as a simple single-line comment header.
#'
#' @param text Character string to format.
#' @param char Character to use for decoration. Default "-".
#' @param width Total width of the header. Default 80.
#'
#' @return Character string formatted as a comment header.
#'
#' @examples
#' cat(comment_header("Load Libraries"))
#' # # Load Libraries --------------------------------------------------------
#'
#' @export
comment_header <- function(text, char = "-", width = 80L) {
  text <- as.character(text)
  width <- as.integer(width)

  prefix <- paste0("# ", text, " ")
  remaining <- width - nchar(prefix)

  if (remaining > 0) {
    suffix <- paste(rep(char, remaining), collapse = "")
    paste0(prefix, suffix)
  } else {
    prefix
  }
}

#' Format text as a section divider
#'
#' Creates a visual divider line for separating code sections.
#'
#' @param char Character to use for the divider. Default "=".
#' @param width Total width of the divider. Default 80.
#'
#' @return Character string formatted as a divider.
#'
#' @examples
#' cat(comment_divider())
#' # # ========================================================================
#'
#' @export
comment_divider <- function(char = "=", width = 80L) {
  width <- as.integer(width)
  paste0("# ", paste(rep(char, width - 2), collapse = ""))
}
