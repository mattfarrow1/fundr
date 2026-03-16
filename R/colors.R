#' fundr colors
#'
#' Named hex colors used by fundr palettes.
#'
#' @param ... Optional color names to return (e.g., "teal", "magenta"). If omitted,
#'   returns all colors.
#' @return A named character vector of hex color codes.
#'
#' @examples
#' # Get all available colors
#' fundr_colors()
#'
#' # Get specific colors by name
#' fundr_colors("teal", "magenta")
#'
#' # Use in base R plotting
#' barplot(1:3, col = fundr_colors("teal", "peach", "purple"))
#'
#' @family colors
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
    fundr_abort(c(
      "Unknown color name(s) requested.",
      "x" = paste0("Unknown: ", paste0("'", unknown, "'", collapse = ", ")),
      "i" = paste0("Available colors: ", paste(names(colors), collapse = ", "))
    ))
  }

  colors[cols]
}

#' fundr palettes
#'
#' Returns a vector of hex colors from one of the fundr palettes.
#'
#' @param palette Palette name: "primary", "secondary", or "tertiary".
#' @return An unnamed character vector of hex color codes.
#'
#' @examples
#' # Get the primary palette (2 colors)
#' fundr_palette("primary")
#'
#' # Get the secondary palette (10 colors)
#' fundr_palette("secondary")
#'
#' # Get the tertiary palette (4 colors)
#' fundr_palette("tertiary")
#'
#' @family colors
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
#' Creates a function that returns `n` colors from a fundr palette.
#' Used internally by [scale_fill_fundr()] and [scale_colour_fundr()].
#'
#' @param palette Palette name: "primary", "secondary", or "tertiary".
#' @param direction If 1, use palette order; if -1, reverse.
#' @return A function that takes `n` and returns `n` colors.
#'
#' @examples
#' # Create a palette function
#' pal <- fundr_pal("secondary")
#'
#' # Get 3 colors from the palette
#' pal(3)
#'
#' # Reverse the palette direction
#' pal_rev <- fundr_pal("secondary", direction = -1)
#' pal_rev(3)
#'
#' @family colors
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
#'
#' @examplesIf requireNamespace("ggplot2", quietly = TRUE)
#' library(ggplot2)
#'
#' # Bar chart with fundr fill colors
#' ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
#'   geom_bar() +
#'   scale_fill_fundr("secondary")
#'
#' # Reverse palette direction
#' ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
#'   geom_bar() +
#'   scale_fill_fundr("tertiary", direction = -1)
#'
#' @family colors
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
#'
#' @examplesIf requireNamespace("ggplot2", quietly = TRUE)
#' library(ggplot2)
#'
#' # Scatter plot with fundr colors
#' ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
#'   geom_point(size = 3) +
#'   scale_colour_fundr("secondary")
#'
#' # US spelling also works
#' ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point(size = 3) +
#'   scale_color_fundr("tertiary")
#'
#' @family colors
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
