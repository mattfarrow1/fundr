# Execute a query and return results

A convenience wrapper that executes a query and returns the results as a
data frame. Handles connection cleanup automatically if
`disconnect = TRUE`.

## Usage

``` r
db_query(conn, query, params = NULL, disconnect = FALSE)
```

## Arguments

- conn:

  A DBI connection object.

- query:

  SQL query string.

- params:

  Named list of parameters for parameterized queries.

- disconnect:

  If TRUE, disconnects after query. Default FALSE.

## Value

Data frame of query results.

## Examples

``` r
if (FALSE) { # \dontrun{
conn <- db_connect(driver = "sqlite", database = "donors.db")

# Simple query
donors <- db_query(conn, "SELECT * FROM donors WHERE status = 'Active'")

# Parameterized query (prevents SQL injection)
donors <- db_query(conn, "SELECT * FROM donors WHERE id = ?id",
                   params = list(id = 123))

DBI::dbDisconnect(conn)
} # }
```
