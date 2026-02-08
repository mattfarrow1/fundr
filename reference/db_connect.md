# Create database connection

A convenience wrapper for common database connections. Supports SQL
Server, PostgreSQL, MySQL, and SQLite.

## Usage

``` r
db_connect(
  driver = c("sqlserver", "postgres", "mysql", "sqlite"),
  host = NULL,
  port = NULL,
  database,
  username = NULL,
  password = NULL,
  ...
)
```

## Arguments

- driver:

  Database driver: "sqlserver", "postgres", "mysql", or "sqlite".

- host:

  Database server hostname or IP address.

- port:

  Database port (uses default if NULL).

- database:

  Database name.

- username:

  Database username.

- password:

  Database password. Consider using environment variables.

- ...:

  Additional arguments passed to the DBI connection function.

## Value

A DBI connection object.

## Details

Required packages by driver:

- **sqlserver**: odbc

- **postgres**: RPostgres

- **mysql**: RMySQL or RMariaDB

- **sqlite**: RSQLite

For security, store credentials in environment variables:

    # In .Renviron
    DB_HOST=server.example.com
    DB_USER=username
    DB_PASS=password

## Examples

``` r
if (FALSE) { # \dontrun{
# SQL Server connection
conn <- db_connect(
  driver = "sqlserver",
  host = Sys.getenv("DB_HOST"),
  database = "Advancement",
  username = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASS")
)

# Query and close
data <- DBI::dbGetQuery(conn, "SELECT * FROM Donors")
DBI::dbDisconnect(conn)

# SQLite (file-based, no credentials needed)
conn <- db_connect(driver = "sqlite", database = "local.db")
} # }
```
