test_that("normalize_phone strips leading 1 for US", {
  expect_equal(normalize_phone("1 (555) 123-4567"), "555-123-4567")
})

test_that("normalize_phone optionally allows 7-digit numbers", {
  expect_true(is.na(normalize_phone("5551234")))
  expect_equal(normalize_phone("5551234", allow_7 = TRUE), "555-1234")
})

test_that("normalize_phone treats blanks as invalid", {
  expect_true(is.na(normalize_phone("   ")))
})

test_that("extensions are ignored when keep_extension = FALSE", {
  expect_equal(
    normalize_phone("555-123-4567 ext 89", keep_extension = FALSE),
    "555-123-4567"
  )
})

test_that("extensions are preserved when keep_extension = TRUE", {
  expect_equal(
    normalize_phone("555-123-4567 ext 89", keep_extension = TRUE),
    "555-123-4567 x89"
  )
})
