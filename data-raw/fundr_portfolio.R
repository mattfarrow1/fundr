# -----------------------------------------------------------------------------
# fundr_portfolio.R
# Generate a sample fundraising portfolio dataset for the fundr package
#
# This script creates a realistic 10,000-record portfolio for an imaginary
# nonprofit organization based in Dallas, TX. The dataset includes:
# - Individuals (singles and married couples) and companies
# - Varied data quality to demonstrate cleanup functions
# - Geographic distribution weighted toward DFW
# - Pyramid-shaped giving distribution
# -----------------------------------------------------------------------------

set.seed(42)  # For reproducibility

# =============================================================================
# CONFIGURATION
# =============================================================================

n_records <- 10000

# Record type distribution (approximate)
pct_companies <- 0.08     # 8% companies (~800)
pct_married <- 0.35       # 35% of individuals are married (creating spouse pairs)
pct_single <- 0.57        # Remaining individuals are singles

# Calculate actual counts
n_companies <- round(n_records * pct_companies)
n_individuals <- n_records - n_companies

# Married individuals come in pairs, so we need even number
# Each household has 2 records (primary + spouse)
n_married_households <- round((n_individuals * pct_married) / 2)
n_married_individuals <- n_married_households * 2
n_singles <- n_individuals - n_married_individuals

cat(sprintf("Record distribution:\n"))
cat(sprintf("  Companies: %d\n", n_companies))
cat(sprintf("  Married couples: %d households (%d records)\n",
            n_married_households, n_married_individuals))
cat(sprintf("  Singles: %d\n", n_singles))
cat(sprintf("  Total: %d\n", n_companies + n_married_individuals + n_singles))

# =============================================================================
# REFERENCE DATA
# =============================================================================

# First names with associated nicknames and gender (for title selection)
first_names_data <- data.frame(
  first_name = c(
    # Male names
    "James", "Robert", "Michael", "William", "David", "Richard", "Joseph",
    "Thomas", "Charles", "Christopher", "Daniel", "Matthew", "Anthony",
    "Donald", "Steven", "Andrew", "Joshua", "Kenneth", "Kevin", "Brian",
    "George", "Timothy", "Ronald", "Edward", "Jason", "Jeffrey", "Ryan",
    "Jacob", "Nicholas", "Jonathan", "Benjamin", "Samuel", "Patrick",
    "Alexander", "Henry", "Douglas", "Lawrence", "Peter", "Frank", "Raymond",
    # Female names
    "Mary", "Patricia", "Jennifer", "Linda", "Elizabeth", "Barbara", "Susan",
    "Jessica", "Sarah", "Karen", "Lisa", "Nancy", "Betty", "Margaret", "Sandra",
    "Ashley", "Dorothy", "Kimberly", "Emily", "Donna", "Michelle", "Carol",
    "Amanda", "Melissa", "Deborah", "Stephanie", "Rebecca", "Sharon", "Laura",
    "Cynthia", "Kathleen", "Amy", "Angela", "Shirley", "Anna", "Brenda",
    "Pamela", "Emma", "Nicole", "Helen", "Samantha", "Katherine", "Christine",
    "Debra", "Rachel", "Carolyn", "Janet", "Catherine", "Maria", "Heather"
  ),
  nickname = c(
    # Male nicknames
    "Jim", "Bob", "Mike", "Bill", "Dave", "Rich", "Joe",
    "Tom", "Chuck", "Chris", "Dan", "Matt", "Tony",
    "Don", "Steve", "Andy", "Josh", "Ken", "Kev", "Bri",
    "Geo", "Tim", "Ron", "Ed", "Jay", "Jeff", "Ry",
    "Jake", "Nick", "Jon", "Ben", "Sam", "Pat",
    "Alex", "Hank", "Doug", "Larry", "Pete", "Frank", "Ray",
    # Female nicknames
    NA, "Pat", "Jen", NA, "Liz", "Barb", "Sue",
    "Jess", NA, NA, NA, "Nan", NA, "Maggie", "Sandy",
    "Ash", "Dot", "Kim", "Em", NA, "Shelly", NA,
    "Mandy", "Mel", "Deb", "Steph", "Becca", NA, NA,
    "Cindy", "Kathy", NA, "Angie", "Shirl", NA, NA,
    "Pam", NA, "Nikki", NA, "Sam", "Kate", NA,
    NA, "Rach", NA, "Jan", "Cathy", NA, NA
  ),
  gender = c(
    rep("M", 40),
    rep("F", 50)
  ),
  stringsAsFactors = FALSE
)

# Common last names
last_names <- c(
  "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller",
  "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez",
  "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin",
  "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark",
  "Ramirez", "Lewis", "Robinson", "Walker", "Young", "Allen", "King",
  "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores", "Green",
  "Adams", "Nelson", "Baker", "Hall", "Rivera", "Campbell", "Mitchell",
  "Carter", "Roberts", "Turner", "Phillips", "Evans", "Parker", "Edwards",
  "Collins", "Stewart", "Morris", "Murphy", "Cook", "Rogers", "Morgan",
  "Peterson", "Cooper", "Reed", "Bailey", "Bell", "Gomez", "Kelly",
  "Howard", "Ward", "Cox", "Diaz", "Richardson", "Wood", "Watson",
  "Brooks", "Bennett", "Gray", "James", "Reyes", "Cruz", "Hughes",
  "Price", "Myers", "Long", "Foster", "Sanders", "Ross", "Morales"
)

