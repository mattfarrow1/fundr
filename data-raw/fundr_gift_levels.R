fundr_gift_levels <- data.frame(
  ask_amount = c(
    0,
    0.01,
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
    "$.01+",
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
    "Less than $100K",
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

# Factor order (highest -> lowest -> No Amount), as you had it
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
  "$.01+",
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
  "Less than $100K",
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
