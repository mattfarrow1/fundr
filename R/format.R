#' Format numbers as currency
#'
#' Converts numeric values to formatted currency strings with proper
#' thousands separators and configurable decimal places. Handles NA values
#' and negative numbers gracefully.
#'
#' @param x Numeric vector to format.
#' @param prefix Currency symbol prefix. Default "$".
#' @param suffix Currency symbol suffix. Default "".
#' @param digits Number of decimal places. Default 0 (whole dollars).
#' @param big.mark Thousands separator. Default ",".
#' @param decimal.mark Decimal separator. Default ".".
#' @param negative How to display negative numbers: "parens" for ($100),
#'   "minus" for -$100. Default "parens".
#' @param trim Logical; if TRUE, trims leading whitespace. Default TRUE.
#'
#' @return Character vector of formatted currency strings.
#'
#' @examples
#' # Basic usage
#' format_currency(1234567)
#' #> "$1,234,567"
#'
#' # With decimals
#' format_currency(1234.567, digits = 2)
#' #> "$1,234.57"
#'
#' # Negative numbers
#' format_currency(-500)
#' #> "($500)"
#'
#' format_currency(-500, negative = "minus")
#' #> "-$500"
#'
#' # In a dplyr pipeline
#' # df |> mutate(gift_formatted = format_currency(gift_amount))
#'
#' @export
format_currency <- function(
    x,
    prefix = "$",
    suffix = "",
    digits = 0L,
    big.mark = ",",
    decimal.mark = ".",
    negative = c("parens", "minus"),
    trim = TRUE
) {
  negative <- match.arg(negative)

  x <- as.numeric(x)
  n <- length(x)
  out <- rep(NA_character_, n)

  ok <- !is.na(x)
  if (!any(ok)) return(out)

  is_neg <- ok & x < 0

  # Format absolute values
  formatted <- formatC(
    abs(x[ok]),
    format = "f",
    digits = as.integer(digits),
    big.mark = big.mark,
    decimal.mark = decimal.mark
  )

  if (isTRUE(trim)) {
    formatted <- trimws(formatted)
  }

  # Add prefix and suffix
  formatted <- paste0(prefix, formatted, suffix)

  # Handle negatives
  if (negative == "parens") {
    neg_idx <- x[ok] < 0
    formatted[neg_idx] <- paste0("(", formatted[neg_idx], ")")
  } else {
    neg_idx <- x[ok] < 0
    formatted[neg_idx] <- paste0("-", formatted[neg_idx])
  }

  out[ok] <- formatted
  out
}

#' Format currency in compact notation
#'
#' Formats large currency values using K (thousands), M (millions), or
#' B (billions) suffixes. Useful for chart labels and summary tables
#' where space is limited.
#'
#' @param x Numeric vector to format.
#' @param prefix Currency symbol prefix. Default "$".
#' @param digits Number of decimal places for the shortened number. Default 1.
#' @param threshold Minimum absolute value to apply shortening. Values below
#'   this are formatted as regular currency. Default 1000.
#' @param negative How to display negative numbers: "parens" or "minus".
#'   Default "minus" (more common in compact formats).
#'
#' @return Character vector of formatted currency strings.
#'
#' @examples
#' format_currency_short(1500000)
#' #> "$1.5M"
#'
#' format_currency_short(250000)
#' #> "$250K"
#'
#' format_currency_short(500)
#' #> "$500"
#'
#' format_currency_short(c(1000, 50000, 2500000, 1000000000))
#' #> "$1K" "$50K" "$2.5M" "$1B"
#'
#' @export
format_currency_short <- function(
    x,
    prefix = "$",
    digits = 1L,
    threshold = 1000,
    negative = c("minus", "parens")
) {
  negative <- match.arg(negative)

  x <- as.numeric(x)
  n <- length(x)
  out <- rep(NA_character_, n)

  ok <- !is.na(x)
  if (!any(ok)) return(out)

  abs_x <- abs(x[ok])
  is_neg <- x[ok] < 0

  # Determine suffix and divisor
  suffix <- rep("", length(abs_x))
  divisor <- rep(1, length(abs_x))

  billions <- abs_x >= 1e9
  millions <- abs_x >= 1e6 & abs_x < 1e9
  thousands <- abs_x >= threshold & abs_x < 1e6
  small <- abs_x < threshold

  suffix[billions] <- "B"
  divisor[billions] <- 1e9


  suffix[millions] <- "M"
  divisor[millions] <- 1e6

  suffix[thousands] <- "K"
  divisor[thousands] <- 1e3

  # Format the numbers
  formatted <- rep("", length(abs_x))

  # Large numbers with suffix
  large <- !small
  if (any(large)) {
    vals <- abs_x[large] / divisor[large]
    # Use digits for large numbers, but drop trailing zeros
    formatted[large] <- formatC(vals, format = "f", digits = as.integer(digits))
    formatted[large] <- sub("\\.?0+$", "", formatted[large])
  }

  # Small numbers without suffix
  if (any(small)) {
    formatted[small] <- formatC(abs_x[small], format = "f", digits = 0, big.mark = ",")
  }

  # Combine prefix, number, suffix
  result <- paste0(prefix, formatted, suffix)

  # Handle negatives
  if (negative == "parens") {
    result[is_neg] <- paste0("(", result[is_neg], ")")
  } else {
    result[is_neg] <- paste0("-", result[is_neg])
  }

  out[ok] <- result
  out
}

#' Format numbers as percentages
#'
#' Converts numeric values (assumed to be proportions 0-1) to formatted
#' percentage strings.
#'
#' @param x Numeric vector to format (values between 0 and 1).
#' @param digits Number of decimal places. Default 1.
#' @param symbol Logical; if TRUE, append "%" symbol. Default TRUE.
#' @param multiply Logical; if TRUE, multiply by 100 (for proportions).
#'   If FALSE, assume x is already a percentage. Default TRUE.
#'
#' @return Character vector of formatted percentage strings.
#'
#' @examples
#' format_pct(0.4567)
#' #> "45.7%"
#'
#' format_pct(0.4567, digits = 0)
#' #> "46%"
#'
#' format_pct(45.67, multiply = FALSE)
#' #> "45.7%"
#'
#' @export
format_pct <- function(
    x,
    digits = 1L,
    symbol = TRUE,
    multiply = TRUE
) {
  x <- as.numeric(x)
  n <- length(x)
  out <- rep(NA_character_, n)

  ok <- !is.na(x)
  if (!any(ok)) return(out)

  vals <- x[ok]
  if (isTRUE(multiply)) {
    vals <- vals * 100
  }

  formatted <- formatC(vals, format = "f", digits = as.integer(digits))

  if (isTRUE(symbol)) {
    formatted <- paste0(formatted, "%")
  }

  out[ok] <- formatted
  out
}
