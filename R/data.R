#' Gift level reference table
#'
#' A reference table of common ask amounts, formatted giving level labels, and
#' broader ask buckets useful for reporting and segmentation.
#'
#' @format A data frame with 14 rows and 3 variables:
#' \describe{
#'   \item{ask_amount}{Numeric ask amount threshold.}
#'   \item{giving_level}{Ordered factor label for the threshold (e.g., "$1,000,000+").}
#'   \item{ask_bucket}{Ordered factor bucket label (e.g., "$1M to $2.49M").}
#' }
#' @source Internal conventions (fundr).
"fundr_gift_levels"

#' Rating level reference table
#'
#' A reference table of wealth or capacity rating levels, numeric thresholds,
#' and broader rating buckets commonly used in fundraising analytics.
#'
#' @format A data frame with 15 rows and 3 variables:
#' \describe{
#'   \item{rating_level}{Ordered factor rating label (e.g., "A - $100M+").}
#'   \item{rating_value}{Numeric threshold representing the rating level.}
#'   \item{rating_bucket}{Ordered factor grouping (Principal, Major, Mid-Level, Annual, Unrated).}
#' }
#' @source Internal conventions (fundr).
"fundr_rating_levels"
