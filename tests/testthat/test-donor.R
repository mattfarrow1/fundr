# calc_age tests
test_that("calc_age calculates basic ages correctly", {
  # Someone born 40 years ago
  expect_equal(
    calc_age(as.Date("1984-01-15"), as_of = as.Date("2024-06-15")),
    40L
  )
})

test_that("calc_age handles birthday not yet occurred this year", {
  # Birthday in December, checking in June - should be one year less
  expect_equal(
    calc_age(as.Date("1984-12-15"), as_of = as.Date("2024-06-15")),
    39L
  )

  # Same month, day before birthday
 expect_equal(
    calc_age(as.Date("1984-06-20"), as_of = as.Date("2024-06-15")),
    39L
  )
})

test_that("calc_age handles birthday already occurred this year", {
  # Birthday in January, checking in June
  expect_equal(
    calc_age(as.Date("1984-01-15"), as_of = as.Date("2024-06-15")),
    40L
  )

  # Same day as birthday
  expect_equal(
    calc_age(as.Date("1984-06-15"), as_of = as.Date("2024-06-15")),
    40L
  )
})

test_that("calc_age returns NA for future birthdates", {
  expect_true(is.na(calc_age(as.Date("2025-01-01"), as_of = as.Date("2024-06-15"))))
})

test_that("calc_age handles NA values", {
  expect_true(is.na(calc_age(NA)))

  result <- calc_age(c(as.Date("1984-01-15"), NA), as_of = as.Date("2024-06-15"))
  expect_equal(result[1], 40L)
  expect_true(is.na(result[2]))
})

test_that("calc_age is vectorized", {
  birthdates <- as.Date(c("1980-01-15", "1990-06-20", "2000-12-01"))
  result <- calc_age(birthdates, as_of = as.Date("2024-06-15"))
  expect_equal(result, c(44L, 33L, 23L))
})

test_that("calc_age errors on invalid as_of", {
  expect_error(calc_age(as.Date("1980-01-01"), as_of = NA))
  expect_error(calc_age(as.Date("1980-01-01"), as_of = c(Sys.Date(), Sys.Date())))
})

# donor_status tests
test_that("donor_status classifies Active donors correctly", {
  # Gift in current FY (FY2025 = July 2024 - June 2025)
  result <- donor_status(
    as.Date("2024-09-15"),
    as_of = as.Date("2025-01-15"),
    fy_start_month = 7
  )
  expect_equal(as.character(result), "Active")
})

test_that("donor_status classifies LYBUNT donors correctly", {
  # Gift in last FY (FY2024 = July 2023 - June 2024)
  result <- donor_status(
    as.Date("2024-03-01"),
    as_of = as.Date("2025-01-15"),
    fy_start_month = 7
  )
  expect_equal(as.character(result), "LYBUNT")
})

test_that("donor_status classifies SYBUNT donors correctly", {
  # Gift 2+ years ago but within lapsed threshold
  result <- donor_status(
    as.Date("2022-01-15"),
    as_of = as.Date("2025-01-15"),
    fy_start_month = 7,
    lapsed_years = 5
  )
  expect_equal(as.character(result), "SYBUNT")
})

test_that("donor_status classifies Lapsed donors correctly", {
  # Gift more than 5 years ago
  result <- donor_status(
    as.Date("2018-06-01"),
    as_of = as.Date("2025-01-15"),
    fy_start_month = 7,
    lapsed_years = 5
  )
  expect_equal(as.character(result), "Lapsed")
})

test_that("donor_status classifies Never donors correctly", {
  result <- donor_status(NA, as_of = as.Date("2025-01-15"))
  expect_equal(as.character(result), "Never")
})

test_that("donor_status returns ordered factor", {
  result <- donor_status(as.Date("2024-09-15"), as_of = as.Date("2025-01-15"))
  expect_true(is.factor(result))
  expect_true(is.ordered(result))
  expect_equal(levels(result), c("Active", "LYBUNT", "SYBUNT", "Lapsed", "Never"))
})

test_that("donor_status is vectorized", {
  dates <- as.Date(c(
    "2024-09-15",  # Active
    "2024-03-01",  # LYBUNT
    "2022-01-15",  # SYBUNT
    "2018-06-01",  # Lapsed
    NA             # Never
  ))

  result <- donor_status(dates, as_of = as.Date("2025-01-15"), fy_start_month = 7)
  expect_equal(
    as.character(result),
    c("Active", "LYBUNT", "SYBUNT", "Lapsed", "Never")
  )
})

test_that("donor_status respects lapsed_years parameter", {
  # With lapsed_years = 3, a gift from 4 years ago should be Lapsed
  result <- donor_status(
    as.Date("2021-01-15"),
    as_of = as.Date("2025-01-15"),
    lapsed_years = 3
  )
  expect_equal(as.character(result), "Lapsed")

  # With lapsed_years = 5, same gift should be SYBUNT
  result <- donor_status(
    as.Date("2021-01-15"),
    as_of = as.Date("2025-01-15"),
    lapsed_years = 5
  )
  expect_equal(as.character(result), "SYBUNT")
})

test_that("donor_status errors on invalid inputs", {
  expect_error(donor_status(as.Date("2024-01-01"), as_of = NA))
  expect_error(donor_status(as.Date("2024-01-01"), fy_start_month = 13))
  expect_error(donor_status(as.Date("2024-01-01"), lapsed_years = 0))
})

