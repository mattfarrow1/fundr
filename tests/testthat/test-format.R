# format_currency tests
test_that("format_currency formats basic numbers", {
  expect_equal(format_currency(1234567), "$1,234,567")
  expect_equal(format_currency(1000), "$1,000")
  expect_equal(format_currency(0), "$0")
})
test_that("format_currency handles decimals", {
  expect_equal(format_currency(1234.567, digits = 2), "$1,234.57")
  expect_equal(format_currency(1234.5, digits = 2), "$1,234.50")
})

test_that("format_currency handles negative numbers with parens", {
 expect_equal(format_currency(-500), "($500)")
  expect_equal(format_currency(-1234567), "($1,234,567)")
})

test_that("format_currency handles negative numbers with minus sign", {
  expect_equal(format_currency(-500, negative = "minus"), "-$500")
  expect_equal(format_currency(-1234567, negative = "minus"), "-$1,234,567")
})

test_that("format_currency handles NA values", {
  expect_true(is.na(format_currency(NA)))
  result <- format_currency(c(100, NA, 200))
  expect_equal(result[1], "$100")
  expect_true(is.na(result[2]))
  expect_equal(result[3], "$200")
})

test_that("format_currency allows custom prefix", {
  expect_equal(format_currency(1000, prefix = "USD "), "USD 1,000")
  expect_equal(format_currency(1000, prefix = ""), "1,000")
})

test_that("format_currency is vectorized", {
  result <- format_currency(c(100, 1000, 10000))
  expect_equal(result, c("$100", "$1,000", "$10,000"))
})

# format_currency_short tests
test_that("format_currency_short formats billions", {
  expect_equal(format_currency_short(1000000000), "$1B")
  expect_equal(format_currency_short(2500000000), "$2.5B")
})

test_that("format_currency_short formats millions", {
  expect_equal(format_currency_short(1000000), "$1M")
  expect_equal(format_currency_short(1500000), "$1.5M")
  expect_equal(format_currency_short(2500000), "$2.5M")
})

test_that("format_currency_short formats thousands", {
  expect_equal(format_currency_short(1000), "$1K")
  expect_equal(format_currency_short(50000), "$50K")
  expect_equal(format_currency_short(250000), "$250K")
})

test_that("format_currency_short handles small numbers", {
  expect_equal(format_currency_short(500), "$500")
  expect_equal(format_currency_short(99), "$99")
})

test_that("format_currency_short handles NA values", {
  expect_true(is.na(format_currency_short(NA)))
})

test_that("format_currency_short handles negative numbers", {
  expect_equal(format_currency_short(-1500000), "-$1.5M")
  expect_equal(format_currency_short(-1500000, negative = "parens"), "($1.5M)")
})

test_that("format_currency_short is vectorized", {
  result <- format_currency_short(c(1000, 50000, 2500000, 1000000000))
  expect_equal(result, c("$1K", "$50K", "$2.5M", "$1B"))
})

# format_pct tests
test_that("format_pct formats proportions as percentages", {
  expect_equal(format_pct(0.5), "50.0%")
  expect_equal(format_pct(0.4567), "45.7%")
  expect_equal(format_pct(1), "100.0%")
})

test_that("format_pct handles digits parameter", {
  expect_equal(format_pct(0.4567, digits = 0), "46%")
  expect_equal(format_pct(0.4567, digits = 2), "45.67%")
})

test_that("format_pct handles symbol parameter", {
  expect_equal(format_pct(0.5, symbol = FALSE), "50.0")
})

test_that("format_pct handles multiply parameter", {
  expect_equal(format_pct(45.67, multiply = FALSE), "45.7%")
})

test_that("format_pct handles NA values", {
  expect_true(is.na(format_pct(NA)))
})

test_that("format_pct is vectorized", {
  result <- format_pct(c(0.1, 0.5, 0.9))
  expect_equal(result, c("10.0%", "50.0%", "90.0%"))
})
