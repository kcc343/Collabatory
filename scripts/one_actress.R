# Load libraries

library(dplyr)
library(httr)
library(jsonlite)

# Source api key

source("api_key.R")

# Create HTTP request to get actress id

base_uri <- "https://api.themoviedb.org/3"
resource <- "/search/person"
uri_full <- paste0(base_uri, resource)
query_params <- list(api_key = api_key, query = "keira knightley")

# Send HTTP request to get id

response <- GET(uri_full, query = query_params)
body <- content(response, "text")
actress_list <- fromJSON(body)

actress_id <- actress_list$results$id

# Get all movies for specific actress

resource <- "/discover/movie"
uri_full <- paste0(base_uri, resource)
query_params <- list(api_key = api_key, with_people = paste(actress_id))

response <- GET(uri_full, query = query_params)
body <- content(response, "text")
actress_movie_list <- fromJSON(body)

# Get budget and revenue

movie_data <- list()

query_params <- list(api_key = api_key)

for (num in 1:length(actress_movie_list$results$id)) {
  resource <- paste0("/movie/", actress_movie_list$results$id[num])
  uri_full <- paste0(base_uri, resource)
  response <- GET(uri_full, query = query_params)
  body <- content(response, "text")
  one_movie <- fromJSON(body)
  movie_data[[num]] <- one_movie
}

budget <- c()
genres <- list()
homepage <- c()
status <- c()
original_title <- c()
overview <- c()
popularity <- c()
production_companies <- list()
production_countries <- c()
release_date <- c()
revenue <- c()
runtime <- c()
title <- c()

for (num in 1:length(movie_data)) {
  budget <- c(budget, movie_data[[num]]$budget)
  original_title <- c(original_title, movie_data[[num]]$original_title)
  overview <- c(overview, movie_data[[num]]$overview)
  popularity <- c(popularity, movie_data[[num]]$popularity)
  status <- c(status, movie_data[[num]]$status)
  release_date <- c(release_date, movie_data[[num]]$release_date)
  revenue <- c(revenue, movie_data[[num]]$revenue)
  runtime <- c(runtime, movie_data[[num]]$runtime)
  title <- c(title, movie_data[[num]]$title)
}

get_details <- data.frame(budget, revenue, title, overview, popularity, release_date, status, stringsAsFactors = F)