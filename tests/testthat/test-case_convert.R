# Tests for case conversion functions

# to_snake_case ----

test_that("to_snake_case converts TitleCase", {
  expect_equal(to_snake_case("FirstName"), "first_name")
  expect_equal(to_snake_case("GiftAmount"), "gift_amount")
  expect_equal(to_snake_case("DonorID"), "donor_id")
})

test_that("to_snake_case converts camelCase", {
  expect_equal(to_snake_case("firstName"), "first_name")
  expect_equal(to_snake_case("giftAmount"), "gift_amount")
})

test_that("to_snake_case handles consecutive capitals", {
  expect_equal(to_snake_case("XMLParser"), "xml_parser")
  expect_equal(to_snake_case("getHTTPResponse"), "get_http_response")
})

test_that("to_snake_case handles spaces and hyphens", {
  expect_equal(to_snake_case("First Name"), "first_name")
  expect_equal(to_snake_case("first-name"), "first_name")
  expect_equal(to_snake_case("first.name"), "first_name")
})

test_that("to_snake_case passes through snake_case", {
  expect_equal(to_snake_case("first_name"), "first_name")
  expect_equal(to_snake_case("gift_amount"), "gift_amount")
})

test_that("to_snake_case handles NA", {
  expect_true(is.na(to_snake_case(NA)))

  result <- to_snake_case(c("FirstName", NA, "LastName"))
  expect_equal(result[1], "first_name")
  expect_true(is.na(result[2]))
  expect_equal(result[3], "last_name")
})

test_that("to_snake_case is vectorized", {
  input <- c("FirstName", "GiftAmount", "DonorID")
  expected <- c("first_name", "gift_amount", "donor_id")
  expect_equal(to_snake_case(input), expected)
})

# to_title_case ----

test_that("to_title_case converts snake_case", {
  expect_equal(to_title_case("first_name"), "First Name")
  expect_equal(to_title_case("gift_amount"), "Gift Amount")
})

test_that("to_title_case converts camelCase", {
  expect_equal(to_title_case("firstName"), "First Name")
  expect_equal(to_title_case("giftAmount"), "Gift Amount")
})

test_that("to_title_case handles hyphens and dots", {
  expect_equal(to_title_case("first-name"), "First Name")
  expect_equal(to_title_case("first.name"), "First Name")
})

test_that("to_title_case passes through Title Case", {
  expect_equal(to_title_case("First Name"), "First Name")
})

test_that("to_title_case handles NA", {
  expect_true(is.na(to_title_case(NA)))
})

test_that("to_title_case is vectorized", {
  input <- c("first_name", "gift_amount", "donor_id")
  expected <- c("First Name", "Gift Amount", "Donor Id")
  expect_equal(to_title_case(input), expected)
})

test_that("to_title_case respects strict parameter", {
  # Strict mode lowercases everything first
  expect_equal(to_title_case("FIRST_NAME", strict = TRUE), "First Name")

  # Non-strict preserves case after first letter
  expect_equal(to_title_case("firstNAME", strict = FALSE), "First NAME")
})

# to_camel_case ----

test_that("to_camel_case converts snake_case", {
  expect_equal(to_camel_case("first_name"), "firstName")
  expect_equal(to_camel_case("gift_amount"), "giftAmount")
})

test_that("to_camel_case converts Title Case", {
  expect_equal(to_camel_case("First Name"), "firstName")
  expect_equal(to_camel_case("Gift Amount"), "giftAmount")
})

test_that("to_camel_case handles NA", {
  expect_true(is.na(to_camel_case(NA)))
})

test_that("to_camel_case is vectorized", {
  input <- c("first_name", "gift_amount")
  expected <- c("firstName", "giftAmount")
  expect_equal(to_camel_case(input), expected)
})

# convert_names ----

test_that("convert_names converts to snake_case", {
  df <- data.frame(FirstName = "John", LastName = "Doe")
  result <- convert_names(df, "snake")
  expect_equal(names(result), c("first_name", "last_name"))
})

test_that("convert_names converts to title", {
  df <- data.frame(first_name = "John", last_name = "Doe")
  result <- convert_names(df, "title")
  expect_equal(names(result), c("First Name", "Last Name"))
})

test_that("convert_names converts to camel", {
  df <- data.frame(first_name = "John", last_name = "Doe")
  result <- convert_names(df, "camel")
  expect_equal(names(result), c("firstName", "lastName"))
})

test_that("convert_names preserves data", {
  df <- data.frame(FirstName = "John", Age = 30)
  result <- convert_names(df, "snake")
  expect_equal(result$first_name, "John")
  expect_equal(result$age, 30)
})