# years_since tests
test_that("years_since calculates correctly", {
  expect_equal(
    years_since(as.Date("2020-06-15"), as_of = as.Date("2024-06-15")),
    4.0
  )
})

test_that("years_since handles partial years", {
  result <- years_since(as.Date("2023-01-01"), as_of = as.Date("2024-06-15"), digits = 1)
  expect_equal(result, 1.5)
})

test_that("years_since handles NA values", {
  expect_true(is.na(years_since(NA)))
})

test_that("years_since is vectorized", {
  dates <- as.Date(c("2022-06-15", "2023-06-15", "2024-01-15"))
  result <- years_since(dates, as_of = as.Date("2024-06-15"))
  expect_equal(length(result), 3)
  expect_equal(result[1], 2.0)
  expect_equal(result[2], 1.0)
})

test_that("years_since respects digits parameter", {
  result <- years_since(as.Date("2023-01-01"), as_of = as.Date("2024-06-15"), digits = 2)
  expect_equal(round(result, 2), result)

  result_no_round <- years_since(as.Date("2023-01-01"), as_of = as.Date("2024-06-15"), digits = NULL)
  expect_true(nchar(as.character(result_no_round)) > 4)
})

test_that("years_since returns negative for future dates", {
  result <- years_since(as.Date("2025-06-15"), as_of = as.Date("2024-06-15"))
  expect_true(result < 0)
})

# total_giving_years tests
test_that("total_giving_years counts distinct fiscal years", {
  # Gifts in FY2021, FY2022, FY2024 (3 distinct years)
  gifts <- as.Date(c(
    "2020-09-01",  # FY2021
    "2020-12-01",  # FY2021 (same year)
    "2021-09-01",  # FY2022
    "2023-09-01"   # FY2024
  ))
  expect_equal(total_giving_years(gifts), 3L)
})

test_that("total_giving_years counts single gift", {
  expect_equal(total_giving_years(as.Date("2024-01-01")), 1L)
})

test_that("total_giving_years handles NA", {
  expect_equal(total_giving_years(NA), 0L)
  expect_equal(total_giving_years(as.Date(c(NA, NA))), 0L)

  # Mixed with NA
  gifts <- as.Date(c("2024-01-01", NA, "2023-01-01"))
  expect_equal(total_giving_years(gifts), 2L)
})

test_that("total_giving_years respects fy_start_month", {
  # December 2023 and January 2024 are same FY with July start
  gifts <- as.Date(c("2023-12-01", "2024-01-01"))
  expect_equal(total_giving_years(gifts, fy_start_month = 7), 1L)

  # But different FY with January start
  expect_equal(total_giving_years(gifts, fy_start_month = 1), 2L)
})

test_that("total_giving_years handles empty input", {
  expect_equal(total_giving_years(as.Date(character(0))), 0L)
})

# consecutive_giving_years tests
test_that("consecutive_giving_years counts streak correctly", {
  # FY2022, FY2023, FY2024 (3 consecutive)
  gifts <- as.Date(c("2021-09-01", "2022-09-01", "2023-09-01"))
  result <- consecutive_giving_years(gifts, as_of = as.Date("2024-01-15"))
  expect_equal(result, 3L)
})

test_that("consecutive_giving_years detects gaps", {
  # FY2022 and FY2024 (gap in FY2023)
  gifts <- as.Date(c("2021-09-01", "2023-09-01"))
  result <- consecutive_giving_years(gifts, as_of = as.Date("2024-01-15"))
  expect_equal(result, 1L)  # Only current year counts
})

test_that("consecutive_giving_years handles no gift this year", {
  # FY2022, FY2023 but not FY2024
  gifts <- as.Date(c("2021-09-01", "2022-09-01"))
  # With include_current = TRUE, streak is 0 (no current year gift)
  result <- consecutive_giving_years(
    gifts,
    as_of = as.Date("2024-01-15"),
    include_current = TRUE
  )
  expect_equal(result, 0L)
})

test_that("consecutive_giving_years respects include_current", {
  # FY2022, FY2023 (consecutive, but not FY2024)
  gifts <- as.Date(c("2021-09-01", "2022-09-01"))

  # Starting from last FY (include_current = FALSE)
  result <- consecutive_giving_years(
    gifts,
    as_of = as.Date("2024-01-15"),
    include_current = FALSE
  )
  expect_equal(result, 2L)
})

test_that("consecutive_giving_years handles NA", {
  expect_equal(consecutive_giving_years(NA), 0L)
})

test_that("consecutive_giving_years handles empty input", {
  expect_equal(consecutive_giving_years(as.Date(character(0))), 0L)
})

test_that("consecutive_giving_years validates as_of", {
  expect_error(consecutive_giving_years(as.Date("2024-01-01"), as_of = NA))
  expect_error(consecutive_giving_years(
    as.Date("2024-01-01"),
    as_of = c(Sys.Date(), Sys.Date())
  ))
})

test_that("consecutive_giving_years respects fy_start_month", {
  # FY2023 and FY2024 with July start
  gifts <- as.Date(c("2022-09-01", "2023-09-01"))
  result <- consecutive_giving_years(
    gifts,
    as_of = as.Date("2024-01-15"),
    fy_start_month = 7
  )
  expect_equal(result, 2L)

  # With January start, these are different FYs
  result <- consecutive_giving_years(
    gifts,
    as_of = as.Date("2024-01-15"),
    fy_start_month = 1
  )
  expect_equal(result, 0L)  # No gift in CY2024 yet
})
