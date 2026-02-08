# List files sorted by modification time

Returns a data frame of files with their metadata, sorted by
modification time (most recent first). Useful for reviewing available
data files.

## Usage

``` r
list_recent_files(path, pattern = NULL, recursive = FALSE, n = NULL)
```

## Arguments

- path:

  Directory path to search in.

- pattern:

  Regular expression pattern to filter files. Default NULL.

- recursive:

  Logical. If TRUE, searches subdirectories. Default FALSE.

- n:

  Maximum number of files to return. Default NULL returns all.

## Value

A tibble (or data frame if tibble not installed) with columns: file
(basename), path (full path), size (in bytes), mtime (modification
time). Sorted by mtime descending.

## Examples

``` r
if (FALSE) { # \dontrun{
# List recent CSV files
list_recent_files("data/exports", pattern = "\\.csv$", n = 10)
} # }
```