# Company name components
company_prefixes <- c(
  "Texas", "Dallas", "Lone Star", "Southwest", "Heritage", "Premier",
  "Legacy", "First", "United", "American", "National", "Metro",
  "Metroplex", "Trinity", "North Texas", "DFW", "Highland", "Oakwood",
  "Westlake", "Park Cities", "Preston", "Uptown", "Victory", "Deep Ellum"
)

company_types <- c(
  "Industries", "Enterprises", "Holdings", "Group", "Partners", "Associates",
  "Corporation", "LLC", "Company", "Investments", "Capital", "Properties",
  "Development", "Services", "Solutions", "Management", "Consulting", "Trust",
  "Foundation", "Ventures", "Energy", "Technology", "Financial", "Real Estate"
)

# Suffixes
suffixes <- c("Jr.", "Sr.", "II", "III", "IV", NA, NA, NA, NA, NA, NA, NA, NA)

# Titles by gender
titles_m <- c("Mr.", "Dr.", NA, NA, NA, NA)
titles_f <- c("Ms.", "Mrs.", "Dr.", NA, NA, NA)

# DFW Metroplex cities and ZIP codes
dfw_cities <- data.frame(
  city = c(
    "Dallas", "Dallas", "Dallas", "Dallas", "Dallas",
    "Fort Worth", "Fort Worth", "Fort Worth",
    "Arlington", "Arlington",
    "Plano", "Plano",
    "Irving", "Irving",
    "Garland", "Garland",
    "Frisco", "Frisco",
    "McKinney", "McKinney",
    "Grand Prairie", "Grand Prairie",
    "Denton", "Denton",
    "Mesquite", "Mesquite",
    "Carrollton", "Carrollton",
    "Richardson", "Richardson",
    "Lewisville", "Lewisville",
    "Allen", "Allen",
    "Flower Mound", "Flower Mound",
    "Grapevine", "Grapevine",
    "Southlake", "Southlake",
    "Coppell", "Coppell",
    "Keller", "Keller",
    "Highland Park", "Highland Park",
    "University Park", "University Park",
    "Colleyville", "Colleyville"
  ),
  zip = c(
    "75201", "75204", "75219", "75225", "75230",
    "76102", "76107", "76109",
    "76010", "76011",
    "75024", "75025",
    "75038", "75039",
    "75040", "75041",
    "75033", "75034",
    "75069", "75070",
    "75050", "75051",
    "76201", "76205",
    "75149", "75150",
    "75006", "75007",
    "75080", "75081",
    "75029", "75067",
    "75002", "75013",
    "75028", "75022",
    "76051", "76092",
    "76092", "76262",
    "75019", "75099",
    "76244", "76248",
    "75205", "75209",
    "75205", "75225",
    "76034", "76262"
  ),
  stringsAsFactors = FALSE
)

# Texas cities (non-DFW)
texas_cities <- data.frame(
  city = c(
    "Houston", "Houston", "Houston",
    "San Antonio", "San Antonio",
    "Austin", "Austin",
    "El Paso", "El Paso",
    "Corpus Christi",
    "Lubbock",
    "Amarillo",
    "Waco",
    "Midland",
    "Odessa",
    "Tyler",
    "Abilene",
    "Beaumont",
    "Brownsville",
    "College Station"
  ),
  zip = c(
    "77001", "77002", "77005",
    "78201", "78205",
    "78701", "78702",
    "79901", "79902",
    "78401",
    "79401",
    "79101",
    "76701",
    "79701",
    "79761",
    "75701",
    "79601",
    "77701",
    "78520",
    "77840"
  ),
  st = rep("TX", 20),
  stringsAsFactors = FALSE
)

# National cities (other US states)
national_cities <- data.frame(
  city = c(
    "New York", "New York", "Los Angeles", "Los Angeles", "Chicago", "Chicago",
    "Phoenix", "Philadelphia", "San Diego", "San Jose", "Jacksonville",
    "Columbus", "Charlotte", "Indianapolis", "San Francisco", "Seattle",
    "Denver", "Washington", "Boston", "Nashville", "Detroit", "Portland",
    "Las Vegas", "Memphis", "Louisville", "Baltimore", "Milwaukee",
    "Albuquerque", "Tucson", "Oklahoma City", "Kansas City", "Atlanta",
    "Miami", "Raleigh", "Omaha", "Colorado Springs", "Virginia Beach",
    "Oakland", "Minneapolis", "Tampa", "Tulsa", "New Orleans", "Cleveland"
  ),
  st = c(
    "NY", "NY", "CA", "CA", "IL", "IL",
    "AZ", "PA", "CA", "CA", "FL",
    "OH", "NC", "IN", "CA", "WA",
    "CO", "DC", "MA", "TN", "MI", "OR",
    "NV", "TN", "KY", "MD", "WI",
    "NM", "AZ", "OK", "MO", "GA",
    "FL", "NC", "NE", "CO", "VA",
    "CA", "MN", "FL", "OK", "LA", "OH"
  ),
  zip = c(
    "10001", "10016", "90001", "90210", "60601", "60614",
    "85001", "19101", "92101", "95101", "32099",
    "43085", "28202", "46201", "94102", "98101",
    "80202", "20001", "02101", "37201", "48201", "97201",
    "89101", "38101", "40202", "21201", "53201",
    "87101", "85701", "73102", "64101", "30301",
    "33101", "27601", "68102", "80901", "23451",
    "94601", "55401", "33601", "74101", "70112", "44101"
  ),
  stringsAsFactors = FALSE
)

