# Sample fundraising portfolio

A synthetic dataset of 10,000 constituent records for a fictional
nonprofit organization based in Dallas, TX. The dataset includes
individuals (singles and married couples) and companies, with realistic
data quality variations to demonstrate data cleanup functions.

## Usage

``` r
fundr_portfolio
```

## Format

A data frame with 10,000 rows and 43 variables:

- constituent_id:

  Unique 8-digit ID prefixed with "8-".

- household_id:

  Identifier linking household members (spouses share same ID).

- household_position:

  Position in household: "Primary" or "Spouse".

- record_type:

  "Individual" or "Organization".

- title:

  Honorific (Dr., Mr., Ms., Mrs., etc.) or NA.

- first_name:

  First name (individuals only).

- middle_name:

  Middle name or NA.

- last_name:

  Last name (individuals only).

- suffix:

  Name suffix (Jr., Sr., II, III, IV) or NA.

- nickname:

  Common nickname or NA.

- company_name:

  Organization name (organizations only).

- gender:

  "M" or "F" for individuals, NA for organizations.

- dob:

  Date of birth in varied formats (MDY, MY, Y) for partial date parsing.

- relationship_status:

  Single, Married, Divorced, Widowed, or Unknown.

- address_1:

  Street address with varied formatting for cleanup demos.

- address_2:

  Secondary address line (apartment, suite) or NA.

- city:

  City name.

- st:

  State/province abbreviation.

- zip:

  ZIP/postal code in varied formats (5-digit, ZIP+4, Canadian).

- region:

  Factor: Local (DFW), Texas, National, International, Unknown.

- email:

  Email address or NA.

- phone_number:

  Phone number with varied formatting for cleanup demos.

- preferred_contact:

  Preferred contact method: Email, Phone, Mail, or NA.

- do_not_email:

  Logical: TRUE if opted out of email.

- do_not_call:

  Logical: TRUE if opted out of calls.

- do_not_mail:

  Logical: TRUE if opted out of mail.

- do_not_solicit:

  Logical: TRUE if opted out of solicitations.

- first_gift_date:

  Date of first gift or NA for non-donors.

- first_gift_amount:

  Amount of first gift or NA.

- last_gift_date:

  Date of most recent gift or NA.

- last_gift_amount:

  Amount of most recent gift or NA.

- largest_gift_date:

  Date of largest gift or NA.

- largest_gift_amount:

  Amount of largest gift or NA.

- total_giving:

  Cumulative lifetime giving or NA.

- total_years_giving:

  Number of distinct fiscal years with gifts or NA.

- consecutive_years_giving:

  Current giving streak in years (recent donors only).

- donor_status:

  Derived status: Active, LYBUNT, SYBUNT, Lapsed, Never.

- fundraiser:

  Assigned fundraiser name or NA if unassigned.

- fundraiser_start_date:

  Date fundraiser was assigned or NA.

- prospect_status:

  Factor: Identification, Qualification, Cultivation, Solicitation,
  Stewardship, Disqualification.

- research_rating:

  Wealth rating from fundr_rating_levels (left-skewed distribution).

- open_proposal:

  "Yes" or "No" for prospects in Solicitation status.

- deceased:

  Logical: TRUE if constituent is deceased.

- is_board_member:

  Logical: TRUE if current board member.

- is_volunteer:

  Logical: TRUE if active volunteer.

- events_attended:

  Number of events attended in last 3 years.

- date_added:

  Date constituent was added to the database.

## Source

Synthetically generated for the fundr package.

## Details

The dataset is designed for:

- Testing fundr package functions (phone/ZIP normalization, fiscal year,
  etc.)

- Learning R and tidyverse data manipulation

- Practicing statistical analysis and visualization techniques

- Demonstrating machine learning approaches for fundraising analytics

Data quality intentionally varies to simulate real-world conditions:

- DOB field contains mixed date formats (full dates, month/year, year
  only)

- Phone numbers use varied formatting (dashes, dots, parentheses, etc.)

- ZIP codes include 5-digit, ZIP+4, and Canadian postal codes

- Some fields have missing values at realistic rates

Geographic distribution is weighted toward Dallas/Fort Worth (~50\\
decreasing representation for greater Texas, national, and
international.

Gift amounts follow a pyramid distribution with most donors at lower
levels.

## See also

[`normalize_phone()`](https://mattfarrow1.github.io/fundr/reference/normalize_phone.md),
[`normalize_zip()`](https://mattfarrow1.github.io/fundr/reference/normalize_zip.md),
[`parse_partial_date()`](https://mattfarrow1.github.io/fundr/reference/parse_partial_date.md),
[`fy_year()`](https://mattfarrow1.github.io/fundr/reference/fy_year.md),
[`donor_status()`](https://mattfarrow1.github.io/fundr/reference/donor_status.md),
[`bucket_gift_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_gift_level.md),
[`bucket_rating_level()`](https://mattfarrow1.github.io/fundr/reference/bucket_rating_level.md)
