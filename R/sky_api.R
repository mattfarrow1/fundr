#' Create SKY API connection
#'
#' Sets up authentication for Blackbaud's SKY API. Requires a subscription
#' key and OAuth token. See Blackbaud Developer Portal for setup instructions.
#'
#' @param subscription_key Your SKY API subscription key.
#' @param access_token OAuth 2.0 access token.
#' @param base_url Base URL for the API. Default is the production endpoint.
#'
#' @return A list containing connection parameters, used by other SKY API functions.
#'
#' @details
#' To obtain credentials:
#' \enumerate{
#'   \item Register at developer.blackbaud.com
#'   \item Create an application and note the subscription key
#'   \item Complete OAuth flow to get access token
#' }
#'
#' Store credentials securely using environment variables:
#' \preformatted{
#' # In .Renviron
#' SKY_API_KEY=your_subscription_key
#' SKY_API_TOKEN=your_access_token
#' }
#'
#' @examples
#' \dontrun{
#' # Using environment variables
#' conn <- sky_connect(
#'   subscription_key = Sys.getenv("SKY_API_KEY"),
#'   access_token = Sys.getenv("SKY_API_TOKEN")
#' )
#'
#' # Get constituents
#' constituents <- sky_get(conn, "constituent/v1/constituents")
#' }
#'
#' @export
sky_connect <- function(
    subscription_key,
    access_token,
    base_url = "https://api.sky.blackbaud.com"
) {
  if (missing(subscription_key) || is.null(subscription_key) || subscription_key == "") {
    stop("subscription_key is required. Set SKY_API_KEY environment variable.",
         call. = FALSE)
  }

  if (missing(access_token) || is.null(access_token) || access_token == "") {
    stop("access_token is required. Set SKY_API_TOKEN environment variable.",
         call. = FALSE)
  }

  structure(
    list(
      subscription_key = subscription_key,
      access_token = access_token,
      base_url = base_url
    ),
    class = "sky_connection"
  )
}

#' Make GET request to SKY API
#'
#' Sends a GET request to the SKY API and returns the parsed response.
#'
#' @param conn A SKY API connection created by [sky_connect()].
#' @param endpoint API endpoint path (e.g., "constituent/v1/constituents").
#' @param params Named list of query parameters.
#' @param ... Additional arguments passed to httr.
#'
#' @return Parsed JSON response as a list or data frame.
#'
#' @examples
#' \dontrun{
#' conn <- sky_connect(
#'   subscription_key = Sys.getenv("SKY_API_KEY"),
#'   access_token = Sys.getenv("SKY_API_TOKEN")
#' )
#'
#' # Get constituents
#' result <- sky_get(conn, "constituent/v1/constituents",
#'                   params = list(limit = 100))
#' }
#'
#' @export
sky_get <- function(conn, endpoint, params = list(), ...) {
  fundr_needs("httr", "Install with: install.packages('httr')")
  fundr_needs("jsonlite", "Install with: install.packages('jsonlite')")

  if (!inherits(conn, "sky_connection")) {
    stop("conn must be a sky_connection object from sky_connect()", call. = FALSE)
  }

  url <- paste0(conn$base_url, "/", endpoint)

  response <- httr::GET(
    url,
    httr::add_headers(
      `Bb-Api-Subscription-Key` = conn$subscription_key,
      Authorization = paste("Bearer", conn$access_token)
    ),
    query = params,
    ...
  )

  if (httr::http_error(response)) {
    status <- httr::status_code(response)
    content <- httr::content(response, as = "text", encoding = "UTF-8")
    stop("SKY API error (", status, "): ", content, call. = FALSE)
  }

  content <- httr::content(response, as = "text", encoding = "UTF-8")
  jsonlite::fromJSON(content, simplifyVector = TRUE)
}

#' Get all pages from SKY API endpoint
#'
#' Handles pagination to retrieve all records from a SKY API endpoint.
#'
#' @param conn A SKY API connection created by [sky_connect()].
#' @param endpoint API endpoint path.
#' @param params Named list of query parameters.
#' @param limit Records per page. Default 500 (max allowed).
#' @param max_records Maximum total records to retrieve. Default NULL (all).
#' @param verbose If TRUE, prints progress messages.
#'
#' @return Combined data frame of all records.
#'
#' @examples
#' \dontrun{
#' conn <- sky_connect(
#'   subscription_key = Sys.getenv("SKY_API_KEY"),
#'   access_token = Sys.getenv("SKY_API_TOKEN")
#' )
#'
#' # Get all constituents (handles pagination automatically)
#' all_constituents <- sky_get_all(conn, "constituent/v1/constituents")
#' }
#'
#' @export
sky_get_all <- function(
    conn,
    endpoint,
    params = list(),
    limit = 500L,
    max_records = NULL,
    verbose = TRUE
) {
  all_data <- list()
  offset <- 0L
  total_fetched <- 0L
  page <- 1L

  repeat {
    params$limit <- limit
    params$offset <- offset

    if (isTRUE(verbose)) {
      message("Fetching page ", page, " (offset ", offset, ")...")
    }

    result <- sky_get(conn, endpoint, params)

    # SKY API returns data in a "value" field typically
    if ("value" %in% names(result)) {
      data <- result$value
    } else {
      data <- result
    }

    if (length(data) == 0 || (is.data.frame(data) && nrow(data) == 0)) {
      break
    }

    all_data[[page]] <- data
    fetched_count <- if (is.data.frame(data)) nrow(data) else length(data)
    total_fetched <- total_fetched + fetched_count

    if (!is.null(max_records) && total_fetched >= max_records) {
      break
    }

    # Check if there are more pages
    if (fetched_count < limit) {
      break
    }

    offset <- offset + limit
    page <- page + 1L
  }

  if (length(all_data) == 0) {
    return(NULL)
  }

  if (all(vapply(all_data, is.data.frame, logical(1)))) {
    result <- do.call(rbind, all_data)
    if (!is.null(max_records) && nrow(result) > max_records) {
      result <- result[seq_len(max_records), ]
    }
    return(result)
  }

  unlist(all_data, recursive = FALSE)
}

#' Test SKY API connection
#'
#' Verifies that the SKY API credentials are valid by making a test request.
#'
#' @param conn A SKY API connection created by [sky_connect()].
#'
#' @return TRUE if connection is valid, otherwise throws an error.
#'
#' @examples
#' \dontrun{
#' conn <- sky_connect(
#'   subscription_key = Sys.getenv("SKY_API_KEY"),
#'   access_token = Sys.getenv("SKY_API_TOKEN")
#' )
#'
#' sky_test(conn)
#' #> TRUE
#' }
#'
#' @export
sky_test <- function(conn) {
  # Try to get a single constituent to test the connection
  tryCatch({
    result <- sky_get(conn, "constituent/v1/constituents",
                      params = list(limit = 1))
    message("SKY API connection successful!")
    invisible(TRUE)
  }, error = function(e) {
    stop("SKY API connection failed: ", e$message, call. = FALSE)
  })
}
