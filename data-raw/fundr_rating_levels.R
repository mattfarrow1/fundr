# Comprehensive rating levels table
# Contains all thresholds; use rating_levels() to get presets

fundr_rating_levels <- data.frame(
  rating_value = c(
    0,
    1,
    5000,
    10000,
    25000,
    50000,
    100000,
    250000,
    500000,
    1000000,
    2500000,
    5000000,
    10000000,
    25000000,
    50000000,
    100000000
  ),
  rating_level = c(
    "U - Unrated",
    "O - Less than $5K",
    "N - $5K to $9.9K",
    "M - $10K to $24.9K",
    "L - $25K to $49.9K",
    "K - $50K to $99.9K",
    "J - $100K to $249K",
    "I - $250K to $499K",
    "H - $500K to $999K",
    "G - $1M to $2.49M",
    "F - $2.5M to $4.9M",
    "E - $5M to $9.9M",
    "D - $10M to $24.9M",
    "C - $25M to $49.9M",
    "B - $50M to $99.9M",
    "A - $100M+"
  ),
  # Default bucket assignments (large shop perspective)
  rating_bucket = c(
    "Unrated",
    "Annual",
    "Annual",
    "Annual",
    "Mid-Level",
    "Mid-Level",
    "Major",
    "Major",
    "Major",
    "Major",
    "Major",
    "Principal",
    "Principal",
    "Principal",
    "Principal",
    "Principal"
  ),
  stringsAsFactors = FALSE
)

# Factor ordering (A first, U last)
rating_level_order <- c(
  "A - $100M+",
  "B - $50M to $99.9M",
  "C - $25M to $49.9M",
  "D - $10M to $24.9M",
  "E - $5M to $9.9M",
  "F - $2.5M to $4.9M",
  "G - $1M to $2.49M",
  "H - $500K to $999K",
  "I - $250K to $499K",
  "J - $100K to $249K",
  "K - $50K to $99.9K",
  "L - $25K to $49.9K",
  "M - $10K to $24.9K",
  "N - $5K to $9.9K",
  "O - Less than $5K",
  "U - Unrated"
)

fundr_rating_levels$rating_level <- factor(
  fundr_rating_levels$rating_level,
  levels = rating_level_order,
  ordered = TRUE
)

bucket_order <- c("Principal", "Major", "Mid-Level", "Annual", "Unrated")

fundr_rating_levels$rating_bucket <- factor(
  fundr_rating_levels$rating_bucket,
  levels = bucket_order,
  ordered = TRUE
)

usethis::use_data(fundr_rating_levels, overwrite = TRUE)
