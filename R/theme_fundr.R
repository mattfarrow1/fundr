#' fundr ggplot theme
#'
#' A minimal theme with fundraising-report friendly defaults.
#'
#' @inheritParams ggplot2::theme_minimal
#' @param plot_title_family,plot_title_size,plot_title_face Title font family, size, and face.
#' @param plot_title_margin Bottom margin (in points) below the plot title.
#' @param subtitle_family,subtitle_size,subtitle_face Subtitle font family, size, and face.
#' @param subtitle_margin Bottom margin (in points) below the subtitle.
#' @param strip_text_family,strip_text_size,strip_text_face Facet strip text font family, size, and face.
#' @param caption_family,caption_size,caption_face Caption font family, size, and face.
#' @param caption_margin Top margin (in points) above the caption.
#' @param axis_text_size Axis tick label text size.
#' @param axis_title_family,axis_title_size,axis_title_face Axis title font family, size, and face.
#' @param axis_title_just Two-character code controlling axis title justification; see Details.
#' @param plot_margin Plot margin; defaults to `ggplot2::margin(30, 30, 30, 30)`.
#' @param grid_col Color for grid lines.
#' @param grid Logical; if `TRUE` show major+minor grids. If a character string, controls which grids
#'   are shown: include `X`/`Y` for major x/y and `x`/`y` for minor x/y (e.g., `"XY"` or `"Xy"`).
#' @param axis_col Color for axis lines (when enabled).
#' @param axis Logical; if `TRUE` show both axes. If a character string, controls which axes are shown
#'   (e.g., `"x"`, `"y"`, `"xy"`).
#' @param ticks Logical; if `TRUE` show axis ticks.
#' @details
#' `axis_title_just` is interpreted as a two-character code, where the first character controls the
#' x-axis title (`l`, `m`/`c`, `r`) and the second controls the y-axis title (`b`, `m`/`c`, `t`).
#' The default `"rt"` places the x title right and the y title at the top.
#' @return A ggplot2 theme object.
#' @export
theme_fundr <- function(base_family = "montserrat", base_size = 12,
                        plot_title_family = base_family, plot_title_size = 16,
                        plot_title_face = "bold", plot_title_margin = 10,
                        subtitle_family = base_family, subtitle_size = 14,
                        subtitle_face = "plain", subtitle_margin = 15,
                        strip_text_family = base_family, strip_text_size = 10,
                        strip_text_face = "plain",
                        caption_family = base_family, caption_size = 10,
                        caption_face = "italic", caption_margin = 10,
                        axis_text_size = base_size,
                        axis_title_family = subtitle_family, axis_title_size = 10,
                        axis_title_face = "plain", axis_title_just = "rt",
                        plot_margin = NULL,
                        grid_col = "#cccccc", grid = TRUE,
                        axis_col = "#cccccc", axis = FALSE, ticks = FALSE) {
  fundr_needs("ggplot2")

  if (is.null(plot_margin)) {
    plot_margin <- ggplot2::margin(30, 30, 30, 30)
  }

  ret <- ggplot2::theme_minimal(base_family = base_family, base_size = base_size)

  ret <- ret + ggplot2::theme(legend.background = ggplot2::element_blank())
  ret <- ret + ggplot2::theme(legend.key = ggplot2::element_blank())

  if (inherits(grid, "character") || isTRUE(grid)) {
    ret <- ret + ggplot2::theme(panel.grid = ggplot2::element_line(color = grid_col, linewidth = 0.2))
    ret <- ret + ggplot2::theme(panel.grid.major = ggplot2::element_line(color = grid_col, linewidth = 0.2))
    ret <- ret + ggplot2::theme(panel.grid.minor = ggplot2::element_line(color = grid_col, linewidth = 0.15))

    if (inherits(grid, "character")) {
      if (regexpr("X", grid)[1] < 0) ret <- ret + ggplot2::theme(panel.grid.major.x = ggplot2::element_blank())
      if (regexpr("Y", grid)[1] < 0) ret <- ret + ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
      if (regexpr("x", grid)[1] < 0) ret <- ret + ggplot2::theme(panel.grid.minor.x = ggplot2::element_blank())
      if (regexpr("y", grid)[1] < 0) ret <- ret + ggplot2::theme(panel.grid.minor.y = ggplot2::element_blank())
    }
  } else {
    ret <- ret + ggplot2::theme(panel.grid = ggplot2::element_blank())
  }

  if (inherits(axis, "character") || isTRUE(axis)) {
    ret <- ret + ggplot2::theme(axis.line = ggplot2::element_line(color = "#2b2b2b", linewidth = 0.15))
    if (inherits(axis, "character")) {
      axis <- tolower(axis)
      if (regexpr("x", axis)[1] < 0) {
        ret <- ret + ggplot2::theme(axis.line.x = ggplot2::element_blank())
      } else {
        ret <- ret + ggplot2::theme(axis.line.x = ggplot2::element_line(color = axis_col, linewidth = 0.15))
      }
      if (regexpr("y", axis)[1] < 0) {
        ret <- ret + ggplot2::theme(axis.line.y = ggplot2::element_blank())
      } else {
        ret <- ret + ggplot2::theme(axis.line.y = ggplot2::element_line(color = axis_col, linewidth = 0.15))
      }
    } else {
      ret <- ret + ggplot2::theme(axis.line.x = ggplot2::element_line(color = axis_col, linewidth = 0.15))
      ret <- ret + ggplot2::theme(axis.line.y = ggplot2::element_line(color = axis_col, linewidth = 0.15))
    }
  } else {
    ret <- ret + ggplot2::theme(axis.line = ggplot2::element_blank())
  }

  if (!isTRUE(ticks)) {
    ret <- ret + ggplot2::theme(axis.ticks = ggplot2::element_blank())
    ret <- ret + ggplot2::theme(axis.ticks.x = ggplot2::element_blank())
    ret <- ret + ggplot2::theme(axis.ticks.y = ggplot2::element_blank())
  } else {
    ret <- ret + ggplot2::theme(axis.ticks = ggplot2::element_line(linewidth = 0.15))
    ret <- ret + ggplot2::theme(axis.ticks.x = ggplot2::element_line(linewidth = 0.15))
    ret <- ret + ggplot2::theme(axis.ticks.y = ggplot2::element_line(linewidth = 0.15))
    ret <- ret + ggplot2::theme(axis.ticks.length = grid::unit(5, "pt"))
  }

  xj <- switch(tolower(substr(axis_title_just, 1, 1)),
    b = 0,
    l = 0,
    m = 0.5,
    c = 0.5,
    r = 1,
    t = 1
  )
  yj <- switch(tolower(substr(axis_title_just, 2, 2)),
    b = 0,
    l = 0,
    m = 0.5,
    c = 0.5,
    r = 1,
    t = 1
  )

  ret <- ret + ggplot2::theme(axis.text.x = ggplot2::element_text(size = axis_text_size, margin = ggplot2::margin(t = 0)))
  ret <- ret + ggplot2::theme(axis.text.y = ggplot2::element_text(size = axis_text_size, margin = ggplot2::margin(r = 0)))
  ret <- ret + ggplot2::theme(axis.title = ggplot2::element_text(size = axis_title_size, family = axis_title_family))
  ret <- ret + ggplot2::theme(axis.title.x = ggplot2::element_text(
    hjust = xj, size = axis_title_size, family = axis_title_family, face = axis_title_face
  ))
  ret <- ret + ggplot2::theme(axis.title.y = ggplot2::element_text(
    hjust = yj, size = axis_title_size, family = axis_title_family, face = axis_title_face
  ))
  ret <- ret + ggplot2::theme(axis.title.y.right = ggplot2::element_text(
    hjust = yj, size = axis_title_size, angle = 90, family = axis_title_family, face = axis_title_face
  ))
  ret <- ret + ggplot2::theme(strip.text = ggplot2::element_text(
    hjust = 0, size = strip_text_size, face = strip_text_face, family = strip_text_family
  ))
  ret <- ret + ggplot2::theme(panel.spacing = grid::unit(2, "lines"))
  ret <- ret + ggplot2::theme(plot.title = ggplot2::element_text(
    hjust = 0, size = plot_title_size, margin = ggplot2::margin(b = plot_title_margin),
    family = plot_title_family, face = plot_title_face
  ))
  ret <- ret + ggplot2::theme(plot.subtitle = ggplot2::element_text(
    hjust = 0, size = subtitle_size, margin = ggplot2::margin(b = subtitle_margin),
    family = subtitle_family, face = subtitle_face
  ))
  ret <- ret + ggplot2::theme(plot.caption = ggplot2::element_text(
    hjust = 1, size = caption_size, margin = ggplot2::margin(t = caption_margin),
    family = caption_family, face = caption_face
  ))
  ret <- ret + ggplot2::theme(plot.margin = plot_margin)

  ret
}

