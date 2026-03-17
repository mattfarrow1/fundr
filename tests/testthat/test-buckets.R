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

test_that("bucket_gift_level buckets correctly with comprehensive levels", {
  x <- c(NA, 0, 1, 500, 5000, 100000, 250000, 150000000)
  lvl <- bucket_gift_level(x, what = "giving_level")
  bkt <- bucket_gift_level(x, what = "ask_bucket")

  expect_true(is.na(lvl[1]))

  expect_equal(as.character(lvl[2]), "No Amount")
  expect_equal(as.character(lvl[3]), "$1+")
  expect_equal(as.character(lvl[4]), "$500+")
  expect_equal(as.character(lvl[5]), "$5,000+")
  expect_equal(as.character(lvl[6]), "$100,000+")
  expect_equal(as.character(lvl[7]), "$250,000+")
  expect_equal(as.character(lvl[8]), "$150,000,000+")

  expect_equal(as.character(bkt[2]), "No Amount")
  expect_equal(as.character(bkt[3]), "Less than $100")
  expect_equal(as.character(bkt[4]), "$500 to $999")
  expect_equal(as.character(bkt[6]), "$100K to $249K")
})

test_that("gift_levels returns expected presets", {
  small <- gift_levels("small")
  medium <- gift_levels("medium")
  large <- gift_levels("large")
  all_levels <- gift_levels("all")

  # Check row counts
  expect_equal(nrow(small), 12)
  expect_equal(nrow(medium), 11)
  expect_equal(nrow(large), 14)
  expect_equal(nrow(all_levels), 23)

  # Small should have lower thresholds
  expect_true(max(small$ask_amount) == 100000)

  # Large should start at higher thresholds (after 0 and 0.01)
  expect_true(min(large$ask_amount[large$ask_amount > 1]) == 100000)

  # All columns should be present
  expect_true(all(c("ask_amount", "giving_level", "ask_bucket") %in% names(small)))
})

test_that("gift_levels with custom include works", {
  custom <- gift_levels(include = c(0, 0.01, 1000, 10000, 100000))
  expect_equal(nrow(custom), 5)
  expect_equal(custom$ask_amount, c(0, 0.01, 1000, 10000, 100000))
})

test_that("bucket_gift_level accepts preset strings", {
  x <- c(500, 5000, 25000)

  # Using small preset
  lvl_small <- bucket_gift_level(x, levels = "small")
  expect_equal(as.character(lvl_small[1]), "$500+")
  expect_equal(as.character(lvl_small[2]), "$5,000+")
  expect_equal(as.character(lvl_small[3]), "$25,000+")

  # Using large preset - lower amounts fall into $1+
  lvl_large <- bucket_gift_level(x, levels = "large")
  expect_equal(as.character(lvl_large[1]), "$1+")
  expect_equal(as.character(lvl_large[2]), "$1+")
  expect_equal(as.character(lvl_large[3]), "$1+")
})

test_that("bucket_rating_level buckets correctly with comprehensive levels", {
  x <- c(NA, 0, 1, 5000, 10000, 250000, 100000000)
  lvl <- bucket_rating_level(x, what = "rating_level")
  bkt <- bucket_rating_level(x, what = "rating_bucket")

  expect_true(is.na(lvl[1]))
  expect_equal(as.character(lvl[2]), "U - Unrated")
  expect_equal(as.character(lvl[3]), "O - Less than $5K")
  expect_equal(as.character(lvl[4]), "N - $5K to $9.9K")
  expect_equal(as.character(lvl[5]), "M - $10K to $24.9K")
  expect_equal(as.character(lvl[6]), "I - $250K to $499K")
  expect_equal(as.character(lvl[7]), "A - $100M+")

  expect_equal(as.character(bkt[2]), "Unrated")
  expect_equal(as.character(bkt[5]), "Annual")
})

test_that("rating_levels returns expected presets", {
  small <- rating_levels("small")
  medium <- rating_levels("medium")
  large <- rating_levels("large")
  all_levels <- rating_levels("all")

  # Check row counts
  expect_equal(nrow(small), 8)
  expect_equal(nrow(medium), 10)
  expect_equal(nrow(large), 16)
  expect_equal(nrow(all_levels), 16)

  # Small should have Principal starting at $250K
  small_principal <- small[small$rating_bucket == "Principal", ]
  expect_true(min(small_principal$rating_value) == 250000)

  # Large should have Principal starting at $5M
  large_principal <- large[large$rating_bucket == "Principal", ]
  expect_true(min(large_principal$rating_value) == 5000000)

  # All columns should be present
  expect_true(all(c("rating_value", "rating_level", "rating_bucket") %in% names(small)))
})

test_that("bucket_rating_level accepts preset strings", {
  x <- c(50000, 250000, 1000000)

  # Using small preset - $50K is Major, $250K is Principal
  bkt_small <- bucket_rating_level(x, levels = "small", what = "rating_bucket")
  expect_equal(as.character(bkt_small[1]), "Major")
  expect_equal(as.character(bkt_small[2]), "Principal")
  expect_equal(as.character(bkt_small[3]), "Principal")

  # Using large preset - $50K is Mid-Level, $250K is Major
  bkt_large <- bucket_rating_level(x, levels = "large", what = "rating_bucket")
  expect_equal(as.character(bkt_large[1]), "Mid-Level")
  expect_equal(as.character(bkt_large[2]), "Major")
  expect_equal(as.character(bkt_large[3]), "Major")
})