# Canadian cities
canadian_cities <- data.frame(
  city = c("Toronto", "Vancouver", "Montreal", "Calgary", "Edmonton", "Ottawa"),
  st = c("ON", "BC", "QC", "AB", "AB", "ON"),
  zip = c("M5H 2N2", "V6B 1A1", "H2Y 1C6", "T2P 1J9", "T5J 0K1", "K1P 1J1"),
  stringsAsFactors = FALSE
)

# Street names and types
street_names <- c(
  "Main", "Oak", "Maple", "Cedar", "Elm", "Pine", "Walnut", "Cherry",
  "Hickory", "Magnolia", "Pecan", "Willow", "Birch", "Ash", "Cypress",
  "Preston", "Highland", "Park", "Lake", "River", "Spring", "Hill",
  "Valley", "Forest", "Meadow", "Garden", "Sunrise", "Sunset", "Vista",
  "Commerce", "Market", "Church", "School", "College", "University",
  "Washington", "Jefferson", "Lincoln", "Kennedy", "Roosevelt"
)

street_types <- c(
  "Street", "St", "St.", "Avenue", "Ave", "Ave.", "Boulevard", "Blvd",

  "Drive", "Dr", "Dr.", "Road", "Rd", "Rd.", "Lane", "Ln", "Ln.",
  "Court", "Ct", "Circle", "Cir", "Way", "Place", "Pl", "Trail", "Trl"
)

# Fundraiser names
fundraisers <- c(
  "Sarah Mitchell", "Marcus Thompson", "Jennifer Chen", "David Rodriguez",

  "Amanda Foster", "Christopher Lee", "Rachel Williams", "Michael Davis",
  "Katherine Brown", "James Wilson"
)

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

#' Generate a random date of birth (for individuals)
generate_dob <- function(n, min_age = 22, max_age = 95) {
  # Generate ages with realistic distribution (skewed toward older donors)
  ages <- round(rnorm(n, mean = 55, sd = 15))
  ages <- pmax(min_age, pmin(max_age, ages))

  # Calculate birth years
  current_year <- as.integer(format(Sys.Date(), "%Y"))
  birth_years <- current_year - ages

  # Generate random month/day
  months <- sample(1:12, n, replace = TRUE)
  days <- sample(1:28, n, replace = TRUE)  # Using 28 to avoid invalid dates

  # Create dates
  dobs <- as.Date(paste(birth_years, months, days, sep = "-"))

  # Create formatted strings with varied precision
  # 60% full date (MDY), 25% month/year only, 15% year only
  formats <- sample(c("MDY", "MY", "Y"), n, replace = TRUE,
                    prob = c(0.60, 0.25, 0.15))

  result <- character(n)
  for (i in seq_len(n)) {
    if (formats[i] == "MDY") {
      # Varied MDY formats
      fmt <- sample(c("%m/%d/%Y", "%m-%d-%Y", "%B %d, %Y", "%m/%d/%y"), 1)
      result[i] <- format(dobs[i], fmt)
    } else if (formats[i] == "MY") {
      fmt <- sample(c("%m/%Y", "%B %Y", "%m-%Y"), 1)
      result[i] <- format(dobs[i], fmt)
    } else {
      result[i] <- format(dobs[i], "%Y")
    }
  }

  result
}

#' Generate phone numbers with varied formatting
generate_phone <- function(n) {
  # Area codes common in Texas
  area_codes <- c("214", "972", "469", "817", "682", "254", "940",
                  "903", "430", "512", "713", "281", "832", "346",
                  "210", "830", "956", "361", "409", "936")

  phones <- character(n)
  for (i in seq_len(n)) {
    ac <- sample(area_codes, 1)
    exchange <- sprintf("%03d", sample(200:999, 1))
    line <- sprintf("%04d", sample(0:9999, 1))

    # Varied formats to demonstrate cleanup function
    fmt <- sample(1:10, 1)
    phones[i] <- switch(fmt,
      paste0("(", ac, ") ", exchange, "-", line),      # (214) 555-1234
      paste0(ac, "-", exchange, "-", line),            # 214-555-1234
      paste0(ac, ".", exchange, ".", line),            # 214.555.1234
      paste0(ac, " ", exchange, " ", line),            # 214 555 1234
      paste0(ac, exchange, line),                       # 2145551234
      paste0("1-", ac, "-", exchange, "-", line),      # 1-214-555-1234
      paste0("+1 (", ac, ") ", exchange, "-", line),   # +1 (214) 555-1234
      paste0(ac, "/", exchange, "-", line),            # 214/555-1234
      paste0("(", ac, ")", exchange, "-", line),       # (214)555-1234
      paste0(ac, "-", exchange, line)                   # 214-5551234
    )
  }
  phones
}

#' Generate email addresses
generate_email <- function(first, last, company = NULL) {
  n <- length(first)
  emails <- character(n)
  domains <- c("gmail.com", "yahoo.com", "outlook.com", "hotmail.com",
               "aol.com", "icloud.com", "protonmail.com", "mail.com")

  for (i in seq_len(n)) {
    if (!is.na(company[i]) && nzchar(company[i])) {
      # Company email
      company_domain <- tolower(gsub("[^a-zA-Z0-9]", "", company[i]))
      company_domain <- substr(company_domain, 1, 15)
      emails[i] <- paste0("info@", company_domain, ".com")
    } else {
      fn <- tolower(gsub("[^a-zA-Z]", "", first[i]))
      ln <- tolower(gsub("[^a-zA-Z]", "", last[i]))
      domain <- sample(domains, 1)

      # Varied email formats
      fmt <- sample(1:5, 1)
      emails[i] <- switch(fmt,
        paste0(fn, ".", ln, "@", domain),
        paste0(substr(fn, 1, 1), ln, "@", domain),
        paste0(fn, ln, sample(1:99, 1), "@", domain),
        paste0(fn, "_", ln, "@", domain),
        paste0(ln, ".", fn, "@", domain)
      )
    }
  }
  emails
}

