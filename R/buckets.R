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

# Preset definitions for gift_levels()
.gift_level_presets <- list(

  small = c(0, 0.01, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000),

  medium = c(0, 0.01, 1000, 5000, 10000, 25000, 50000, 100000, 250000, 500000, 1000000),

  large = c(0, 0.01, 100000, 250000, 500000, 750000, 1000000, 2500000, 5000000,
            10000000, 25000000, 50000000, 100000000, 150000000)
)

#' Get gift level thresholds
#'
#' Returns a subset of `fundr_gift_levels` based on a preset or custom thresholds.
#' Use this to get levels appropriate for your organization's gift size distribution.
#'
#' @param preset A preset name: "small", "medium", "large", or "all" (default).
#'   - "small": Annual fund focus, thresholds from $1 to $100K
#'   - "medium": Leadership/major gifts, thresholds from $1K to $1M
#'   - "large": Principal gifts, thresholds from $100K to $150M+
#'   - "all": All available thresholds (comprehensive)
#' @param include Numeric vector of specific thresholds to include. If provided,
#'   overrides `preset`. Values must exist in `fundr_gift_levels$ask_amount`.
#' @return A data frame with columns `ask_amount`, `giving_level`, and `ask_bucket`,
#'   suitable for use with [bucket_gift_level()].
#'
#' @examples
#' # Get small shop levels (annual fund focus)
#' gift_levels("small")
#'
#' # Get large shop levels (principal gifts)
#' gift_levels("large")
#'
#' # Get all levels
#' gift_levels()
#'
#' # Custom selection of thresholds
#' gift_levels(include = c(0, 0.01, 1000, 10000, 100000))
#'
#' # Use with bucket_gift_level()
#' amounts <- c(500, 5000, 25000, 100000)
#' bucket_gift_level(amounts, levels = gift_levels("small"))
#'
#' @family bucketing
#' @export
gift_levels <- function(preset = c("all", "small", "medium", "large"),
                        include = NULL) {
  if (!is.null(include)) {
    if (!is.numeric(include)) {
      fundr_abort(c(
        "`include` must be a numeric vector of thresholds.",
        "x" = paste0("Got: ", class(include)[1])
      ))
    }

    valid <- include %in% fundr_gift_levels$ask_amount
    if (!all(valid)) {
      invalid <- include[!valid]
      fundr_abort(c(
        "Some thresholds in `include` are not in `fundr_gift_levels`.",
        "x" = paste0("Invalid: ", paste(invalid, collapse = ", ")),
        "i" = "Use thresholds from `fundr_gift_levels$ask_amount`."
      ))
    }

    out <- fundr_gift_levels[fundr_gift_levels$ask_amount %in% include, ]
    out <- out[order(out$ask_amount), ]
    rownames(out) <- NULL

    # Preserve factor levels but drop unused
    out$giving_level <- factor(
      as.character(out$giving_level),
      levels = intersect(levels(fundr_gift_levels$giving_level),
                         as.character(out$giving_level)),
      ordered = TRUE
    )
    out$ask_bucket <- factor(
      as.character(out$ask_bucket),
      levels = intersect(levels(fundr_gift_levels$ask_bucket),
                         as.character(out$ask_bucket)),
      ordered = TRUE
    )
    return(out)
  }

  preset <- match.arg(preset)

  if (preset == "all") {
    return(fundr_gift_levels)
  }

  thresholds <- .gift_level_presets[[preset]]
  out <- fundr_gift_levels[fundr_gift_levels$ask_amount %in% thresholds, ]
  rownames(out) <- NULL

  # Preserve factor levels but drop unused
  out$giving_level <- factor(
    as.character(out$giving_level),
    levels = intersect(levels(fundr_gift_levels$giving_level),
                       as.character(out$giving_level)),
    ordered = TRUE
  )
  out$ask_bucket <- factor(
    as.character(out$ask_bucket),
    levels = intersect(levels(fundr_gift_levels$ask_bucket),
                       as.character(out$ask_bucket)),
    ordered = TRUE
  )

  out
}

