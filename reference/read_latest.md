# Read the most recent file in a folder

Combines
[`latest_file()`](https://mattfarrow1.github.io/fundr/reference/latest_file.md)
with a file reader to load the most recent file matching a pattern.
Automatically detects file type and uses the appropriate reader.

## Usage

``` r
read_latest(path, pattern = NULL, recursive = FALSE, reader = NULL, ...)
```

## Arguments

- path:

  Directory path to search in.

- pattern:

  Regular expression pattern to filter files. Default NULL matches all
  files.

- recursive:

  Logical. If TRUE, searches subdirectories. Default FALSE.

- reader:

  Function to read the file. Default NULL auto-detects based on file
  extension (supports .csv, .rds, .rda).

- ...:

  Additional arguments passed to the reader function.

## Value

The contents of the most recent file, or NULL if no matching files
found.

## Details

Auto-detection supports these file types:

- **.csv**: Uses
  [`utils::read.csv()`](https://rdrr.io/r/utils/read.table.html)

- **.rds**: Uses [`readRDS()`](https://rdrr.io/r/base/readRDS.html)

- **.rda/.RData**: Uses [`load()`](https://rdrr.io/r/base/load.html) and
  returns the first object

For other file types or custom reading behavior, provide a `reader`
function.

## Examples

``` r
if (FALSE) { # \dontrun{
# Read the most recent CSV
df <- read_latest("data/exports", pattern = "\\.csv$")

# Read with custom options
df <- read_latest("data/exports", pattern = "\\.csv$",
                  stringsAsFactors = FALSE)

# Use a custom reader
df <- read_latest("data/exports", pattern = "\\.xlsx$",
                  reader = readxl::read_excel)
} # }
```
