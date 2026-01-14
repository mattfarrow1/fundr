test_that("fundr_colors returns all colors when no args", {
  x <- fundr_colors()
  expect_true(is.character(x))
  expect_true(length(x) >= 10)
  expect_true(all(nzchar(x)))
})

test_that("fundr_palette returns expected lengths", {
  expect_equal(length(fundr_palette("primary")), 2)
  expect_equal(length(fundr_palette("tertiary")), 4)
})

test_that("fundr_pal returns n colors", {
  pal <- fundr_pal("secondary")
  expect_equal(length(pal(3)), 3)
})