#' Generate street addresses with varied formatting
generate_address <- function(n) {
  addresses <- character(n)
  for (i in seq_len(n)) {
    num <- sample(100:9999, 1)
    street <- sample(street_names, 1)
    type <- sample(street_types, 1)

    # Direction prefixes (sometimes)
    dir <- ifelse(runif(1) < 0.2, paste0(sample(c("N", "S", "E", "W", "N.", "S.", "E.", "W."), 1), " "), "")

    # Varied formats
    fmt <- sample(1:4, 1)
    addresses[i] <- switch(fmt,
      paste0(num, " ", dir, street, " ", type),
      paste0(num, " ", dir, street, " ", type, "."),
      paste0(num, "  ", dir, street, " ", type),  # Extra space
      tolower(paste0(num, " ", dir, street, " ", type))  # Lowercase
    )
  }
  addresses
}

#' Generate address line 2 (mostly empty)
generate_address2 <- function(n) {
  address2 <- rep(NA_character_, n)

  # About 15% have address line 2
  has_addr2 <- sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.15, 0.85))

  types <- c("Apt", "Apt.", "Apartment", "Suite", "Ste", "Ste.", "Unit", "#", "Floor", "Fl")

  for (i in which(has_addr2)) {
    type <- sample(types, 1)
    num <- sample(c(1:999, LETTERS, paste0(LETTERS, 1:9)), 1)
    address2[i] <- paste(type, num)
  }
  address2
}

#' Generate ZIP codes with varied formatting
generate_zip <- function(base_zips, n) {
  zips <- sample(base_zips, n, replace = TRUE)

  # Varied formats
  result <- character(n)
  for (i in seq_len(n)) {
    fmt <- sample(1:5, 1)
    zip5 <- zips[i]
    zip4 <- sprintf("%04d", sample(0:9999, 1))

    result[i] <- switch(fmt,
      zip5,                                    # 75201
      paste0(zip5, "-", zip4),                # 75201-1234
      paste0(zip5, zip4),                     # 752011234
      paste0(zip5, " ", zip4),                # 75201 1234
      paste0(" ", zip5, " ")                  # With spaces
    )
  }
  result
}

#' Generate gift amounts with pyramid distribution
generate_gift_amount <- function(n, include_zeros = TRUE) {
  if (include_zeros) {
    # About 30% are non-donors (0)
    is_donor <- sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.70, 0.30))
  } else {
    is_donor <- rep(TRUE, n)
  }

  amounts <- rep(0, n)

  # For donors, create pyramid distribution
  n_donors <- sum(is_donor)
  if (n_donors > 0) {
    # Use log-normal distribution for realistic giving pyramid
    # Mean around $500, with long right tail
    log_amounts <- rnorm(n_donors, mean = 5.5, sd = 2.0)
    raw_amounts <- exp(log_amounts)

    # Round to realistic gift amounts
    donor_amounts <- sapply(raw_amounts, function(x) {
      if (x < 25) round(x / 5) * 5
      else if (x < 100) round(x / 10) * 10
      else if (x < 1000) round(x / 25) * 25
      else if (x < 10000) round(x / 100) * 100
      else if (x < 100000) round(x / 1000) * 1000
      else round(x / 10000) * 10000
    })

    amounts[is_donor] <- pmax(5, donor_amounts)  # Minimum $5 gift
  }

  amounts
}

#' Generate giving dates
generate_gift_date <- function(n, start_year = 1990) {
  end_date <- Sys.Date()
  start_date <- as.Date(paste0(start_year, "-01-01"))
  date_range <- as.numeric(end_date - start_date)

  random_days <- sample(0:date_range, n, replace = TRUE)
  as.Date(start_date + random_days)
}

# =============================================================================
# BUILD THE DATASET
# =============================================================================

# Initialize empty data frame
portfolio <- data.frame(
  constituent_id = character(n_records),
  household_position = character(n_records),
  record_type = character(n_records),  # Additional: Individual or Organization
  stringsAsFactors = FALSE
)

# Generate unique constituent IDs
portfolio$constituent_id <- sprintf("8-%08d", seq_len(n_records))

# Assign record types and household positions
# First: companies
idx_companies <- 1:n_companies
portfolio$record_type[idx_companies] <- "Organization"
portfolio$household_position[idx_companies] <- "Primary"

# Second: married couples (pairs)
idx_married_start <- n_companies + 1
idx_married_end <- n_companies + n_married_individuals
idx_married <- idx_married_start:idx_married_end

portfolio$record_type[idx_married] <- "Individual"
# Alternate Primary/Spouse for married pairs
portfolio$household_position[idx_married] <- rep(c("Primary", "Spouse"),
                                                   length.out = n_married_individuals)

# Third: singles
idx_singles_start <- idx_married_end + 1
idx_singles_end <- n_records
idx_singles <- idx_singles_start:idx_singles_end

