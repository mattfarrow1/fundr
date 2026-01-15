fundr_rating_levels <- data.frame(
  rating_level = c(
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
    "K - $50K to $99K",
    "L - $25K to $49K",
    "M - $10K to $24K",
    "N - Less than $10K",
    "U - Unrated"
  ),
  rating_value = c(
    100000000,
    50000000,
    25000000,
    10000000,
    5000000,
    2500000,
    1000000,
    500000,
    250000,
    100000,
    50000,
    25000,
    10000,
    1,
    0
  ),
  rating_bucket = c(
    rep("Principal", 5),
    rep("Major", 5),
    rep("Mid-Level", 2),
    rep("Annual", 2),
    "Unrated"
  ),
  stringsAsFactors = FALSE
)

# Ordered factor levels (highest capacity → lowest → unrated)
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
  "K - $50K to $99K",
  "L - $25K to $49K",
  "M - $10K to $24K",
  "N - Less than $10K",
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
