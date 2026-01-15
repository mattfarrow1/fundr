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
