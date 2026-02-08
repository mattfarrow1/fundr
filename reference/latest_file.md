# Find the most recent file in a folder

Scans a directory for files matching a pattern and returns the path to
the most recently modified file. Useful for loading the latest data
export or report.

## Usage

``` r
latest_file(
  path,
  pattern = NULL,
  full.names = TRUE,
  recursive = FALSE,
  by = c("mtime", "ctime", "atime")
)
```

## Arguments

- path:

  Directory path to search in.

- pattern:

  Regular expression pattern to filter files. Default NULL matches all
  files.

- full.names:

  Logical. If TRUE (default), returns the full file path. If FALSE,
  returns just the filename.

- recursive:

  Logical. If TRUE, searches subdirectories recursively. Default FALSE.

- by:

  How to determine "most recent": "mtime" (modification time, default),
  "ctime" (creation/change time), or "atime" (access time).

## Value

Character string with the path to the most recent file, or NULL if no
matching files are found.

## Examples

``` r
if (FALSE) { # \dontrun{
# Find the most recent CSV in a data folder
latest_file("data/exports", pattern = "\\.csv$")

# Find the most recent Excel file
latest_file("data/reports", pattern = "\\.(xlsx?|xls)$")

# Search recursively
latest_file("data", pattern = "\\.csv$", recursive = TRUE)
} # }
```
