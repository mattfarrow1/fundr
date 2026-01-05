#' Normalize postal (ZIP) codes
#'
#' Normalizes US ZIP codes to either 5-digit ("12345") or ZIP+4 ("12345-6789")
#' format by removing punctuation and whitespace. Postal codes are treated as
#' character strings; leading zeros are preserved.
#'
#' @param postal Character vector of postal codes.
#' @param format Output format: "zip5" (always 5 digits), "zip9" (ZIP+4 when available),
#'   or "digits" (raw digits, 5 or 9).
#' @param invalid Value to return for invalid postal codes.
#' @param strict Logical; if TRUE, only accept exactly 5 or 9 digits after cleaning.
#'   If FALSE, will attempt to salvage by taking the first 5 digits when at least 5 are present,
#'   and the first 9 digits when at least 9 are present.
#' @param na_if_blank Logical; if TRUE, blank/whitespace-only inputs become `invalid`.
#'
#' @return A character vector of normalized postal codes.
#' @export
normalize_zip <- function(
    postal,
    format = c("zip5", "zip9", "digits"),
    invalid = NA_character_,
    strict = TRUE,
    na_if_blank = TRUE
) {
  format <- match.arg(format)

  postal <- as.character(postal)
  n <- length(postal)
  out <- rep(invalid, n)

  if (na_if_blank) {
    blank <- is.na(postal) | !nzchar(trimws(postal))
    postal[blank] <- NA_character_
  }

  # Digits only
  digits <- rep("", n)
  ok <- !is.na(postal)
  digits[ok] <- gsub("[^0-9]", "", postal[ok])

  if (!strict) {
    # Salvage: if at least 9 digits, take first 9; else if at least 5, take first 5
    has9 <- nchar(digits) >= 9
    digits[has9] <- substr(digits[has9], 1, 9)

    has5 <- !has9 & nchar(digits) >= 5
    digits[has5] <- substr(digits[has5], 1, 5)
  }

  is5 <- nchar(digits) == 5
  is9 <- nchar(digits) == 9

  if (format == "digits") {
    out[is5] <- digits[is5]
    out[is9] <- digits[is9]
    return(out)
  }

  if (format == "zip5") {
    out[is5] <- digits[is5]
    out[is9] <- substr(digits[is9], 1, 5)
    return(out)
  }

  # format == "zip9"
  out[is5] <- digits[is5]
  out[is9] <- paste0(substr(digits[is9], 1, 5), "-", substr(digits[is9], 6, 9))
  out
}