#' Bucket gift ask amounts using fundr_gift_levels
#'
#' Maps numeric ask amounts to the nearest threshold in `fundr_gift_levels`.
#' Returns labels such as "$1,000,000+" and/or broader buckets.
#'
#' @param ask_amount Numeric vector of ask amounts.
#' @param levels A levels table like `fundr_gift_levels`, or a preset name
#'   ("small", "medium", "large", "all"). See [gift_levels()] for details on
#'   presets.
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
#' # Use a preset for smaller gift ranges
#' bucket_gift_level(amounts, levels = "small")
#'
#' # Return broader ask buckets instead
#' bucket_gift_level(amounts, what = "ask_bucket")
#'
#' # Vectorized for use in data frames
#' # df |> mutate(level = bucket_gift_level(gift_amount))
#'
#' @seealso [gift_levels()] for creating custom level tables
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


  # Allow preset strings for convenience
  if (is.character(levels) && length(levels) == 1) {
    valid_presets <- c("small", "medium", "large", "all")
    if (!levels %in% valid_presets) {
      fundr_abort(c(
        paste0("`levels` must be a data frame or one of: ",
               paste(valid_presets, collapse = ", ")),
        "x" = paste0("Got: \"", levels, "\"")
      ))
    }
    levels <- gift_levels(levels)
  }

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

# Preset definitions for rating_levels()
# Each preset defines: thresholds to include and bucket assignments
.rating_level_presets <- list(
  # Small: community foundations, small nonprofits

  # Major starts at $25K, Principal at $250K
  small = list(
    include = c(0, 1, 5000, 25000, 250000, 1000000, 5000000, 25000000),
    buckets = c("Unrated", "Annual", "Mid-Level", "Major", "Principal",
                "Principal", "Principal", "Principal")
  ),

  # Medium: mid-size organizations
  # Major starts at $50K, Principal at $1M
  medium = list(
    include = c(0, 1, 10000, 50000, 100000, 250000, 1000000, 5000000,
                25000000, 100000000),
    buckets = c("Unrated", "Annual", "Mid-Level", "Major", "Major",
                "Major", "Principal", "Principal", "Principal", "Principal")
  ),

  # Large: universities, hospitals, large institutions
  # Major starts at $100K, Principal at $5M
  large = list(
    include = c(0, 1, 5000, 10000, 25000, 50000, 100000, 250000, 500000,
                1000000, 2500000, 5000000, 10000000, 25000000, 50000000,
                100000000),
    buckets = c("Unrated", "Annual", "Annual", "Annual", "Mid-Level",
                "Mid-Level", "Major", "Major", "Major", "Major", "Major",
                "Principal", "Principal", "Principal", "Principal", "Principal")
  )
)

