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
# Create temporary files
tmp <- tempdir()
writeLines("a", file.path(tmp, "data1.csv"))
writeLines("b", file.path(tmp, "data2.csv"))

# List CSV files sorted by modification time
list_recent_files(tmp, pattern = "\\.csv$")
#> # A tibble: 2 × 4
#>   file      path                       size mtime              
#>   <chr>     <chr>                     <dbl> <dttm>             
#> 1 data2.csv /tmp/RtmpCxkqGh/data2.csv     2 2026-03-17 14:53:19
#> 2 data1.csv /tmp/RtmpCxkqGh/data1.csv     2 2026-03-17 14:53:19

# Clean up
unlink(file.path(tmp, c("data1.csv", "data2.csv")))
```
