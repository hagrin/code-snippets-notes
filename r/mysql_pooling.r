# Need this for any R file / project you want to have mySQL connection pooling functionality

library(pool)
library(RMySQL)

# Create a connection pool
my_pool <- dbPool(
  drv = RMySQL::MySQL(),
  dbname = "your_database",
  host = "localhost",
  username = "your_username",
  password = "your_password",
  minSize = 1,
  maxSize = 5
)

# Use the pool to query
result <- dbGetQuery(my_pool, "SELECT * FROM your_table")

# When done, close the pool
poolClose(my_pool)
