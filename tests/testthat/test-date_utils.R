# Tests for date utility functions

# date_interval ----

test_that("date_interval calculates days correctly", {
  result <- date_interval(
    as.Date("2024-01-01"),
    as.Date("2024-01-15"),
    unit = "days"
  )
  expect_equal(result, 14)
})

test_that("date_interval calculates weeks correctly", {
  result <- date_interval(
    as.Date("2024-01-01"),
    as.Date("2024-01-15"),
    unit = "weeks"
  )
  expect_equal(result, 2)
})

test_that("date_interval calculates months correctly", {
  result <- date_interval(
    as.Date("2024-01-15"),
    as.Date("2024-06-15"),
    unit = "months"
  )
  expect_equal(result, 5)
})

test_that("date_interval calculates years correctly", {
  result <- date_interval(
    as.Date("2020-06-15"),
    as.Date("2024-06-15"),
    unit = "years"
  )
  expect_equal(result, 4)
})

test_that("date_interval handles partial years", {
  result <- date_interval(
    as.Date("2020-06-15"),
    as.Date("2024-03-15"),
    unit = "years"
  )
  expect_true(result > 3.5 && result < 4)
})

test_that("date_interval respects digits parameter", {
  result <- date_interval(
    as.Date("2020-01-01"),
    as.Date("2024-06-15"),
    unit = "years",
    digits = 2
  )
  # Should have at most 2 decimal places
  expect_equal(result, round(result, 2))
})

test_that("date_interval handles NULL digits", {
  result <- date_interval(
    as.Date("2020-01-01"),
    as.Date("2024-06-15"),
    unit = "years",
    digits = NULL
  )
  expect_true(is.numeric(result))
})

test_that("date_interval handles NA", {
  expect_true(is.na(date_interval(NA, as.Date("2024-01-01"))))
  expect_true(is.na(date_interval(as.Date("2024-01-01"), NA)))
})

test_that("date_interval is vectorized", {
  from <- as.Date(c("2020-01-01", "2022-01-01", "2023-01-01"))
  to <- as.Date("2024-01-01")
  result <- date_interval(from, to, unit = "years")
  expect_equal(result, c(4, 2, 1))
})

test_that("date_interval handles negative intervals", {
  result <- date_interval(
    as.Date("2024-06-15"),
    as.Date("2024-01-15"),
    unit = "months"
  )
  expect_true(result < 0)
})

test_that("date_interval defaults to today", {
  result <- date_interval(Sys.Date() - 365, unit = "days")
  expect_true(result >= 364 && result <= 366)
})

# bucket_recency ----

test_that("bucket_recency creates default buckets", {
  dates <- as.Date(c("2024-06-15", "2023-03-01", "2020-12-25", "2015-01-01"))
  result <- bucket_recency(dates, as_of = as.Date("2024-06-15"))

  expect_true(is.factor(result))
  expect_true(is.ordered(result))
  expect_equal(length(result), 4)
})

test_that("bucket_recency assigns this year correctly", {
  result <- bucket_recency(
    as.Date("2024-03-15"),
    as_of = as.Date("2024-06-15")
  )
  expect_equal(as.character(result), "This year")
})

test_that("bucket_recency assigns last year correctly", {
  result <- bucket_recency(
    as.Date("2023-03-15"),
    as_of = as.Date("2024-06-15")
  )
  expect_equal(as.character(result), "Last year")
})

test_that("bucket_recency handles fiscal year mode", {
  # In FY mode with July start, June 2024 is FY2024
  # December 2023 is also FY2024
  result <- bucket_recency(
    as.Date("2023-12-15"),
    as_of = as.Date("2024-06-15"),
    use_fiscal = TRUE,
    fy_start_month = 7
  )
  expect_equal(as.character(result), "This year")
})

test_that("bucket_recency handles custom buckets", {
  dates <- as.Date(c("2024-01-01", "2020-01-01"))
  result <- bucket_recency(
    dates,
    as_of = as.Date("2024-06-15"),
    buckets = c(0, 1, 3),
    labels = c("Current", "Last year", "1-3 years", "3+ years")
  )

  expect_equal(as.character(result[1]), "Current")
  expect_equal(as.character(result[2]), "3+ years")
})

test_that("bucket_recency handles NA", {
  result <- bucket_recency(NA, as_of = as.Date("2024-06-15"))
  expect_true(is.na(result))

  dates <- as.Date(c("2024-01-01", NA, "2020-01-01"))
  result <- bucket_recency(dates, as_of = as.Date("2024-06-15"))
  expect_false(is.na(result[1]))
  expect_true(is.na(result[2]))
  expect_false(is.na(result[3]))
})

test_that("bucket_recency validates as_of", {
  expect_error(bucket_recency(as.Date("2024-01-01"), as_of = NA))
  expect_error(bucket_recency(
    as.Date("2024-01-01"),
    as_of = c(Sys.Date(), Sys.Date())
  ))
})

test_that("bucket_recency validates buckets", {
  expect_error(bucket_recency(
    as.Date("2024-01-01"),
    buckets = c(5, 2, 1)  # Not sorted
  ))
})

test_that("bucket_recency validates labels length", {
  expect_error(bucket_recency(
    as.Date("2024-01-01"),
    buckets = c(0, 1, 2),
    labels = c("A", "B")  # Should have 4 labels
  ))
})

# is_within ----

