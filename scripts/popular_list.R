# Load libraries

library(dplyr)
library(httr)
library(jsonlite)

# Source api key

source("api_key.R")

# Create HTTP request to get get popular movies (first 20)

base_uri <- "https://api.themoviedb.org/3"
resource <- "/movie/popular"
uri_full <- paste0(base_uri, resource)
query_params <- list(api_key = api_key)

# Send HTTP Request

response <- GET(uri_full, query = query_params)
body <- content(response, "text")
popular_list <- fromJSON(body)

# Get budget and revenue

popular_data <- list()

query_params <- list(api_key = api_key, append_to_response = "credits")

for (num in 1:length(popular_list$results$id)) {
  resource <- paste0("/movie/", popular_list$results$id[num])
  uri_full <- paste0(base_uri, resource)
  response <- GET(uri_full, query = query_params)
  body <- content(response, "text")
  popular_movie <- fromJSON(body)
  popular_data[[num]] <- popular_movie
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
credits <- c()

for (num in 1:length(popular_data)) {
  budget <- c(budget, popular_data[[num]]$budget)
  original_title <- c(original_title, popular_data[[num]]$original_title)
  overview <- c(overview, popular_data[[num]]$overview)
  popularity <- c(popularity, popular_data[[num]]$popularity)
  status <- c(status, popular_data[[num]]$status)
  release_date <- c(release_date, popular_data[[num]]$release_date)
  revenue <- c(revenue, popular_data[[num]]$revenue)
  runtime <- c(runtime, popular_data[[num]]$runtime)
  title <- c(title, popular_data[[num]]$title)
  credits <- c(credits, popular_data[[num]]$credits[1])
}

get_details <- data.frame(budget, revenue, title, overview, popularity, release_date, status, b=I(credits))