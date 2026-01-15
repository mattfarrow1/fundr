test_that("gift levels table has expected structure", {
  expect_true(is.data.frame(fundr_gift_levels))
  expect_true(all(c("ask_amount", "giving_level", "ask_bucket") %in% names(fundr_gift_levels)))
  expect_true(is.numeric(fundr_gift_levels$ask_amount))
  expect_false(anyNA(fundr_gift_levels$ask_amount))
})

test_that("rating levels table has expected structure", {
  expect_true(is.data.frame(fundr_rating_levels))
  expect_true(all(c("rating_value", "rating_level", "rating_bucket") %in% names(fundr_rating_levels)))
  expect_true(is.numeric(fundr_rating_levels$rating_value))
  expect_false(anyNA(fundr_rating_levels$rating_value))
})

test_that("bucket_gift_level buckets correctly", {
  x <- c(NA, 0, 1, 99999, 100000, 250000, 150000000)
  lvl <- bucket_gift_level(x, what = "giving_level")
  bkt <- bucket_gift_level(x, what = "ask_bucket")

  expect_true(is.na(lvl[1]))
  expect_equal(as.character(lvl[2]), "No Amount")
  expect_equal(as.character(lvl[3]), "$.01+")
  expect_equal(as.character(lvl[4]), "$.01+")
  expect_equal(as.character(lvl[5]), "$100,000+")
  expect_equal(as.character(lvl[6]), "$250,000+")
  expect_equal(as.character(lvl[7]), "$150,000,000+")

  expect_equal(as.character(bkt[2]), "No Amount")
  expect_equal(as.character(bkt[3]), "Less than $100K")
  expect_equal(as.character(bkt[5]), "$100K to $249K")
})

test_that("bucket_rating_level buckets correctly", {
  x <- c(NA, 0, 1, 9999, 10000, 250000, 100000000)
  lvl <- bucket_rating_level(x, what = "rating_level")
  bkt <- bucket_rating_level(x, what = "rating_bucket")

  expect_true(is.na(lvl[1]))
  expect_equal(as.character(lvl[2]), "U - Unrated")  # assuming 0 maps to Unrated
  expect_equal(as.character(lvl[3]), "N - Less than $10K")
  expect_equal(as.character(lvl[4]), "N - Less than $10K")
  expect_equal(as.character(lvl[5]), "M - $10K to $24K")
  expect_equal(as.character(lvl[6]), "I - $250K to $499K")
  expect_equal(as.character(lvl[7]), "A - $100M+")

  expect_equal(as.character(bkt[2]), "Unrated")
  expect_equal(as.character(bkt[5]), "Annual")
})
