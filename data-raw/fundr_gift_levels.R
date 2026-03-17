# Comprehensive gift levels table
# Contains all thresholds; use gift_levels() to get presets

fundr_gift_levels <- data.frame(
  ask_amount = c(
    0,
    0.01,
    100,
    250,
    500,
    1000,
    2500,
    5000,
    10000,
    25000,
    50000,
    100000,
    250000,
    500000,
    750000,
    1000000,
    2500000,
    5000000,
    10000000,
    25000000,
    50000000,
    100000000,
    150000000
  ),
  giving_level = c(
    "No Amount",
    "$1+",
    "$100+",
    "$250+",
    "$500+",
    "$1,000+",
    "$2,500+",
    "$5,000+",
    "$10,000+",
    "$25,000+",
    "$50,000+",
    "$100,000+",
    "$250,000+",
    "$500,000+",
    "$750,000+",
    "$1,000,000+",
    "$2,500,000+",
    "$5,000,000+",
    "$10,000,000+",
    "$25,000,000+",
    "$50,000,000+",
    "$100,000,000+",
    "$150,000,000+"
  ),
  ask_bucket = c(
    "No Amount",
    "Less than $100",
    "$100 to $249",
    "$250 to $499",
    "$500 to $999",
    "$1K to $2.4K",
    "$2.5K to $4.9K",
    "$5K to $9.9K",
    "$10K to $24.9K",
    "$25K to $49.9K",
    "$50K to $99.9K",
    "$100K to $249K",
    "$250K to $499K",
    "$500K to $749K",
    "$750K to $999K",
    "$1M to $2.49M",
    "$2.5M to $4.9M",
    "$5M to $9.9M",
    "$10M to $24.9M",
    "$25M to $49.9M",
    "$50M to $99.9M",
    "$100M to $149M",
    "$150M+"
  ),
  stringsAsFactors = FALSE
)

# Factor order (highest -> lowest -> No Amount)
giving_levels_order <- c(
  "$150,000,000+",
  "$100,000,000+",
  "$50,000,000+",
  "$25,000,000+",
  "$10,000,000+",
  "$5,000,000+",
  "$2,500,000+",
  "$1,000,000+",
  "$750,000+",
  "$500,000+",
  "$250,000+",
  "$100,000+",
  "$50,000+",
  "$25,000+",
  "$10,000+",
  "$5,000+",
  "$2,500+",
  "$1,000+",
  "$500+",
  "$250+",
  "$100+",
  "$1+",
  "No Amount"
)

ask_bucket_order <- c(
  "$150M+",
  "$100M to $149M",
  "$50M to $99.9M",
  "$25M to $49.9M",
  "$10M to $24.9M",
  "$5M to $9.9M",
  "$2.5M to $4.9M",
  "$1M to $2.49M",
  "$750K to $999K",
  "$500K to $749K",
  "$250K to $499K",
  "$100K to $249K",
  "$50K to $99.9K",
  "$25K to $49.9K",
  "$10K to $24.9K",
  "$5K to $9.9K",
  "$2.5K to $4.9K",
  "$1K to $2.4K",
  "$500 to $999",
  "$250 to $499",
  "$100 to $249",
  "Less than $100",
  "No Amount"
)

fundr_gift_levels$giving_level <- factor(
  fundr_gift_levels$giving_level,
  levels = giving_levels_order,
  ordered = TRUE
)

fundr_gift_levels$ask_bucket <- factor(
  fundr_gift_levels$ask_bucket,
  levels = ask_bucket_order,
  ordered = TRUE
)

usethis::use_data(fundr_gift_levels, overwrite = TRUE)