#' Move legend to bottom of plot
#'
#' A convenience function that returns a theme element to place the legend
#' at the bottom of a ggplot. Commonly used in reports where horizontal
#' space is limited.
#'
#' @param direction Legend direction: "horizontal" (default) or "vertical".
#' @param justify Legend justification: "center" (default), "left", or "right".
#' @param box How to arrange multiple legends: "horizontal" or "vertical" (default).
#' @param title_position Position of legend title: "top" (default), "left",
#'   "right", or "bottom".
#'
#' @return A ggplot2 theme object that can be added to a plot.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' # Basic usage
#' ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   legend_bottom()
#'
#' # Horizontal legend with left justification
#' ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   legend_bottom(justify = "left")
#' }
#'
#' @export
legend_bottom <- function(
    direction = c("horizontal", "vertical"),
    justify = c("center", "left", "right"),
    box = c("vertical", "horizontal"),
    title_position = c("top", "left", "right", "bottom")
) {
  fundr_needs("ggplot2")

  direction <- match.arg(direction)
  justify <- match.arg(justify)
  box <- match.arg(box)
  title_position <- match.arg(title_position)

  hjust <- switch(
    justify,
    "left" = 0,
    "center" = 0.5,
    "right" = 1
  )

  ggplot2::theme(
    legend.position = "bottom",
    legend.direction = direction,
    legend.justification = c(hjust, 0.5),
    legend.box = box,
    legend.title.position = title_position
  )
}

#' Move legend to a specific position
#'
#' A convenience function that returns a theme element to control legend
#' position in ggplot2 plots.
#'
#' @param position Legend position: "bottom", "top", "left", "right", or "none".
#' @param direction Legend direction: "horizontal" or "vertical".
#'   Defaults to horizontal for bottom/top, vertical for left/right.
#' @param box How to arrange multiple legends: "horizontal" or "vertical".
#'
#' @return A ggplot2 theme object that can be added to a plot.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' # Legend on the right (default ggplot behavior)
#' ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   legend_position("right")
#'
#' # Remove legend
#' ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   legend_position("none")
#' }
#'
#' @export
legend_position <- function(
    position = c("bottom", "top", "left", "right", "none"),
    direction = NULL,
    box = c("vertical", "horizontal")
) {
  fundr_needs("ggplot2")

  position <- match.arg(position)
  box <- match.arg(box)

  if (position == "none") {
    return(ggplot2::theme(legend.position = "none"))
  }

  # Default direction based on position
  if (is.null(direction)) {
    direction <- if (position %in% c("bottom", "top")) "horizontal" else "vertical"
  }

  ggplot2::theme(
    legend.position = position,
    legend.direction = direction,
    legend.box = box
  )
}
