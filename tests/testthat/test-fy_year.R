test_that("fy_year works for January start", {
  d <- as.Date(c("2024-01-01", "2024-12-31"))
  expect_equal(fy_year(d, 1L), c(2024L, 2024L))
})

test_that("fy_year works for July start", {
  d <- as.Date(c("2024-06-30", "2024-07-01"))
  expect_equal(fy_year(d, 7L), c(2024L, 2025L))
})

test_that("fy_label formats correctly", {
  d <- as.Date("2024-07-01")
  expect_equal(fy_label(d, 7L), "FY25")
  expect_equal(fy_label(d, 7L, short = FALSE), "FY2025")
})

test_that("fy_quarter works for July start", {
  d <- as.Date(c("2024-07-01", "2024-10-01", "2025-01-01", "2025-04-01"))
  expect_equal(fy_quarter(d, 7L), c(1L, 2L, 3L, 4L))
})
