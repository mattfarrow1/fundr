# Internal helper: validate levels table structure
fundr_check_levels_table <- function(df, value_col, label_col, bucket_col) {
  if (!is.data.frame(df)) {
    fundr_abort(c(
      "Levels table must be a data frame.",
      "x" = paste0("Got: ", class(df)[1]),
      "i" = "Use a data frame like `fundr_gift_levels` or `fundr_rating_levels`."
    ))
  }

  req <- c(value_col, label_col, bucket_col)
  missing <- setdiff(req, names(df))
  if (length(missing) > 0) {
    fundr_abort(c(
      "Levels table is missing required columns.",
      "x" = paste0("Missing: ", paste(missing, collapse = ", ")),
      "i" = paste0("Required columns: ", paste(req, collapse = ", "))
    ))
  }

  values <- df[[value_col]]
  if (!is.numeric(values)) {
    fundr_abort(c(
      paste0("`", value_col, "` must be numeric in levels table."),
      "x" = paste0("Got: ", class(values)[1])
    ))
  }

  if (anyNA(values)) {
    fundr_abort(c(
      paste0("`", value_col, "` must not contain NA in levels table."),
      "i" = "Remove or replace NA values in the threshold column."
    ))
  }

  # We assume values are thresholds sorted ascending.
  if (is.unsorted(values, strictly = TRUE)) {
    fundr_abort(c(
      paste0("`", value_col, "` must be strictly increasing (ascending) in levels table."),
      "i" = "Sort thresholds from smallest to largest with no duplicates."
    ))
  }

  invisible(TRUE)
}

#' Bucket gift ask amounts using fundr_gift_levels
#'
#' Maps numeric ask amounts to the nearest threshold in `fundr_gift_levels`.
#' Returns labels such as "$1,000,000+" and/or broader buckets.
#'
#' @param ask_amount Numeric vector of ask amounts.
#' @param levels A levels table like `fundr_gift_levels`.
#' @param value_col Name of the numeric threshold column.
#' @param giving_level_col Name of the giving level label column.
#' @param bucket_col Name of the bucket label column.
#' @param what Which label to return: "giving_level" or "ask_bucket".
#' @param na_value Value to return when `ask_amount` is NA or cannot be bucketed.
#' @return A factor (ordered if the source column is ordered), or character if source is character.
#'
#' @examples
#' # Bucket gift amounts into giving levels
#' amounts <- c(500, 5000, 25000, 100000, 1500000, NA)
#' bucket_gift_level(amounts)
#'
#' # Return broader ask buckets instead
#' bucket_gift_level(amounts, what = "ask_bucket")
#'
#' # Vectorized for use in data frames
#' # df |> mutate(level = bucket_gift_level(gift_amount))
#'
#' @family bucketing
#' @export
bucket_gift_level <- function(
    ask_amount,
    levels = fundr_gift_levels,
    value_col = "ask_amount",
    giving_level_col = "giving_level",
    bucket_col = "ask_bucket",
    what = c("giving_level", "ask_bucket"),
    na_value = NA
) {
  what <- match.arg(what)

  fundr_check_levels_table(levels, value_col, giving_level_col, bucket_col)

  x <- suppressWarnings(as.numeric(ask_amount))
  out_chr <- rep(as.character(na_value), length(x))

  ok <- !is.na(x)
  if (!any(ok)) return(out_chr)

  thresholds <- levels[[value_col]]
  idx <- findInterval(x[ok], thresholds, rightmost.closed = TRUE)

  # Ensure values at/above the maximum threshold map to the top bucket
  idx[x[ok] >= max(thresholds)] <- length(thresholds)

  # below the smallest threshold -> NA
  valid_idx <- idx > 0
  if (any(valid_idx)) {
    col <- if (what == "giving_level") giving_level_col else bucket_col
    labels <- levels[[col]]

    picked_chr <- as.character(labels[idx[valid_idx]])
    out_ok <- rep(as.character(na_value), length(idx))
    out_ok[valid_idx] <- picked_chr
    out_chr[ok] <- out_ok
  }

  # If the source column is a factor, return a factor with identical levels/order
  col <- if (what == "giving_level") giving_level_col else bucket_col
  labels <- levels[[col]]
  if (is.factor(labels)) {
    return(factor(out_chr, levels = levels(labels), ordered = is.ordered(labels)))
  }

  out_chr
}

#' Bucket wealth/capacity values using fundr_rating_levels
#'
#' Maps numeric rating values to the nearest threshold in `fundr_rating_levels`.
#'
#' @param rating_value Numeric vector of rating values (capacity/wealth estimate).
#' @param levels A levels table like `fundr_rating_levels`.
#' @param value_col Name of the numeric threshold column.
#' @param level_col Name of the rating level label column.
#' @param bucket_col Name of the rating bucket column.
#' @param what Which label to return: "rating_level" or "rating_bucket".
#' @param na_value Value to return when `rating_value` is NA or cannot be bucketed.
#' @return A factor (ordered if the source column is ordered), or character if source is character.
#'
#' @examples
#' # Bucket capacity ratings into levels
#' ratings <- c(25000, 75000, 500000, 5000000, 150000000, NA)
#' bucket_rating_level(ratings)
#'
#' # Return broader rating buckets instead
#' bucket_rating_level(ratings, what = "rating_bucket")
#'
#' # Vectorized for use in data frames
#' # df |> mutate(rating = bucket_rating_level(estimated_capacity))
#'
#' @family bucketing
#' @export
bucket_rating_level <- function(
    rating_value,
    levels = fundr_rating_levels,
    value_col = "rating_value",
    level_col = "rating_level",
    bucket_col = "rating_bucket",
    what = c("rating_level", "rating_bucket"),
    na_value = NA
) {
  what <- match.arg(what)

  fundr_check_levels_table(levels, value_col, level_col, bucket_col)

  x <- suppressWarnings(as.numeric(rating_value))
  out_chr <- rep(as.character(na_value), length(x))

  ok <- !is.na(x)
  if (!any(ok)) return(out_chr)

  thresholds <- levels[[value_col]]
  idx <- findInterval(x[ok], thresholds, rightmost.closed = TRUE)

  # Ensure values at/above the maximum threshold map to the top bucket
  max_thr <- thresholds[length(thresholds)]
  idx[x[ok] >= max_thr] <- length(thresholds)

  valid_idx <- idx > 0
  if (any(valid_idx)) {
    col <- if (what == "rating_level") level_col else bucket_col
    labels <- levels[[col]]

    picked_chr <- as.character(labels[idx[valid_idx]])
    out_ok <- rep(as.character(na_value), length(idx))
    out_ok[valid_idx] <- picked_chr
    out_chr[ok] <- out_ok
  }

  col <- if (what == "rating_level") level_col else bucket_col
  labels <- levels[[col]]
  if (is.factor(labels)) {
    return(factor(out_chr, levels = levels(labels), ordered = is.ordered(labels)))
  }

  out_chr
}
