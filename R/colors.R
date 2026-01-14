#' fundr colors
#'
#' Named hex colors used by fundr palettes.
#'
#' @param ... Optional color names to return (e.g., "teal", "magenta"). If omitted,
#'   returns all colors.
#' @return A named character vector of hex color codes.
#' @export
fundr_colors <- function(...) {
  cols <- c(...)

  colors <- c(
    `red`         = "#ff0000",
    `white`       = "#f2ebe7",
    `peach`       = "#ff8d78",
    `magenta`     = "#933195",
    `teal`        = "#00a8bf",
    `aqua`        = "#97c2a3",
    `bright blue` = "#327fef",
    `violet`      = "#8c84e3",
    `pink`        = "#ed86e0",
    `purple`      = "#963ac7",
    `black`       = "#101921",
    `gray`        = "#d0ced5",
    `brown`       = "#7d3f16",
    `orange`      = "#ed8c00",
    `yellow`      = "#f2ce00",
    `green`       = "#909b44"
  )

  if (length(cols) == 0) return(colors)

  unknown <- setdiff(cols, names(colors))
  if (length(unknown) > 0) {
    stop(
      "Unknown color name(s): ", paste0("'", unknown, "'", collapse = ", "),
      call. = FALSE
    )
  }

  colors[cols]
}

#' fundr palettes
#'
#' @param palette Palette name: "primary", "secondary", or "tertiary".
#' @return An unnamed character vector of hex color codes.
#' @export
fundr_palette <- function(palette = c("primary", "secondary", "tertiary")) {
  palette <- match.arg(palette)

  palettes <- list(
    primary = fundr_colors("red", "white"),
    secondary = fundr_colors(
      "peach", "magenta", "teal", "aqua", "bright blue",
      "violet", "pink", "purple", "black", "gray"
    ),
    tertiary = fundr_colors("brown", "orange", "yellow", "green")
  )

  unname(palettes[[palette]])
}

#' Palette function for ggplot2 discrete scales
#'
#' @param palette Palette name: "primary", "secondary", or "tertiary".
#' @param direction If 1, use palette order; if -1, reverse.
#' @return A function that takes `n` and returns `n` colors.
#' @export
fundr_pal <- function(palette = c("primary", "secondary", "tertiary"), direction = 1) {
  palette <- match.arg(palette)
  direction <- ifelse(direction >= 0, 1, -1)

  function(n) {
    cols <- fundr_palette(palette)
    if (direction < 0) cols <- rev(cols)

    if (n > length(cols)) {
      warning("Requested ", n, " colors but palette has only ", length(cols), ".", call. = FALSE)
    }

    cols[seq_len(min(n, length(cols)))]
  }
}

#' Discrete fill scale using fundr palettes
#'
#' @param palette Palette name: "primary", "secondary", or "tertiary".
#' @param direction If 1, use palette order; if -1, reverse.
#' @param ... Passed to ggplot2::discrete_scale().
#' @export
scale_fill_fundr <- function(palette = c("primary", "secondary", "tertiary"), direction = 1, ...) {
  fundr_needs("ggplot2")
  palette <- match.arg(palette)

  ggplot2::discrete_scale(
    aesthetics = "fill",
    scale_name = "fundr",
    palette = fundr_pal(palette = palette, direction = direction),
    ...
  )
}

#' Discrete colour scale using fundr palettes
#'
#' @param palette Palette name: "primary", "secondary", or "tertiary".
#' @param direction If 1, use palette order; if -1, reverse.
#' @param ... Passed to ggplot2::discrete_scale().
#' @export
scale_colour_fundr <- function(palette = c("primary", "secondary", "tertiary"), direction = 1, ...) {
  fundr_needs("ggplot2")
  palette <- match.arg(palette)

  ggplot2::discrete_scale(
    aesthetics = "colour",
    scale_name = "fundr",
    palette = fundr_pal(palette = palette, direction = direction),
    ...
  )
}

#' @rdname scale_colour_fundr
#' @export
scale_color_fundr <- scale_colour_fundr