portfolio$record_type[idx_singles] <- "Individual"
portfolio$household_position[idx_singles] <- "Primary"

# Create household IDs for married couples (to link spouses)
portfolio$household_id <- portfolio$constituent_id
married_household_ids <- sprintf("HH-%08d", seq_len(n_married_households))
portfolio$household_id[idx_married] <- rep(married_household_ids, each = 2)

# -----------------------------------------------------------------------------
# BIOGRAPHICAL DATA
# -----------------------------------------------------------------------------

portfolio$dob <- NA_character_
portfolio$relationship_status <- NA_character_

# Generate DOBs for individuals (with some missing ~5%)
idx_individuals <- c(idx_married, idx_singles)
n_ind <- length(idx_individuals)

dob_values <- generate_dob(n_ind)
# Add ~5% missing
dob_values[sample(n_ind, round(n_ind * 0.05))] <- NA_character_
portfolio$dob[idx_individuals] <- dob_values

# Relationship status
portfolio$relationship_status[portfolio$household_position == "Spouse"] <- "Married"
portfolio$relationship_status[idx_married[portfolio$household_position[idx_married] == "Primary"]] <- "Married"

# Singles get varied statuses
single_statuses <- sample(
  c("Single", "Divorced", "Widowed", "Unknown"),
  n_singles,
  replace = TRUE,
  prob = c(0.50, 0.25, 0.15, 0.10)
)
portfolio$relationship_status[idx_singles] <- single_statuses

# -----------------------------------------------------------------------------
# NAME DATA
# -----------------------------------------------------------------------------

portfolio$title <- NA_character_
portfolio$first_name <- NA_character_
portfolio$middle_name <- NA_character_
portfolio$last_name <- NA_character_
portfolio$suffix <- NA_character_
portfolio$nickname <- NA_character_
portfolio$company_name <- NA_character_

# Generate company names
company_names <- paste(
  sample(company_prefixes, n_companies, replace = TRUE),
  sample(company_types, n_companies, replace = TRUE)
)
portfolio$company_name[idx_companies] <- company_names

# Generate individual names
n_ind <- length(idx_individuals)

# Sample from first_names_data
name_samples <- first_names_data[sample(nrow(first_names_data), n_ind, replace = TRUE), ]

portfolio$first_name[idx_individuals] <- name_samples$first_name
portfolio$last_name[idx_individuals] <- sample(last_names, n_ind, replace = TRUE)

# Middle names (~60% have them)
has_middle <- sample(c(TRUE, FALSE), n_ind, replace = TRUE, prob = c(0.60, 0.40))
middle_names <- first_names_data$first_name[sample(nrow(first_names_data), n_ind, replace = TRUE)]
portfolio$middle_name[idx_individuals] <- ifelse(has_middle, middle_names, NA_character_)

# Suffixes (~5% have them)
portfolio$suffix[idx_individuals] <- sample(suffixes, n_ind, replace = TRUE)

# Titles based on gender (~40% have them)
has_title <- sample(c(TRUE, FALSE), n_ind, replace = TRUE, prob = c(0.40, 0.60))
titles <- character(n_ind)
for (i in seq_len(n_ind)) {
  if (has_title[i]) {
    if (name_samples$gender[i] == "M") {
      titles[i] <- sample(titles_m, 1)
    } else {
      titles[i] <- sample(titles_f, 1)
    }
  } else {
    titles[i] <- NA_character_
  }
}
portfolio$title[idx_individuals] <- titles

# Nicknames (~25% have them, using appropriate nicknames from data)
has_nickname <- sample(c(TRUE, FALSE), n_ind, replace = TRUE, prob = c(0.25, 0.75))
nicknames <- ifelse(has_nickname & !is.na(name_samples$nickname),
                    name_samples$nickname, NA_character_)
portfolio$nickname[idx_individuals] <- nicknames

# For married couples, ensure same last name
for (i in seq(1, n_married_individuals, by = 2)) {
  idx1 <- idx_married_start + i - 1
  idx2 <- idx_married_start + i
  portfolio$last_name[idx2] <- portfolio$last_name[idx1]
}

# -----------------------------------------------------------------------------
# CONTACT INFORMATION
# -----------------------------------------------------------------------------

portfolio$address_1 <- NA_character_
portfolio$address_2 <- NA_character_
portfolio$city <- NA_character_
portfolio$st <- NA_character_
portfolio$zip <- NA_character_
portfolio$region <- NA_character_
portfolio$email <- NA_character_
portfolio$phone_number <- NA_character_

# Geographic distribution:
# 50% Local (DFW), 25% Texas (non-DFW), 18% National, 5% International, 2% Unknown
geo_dist <- sample(
  c("Local", "Texas", "National", "International", "Unknown"),
  n_records,
  replace = TRUE,
  prob = c(0.50, 0.25, 0.18, 0.05, 0.02)
)
portfolio$region <- factor(geo_dist,
                            levels = c("Local", "Texas", "National", "International", "Unknown"))

