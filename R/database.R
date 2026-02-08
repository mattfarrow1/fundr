#' Create database connection
#'
#' A convenience wrapper for common database connections. Supports
#' SQL Server, PostgreSQL, MySQL, and SQLite.
#'
#' @param driver Database driver: "sqlserver", "postgres", "mysql", or "sqlite".
#' @param host Database server hostname or IP address.
#' @param port Database port (uses default if NULL).
#' @param database Database name.
#' @param username Database username.
#' @param password Database password. Consider using environment variables.
#' @param ... Additional arguments passed to the DBI connection function.
#'
#' @return A DBI connection object.
#'
#' @details
#' Required packages by driver:
#' \itemize{
#'   \item \strong{sqlserver}: odbc
#'   \item \strong{postgres}: RPostgres
#'   \item \strong{mysql}: RMySQL or RMariaDB
#'   \item \strong{sqlite}: RSQLite
#' }
#'
#' For security, store credentials in environment variables:
#' \preformatted{
#' # In .Renviron
#' DB_HOST=server.example.com
#' DB_USER=username
#' DB_PASS=password
#' }
#'
#' @examples
#' \dontrun{
#' # SQL Server connection
#' conn <- db_connect(
#'   driver = "sqlserver",
#'   host = Sys.getenv("DB_HOST"),
#'   database = "Advancement",
#'   username = Sys.getenv("DB_USER"),
#'   password = Sys.getenv("DB_PASS")
#' )
#'
#' # Query and close
#' data <- DBI::dbGetQuery(conn, "SELECT * FROM Donors")
#' DBI::dbDisconnect(conn)
#'
#' # SQLite (file-based, no credentials needed)
#' conn <- db_connect(driver = "sqlite", database = "local.db")
#' }
#'
#' @export
db_connect <- function(
    driver = c("sqlserver", "postgres", "mysql", "sqlite"),
    host = NULL,
    port = NULL,
    database,
    username = NULL,
    password = NULL,
    ...
) {
  driver <- match.arg(driver)

  fundr_needs("DBI", "Install with: install.packages('DBI')")

  conn <- switch(
    driver,
    "sqlserver" = connect_sqlserver(host, port, database, username, password, ...),
    "postgres" = connect_postgres(host, port, database, username, password, ...),
    "mysql" = connect_mysql(host, port, database, username, password, ...),
    "sqlite" = connect_sqlite(database, ...)
  )

  conn
}

#' @noRd
connect_sqlserver <- function(host, port, database, username, password, ...) {
  fundr_needs("odbc", "Install with: install.packages('odbc')")

  if (is.null(port)) port <- 1433

  connection_string <- paste0(
    "Driver={ODBC Driver 17 for SQL Server};",
    "Server=", host, ",", port, ";",
    "Database=", database, ";"
  )

  if (!is.null(username) && !is.null(password)) {
    connection_string <- paste0(
      connection_string,
      "Uid=", username, ";",
      "Pwd=", password, ";"
    )
  } else {
    # Use trusted connection (Windows authentication)
    connection_string <- paste0(connection_string, "Trusted_Connection=yes;")
  }

  DBI::dbConnect(odbc::odbc(), .connection_string = connection_string, ...)
}

#' @noRd
connect_postgres <- function(host, port, database, username, password, ...) {
  fundr_needs("RPostgres", "Install with: install.packages('RPostgres')")

  if (is.null(port)) port <- 5432

  DBI::dbConnect(
    RPostgres::Postgres(),
    host = host,
    port = port,
    dbname = database,
    user = username,
    password = password,
    ...
  )
}

#' @noRd
connect_mysql <- function(host, port, database, username, password, ...) {
  # Try RMariaDB first, then RMySQL
  if (requireNamespace("RMariaDB", quietly = TRUE)) {
    if (is.null(port)) port <- 3306
    return(DBI::dbConnect(
      RMariaDB::MariaDB(),
      host = host,
      port = port,
      dbname = database,
      user = username,
      password = password,
      ...
    ))
  }

  fundr_needs("RMySQL", "Install RMariaDB or RMySQL")

  if (is.null(port)) port <- 3306

  DBI::dbConnect(
    RMySQL::MySQL(),
    host = host,
    port = port,
    dbname = database,
    user = username,
    password = password,
    ...
  )
}

#' @noRd
connect_sqlite <- function(database, ...) {
  fundr_needs("RSQLite", "Install with: install.packages('RSQLite')")

  DBI::dbConnect(RSQLite::SQLite(), dbname = database, ...)
}

#' Execute a query and return results
#'
#' A convenience wrapper that executes a query and returns the results
#' as a data frame. Handles connection cleanup automatically if
#' `disconnect = TRUE`.
#'
#' @param conn A DBI connection object.
#' @param query SQL query string.
#' @param params Named list of parameters for parameterized queries.
#' @param disconnect If TRUE, disconnects after query. Default FALSE.
#'
#' @return Data frame of query results.
#'
#' @examples
#' \dontrun{
#' conn <- db_connect(driver = "sqlite", database = "donors.db")
#'
#' # Simple query
#' donors <- db_query(conn, "SELECT * FROM donors WHERE status = 'Active'")
#'
#' # Parameterized query (prevents SQL injection)
#' donors <- db_query(conn, "SELECT * FROM donors WHERE id = ?id",
#'                    params = list(id = 123))
#'
#' DBI::dbDisconnect(conn)
#' }
#'
#' @export
db_query <- function(conn, query, params = NULL, disconnect = FALSE) {
  if (!inherits(conn, "DBIConnection")) {
    stop("conn must be a DBI connection object", call. = FALSE)
  }

  result <- tryCatch({
    if (is.null(params)) {
      DBI::dbGetQuery(conn, query)
    } else {
      DBI::dbGetQuery(conn, query, params = params)
    }
  }, finally = {
    if (isTRUE(disconnect)) {
      DBI::dbDisconnect(conn)
    }
  })

  result
}

#' Test database connection
#'
#' Verifies that a database connection is valid.
#'
#' @param conn A DBI connection object.
#'
#' @return TRUE if connection is valid, FALSE otherwise.
#'
#' @examples
#' \dontrun{
#' conn <- db_connect(driver = "sqlite", database = "test.db")
#' db_test(conn)
#' #> TRUE
#' }
#'
#' @export
db_test <- function(conn) {
  if (!inherits(conn, "DBIConnection")) {
    return(FALSE)
  }

  tryCatch({
    DBI::dbIsValid(conn)
  }, error = function(e) {
    FALSE
  })
}
