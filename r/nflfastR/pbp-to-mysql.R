# This script is a very simple script that takes the nflfastR play by play data and inserts into a table called nfl_pbp in a mySQL database.

# You will need to do 2, maybe 3 things
# 1) You need to fill in your mySQL connection parameters below
# 2) You might want to use more sophisticated database code - see pooling
# 3) You will need to assign the years in the pbp_data line.

# Load required libraries
library(nflfastR)
library(DBI)
library(RMySQL)

# Database connection parameters
db_host <- "YOUR_HOSTNAME"
db_port <- YOUR_PORT_3306
db_user <- "YOUR_DN_USERNAME"
db_password <- "YOUR_PASSWORD"
db_name <- "YOUR_DATABASE_NAME"

# Establish connection to the MySQL database
con <- dbConnect(MySQL(),
                 host = db_host,
                 dbname = db_name,
                 user = db_user,
                 password = db_password)

# Fetch play-by-play data for a specific season
# Note - nflfastr currently goes back to 1999 and this code is being posted to GH before the start of the 2024 season. You will need to change the years here as needed.
pbp_data <- load_pbp(seasons = 1999:2023)

# Write the data to the database
dbWriteTable(con, "nfl_pbp", pbp_data, append = TRUE, row.names = FALSE)

# Close the database connection
dbDisconnect(con)