# Generate addresses based on region
for (i in seq_len(n_records)) {
  region <- portfolio$region[i]

  if (region == "Local") {
    loc <- dfw_cities[sample(nrow(dfw_cities), 1), ]
    portfolio$city[i] <- loc$city
    portfolio$st[i] <- "TX"
    portfolio$zip[i] <- generate_zip(loc$zip, 1)
  } else if (region == "Texas") {
    loc <- texas_cities[sample(nrow(texas_cities), 1), ]
    portfolio$city[i] <- loc$city
    portfolio$st[i] <- "TX"
    portfolio$zip[i] <- generate_zip(loc$zip, 1)
  } else if (region == "National") {
    loc <- national_cities[sample(nrow(national_cities), 1), ]
    portfolio$city[i] <- loc$city
    portfolio$st[i] <- loc$st
    portfolio$zip[i] <- generate_zip(loc$zip, 1)
  } else if (region == "International") {
    loc <- canadian_cities[sample(nrow(canadian_cities), 1), ]
    portfolio$city[i] <- loc$city
    portfolio$st[i] <- loc$st
    portfolio$zip[i] <- loc$zip  # Canadian postal codes
  } else {
    # Unknown - leave address fields blank
    portfolio$city[i] <- NA_character_
    portfolio$st[i] <- NA_character_
    portfolio$zip[i] <- NA_character_
  }
}

# Generate street addresses (~95% have them)
has_address <- portfolio$region != "Unknown" &
  sample(c(TRUE, FALSE), n_records, replace = TRUE, prob = c(0.95, 0.05))
portfolio$address_1[has_address] <- generate_address(sum(has_address))
portfolio$address_2 <- generate_address2(n_records)

# Generate phone numbers (~85% have them)
has_phone <- sample(c(TRUE, FALSE), n_records, replace = TRUE, prob = c(0.85, 0.15))
portfolio$phone_number[has_phone] <- generate_phone(sum(has_phone))

# Generate emails (~75% have them)
has_email <- sample(c(TRUE, FALSE), n_records, replace = TRUE, prob = c(0.75, 0.25))
portfolio$email[has_email] <- generate_email(
  portfolio$first_name[has_email],
  portfolio$last_name[has_email],
  portfolio$company_name[has_email]
)

# For married couples, share contact info
for (i in seq(1, n_married_individuals, by = 2)) {
  idx1 <- idx_married_start + i - 1
  idx2 <- idx_married_start + i

  portfolio$address_1[idx2] <- portfolio$address_1[idx1]
  portfolio$address_2[idx2] <- portfolio$address_2[idx1]
  portfolio$city[idx2] <- portfolio$city[idx1]
  portfolio$st[idx2] <- portfolio$st[idx1]
  portfolio$zip[idx2] <- portfolio$zip[idx1]
  portfolio$region[idx2] <- portfolio$region[idx1]
  # Spouses may have different emails/phones
}

# -----------------------------------------------------------------------------
# GIVING INFORMATION
# -----------------------------------------------------------------------------

portfolio$first_gift_date <- as.Date(NA)
portfolio$first_gift_amount <- NA_real_
portfolio$last_gift_date <- as.Date(NA)
portfolio$last_gift_amount <- NA_real_
portfolio$largest_gift_date <- as.Date(NA)
portfolio$largest_gift_amount <- NA_real_
portfolio$total_giving <- NA_real_
portfolio$total_years_giving <- NA_integer_
portfolio$consecutive_years_giving <- NA_integer_
portfolio$donor_status <- NA_character_  # Additional: derived field

# Determine which records are donors (~70%)
is_donor <- sample(c(TRUE, FALSE), n_records, replace = TRUE, prob = c(0.70, 0.30))

# For donors only
donor_idx <- which(is_donor)
n_donors <- length(donor_idx)

# Generate first gift dates
first_dates <- generate_gift_date(n_donors, start_year = 1990)
portfolio$first_gift_date[donor_idx] <- first_dates

# Generate first gift amounts (smaller gifts typically)
first_amounts <- generate_gift_amount(n_donors, include_zeros = FALSE)
# First gifts tend to be smaller
portfolio$first_gift_amount[donor_idx] <- pmin(first_amounts, first_amounts * 0.5)

# Generate last gift dates (must be >= first gift date)
last_dates <- first_dates + sample(0:as.numeric(Sys.Date() - min(first_dates)),
                                    n_donors, replace = TRUE)
last_dates <- pmin(last_dates, Sys.Date())
portfolio$last_gift_date[donor_idx] <- last_dates

# Generate last gift amounts
portfolio$last_gift_amount[donor_idx] <- generate_gift_amount(n_donors, include_zeros = FALSE)

# Generate largest gift (at least as large as first or last)
largest_base <- pmax(portfolio$first_gift_amount[donor_idx],
                      portfolio$last_gift_amount[donor_idx])
# Some donors have given larger gifts than their first/last
upgrade_factor <- sample(c(1, 1, 1, 1.5, 2, 3, 5, 10), n_donors, replace = TRUE)
portfolio$largest_gift_amount[donor_idx] <- largest_base * upgrade_factor

# Largest gift date (between first and last)
for (i in donor_idx) {
  fd <- portfolio$first_gift_date[i]
  ld <- portfolio$last_gift_date[i]
  if (!is.na(fd) && !is.na(ld) && fd <= ld) {
    portfolio$largest_gift_date[i] <- fd + sample(0:as.numeric(ld - fd), 1)
  }
}

# Total giving (roughly: avg gift * years * gifts per year)
years_giving <- as.numeric(difftime(portfolio$last_gift_date[donor_idx],
                                     portfolio$first_gift_date[donor_idx],
                                     units = "days")) / 365.25 + 1
avg_gifts_per_year <- sample(c(0.5, 1, 1, 1, 2, 2, 3, 4), n_donors, replace = TRUE)
avg_gift <- (portfolio$first_gift_amount[donor_idx] +
              portfolio$last_gift_amount[donor_idx] +
              portfolio$largest_gift_amount[donor_idx]) / 3
