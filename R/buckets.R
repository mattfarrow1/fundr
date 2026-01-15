# Internal helper: validate levels table structure
fundr_check_levels_table <- function(df, value_col, label_col, bucket_col) {
  stopifnot(is.data.frame(df))
  req <- c(value_col, label_col, bucket_col)
  missing <- setdiff(req, names(df))
  if (length(missing) > 0) {
    stop("Levels table is missing columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  values <- df[[value_col]]
  if (!is.numeric(values)) {
    stop("`", value_col, "` must be numeric in levels table.", call. = FALSE)
  }

  if (anyNA(values)) {
    stop("`", value_col, "` must not contain NA in levels table.", call. = FALSE)
  }

  # We assume values are thresholds sorted ascending.
  if (is.unsorted(values, strictly = TRUE)) {
    stop("`", value_col, "` must be strictly increasing (ascending) in levels table.", call. = FALSE)
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
