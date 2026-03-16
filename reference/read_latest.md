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
# Create a temporary CSV file
tmp <- tempdir()
write.csv(mtcars[1:3, ], file.path(tmp, "test_data.csv"), row.names = FALSE)

# Read the most recent CSV
df <- read_latest(tmp, pattern = "\\.csv$")
#> Reading: /tmp/RtmpKsjrDO/test_data.csv
head(df)
#>    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> 1 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> 2 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> 3 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1

# Clean up
unlink(file.path(tmp, "test_data.csv"))
```