#' Get rating level thresholds
#'
#' Returns a subset of `fundr_rating_levels` based on a preset or custom
#' thresholds. Use this to get levels appropriate for your organization's
#' capacity rating scale.
#'
#' @param preset A preset name: "small", "medium", "large", or "all" (default).
#'   - "small": Major at $25K+, Principal at $250K+ (community foundations)
#'   - "medium": Major at $50K+, Principal at $1M+ (mid-size orgs)
#'   - "large": Major at $100K+, Principal at $5M+ (universities, hospitals)
#'   - "all": All available thresholds (comprehensive)
#' @param include Numeric vector of specific thresholds to include. If provided,
#'   overrides `preset`. Values must exist in `fundr_rating_levels$rating_value`.
#' @param bucket_map Named character vector mapping thresholds to buckets.
#'   Names should be threshold values (as character), values should be bucket
#'   names ("Principal", "Major", "Mid-Level", "Annual", "Unrated").
#'   Only used with `include`.
#' @return A data frame with columns `rating_value`, `rating_level`, and
#'   `rating_bucket`, suitable for use with [bucket_rating_level()].
#'
#' @examples
#' # Get small shop levels
#' rating_levels("small")
#'
#' # Get large shop levels
#' rating_levels("large")
#'
#' # Get all levels
#' rating_levels()
#'
#' # Custom selection with custom bucket assignments
#' rating_levels(
#'   include = c(0, 1, 10000, 50000, 250000),
#'   bucket_map = c("0" = "Unrated", "1" = "Annual", "10000" = "Mid-Level",
#'                  "50000" = "Major", "250000" = "Principal")
#' )
#'
#' # Use with bucket_rating_level()
#' ratings <- c(5000, 50000, 500000)
#' bucket_rating_level(ratings, levels = rating_levels("small"))
#'
#' @family bucketing
#' @export
rating_levels <- function(preset = c("all", "small", "medium", "large"),
                          include = NULL,
                          bucket_map = NULL) {

  if (!is.null(include)) {
    if (!is.numeric(include)) {
      fundr_abort(c(
        "`include` must be a numeric vector of thresholds.",
        "x" = paste0("Got: ", class(include)[1])
      ))
    }

    valid <- include %in% fundr_rating_levels$rating_value
    if (!all(valid)) {
      invalid <- include[!valid]
      fundr_abort(c(
        "Some thresholds in `include` are not in `fundr_rating_levels`.",
        "x" = paste0("Invalid: ", paste(invalid, collapse = ", ")),
        "i" = "Use thresholds from `fundr_rating_levels$rating_value`."
      ))
    }

    out <- fundr_rating_levels[fundr_rating_levels$rating_value %in% include, ]
    out <- out[order(out$rating_value), ]
    rownames(out) <- NULL

    # Apply custom bucket mapping if provided
    if (!is.null(bucket_map)) {
      for (thresh in names(bucket_map)) {
        idx <- which(out$rating_value == as.numeric(thresh))
        if (length(idx) == 1) {
          out$rating_bucket[idx] <- bucket_map[[thresh]]
        }
      }
    }

    # Preserve factor levels but drop unused
    out$rating_level <- factor(
      as.character(out$rating_level),
      levels = intersect(levels(fundr_rating_levels$rating_level),
                         as.character(out$rating_level)),
      ordered = TRUE
    )
    out$rating_bucket <- factor(
      as.character(out$rating_bucket),
      levels = c("Principal", "Major", "Mid-Level", "Annual", "Unrated"),
      ordered = TRUE
    )
    return(out)
  }

  preset <- match.arg(preset)

  if (preset == "all") {
    return(fundr_rating_levels)
  }

  preset_def <- .rating_level_presets[[preset]]
  thresholds <- preset_def$include
  bucket_assignments <- preset_def$buckets

  out <- fundr_rating_levels[fundr_rating_levels$rating_value %in% thresholds, ]
  out <- out[order(out$rating_value), ]
  rownames(out) <- NULL

  # Apply preset bucket assignments
  out$rating_bucket <- bucket_assignments

  # Preserve factor levels
  out$rating_level <- factor(
    as.character(out$rating_level),
    levels = intersect(levels(fundr_rating_levels$rating_level),
                       as.character(out$rating_level)),
    ordered = TRUE
  )
  out$rating_bucket <- factor(
    out$rating_bucket,
    levels = c("Principal", "Major", "Mid-Level", "Annual", "Unrated"),
    ordered = TRUE
  )

  out
}

#' Bucket wealth/capacity values using fundr_rating_levels
#'
#' Maps numeric rating values to the nearest threshold in `fundr_rating_levels`.
#'
#' @param rating_value Numeric vector of rating values (capacity/wealth estimate).
#' @param levels A levels table like `fundr_rating_levels`, or a preset name
#'   ("small", "medium", "large", "all"). See [rating_levels()] for details on
#'   presets.
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
#' # Use a preset for smaller organizations
#' bucket_rating_level(ratings, levels = "small")
#'
#' # Return broader rating buckets instead
#' bucket_rating_level(ratings, what = "rating_bucket")
#'
#' # Vectorized for use in data frames
#' # df |> mutate(rating = bucket_rating_level(estimated_capacity))
#'
#' @seealso [rating_levels()] for creating custom level tables
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

  # Allow preset strings for convenience
  if (is.character(levels) && length(levels) == 1) {
    valid_presets <- c("small", "medium", "large", "all")
    if (!levels %in% valid_presets) {
      fundr_abort(c(
        paste0("`levels` must be a data frame or one of: ",
               paste(valid_presets, collapse = ", ")),
        "x" = paste0("Got: \"", levels, "\"")
      ))
    }
    levels <- rating_levels(levels)
  }

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
