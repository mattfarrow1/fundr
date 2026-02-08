# Tests for partial date functions

# parse_partial_date ----

test_that("parse_partial_date handles year-only", {
  expect_equal(parse_partial_date("1980"), as.Date("1980-01-01"))
  expect_equal(parse_partial_date("2000"), as.Date("2000-01-01"))
})
test_that("parse_partial_date handles numeric year", {
  expect_equal(parse_partial_date(1980), as.Date("1980-01-01"))
})

test_that("parse_partial_date handles year-month YYYY-MM", {
  expect_equal(parse_partial_date("1980-06"), as.Date("1980-06-01"))
  expect_equal(parse_partial_date("1980/06"), as.Date("1980-06-01"))
  expect_equal(parse_partial_date("1980-6"), as.Date("1980-06-01"))
})

test_that("parse_partial_date handles year-month MM/YYYY", {
  expect_equal(parse_partial_date("06/1980"), as.Date("1980-06-01"))
  expect_equal(parse_partial_date("6-1980"), as.Date("1980-06-01"))
})

test_that("parse_partial_date handles month name formats", {
  expect_equal(parse_partial_date("Jun 1980"), as.Date("1980-06-01"))
  expect_equal(parse_partial_date("June 1980"), as.Date("1980-06-01"))
  expect_equal(parse_partial_date("1980 Jun"), as.Date("1980-06-01"))
  expect_equal(parse_partial_date("1980 June"), as.Date("1980-06-01"))
})

test_that("parse_partial_date passes through full dates", {
  expect_equal(parse_partial_date("1980-06-15"), as.Date("1980-06-15"))
  expect_equal(parse_partial_date("2000-12-25"), as.Date("2000-12-25"))
})

test_that("parse_partial_date respects day_default", {
  expect_equal(parse_partial_date("1980-06", day_default = 15), as.Date("1980-06-15"))
})

test_that("parse_partial_date respects month_default", {
  expect_equal(parse_partial_date("1980", month_default = 7), as.Date("1980-07-01"))
})

test_that("parse_partial_date filters by year range", {
  expect_true(is.na(parse_partial_date("1850")))
  expect_true(is.na(parse_partial_date("3000")))
  expect_equal(parse_partial_date("1850", year_min = 1800), as.Date("1850-01-01"))
})

test_that("parse_partial_date handles NA", {
  expect_true(is.na(parse_partial_date(NA)))
  result <- parse_partial_date(c("1980", NA, "1990"))
  expect_equal(result[1], as.Date("1980-01-01"))
  expect_true(is.na(result[2]))
  expect_equal(result[3], as.Date("1990-01-01"))
})

test_that("parse_partial_date handles invalid input", {
  expect_true(is.na(parse_partial_date("invalid")))
  expect_true(is.na(parse_partial_date("")))
  expect_true(is.na(parse_partial_date("abc123")))
})

test_that("parse_partial_date is vectorized", {
  input <- c("1980", "1990-06", "2000-12-25")
  expected <- as.Date(c("1980-01-01", "1990-06-01", "2000-12-25"))
  expect_equal(parse_partial_date(input), expected)
})

test_that("parse_partial_date validates day_default", {
  expect_error(parse_partial_date("1980", day_default = 0))
  expect_error(parse_partial_date("1980", day_default = 32))
})

test_that("parse_partial_date validates month_default", {
  expect_error(parse_partial_date("1980", month_default = 0))
  expect_error(parse_partial_date("1980", month_default = 13))
})

# calc_age_partial ----

test_that("calc_age_partial works with year-only", {
  # With midpoint (July 1), 1980 -> age depends on as_of date
  age <- calc_age_partial("1980", as_of = as.Date("2024-08-01"))
  expect_equal(age, 44L)

  # Before midpoint
  age <- calc_age_partial("1980", as_of = as.Date("2024-03-01"))
  expect_equal(age, 43L)
})

test_that("calc_age_partial works with year-month", {
  # With midpoint (15th), June 1980 -> depends on as_of
  age <- calc_age_partial("1980-06", as_of = as.Date("2024-06-20"))
  expect_equal(age, 44L)

  age <- calc_age_partial("1980-06", as_of = as.Date("2024-06-10"))
  expect_equal(age, 43L)
})

test_that("calc_age_partial works with full dates", {
  age <- calc_age_partial("1980-06-15", as_of = as.Date("2024-06-15"))
  expect_equal(age, 44L)
})

test_that("calc_age_partial handles assume_midpoint = FALSE", {
  # Without midpoint, uses Jan 1 for year-only

  age <- calc_age_partial("1980", as_of = as.Date("2024-02-01"), assume_midpoint = FALSE)
  expect_equal(age, 44L)
})

test_that("calc_age_partial handles NA", {
  expect_true(is.na(calc_age_partial(NA)))
})

test_that("calc_age_partial is vectorized", {
  # With midpoint, assumes July 15 for year-only dates
  ages <- calc_age_partial(c("1980", "1990", "2000"), as_of = as.Date("2024-08-01"))
  expect_equal(ages, c(44L, 34L, 24L))
})

test_that("calc_age_partial validates as_of", {
  expect_error(calc_age_partial("1980", as_of = NA))
  expect_error(calc_age_partial("1980", as_of = c(Sys.Date(), Sys.Date())))
})

test_that("calc_age_partial handles Date input", {
  age <- calc_age_partial(as.Date("1980-06-15"), as_of = as.Date("2024-06-15"))
  expect_equal(age, 44L)
})

# date_precision ----

test_that("date_precision detects year-only", {
  expect_equal(as.character(date_precision("1980")), "year")
  expect_equal(as.character(date_precision("2000")), "year")
})

test_that("date_precision detects year-month", {
  expect_equal(as.character(date_precision("1980-06")), "year-month")
  expect_equal(as.character(date_precision("1980/06")), "year-month")
  expect_equal(as.character(date_precision("06/1980")), "year-month")
  expect_equal(as.character(date_precision("Jun 1980")), "year-month")
})

test_that("date_precision detects full dates", {
  expect_equal(as.character(date_precision("1980-06-15")), "full")
  expect_equal(as.character(date_precision("2000-12-25")), "full")
})

test_that("date_precision handles invalid input", {
  expect_true(is.na(date_precision("invalid")))
  expect_true(is.na(date_precision("")))
})

test_that("date_precision handles NA", {
  expect_true(is.na(date_precision(NA)))
})

test_that("date_precision is vectorized", {
  input <- c("1980", "1980-06", "1980-06-15", "invalid")
  result <- date_precision(input)
  expect_equal(as.character(result[1]), "year")
  expect_equal(as.character(result[2]), "year-month")
  expect_equal(as.character(result[3]), "full")
  expect_true(is.na(result[4]))
})

test_that("date_precision returns factor", {
  result <- date_precision("1980")
  expect_true(is.factor(result))
  expect_equal(levels(result), c("year", "year-month", "full"))
})