portfolio$total_giving[donor_idx] <- round(avg_gift * years_giving * avg_gifts_per_year, 2)

# Total years giving
portfolio$total_years_giving[donor_idx] <- pmax(1, round(years_giving))

# Consecutive years giving (only for recent donors - FY25 or FY26)
current_fy <- as.integer(format(Sys.Date(), "%Y"))
if (as.integer(format(Sys.Date(), "%m")) >= 7) {
  current_fy <- current_fy + 1
}

recent_donor <- !is.na(portfolio$last_gift_date) &
  portfolio$last_gift_date >= as.Date(paste0(current_fy - 2, "-07-01"))

# For recent donors, consecutive years is a subset of total years
for (i in which(recent_donor)) {
  total_yrs <- portfolio$total_years_giving[i]
  if (!is.na(total_yrs) && total_yrs > 0) {
    # Consecutive could be 1 to total_years, weighted toward lower numbers
    max_consec <- min(total_yrs, 20)
    portfolio$consecutive_years_giving[i] <- sample(1:max_consec, 1,
                                                     prob = rev(1:max_consec))
  }
}

# Donor status based on last gift date
current_date <- Sys.Date()
fy_start_current <- as.Date(paste0(current_fy - 1, "-07-01"))
fy_start_prior <- as.Date(paste0(current_fy - 2, "-07-01"))
fy_start_2prior <- as.Date(paste0(current_fy - 3, "-07-01"))

portfolio$donor_status <- "Never"
portfolio$donor_status[donor_idx] <- "Lapsed"

active_idx <- which(portfolio$last_gift_date >= fy_start_current)
portfolio$donor_status[active_idx] <- "Active"

lybunt_idx <- which(portfolio$last_gift_date >= fy_start_prior &
                     portfolio$last_gift_date < fy_start_current)
portfolio$donor_status[lybunt_idx] <- "LYBUNT"

sybunt_idx <- which(portfolio$last_gift_date >= fy_start_2prior &
                     portfolio$last_gift_date < fy_start_prior)
portfolio$donor_status[sybunt_idx] <- "SYBUNT"

# -----------------------------------------------------------------------------
# PROSPECT INFORMATION
# -----------------------------------------------------------------------------

portfolio$fundraiser <- NA_character_
portfolio$fundraiser_start_date <- as.Date(NA)
portfolio$prospect_status <- NA_character_
portfolio$research_rating <- NA_character_
portfolio$open_proposal <- NA_character_

# Prospect status levels
prospect_status_levels <- c("Identification", "Qualification", "Cultivation",
                            "Solicitation", "Stewardship", "Disqualification")

# Research ratings (from fundr_rating_levels, left-skewed distribution peaking at K)
rating_levels <- c(
  "U - Unrated", "N - Less than $10K", "M - $10K to $24K", "L - $25K to $49K",
  "K - $50K to $99K", "J - $100K to $249K", "I - $250K to $499K",
  "H - $500K to $999K", "G - $1M to $2.49M", "F - $2.5M to $4.9M",
  "E - $5M to $9.9M", "D - $10M to $24.9M", "C - $25M to $49.9M",
  "B - $50M to $99.9M", "A - $100M+"
)

# Distribution: peak at K (index 5), decreasing toward both ends
# but more steeply toward the high end (left-skewed)
rating_probs <- c(0.15, 0.12, 0.15, 0.18, 0.20, 0.08, 0.05, 0.03, 0.02, 0.01,
                  0.005, 0.003, 0.001, 0.0005, 0.0005)
rating_probs <- rating_probs / sum(rating_probs)

# Generate ratings for all records
portfolio$research_rating <- sample(rating_levels, n_records, replace = TRUE,
                                     prob = rating_probs)

# Determine which records are assigned to fundraisers (~20% of records)
# Higher-rated prospects more likely to be assigned
rating_rank <- match(portfolio$research_rating, rating_levels)
# Probability of assignment increases with rating (lower rank = higher rating)
assign_prob <- pmax(0.05, 0.5 - (rating_rank / 30))
is_assigned <- runif(n_records) < assign_prob

# For assigned prospects
assigned_idx <- which(is_assigned)

# Assign fundraisers
portfolio$fundraiser[assigned_idx] <- sample(fundraisers, length(assigned_idx),
                                              replace = TRUE)

# Fundraiser start dates (within last 5 years mostly)
start_dates <- Sys.Date() - sample(0:(5*365), length(assigned_idx), replace = TRUE)
portfolio$fundraiser_start_date[assigned_idx] <- start_dates

# Prospect status for assigned
assigned_statuses <- sample(
  c("Qualification", "Cultivation", "Solicitation", "Stewardship"),
  length(assigned_idx),
  replace = TRUE,
  prob = c(0.25, 0.35, 0.20, 0.20)
)
portfolio$prospect_status[assigned_idx] <- assigned_statuses

# For unassigned prospects - most have no status, some are Identification or Disqualified
unassigned_idx <- which(!is_assigned)
unassigned_statuses <- sample(
  c(NA_character_, "Identification", "Disqualification"),
  length(unassigned_idx),
  replace = TRUE,
  prob = c(0.80, 0.15, 0.05)
)
portfolio$prospect_status[unassigned_idx] <- unassigned_statuses

# Convert to ordered factor
portfolio$prospect_status <- factor(portfolio$prospect_status,
                                     levels = prospect_status_levels)

