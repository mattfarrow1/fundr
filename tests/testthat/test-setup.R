test_that("fundr_setup sets scipen option", {
  old <- fundr_setup(scipen = 999, quiet = TRUE)
  on.exit(options(old), add = TRUE)

  expect_equal(getOption("scipen"), 999L)
})

test_that("fundr_setup sets digits option", {
  old <- fundr_setup(digits = 5, quiet = TRUE)
  on.exit(options(old), add = TRUE)

  expect_equal(getOption("digits"), 5L)
})

test_that("fundr_setup returns old options invisibly", {
  original_scipen <- getOption("scipen")
  original_digits <- getOption("digits")

  old <- fundr_setup(scipen = 999, digits = 10, quiet = TRUE)
  on.exit(options(old), add = TRUE)

  expect_equal(old$scipen, original_scipen)
  expect_equal(old$digits, original_digits)
})

test_that("fundr_setup messages can be suppressed", {
  old <- getOption("scipen")
  on.exit(options(scipen = old), add = TRUE)

  expect_silent(fundr_setup(quiet = TRUE))
})

test_that("fundr_setup shows messages by default", {
  old <- getOption("scipen")
  on.exit(options(scipen = old), add = TRUE)

  expect_message(fundr_setup(quiet = FALSE), "fundr session configured")
})

test_that("fundr_setup sets fy_start_month option", {
  old <- fundr_setup(fy_start_month = 1, quiet = TRUE)
  on.exit(options(old), add = TRUE)

  expect_equal(getOption("fundr.fy_start_month"), 1L)
})

test_that("fundr_setup validates fy_start_month", {
  expect_error(fundr_setup(fy_start_month = 0, quiet = TRUE))
  expect_error(fundr_setup(fy_start_month = 13, quiet = TRUE))
})

# get_fy_start_month tests
test_that("get_fy_start_month returns default of 7", {
  old <- options(fundr.fy_start_month = NULL)
  on.exit(options(old), add = TRUE)

  expect_equal(get_fy_start_month(), 7L)
})

test_that("get_fy_start_month returns configured value", {
  old <- fundr_setup(fy_start_month = 10, quiet = TRUE)
  on.exit(options(old), add = TRUE)

  expect_equal(get_fy_start_month(), 10L)
})

# set_fy_start_month tests
test_that("set_fy_start_month updates option", {
  old <- getOption("fundr.fy_start_month")
  on.exit(options(fundr.fy_start_month = old), add = TRUE)

  set_fy_start_month(1)
  expect_equal(getOption("fundr.fy_start_month"), 1L)

  set_fy_start_month(10)
  expect_equal(getOption("fundr.fy_start_month"), 10L)
})

test_that("set_fy_start_month validates month", {
  expect_error(set_fy_start_month(0))
  expect_error(set_fy_start_month(13))
})

test_that("set_fy_start_month returns previous value", {
  old <- options(fundr.fy_start_month = 7L)
  on.exit(options(old), add = TRUE)

  prev <- set_fy_start_month(1)
  expect_equal(prev, 7L)
})

# Test that fy_year uses the option
test_that("fy_year uses fundr.fy_start_month option", {
  old <- options(fundr.fy_start_month = 1L)
  on.exit(options(old), add = TRUE)

  # With January fiscal year, Dec 2023 is FY2023, Jan 2024 is FY2024
  expect_equal(fy_year(as.Date("2023-12-15")), 2023L)
  expect_equal(fy_year(as.Date("2024-01-15")), 2024L)

  # Change to July
  options(fundr.fy_start_month = 7L)
  # With July fiscal year, Dec 2023 is FY2024
  expect_equal(fy_year(as.Date("2023-12-15")), 2024L)
})
