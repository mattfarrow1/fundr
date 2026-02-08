#' Find the most recent file in a folder
#'
#' Scans a directory for files matching a pattern and returns the path to
#' the most recently modified file. Useful for loading the latest data
#' export or report.
#'
#' @param path Directory path to search in.
#' @param pattern Regular expression pattern to filter files. Default NULL
#'   matches all files.
#' @param full.names Logical. If TRUE (default), returns the full file path.
#'   If FALSE, returns just the filename.
#' @param recursive Logical. If TRUE, searches subdirectories recursively.
#'   Default FALSE.
#' @param by How to determine "most recent": "mtime" (modification time,
#'   default), "ctime" (creation/change time), or "atime" (access time).
#'
#' @return Character string with the path to the most recent file, or NULL
#'   if no matching files are found.
#'
#' @examples
#' \dontrun{
#' # Find the most recent CSV in a data folder
#' latest_file("data/exports", pattern = "\\.csv$")
#'
#' # Find the most recent Excel file
#' latest_file("data/reports", pattern = "\\.(xlsx?|xls)$")
#'
#' # Search recursively
#' latest_file("data", pattern = "\\.csv$", recursive = TRUE)
#' }
#'
#' @export
latest_file <- function(
    path,
    pattern = NULL,
    full.names = TRUE,
    recursive = FALSE,
    by = c("mtime", "ctime", "atime")
) {
  by <- match.arg(by)

  if (!dir.exists(path)) {
    fundr_abort(c(
      "Directory does not exist.",
      "x" = paste0("Path: ", path),
      "i" = "Check that the directory path is correct."
    ))
  }

  # List files
  files <- list.files(
    path,
    pattern = pattern,
    full.names = TRUE,
    recursive = recursive
  )

  if (length(files) == 0L) {
    return(NULL)
  }

  # Get file info
  info <- file.info(files)

  # Find most recent by specified time
  time_col <- info[[by]]
  if (all(is.na(time_col))) {
    return(NULL)
  }

  most_recent_idx <- which.max(time_col)
  result <- files[most_recent_idx]

  if (!isTRUE(full.names)) {
    result <- basename(result)
  }

  result
}

#' Read the most recent file in a folder
#'
#' Combines [latest_file()] with a file reader to load the most recent
#' file matching a pattern. Automatically detects file type and uses
#' the appropriate reader.
#'
#' @param path Directory path to search in.
#' @param pattern Regular expression pattern to filter files. Default NULL
#'   matches all files.
#' @param recursive Logical. If TRUE, searches subdirectories. Default FALSE.
#' @param reader Function to read the file. Default NULL auto-detects based
#'   on file extension (supports .csv, .rds, .rda).
#' @param ... Additional arguments passed to the reader function.
#'
#' @return The contents of the most recent file, or NULL if no matching
#'   files found.
#'
#' @details
#' Auto-detection supports these file types:
#' \itemize{
#'   \item \strong{.csv}: Uses `utils::read.csv()`
#'   \item \strong{.rds}: Uses `readRDS()`
#'   \item \strong{.rda/.RData}: Uses `load()` and returns the first object
#' }
#'
#' For other file types or custom reading behavior, provide a `reader`
#' function.
#'
#' @examples
#' \dontrun{
#' # Read the most recent CSV
#' df <- read_latest("data/exports", pattern = "\\.csv$")
#'
#' # Read with custom options
#' df <- read_latest("data/exports", pattern = "\\.csv$",
#'                   stringsAsFactors = FALSE)
#'
#' # Use a custom reader
#' df <- read_latest("data/exports", pattern = "\\.xlsx$",
#'                   reader = readxl::read_excel)
#' }
#'
#' @export
read_latest <- function(
    path,
    pattern = NULL,
    recursive = FALSE,
    reader = NULL,
    ...
) {
  # Find the most recent file
  file_path <- latest_file(
    path,
    pattern = pattern,
    full.names = TRUE,
    recursive = recursive
  )

  if (is.null(file_path)) {
    message("No matching files found in: ", path)
    return(NULL)
  }

  message("Reading: ", file_path)

  # Determine reader
  if (is.null(reader)) {
    reader <- detect_reader(file_path)
  }

  if (is.null(reader)) {
    fundr_abort(c(
      "Cannot auto-detect file reader.",
      "x" = paste0("Unknown file type: ", basename(file_path)),
      "i" = "Provide a `reader` function for this file type."
    ))
  }

  # Special handling for .rda/.RData files
  ext <- tolower(tools::file_ext(file_path))
  if (ext %in% c("rda", "rdata")) {
    env <- new.env()
    load(file_path, envir = env)
    objects <- ls(env)
    if (length(objects) == 0L) {
      return(NULL)
    }
    if (length(objects) > 1L) {
      message("Multiple objects in file, returning first: ", objects[1])
    }
    return(get(objects[1], envir = env))
  }

  # Read the file
  reader(file_path, ...)
}

#' @noRd
detect_reader <- function(file_path) {
  ext <- tolower(tools::file_ext(file_path))

  switch(
    ext,
    "csv" = utils::read.csv,
    "rds" = readRDS,
    "rda" = function(f, ...) NULL,  # Handled specially above
    "rdata" = function(f, ...) NULL,  # Handled specially above
    NULL
  )
}

#' List files sorted by modification time
#'
#' Returns a data frame of files with their metadata, sorted by modification
#' time (most recent first). Useful for reviewing available data files.
#'
#' @param path Directory path to search in.
#' @param pattern Regular expression pattern to filter files. Default NULL.
#' @param recursive Logical. If TRUE, searches subdirectories. Default FALSE.
#' @param n Maximum number of files to return. Default NULL returns all.
#'
#' @return A tibble (or data frame if tibble not installed) with columns:
#'   file (basename), path (full path), size (in bytes), mtime (modification
#'   time). Sorted by mtime descending.
#'
#' @examples
#' \dontrun{
#' # List recent CSV files
#' list_recent_files("data/exports", pattern = "\\.csv$", n = 10)
#' }
#'
#' @export
list_recent_files <- function(
    path,
    pattern = NULL,
    recursive = FALSE,
    n = NULL
) {
  if (!dir.exists(path)) {
    fundr_abort(c(
      "Directory does not exist.",
      "x" = paste0("Path: ", path),
      "i" = "Check that the directory path is correct."
    ))
  }

  files <- list.files(
    path,
    pattern = pattern,
    full.names = TRUE,
    recursive = recursive
  )

  if (length(files) == 0L) {
    return(fundr_df(
      file = character(0),
      path = character(0),
      size = numeric(0),
      mtime = as.POSIXct(character(0))
    ))
  }

  info <- file.info(files)

  result <- fundr_df(
    file = basename(files),
    path = files,
    size = info$size,
    mtime = info$mtime
  )

  # Sort by mtime descending
  result <- result[order(result$mtime, decreasing = TRUE), ]
  rownames(result) <- NULL

  # Limit to n if specified
 if (!is.null(n) && n > 0 && nrow(result) > n) {
    result <- result[seq_len(n), ]
  }

  result
}
