# Tests for file utility functions

# latest_file ----

test_that("latest_file finds the most recent file", {
  # Create temp directory with files
 tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  # Create files with different modification times
  file1 <- file.path(tmp_dir, "file1.csv")
  file2 <- file.path(tmp_dir, "file2.csv")
  file3 <- file.path(tmp_dir, "file3.csv")

  writeLines("a", file1)
  Sys.sleep(0.1)
  writeLines("b", file2)
  Sys.sleep(0.1)
  writeLines("c", file3)

  result <- latest_file(tmp_dir, pattern = "\\.csv$")
  expect_equal(basename(result), "file3.csv")
})

test_that("latest_file filters by pattern", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  writeLines("a", file.path(tmp_dir, "file1.csv"))
  Sys.sleep(0.1)
  writeLines("b", file.path(tmp_dir, "file2.txt"))

  # Should find CSV even though txt is newer
  result <- latest_file(tmp_dir, pattern = "\\.csv$")
  expect_equal(basename(result), "file1.csv")

  # Should find txt
  result <- latest_file(tmp_dir, pattern = "\\.txt$")
  expect_equal(basename(result), "file2.txt")
})

test_that("latest_file returns NULL when no files match", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  writeLines("a", file.path(tmp_dir, "file1.csv"))

  result <- latest_file(tmp_dir, pattern = "\\.xlsx$")
  expect_null(result)
})

test_that("latest_file returns NULL for empty directory", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  result <- latest_file(tmp_dir)
  expect_null(result)
})

test_that("latest_file errors on non-existent directory", {
  expect_error(latest_file("/nonexistent/path/12345"))
})

test_that("latest_file respects full.names parameter", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  writeLines("a", file.path(tmp_dir, "file1.csv"))

  # full.names = TRUE (default)
  result <- latest_file(tmp_dir, full.names = TRUE)
  expect_true(grepl("^/", result) || grepl("^[A-Za-z]:", result))

  # full.names = FALSE
  result <- latest_file(tmp_dir, full.names = FALSE)
  expect_equal(result, "file1.csv")
})

test_that("latest_file works recursively", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  sub_dir <- file.path(tmp_dir, "subdir")
  dir.create(sub_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  writeLines("a", file.path(tmp_dir, "file1.csv"))
  Sys.sleep(0.1)
  writeLines("b", file.path(sub_dir, "file2.csv"))

  # Without recursive, should find file1
  result <- latest_file(tmp_dir, pattern = "\\.csv$", recursive = FALSE)
  expect_equal(basename(result), "file1.csv")

  # With recursive, should find file2
  result <- latest_file(tmp_dir, pattern = "\\.csv$", recursive = TRUE)
  expect_equal(basename(result), "file2.csv")
})

# list_recent_files ----

test_that("list_recent_files returns data frame", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  writeLines("a", file.path(tmp_dir, "file1.csv"))

  result <- list_recent_files(tmp_dir)
  expect_true(is.data.frame(result))
  expect_equal(names(result), c("file", "path", "size", "mtime"))
})

test_that("list_recent_files sorts by mtime descending", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  writeLines("a", file.path(tmp_dir, "file1.csv"))
  Sys.sleep(0.1)
  writeLines("b", file.path(tmp_dir, "file2.csv"))
  Sys.sleep(0.1)
  writeLines("c", file.path(tmp_dir, "file3.csv"))

  result <- list_recent_files(tmp_dir)
  expect_equal(result$file, c("file3.csv", "file2.csv", "file1.csv"))
})

test_that("list_recent_files respects n parameter", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  writeLines("a", file.path(tmp_dir, "file1.csv"))
  Sys.sleep(0.1)
  writeLines("b", file.path(tmp_dir, "file2.csv"))
  Sys.sleep(0.1)
  writeLines("c", file.path(tmp_dir, "file3.csv"))

  result <- list_recent_files(tmp_dir, n = 2)
  expect_equal(nrow(result), 2)
  expect_equal(result$file[1], "file3.csv")
})

test_that("list_recent_files returns empty data frame for empty directory", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  result <- list_recent_files(tmp_dir)
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 0)
})

test_that("list_recent_files errors on non-existent directory", {
  expect_error(list_recent_files("/nonexistent/path/12345"))
})

# read_latest ----

test_that("read_latest reads CSV files", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  write.csv(df, file.path(tmp_dir, "data.csv"), row.names = FALSE)

  result <- suppressMessages(read_latest(tmp_dir, pattern = "\\.csv$"))
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 3)
})

test_that("read_latest reads RDS files", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  saveRDS(df, file.path(tmp_dir, "data.rds"))

  result <- suppressMessages(read_latest(tmp_dir, pattern = "\\.rds$"))
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 3)
})

test_that("read_latest reads RDA files", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  my_data <- data.frame(x = 1:3, y = c("a", "b", "c"))
  save(my_data, file = file.path(tmp_dir, "data.rda"))

  result <- suppressMessages(read_latest(tmp_dir, pattern = "\\.rda$"))
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 3)
})

test_that("read_latest returns NULL when no files match", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  result <- suppressMessages(read_latest(tmp_dir, pattern = "\\.csv$"))
  expect_null(result)
})

test_that("read_latest uses custom reader", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  writeLines("test content", file.path(tmp_dir, "file.txt"))

  # Custom reader that returns the content
  result <- suppressMessages(read_latest(
    tmp_dir,
    pattern = "\\.txt$",
    reader = readLines
  ))
  expect_equal(result, "test content")
})

test_that("read_latest passes ... arguments to reader", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  write.csv(df, file.path(tmp_dir, "data.csv"), row.names = FALSE)

  # Pass stringsAsFactors argument
  result <- suppressMessages(read_latest(
    tmp_dir,
    pattern = "\\.csv$",
    stringsAsFactors = TRUE
  ))
  expect_true(is.factor(result$y))
})
