#' Ensure a Google Font is available for plotting
#'
#' Downloads/registers a Google Font via sysfonts and enables showtext rendering
#' so the font works reliably across devices.
#'
#' @param name Google Fonts family name (e.g., "Montserrat")
#' @param family The family name you'll reference in ggplot2 (e.g., "montserrat")
#' @param enable_showtext If TRUE, calls showtext::showtext_auto()
#' @param ... Passed to sysfonts::font_add_google() (e.g., db_cache = TRUE)
#'
#' @return Invisibly returns the family name.
#'
#' @examples
#' \dontrun{
#' # Load the default Montserrat font
#' fundr_use_google_font()
#'
#' # Load a different Google Font
#' fundr_use_google_font("Roboto", "roboto")
#'
#' # Use in ggplot2 with theme_fundr()
#' library(ggplot2)
#' fundr_use_google_font()
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_fundr()
#' }
#'
#' @family theme
#' @export
fundr_use_google_font <- function(
    name = "Montserrat",
    family = "montserrat",
    enable_showtext = TRUE,
    ...
) {
  fundr_needs("sysfonts", hint = "Google Font support uses sysfonts + showtext.")
  fundr_needs("showtext", hint = "Install showtext to render Google Fonts in plots.")

  # If already registered in this session, don't re-add
  if (!family %in% sysfonts::font_families()) {
    sysfonts::font_add_google(name = name, family = family, ...)
  }

  if (isTRUE(enable_showtext)) showtext::showtext_auto()
  invisible(family)
}
