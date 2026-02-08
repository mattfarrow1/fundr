# Tests for utility functions

# %notin% operator ----

test_that("%notin% returns negation of %in%", {
  result <- c(1, 2, 3, 4, 5) %notin% c(2, 4)
  expect_equal(result, c(TRUE, FALSE, TRUE, FALSE, TRUE))
})

test_that("%notin% handles empty table", {
  result <- c(1, 2, 3) %notin% integer(0)
  expect_equal(result, c(TRUE, TRUE, TRUE))
})

test_that("%notin% handles character vectors", {
  result <- c("a", "b", "c") %notin% c("b")
  expect_equal(result, c(TRUE, FALSE, TRUE))
})

test_that("%notin% handles NA", {
  # NA %in% table returns FALSE, so NA %notin% table returns TRUE
  result <- c(1, NA, 3) %notin% c(1)
  expect_equal(result, c(FALSE, TRUE, TRUE))
})

# %!in% operator ----

test_that("%!in% is alias for %notin%", {
  x <- c(1, 2, 3, 4, 5)
  table <- c(2, 4)
  expect_equal(x %!in% table, x %notin% table)
})

# comment_block ----

test_that("comment_block creates bordered comment", {
  result <- comment_block("Test")
  expect_true(grepl("^#", result))
  expect_true(grepl("Test", result))
})

test_that("comment_block centers text", {
  result <- comment_block("Hi", width = 20)
  lines <- strsplit(result, "\n")[[1]]
  # Check middle line has text centered
  expect_true(any(grepl("\\s+Hi\\s+", lines)))
})

test_that("comment_block respects width", {
  result <- comment_block("Test", width = 40)
  lines <- strsplit(result, "\n")[[1]]
  expect_true(all(nchar(lines) <= 40))
})

# comment_header ----

test_that("comment_header creates simple header", {
  result <- comment_header("Setup")
  expect_true(grepl("^# Setup", result))
  expect_true(grepl("-+$", result))
})

test_that("comment_header respects width", {
  result <- comment_header("Test", width = 40)
  expect_equal(nchar(result), 40)
})

test_that("comment_header uses custom char", {
  result <- comment_header("Test", char = "=")
  expect_true(grepl("=+$", result))
})

# comment_divider ----

test_that("comment_divider creates divider line", {
  result <- comment_divider()
  expect_true(grepl("^# =+$", result))
})

test_that("comment_divider respects width", {
  result <- comment_divider(width = 40)
  expect_equal(nchar(result), 40)
})

test_that("comment_divider uses custom char", {
  result <- comment_divider(char = "-")
  expect_true(grepl("^# -+$", result))
})
