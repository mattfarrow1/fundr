# Test the internal labeller function (doesn't require ggplot2)
test_that("make_currency_labeller formats basic values", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = FALSE,
    short_digits = 1,
    negative = "minus"
  )

  expect_equal(labeller(1000), "$1,000")
  expect_equal(labeller(1234567), "$1,234,567")
  expect_equal(labeller(0), "$0")
})

test_that("make_currency_labeller handles decimals", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 2,
    short = FALSE,
    short_digits = 1,
    negative = "minus"
  )

  expect_equal(labeller(1234.56), "$1,234.56")
  expect_equal(labeller(1000), "$1,000.00")
})

test_that("make_currency_labeller handles negative with minus", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = FALSE,
    short_digits = 1,
    negative = "minus"
  )

  expect_equal(labeller(-1000), "-$1,000")
})

test_that("make_currency_labeller handles negative with parens", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = FALSE,
    short_digits = 1,
    negative = "parens"
  )

  expect_equal(labeller(-1000), "($1,000)")
})

test_that("make_currency_labeller handles NA values", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = FALSE,
    short_digits = 1,
    negative = "minus"
  )

  result <- labeller(c(1000, NA, 2000))
  expect_equal(result[1], "$1,000")
  expect_true(is.na(result[2]))
  expect_equal(result[3], "$2,000")
})

test_that("make_currency_labeller handles empty input", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = FALSE,
    short_digits = 1,
    negative = "minus"
  )

  expect_equal(labeller(numeric(0)), character(0))
})

test_that("make_currency_labeller short format works for billions", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = TRUE,
    short_digits = 1,
    negative = "minus"
  )

  expect_equal(labeller(1000000000), "$1B")
  expect_equal(labeller(2500000000), "$2.5B")
})

test_that("make_currency_labeller short format works for millions", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = TRUE,
    short_digits = 1,
    negative = "minus"
  )

  expect_equal(labeller(1000000), "$1M")
  expect_equal(labeller(1500000), "$1.5M")
  expect_equal(labeller(2500000), "$2.5M")
})

test_that("make_currency_labeller short format works for thousands", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = TRUE,
    short_digits = 1,
    negative = "minus"
  )

  expect_equal(labeller(1000), "$1K")
  expect_equal(labeller(50000), "$50K")
  expect_equal(labeller(250000), "$250K")
})

test_that("make_currency_labeller short format handles small values", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = TRUE,
    short_digits = 1,
    negative = "minus"
  )

  expect_equal(labeller(500), "$500")
  expect_equal(labeller(99), "$99")
})

test_that("make_currency_labeller is vectorized", {
  labeller <- fundr:::make_currency_labeller(
    prefix = "$",
    suffix = "",
    big.mark = ",",
    decimal.mark = ".",
    digits = 0,
    short = TRUE,
    short_digits = 1,
    negative = "minus"
  )

  result <- labeller(c(1000, 50000, 2500000, 1000000000))
  expect_equal(result, c("$1K", "$50K", "$2.5M", "$1B"))
})

# Tests for scale functions (require ggplot2)
test_that("scale_y_currency returns a scale object", {
  skip_if_not_installed("ggplot2")

  scale <- scale_y_currency()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuous")
})

test_that("scale_x_currency returns a scale object", {
  skip_if_not_installed("ggplot2")

  scale <- scale_x_currency()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuous")
})

test_that("scale_y_currency with short=TRUE returns a scale object", {
  skip_if_not_installed("ggplot2")

  scale <- scale_y_currency(short = TRUE)
  expect_s3_class(scale, "Scale")
})

test_that("scale_y_currency accepts custom parameters", {
  skip_if_not_installed("ggplot2")

  scale <- scale_y_currency(prefix = "USD ", digits = 2, negative = "parens")
  expect_s3_class(scale, "Scale")
})
