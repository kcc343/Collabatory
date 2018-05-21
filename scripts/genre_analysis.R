# Load libraries

library(dplyr)
library(httr)
library(jsonlite)

# Source api key

source("api_key.R")

# Create HTTP request to get genre array ids

base_uri <- "https://api.themoviedb.org/3"
resource <- "/genre/movie/list"
uri_full <- paste0(base_uri, resource)
query_params <- list(api_key = api_key)

# Send HTTP Request

response <- GET(uri_full, query = query_params)
body <- content(response, "text")
genre_list <- fromJSON(body)

# Get genre average budgets

# all_movies <- list()
# 
# for (num in 1:length(genre_list$genres$name)) {
#   resource <- "/discover/movie"
#   uri_full <- paste0(base_uri, resource)
#   query_params <- list(api_key = api_key, with_genres = genre_list$genres$id[num])
#   
#   response <- GET(uri_full, query = query_params)
#   body <- content(response, "text")
#   
#   variable_string <- paste0(genre_list$genres$name[num], "_movies")
#   variable_frame <- assign(variable_string, fromJSON(body))
#   all_movies[[num]] <- variable_frame
# }
# 
# action_movies <- list()
# 
# for (num in 1:length(all_movies[[1]]$results$id)) {
#   resource <- paste0("/movie/", all_movies[[1]]$results$id[num])
#   uri_full <- paste0(base_uri, resource)
#   query_params <- list(api_key = api_key)
#   
#   response <- GET(uri_full, query = query_params)
#   body <- content(response, "text")
#   movie <- fromJSON(body)
#   action_movies[[num]] <- movie
# }

resource <- "/discover/movie"
uri_full <- paste0(base_uri, resource)
query_params <- list(api_key = api_key, with_genres = genre_list$genres$id[1], primary_release_date.gte = as.character(Sys.Date() - 3650))

response <- GET(uri_full, query = query_params)
body <- content(response, "text")

# variable_string <- paste0(genre_list$genres$name[num], "_movies")
# variable_frame <- assign(variable_string, fromJSON(body))
action_movies <- fromJSON(body)
all_action_movies <- action_movies$results
for (num in 2:action_movies$total_pages) {
  query_params <- list(api_key = api_key, with_genres = genre_list$genres$id[1], page = num)
  response <- GET(uri_full, query = query_params)
  body <- content(response, "text")
  one_page <- fromJSON(body)
  all_action_movies <- rbind(all_action_movies, one_page$results)
}

get_details <- list()

for (num in 1:nrow(all_action_movies)) {
    resource <- paste0("/movie/", all_action_movies$id[num])
    uri_full <- paste0(base_uri, resource)
    query_params <- list(api_key = api_key)
  
    response <- GET(uri_full, query = query_params)
    body <- content(response, "text")
    one_page <- fromJSON(body)
    get_details[[num]] <- one_page
}

budget <- c()
#genres <- list()
#homepage <- c()
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

for (num in 1:length(get_details)) {
  budget <- c(budget, get_details[[num]]$budget)
  #genres <- c(genres, get_details[[num]]$genres)
  #homepage <- c(homepage, get_details[[num]]$homepage)
  original_title <- c(original_title, get_details[[num]]$original_title)
  overview <- c(overview, get_details[[num]]$overview)
  popularity <- c(popularity, get_details[[num]]$popularity)
  production_companies <- c(production_companies, get_details[[num]]$production_companies)
  # production_countries <- c(production_countries, get_details[[num]]$production_countries)
  status <- c(status, get_details[[num]]$status)
  release_date <- c(release_date, get_details[[num]]$release_date)
  revenue <- c(revenue, get_details[[num]]$revenue)
  runtime <- c(runtime, get_details[[num]]$runtime)
  title <- c(title, get_details[[num]]$title)
}

get_details_2 <- data.frame(budget, revenue, title, overview, popularity, release_date, status)

