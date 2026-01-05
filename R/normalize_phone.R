#' Normalize phone numbers
#'
#' Normalizes phone numbers by removing punctuation and formatting them into a
#' consistent representation.
#'
#' @param phone Character vector of phone numbers.
#' @param format Output format: "dash" (XXX-XXX-XXXX), "digits", "e164".
#' @param country Country code for e164 format (currently only "US").
#' @param invalid Value to return for invalid phone numbers.
#' @param allow_7 Logical; if TRUE, allow 7-digit numbers and format as XXX-XXXX (dash) or digits.
#' @param keep_extension Logical; if TRUE, retain extensions (e.g., x123).
#' @param extension_sep Separator used when appending extensions (default " x").
#' @param strip_leading_country Logical; if TRUE, strips leading "1" from 11-digit US numbers.
#' @param na_if_blank Logical; if TRUE, blank/whitespace-only inputs become `invalid`.
#' @param strict Logical; When strict = TRUE, numbers must be 10 digits (or 7 digits if allow_7 = TRUE).
#'
#' @return A character vector of normalized phone numbers.
#' @export
normalize_phone <- function(
    phone,
    format = c("dash", "digits", "e164"),
    country = "US",
    invalid = NA_character_,
    allow_7 = FALSE,
    keep_extension = FALSE,
    extension_sep = " x",
    strip_leading_country = TRUE,
    na_if_blank = TRUE,
    strict = TRUE
) {
  format <- match.arg(format)

  phone <- as.character(phone)
  n <- length(phone)
  out <- rep(invalid, n)

  if (na_if_blank) {
    blank <- is.na(phone) | !nzchar(trimws(phone))
    phone[blank] <- NA_character_
  }

  # Work on a "main number" string with any extension removed
  phone_main <- phone

  # Detect extensions (for stripping and optional retention)
  has_ext <- !is.na(phone) & grepl("(ext\\.?|extension|x|#)\\s*\\d+", phone, ignore.case = TRUE)

  # Strip extension portion *always* so extension digits don't contaminate the main number
  phone_main[has_ext] <- sub("(ext\\.?|extension|x|#)\\s*\\d+.*$", "", phone_main[has_ext], ignore.case = TRUE)

  # Capture extension digits only if requested
  ext <- rep("", n)
  if (keep_extension) {
    ext[has_ext] <- sub(".*?(ext\\.?|extension|x|#)\\s*(\\d+).*", "\\2", phone[has_ext], ignore.case = TRUE)
  }

  # Keep digits only (from main number only)
  digits <- rep("", n)
  ok <- !is.na(phone_main)
  digits[ok] <- gsub("[^0-9]", "", phone_main[ok])

  # Optionally strip leading US country code
  if (strip_leading_country && toupper(country) == "US") {
    idx <- nchar(digits) == 11 & substr(digits, 1, 1) == "1"
    digits[idx] <- substr(digits[idx], 2, 11)
  }

  # Valid lengths
  is_10 <- nchar(digits) == 10
  is_7  <- allow_7 & nchar(digits) == 7

  if (!strict) {
    salvage <- nchar(digits) > 10
    digits[salvage] <- substr(digits[salvage], nchar(digits[salvage]) - 9, nchar(digits[salvage]))
    is_10 <- nchar(digits) == 10
    is_7  <- allow_7 & nchar(digits) == 7
  }

  valid <- is_10 | is_7

  if (format == "digits") {
    out[is_10] <- digits[is_10]
    out[is_7]  <- digits[is_7]
  } else if (format == "dash") {
    out[is_10] <- paste0(
      substr(digits[is_10], 1, 3), "-",
      substr(digits[is_10], 4, 6), "-",
      substr(digits[is_10], 7, 10)
    )
    out[is_7] <- paste0(
      substr(digits[is_7], 1, 3), "-",
      substr(digits[is_7], 4, 7)
    )
  } else if (format == "e164") {
    if (toupper(country) != "US") {
      stop("`format = 'e164'` currently supports only `country = 'US'`.", call. = FALSE)
    }
    out[is_10] <- paste0("+1", digits[is_10])
    # 7-digit numbers can't be represented in E.164 without area code
    out[is_7] <- invalid
  }

  if (keep_extension) {
    has_ext_out <- valid & has_ext & nzchar(ext) & !is.na(out)
    out[has_ext_out] <- paste0(out[has_ext_out], extension_sep, ext[has_ext_out])
  }

  out
}
