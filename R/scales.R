#' Currency scale for ggplot2 y-axis
#'
#' Formats y-axis labels as currency values, avoiding scientific notation
#' and displaying proper dollar formatting. Supports both full format
#' ($1,234,567) and compact format ($1.2M).
#'
#' @param prefix Currency symbol prefix. Default "$".
#' @param suffix Currency symbol suffix. Default "".
#' @param big.mark Thousands separator. Default ",".
#' @param decimal.mark Decimal separator. Default ".".
#' @param digits Number of decimal places. Default 0.
#' @param short Logical; if TRUE, use compact notation (K/M/B). Default FALSE.
#' @param short_digits Decimal places for compact notation. Default 1.
#' @param negative How to display negative numbers: "parens" or "minus".
#'   Default "minus".
#' @param ... Additional arguments passed to [ggplot2::scale_y_continuous()].
#'
#' @return A ggplot2 scale object.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' # Sample data with large dollar amounts
#' df <- data.frame(
#'   category = c("A", "B", "C", "D"),
#'   amount = c(1500000, 2300000, 800000, 3100000)
#' )
#'
#' # Default currency formatting
#' ggplot(df, aes(category, amount)) +
#'   geom_col() +
#'   scale_y_currency()
#'
#' # Compact notation for large values
#' ggplot(df, aes(category, amount)) +
#'   geom_col() +
#'   scale_y_currency(short = TRUE)
#' }
#'
#' @export
scale_y_currency <- function(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0L,
    short = FALSE,
    short_digits = 1L,
    negative = c("minus", "parens"),
    ...
) {
  fundr_needs("ggplot2")
  negative <- match.arg(negative)

  labeller <- make_currency_labeller(
    prefix = prefix,
    suffix = suffix,
    big.mark = big.mark,
    decimal.mark = decimal.mark,
    digits = digits,
    short = short,
    short_digits = short_digits,
    negative = negative
  )

  ggplot2::scale_y_continuous(labels = labeller, ...)
}

#' Currency scale for ggplot2 x-axis
#'
#' Formats x-axis labels as currency values. See [scale_y_currency()] for
#' details on parameters.
#'
#' @inheritParams scale_y_currency
#'
#' @return A ggplot2 scale object.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' df <- data.frame(
#'   revenue = c(500000, 1000000, 1500000, 2000000),
#'   profit = c(50000, 120000, 180000, 250000)
#' )
#'
#' ggplot(df, aes(revenue, profit)) +
#'   geom_point() +
#'   scale_x_currency(short = TRUE) +
#'   scale_y_currency(short = TRUE)
#' }
#'
#' @export
scale_x_currency <- function(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0L,
    short = FALSE,
    short_digits = 1L,
    negative = c("minus", "parens"),
    ...
) {
  fundr_needs("ggplot2")
  negative <- match.arg(negative)

  labeller <- make_currency_labeller(
    prefix = prefix,
    suffix = suffix,
    big.mark = big.mark,
    decimal.mark = decimal.mark,
    digits = digits,
    short = short,
    short_digits = short_digits,
    negative = negative
  )

  ggplot2::scale_x_continuous(labels = labeller, ...)
}

#' Create a currency labeller function for ggplot2 scales
#'
#' Internal helper that creates a labeller function for use with ggplot2
#' continuous scales. Not exported.
#'
#' @param prefix Currency symbol prefix.
#' @param suffix Currency symbol suffix.
#' @param big.mark Thousands separator.
#' @param decimal.mark Decimal separator.
#' @param digits Number of decimal places.
#' @param short Use compact notation.
#' @param short_digits Decimal places for compact notation.
#' @param negative How to display negative numbers.
#'
#' @return A function that takes a numeric vector and returns formatted strings.
#'
#' @noRd
make_currency_labeller <- function(
    prefix,
    suffix,
    big.mark,
    decimal.mark,
    digits,
    short,
    short_digits,
    negative
) {
  function(x) {
    if (length(x) == 0) return(character(0))

    out <- rep(NA_character_, length(x))
    ok <- !is.na(x)

    if (!any(ok)) return(out)

    if (isTRUE(short)) {
      # Use compact notation
      abs_x <- abs(x[ok])
      is_neg <- x[ok] < 0

      formatted <- rep("", length(abs_x))
      suffix_short <- rep("", length(abs_x))
      divisor <- rep(1, length(abs_x))

      billions <- abs_x >= 1e9
      millions <- abs_x >= 1e6 & abs_x < 1e9
      thousands <- abs_x >= 1e3 & abs_x < 1e6
      small <- abs_x < 1e3

      suffix_short[billions] <- "B"
      divisor[billions] <- 1e9

      suffix_short[millions] <- "M"
      divisor[millions] <- 1e6

      suffix_short[thousands] <- "K"
      divisor[thousands] <- 1e3

      # Format large numbers
      large <- !small
      if (any(large)) {
        vals <- abs_x[large] / divisor[large]
        formatted[large] <- formatC(vals, format = "f", digits = as.integer(short_digits))
        formatted[large] <- sub("\\.?0+$", "", formatted[large])
      }

      # Format small numbers
      if (any(small)) {
        formatted[small] <- formatC(abs_x[small], format = "f", digits = as.integer(digits), big.mark = big.mark)
      }

      # Combine
      result <- paste0(prefix, formatted, suffix_short, suffix)

      # Handle negatives
      if (negative == "parens") {
        result[is_neg] <- paste0("(", result[is_neg], ")")
      } else {
        result[is_neg] <- paste0("-", result[is_neg])
      }

      out[ok] <- result

    } else {
      # Full format
      is_neg <- x[ok] < 0

      formatted <- formatC(
        abs(x[ok]),
        format = "f",
        digits = as.integer(digits),
        big.mark = big.mark,
        decimal.mark = decimal.mark
      )

      formatted <- trimws(formatted)
      result <- paste0(prefix, formatted, suffix)

      # Handle negatives
      if (negative == "parens") {
        result[is_neg] <- paste0("(", result[is_neg], ")")
      } else {
        result[is_neg] <- paste0("-", result[is_neg])
      }

      out[ok] <- result
    }

    out
  }
}