# Open proposal (only for assigned prospects in Solicitation status)
portfolio$open_proposal <- "No"
solicitation_idx <- which(portfolio$prospect_status == "Solicitation")
portfolio$open_proposal[solicitation_idx] <- sample(
  c("Yes", "No"),
  length(solicitation_idx),
  replace = TRUE,
  prob = c(0.60, 0.40)
)

# For married couples, ensure same fundraiser assignment
for (i in seq(1, n_married_individuals, by = 2)) {
  idx1 <- idx_married_start + i - 1
  idx2 <- idx_married_start + i

  # Use primary's assignment for both
  portfolio$fundraiser[idx2] <- portfolio$fundraiser[idx1]
  portfolio$fundraiser_start_date[idx2] <- portfolio$fundraiser_start_date[idx1]
  # Spouse may have different individual prospect status
}

# =============================================================================
# ADDITIONAL RECOMMENDED COLUMNS
# =============================================================================

# Gender (for individuals)
portfolio$gender <- NA_character_
for (i in idx_individuals) {
  fn <- portfolio$first_name[i]
  match_idx <- which(first_names_data$first_name == fn)
  if (length(match_idx) > 0) {
    portfolio$gender[i] <- first_names_data$gender[match_idx[1]]
  }
}

# Preferred contact method
portfolio$preferred_contact <- sample(
  c("Email", "Phone", "Mail", NA_character_),
  n_records,
  replace = TRUE,
  prob = c(0.40, 0.25, 0.25, 0.10)
)

# Communication preferences (opt-outs)
portfolio$do_not_email <- sample(c(TRUE, FALSE), n_records, replace = TRUE,
                                  prob = c(0.05, 0.95))
portfolio$do_not_call <- sample(c(TRUE, FALSE), n_records, replace = TRUE,
                                 prob = c(0.08, 0.92))
portfolio$do_not_mail <- sample(c(TRUE, FALSE), n_records, replace = TRUE,
                                 prob = c(0.03, 0.97))
portfolio$do_not_solicit <- sample(c(TRUE, FALSE), n_records, replace = TRUE,
                                    prob = c(0.02, 0.98))

# Deceased flag
portfolio$deceased <- sample(c(TRUE, FALSE), n_records, replace = TRUE,
                              prob = c(0.02, 0.98))
portfolio$deceased[idx_companies] <- FALSE  # Companies can't be deceased

# Board member flag
portfolio$is_board_member <- sample(c(TRUE, FALSE), n_records, replace = TRUE,
                                     prob = c(0.005, 0.995))

# Volunteer flag
portfolio$is_volunteer <- sample(c(TRUE, FALSE), n_records, replace = TRUE,
                                  prob = c(0.03, 0.97))

# Event attendance count (last 3 years)
portfolio$events_attended <- sample(0:15, n_records, replace = TRUE,
                                     prob = c(0.50, rep(0.05, 5), rep(0.02, 5), rep(0.01, 5)))

# Constituent added date
portfolio$date_added <- Sys.Date() - sample(0:(35*365), n_records, replace = TRUE)

# =============================================================================
# FINALIZE AND SAVE
# =============================================================================

# Reorder columns for logical grouping
column_order <- c(
  # IDs
  "constituent_id", "household_id", "household_position", "record_type",
  # Biographical
  "title", "first_name", "middle_name", "last_name", "suffix", "nickname",
  "company_name", "gender", "dob", "relationship_status",
  # Contact

  "address_1", "address_2", "city", "st", "zip", "region",
  "email", "phone_number", "preferred_contact",
  "do_not_email", "do_not_call", "do_not_mail", "do_not_solicit",
  # Giving
  "first_gift_date", "first_gift_amount", "last_gift_date", "last_gift_amount",
  "largest_gift_date", "largest_gift_amount", "total_giving",
  "total_years_giving", "consecutive_years_giving", "donor_status",
  # Prospect
  "fundraiser", "fundraiser_start_date", "prospect_status",
  "research_rating", "open_proposal",
  # Status flags
  "deceased", "is_board_member", "is_volunteer", "events_attended",
  "date_added"
)

fundr_portfolio <- portfolio[, column_order]

# Final verification
cat("\n=== Dataset Summary ===\n")
cat(sprintf("Total records: %d\n", nrow(fundr_portfolio)))
cat(sprintf("Individuals: %d\n", sum(fundr_portfolio$record_type == "Individual")))
cat(sprintf("Organizations: %d\n", sum(fundr_portfolio$record_type == "Organization")))
cat(sprintf("Married couples: %d households\n",
            length(unique(fundr_portfolio$household_id[fundr_portfolio$relationship_status == "Married"]))))
cat(sprintf("Donors: %d (%.1f%%)\n", sum(!is.na(fundr_portfolio$first_gift_date)),
            100 * mean(!is.na(fundr_portfolio$first_gift_date))))
cat(sprintf("Assigned prospects: %d (%.1f%%)\n", sum(!is.na(fundr_portfolio$fundraiser)),
            100 * mean(!is.na(fundr_portfolio$fundraiser))))
cat("\nRegion distribution:\n")
print(table(fundr_portfolio$region))
cat("\nDonor status distribution:\n")
print(table(fundr_portfolio$donor_status))
cat("\nProspect status distribution:\n")
print(table(fundr_portfolio$prospect_status, useNA = "ifany"))

# Save the dataset
usethis::use_data(fundr_portfolio, overwrite = TRUE)

cat("\nDataset saved successfully!\n")
