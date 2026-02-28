#' Gift level reference table
#'
#' A reference table of common ask amounts, formatted giving level labels, and
#' broader ask buckets useful for reporting and segmentation.
#'
#' @format A data frame with 14 rows and 3 variables:
#' \describe{
#'   \item{ask_amount}{Numeric ask amount threshold.}
#'   \item{giving_level}{Ordered factor label for the threshold (e.g., "$1,000,000+").}
#'   \item{ask_bucket}{Ordered factor bucket label (e.g., "$1M to $2.49M").}
#' }
#' @source Internal conventions (fundr).
"fundr_gift_levels"

#' Rating level reference table
#'
#' A reference table of wealth or capacity rating levels, numeric thresholds,
#' and broader rating buckets commonly used in fundraising analytics.
#'
#' @format A data frame with 15 rows and 3 variables:
#' \describe{
#'   \item{rating_level}{Ordered factor rating label (e.g., "A - $100M+").}
#'   \item{rating_value}{Numeric threshold representing the rating level.}
#'   \item{rating_bucket}{Ordered factor grouping (Principal, Major, Mid-Level, Annual, Unrated).}
#' }
#' @source Internal conventions (fundr).
"fundr_rating_levels"

#' Sample fundraising portfolio
#'
#' A synthetic dataset of 10,000 constituent records for a fictional nonprofit
#' organization based in Dallas, TX. The dataset includes individuals (singles
#' and married couples) and companies, with realistic data quality variations
#' to demonstrate data cleanup functions.
#'
#' @format A data frame with 10,000 rows and 43 variables:
#' \describe{
#'   \item{constituent_id}{Unique 8-digit ID prefixed with "8-".}
#'   \item{household_id}{Identifier linking household members (spouses share same ID).}
#'   \item{household_position}{Position in household: "Primary" or "Spouse".}
#'   \item{record_type}{"Individual" or "Organization".}
#'   \item{title}{Honorific (Dr., Mr., Ms., Mrs., etc.) or NA.}
#'   \item{first_name}{First name (individuals only).}
#'   \item{middle_name}{Middle name or NA.}
#'   \item{last_name}{Last name (individuals only).}
#'   \item{suffix}{Name suffix (Jr., Sr., II, III, IV) or NA.}
#'   \item{nickname}{Common nickname or NA.}
#'   \item{company_name}{Organization name (organizations only).}
#'   \item{gender}{"M" or "F" for individuals, NA for organizations.}
#'   \item{dob}{Date of birth in varied formats (MDY, MY, Y) for partial date parsing.}
#'   \item{relationship_status}{Single, Married, Divorced, Widowed, or Unknown.}
#'   \item{address_1}{Street address with varied formatting for cleanup demos.}
#'   \item{address_2}{Secondary address line (apartment, suite) or NA.}
#'   \item{city}{City name.}
#'   \item{st}{State/province abbreviation.}
#'   \item{zip}{ZIP/postal code in varied formats (5-digit, ZIP+4, Canadian).}
#'   \item{region}{Factor: Local (DFW), Texas, National, International, Unknown.}
#'   \item{email}{Email address or NA.}
#'   \item{phone_number}{Phone number with varied formatting for cleanup demos.}
#'   \item{preferred_contact}{Preferred contact method: Email, Phone, Mail, or NA.}
#'   \item{do_not_email}{Logical: TRUE if opted out of email.}
#'   \item{do_not_call}{Logical: TRUE if opted out of calls.}
#'   \item{do_not_mail}{Logical: TRUE if opted out of mail.}
#'   \item{do_not_solicit}{Logical: TRUE if opted out of solicitations.}
#'   \item{first_gift_date}{Date of first gift or NA for non-donors.}
#'   \item{first_gift_amount}{Amount of first gift or NA.}
#'   \item{last_gift_date}{Date of most recent gift or NA.}
#'   \item{last_gift_amount}{Amount of most recent gift or NA.}
#'   \item{largest_gift_date}{Date of largest gift or NA.}
#'   \item{largest_gift_amount}{Amount of largest gift or NA.}
#'   \item{total_giving}{Cumulative lifetime giving or NA.}
#'   \item{total_years_giving}{Number of distinct fiscal years with gifts or NA.}
#'   \item{consecutive_years_giving}{Current giving streak in years (recent donors only).}
#'   \item{donor_status}{Derived status: Active, LYBUNT, SYBUNT, Lapsed, Never.}
#'   \item{fundraiser}{Assigned fundraiser name or NA if unassigned.}
#'   \item{fundraiser_start_date}{Date fundraiser was assigned or NA.}
#'   \item{prospect_status}{Factor: Identification, Qualification, Cultivation, Solicitation, Stewardship, Disqualification.}
#'   \item{research_rating}{Wealth rating from fundr_rating_levels (left-skewed distribution).}
#'   \item{open_proposal}{"Yes" or "No" for prospects in Solicitation status.}
#'   \item{deceased}{Logical: TRUE if constituent is deceased.}
#'   \item{is_board_member}{Logical: TRUE if current board member.}
#'   \item{is_volunteer}{Logical: TRUE if active volunteer.}
#'   \item{events_attended}{Number of events attended in last 3 years.}
#'   \item{date_added}{Date constituent was added to the database.}
#' }
#'
#' @details
#' The dataset is designed for:
#' \itemize{
#'   \item Testing fundr package functions (phone/ZIP normalization, fiscal year, etc.)
#'   \item Learning R and tidyverse data manipulation
#'   \item Practicing statistical analysis and visualization techniques
#'   \item Demonstrating machine learning approaches for fundraising analytics
#' }
#'
#' Data quality intentionally varies to simulate real-world conditions:
#' \itemize{
#'   \item DOB field contains mixed date formats (full dates, month/year, year only)
#'   \item Phone numbers use varied formatting (dashes, dots, parentheses, etc.)
#'   \item ZIP codes include 5-digit, ZIP+4, and Canadian postal codes
#'   \item Some fields have missing values at realistic rates
#' }
#'
#' Geographic distribution is weighted toward Dallas/Fort Worth (~50\%), with
#' decreasing representation for greater Texas, national, and international.
#'
#' Gift amounts follow a pyramid distribution with most donors at lower levels.
#'
#' @source Synthetically generated for the fundr package.
#' @seealso [normalize_phone()], [normalize_zip()], [parse_partial_date()],
#'   [fy_year()], [donor_status()], [bucket_gift_level()], [bucket_rating_level()]
"fundr_portfolio"
