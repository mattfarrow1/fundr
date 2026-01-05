test_that("normalize_zip handles ZIP5", {
  expect_equal(normalize_zip("12345"), "12345")
  expect_equal(normalize_zip(" 12345 "), "12345")
})

test_that("normalize_zip handles ZIP+4", {
  expect_equal(normalize_zip("12345-6789", format = "zip9"), "12345-6789")
  expect_equal(normalize_zip("123456789", format = "zip9"), "12345-6789")
  expect_equal(normalize_zip("12345-6789", format = "zip5"), "12345")
})

test_that("normalize_zip invalids", {
  expect_true(is.na(normalize_zip("abc")))
  expect_true(is.na(normalize_zip("1234")))
})

test_that("normalize_zip salvage when strict = FALSE", {
  expect_equal(normalize_zip("12345-6789 extra", format = "zip9", strict = FALSE), "12345-6789")
  expect_equal(normalize_zip("12345 something", strict = FALSE), "12345")
})
