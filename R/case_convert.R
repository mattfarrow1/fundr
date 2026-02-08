#' Convert strings to snake_case
#'
#' Converts strings from various formats (TitleCase, camelCase, etc.)
#' to snake_case. Useful for standardizing column names.
#'
#' @param x Character vector to convert.
#'
#' @return Character vector in snake_case.
#'
#' @examples
#' to_snake_case("FirstName")
#' #> "first_name"
#'
#' to_snake_case("firstName")
#' #> "first_name"
#'
#' to_snake_case(c("GiftAmount", "DonorID", "LastGiftDate"))
#' #> "gift_amount", "donor_id", "last_gift_date"
#'
#' # Already snake_case passes through
#' to_snake_case("gift_amount")
#' #> "gift_amount"
#'
#' @export
to_snake_case <- function(x) {
  x <- as.character(x)

  # Handle NA
  result <- rep(NA_character_, length(x))
  ok <- !is.na(x)
  if (!any(ok)) return(result)

  s <- x[ok]

  # Replace spaces, hyphens, dots with underscores
  s <- gsub("[\\s\\-\\.]+", "_", s, perl = TRUE)

  # Insert underscore before uppercase letters (except at start)
  s <- gsub("([a-z0-9])([A-Z])", "\\1_\\2", s, perl = TRUE)

  # Handle consecutive capitals (e.g., "XMLParser" -> "xml_parser")
  s <- gsub("([A-Z]+)([A-Z][a-z])", "\\1_\\2", s, perl = TRUE)

  # Convert to lowercase
  s <- tolower(s)

  # Clean up multiple underscores
  s <- gsub("_+", "_", s)

  # Remove leading/trailing underscores
  s <- gsub("^_|_$", "", s)

  result[ok] <- s
  result
}

#' Convert strings to Title Case
#'
#' Converts strings from snake_case or other formats to Title Case.
#' Useful for creating readable labels from column names.
#'
#' @param x Character vector to convert.
#' @param strict Logical. If TRUE (default), converts entirely to Title Case.
#'   If FALSE, only capitalizes the first letter of each word, preserving
#'   other capitalization.
#'
#' @return Character vector in Title Case.
#'
#' @examples
#' to_title_case("first_name")
#' #> "First Name"
#'
#' to_title_case("gift_amount")
#' #> "Gift Amount"
#'
#' to_title_case(c("donor_id", "last_gift_date", "total_giving"))
#' #> "Donor Id", "Last Gift Date", "Total Giving"
#'
#' # Already Title Case passes through
#' to_title_case("First Name")
#' #> "First Name"
#'
#' @export
to_title_case <- function(x, strict = TRUE) {
  x <- as.character(x)

  # Handle NA
  result <- rep(NA_character_, length(x))
  ok <- !is.na(x)
  if (!any(ok)) return(result)

  s <- x[ok]

  # Replace underscores, hyphens, dots with spaces
  s <- gsub("[_.-]+", " ", s)

  # Handle camelCase by inserting spaces
  s <- gsub("([a-z0-9])([A-Z])", "\\1 \\2", s, perl = TRUE)

  # Title case: capitalize first letter of each word
  if (isTRUE(strict)) {
    s <- tolower(s)
  }

  # Capitalize first letter of each word
  s <- gsub("\\b([a-z])", "\\U\\1", s, perl = TRUE)

  # Clean up multiple spaces
  s <- gsub("\\s+", " ", s)
  s <- trimws(s)

  result[ok] <- s
  result
}

#' Convert strings to camelCase
#'
#' Converts strings from snake_case or other formats to camelCase.
#'
#' @param x Character vector to convert.
#'
#' @return Character vector in camelCase.
#'
#' @examples
#' to_camel_case("first_name")
#' #> "firstName"
#'
#' to_camel_case("gift_amount")
#' #> "giftAmount"
#'
#' @export
to_camel_case <- function(x) {
  x <- as.character(x)

  # Handle NA
  result <- rep(NA_character_, length(x))
  ok <- !is.na(x)
  if (!any(ok)) return(result)

  s <- x[ok]

  # First convert to snake_case to normalize
  s <- to_snake_case(s)

  # Split by underscore, capitalize each word except first, rejoin
  parts <- strsplit(s, "_")
  s <- vapply(parts, function(p) {
    if (length(p) == 0) return("")
    if (length(p) == 1) return(p)
    p[-1] <- paste0(toupper(substr(p[-1], 1, 1)), substr(p[-1], 2, nchar(p[-1])))
    paste(p, collapse = "")
  }, character(1))

  result[ok] <- s
  result
}

#' Convert data frame column names
#'
#' Convenience function to convert all column names in a data frame
#' to a specified case format.
#'
#' @param df A data frame.
#' @param case Target case: "snake", "title", or "camel".
#'
#' @return Data frame with renamed columns.
#'
#' @examples
#' df <- data.frame(FirstName = "John", LastName = "Doe")
#' convert_names(df, "snake")
#' #> Columns: first_name, last_name
#'
#' df <- data.frame(first_name = "John", last_name = "Doe")
#' convert_names(df, "title")
#' #> Columns: First Name, Last Name
#'
#' @export
convert_names <- function(df, case = c("snake", "title", "camel")) {
  case <- match.arg(case)

  converter <- switch(
    case,
    "snake" = to_snake_case,
    "title" = to_title_case,
    "camel" = to_camel_case
  )

  names(df) <- converter(names(df))
  df
}