test_that("is_within works with years", {
  dates <- as.Date(c("2024-01-15", "2022-06-15", "2020-01-01"))
  result <- is_within(dates, 2, "years", as_of = as.Date("2024-06-15"))

  expect_equal(result, c(TRUE, TRUE, FALSE))
})

test_that("is_within works with months", {
  dates <- as.Date(c("2024-03-15", "2023-06-15"))
  result <- is_within(dates, 6, "months", as_of = as.Date("2024-06-15"))

  expect_equal(result, c(TRUE, FALSE))
})

test_that("is_within works with weeks", {
  dates <- as.Date(c("2024-06-01", "2024-01-01"))
  result <- is_within(dates, 4, "weeks", as_of = as.Date("2024-06-15"))

  expect_equal(result, c(TRUE, FALSE))
})

test_that("is_within works with days", {
  dates <- as.Date(c("2024-06-10", "2024-01-01"))
  result <- is_within(dates, 30, "days", as_of = as.Date("2024-06-15"))

  expect_equal(result, c(TRUE, FALSE))
})

test_that("is_within returns FALSE for future dates", {
  result <- is_within(
    as.Date("2025-01-01"),
    1,
    "years",
    as_of = as.Date("2024-06-15")
  )
  expect_false(result)
})

test_that("is_within handles NA", {
  result <- is_within(NA, 1, "years")
  expect_true(is.na(result))
})

test_that("is_within validates within parameter", {
  expect_error(is_within(as.Date("2024-01-01"), -1, "years"))
  expect_error(is_within(as.Date("2024-01-01"), NA, "years"))
})

test_that("is_within validates as_of", {
  expect_error(is_within(as.Date("2024-01-01"), 1, "years", as_of = NA))
})

test_that("is_within is vectorized", {
  dates <- as.Date(c("2024-01-01", "2023-01-01", "2022-01-01"))
  result <- is_within(dates, 1.5, "years", as_of = as.Date("2024-06-15"))

  expect_equal(length(result), 3)
  expect_true(result[1])
  expect_false(result[3])
})

# last_weekday ----

test_that("last_weekday finds previous occurrence", {
  # 2024-06-15 is Saturday
  # Last Friday should be 2024-06-14
  result <- last_weekday("Friday", as_of = as.Date("2024-06-15"))
  expect_equal(result, as.Date("2024-06-14"))
})

test_that("last_weekday handles same day with include_today TRUE", {
  # 2024-06-14 is Friday
  result <- last_weekday("Friday", as_of = as.Date("2024-06-14"), include_today = TRUE)
  expect_equal(result, as.Date("2024-06-14"))
})

test_that("last_weekday handles same day with include_today FALSE", {
  # 2024-06-14 is Friday, go back to previous Friday
  result <- last_weekday("Friday", as_of = as.Date("2024-06-14"), include_today = FALSE)
  expect_equal(result, as.Date("2024-06-07"))
})

test_that("last_weekday accepts abbreviations", {
  result <- last_weekday("fri", as_of = as.Date("2024-06-15"))
  expect_equal(result, as.Date("2024-06-14"))
})

test_that("last_weekday accepts numeric day", {
  # 6 = Friday
  result <- last_weekday(6, as_of = as.Date("2024-06-15"))
  expect_equal(result, as.Date("2024-06-14"))
})

test_that("last_weekday validates as_of", {
  expect_error(last_weekday("Friday", as_of = NA))
})

test_that("last_weekday validates weekday", {
  expect_error(last_weekday("invalid"))
  expect_error(last_weekday(0))
  expect_error(last_weekday(8))
})

# next_weekday ----

test_that("next_weekday finds next occurrence", {
  # 2024-06-14 is Friday
  # Next Monday should be 2024-06-17
  result <- next_weekday("Monday", as_of = as.Date("2024-06-14"))
  expect_equal(result, as.Date("2024-06-17"))
})

test_that("next_weekday handles same day with include_today TRUE", {
  # 2024-06-14 is Friday
  result <- next_weekday("Friday", as_of = as.Date("2024-06-14"), include_today = TRUE)
  expect_equal(result, as.Date("2024-06-14"))
})

test_that("next_weekday handles same day with include_today FALSE", {
  # 2024-06-14 is Friday, go forward to next Friday
  result <- next_weekday("Friday", as_of = as.Date("2024-06-14"), include_today = FALSE)
  expect_equal(result, as.Date("2024-06-21"))
})

test_that("next_weekday accepts abbreviations", {
  result <- next_weekday("mon", as_of = as.Date("2024-06-14"))
  expect_equal(result, as.Date("2024-06-17"))
})

test_that("next_weekday validates as_of", {
  expect_error(next_weekday("Monday", as_of = NA))
})

# weekday_name ----

test_that("weekday_name returns full name", {
  result <- weekday_name(as.Date("2024-06-14"))
  expect_equal(result, "Friday")
})

test_that("weekday_name returns abbreviated name", {
  result <- weekday_name(as.Date("2024-06-14"), abbreviate = TRUE)
  expect_equal(result, "Fri")
})

test_that("weekday_name is vectorized", {
  dates <- as.Date(c("2024-06-14", "2024-06-15", "2024-06-16"))
  result <- weekday_name(dates)
  expect_equal(result, c("Friday", "Saturday", "Sunday"))
})

test_that("weekday_name handles NA", {
  result <- weekday_name(NA)
  expect_true(is.na(result))
})
