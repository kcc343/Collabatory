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

# Get genre budgets and revenue

for (i in 1:length(genre_list$genres$id)) {
  resource <- "/discover/movie"
  uri_full <- paste0(base_uri, resource)
  query_params <- list(
    api_key = api_key, 
    sort_by = "release_date.desc", 
    with_genres = genre_list$genres$id[i], 
    primary_release_date.gte = as.character(Sys.Date() - 7300),
    with_release_type = 1
  )
  
  response <- GET(uri_full, query = query_params)
  body <- content(response, "text")
  
  movie_string <- paste0(genre_list$genres$name[i], "_movies")
  movie_frame <- assign(movie_string, fromJSON(body))
  
  all_string <- paste0("all_", genre_list$genres$name[i], "_movies")
  all_movie_frame <- assign(all_string, movie_frame$results)
  
  count <- 0
  for (num in 2:movie_frame$total_pages) {
    response <- GET(uri_full, query = c(query_params, page = num))
    body <- content(response, "text")
    one_page <- fromJSON(body)
    all_movie_frame <- rbind(all_movie_frame, one_page$results)
    count <- count + 1
    if (count == 24) {
      Sys.sleep(10)
      count <- 0
    }
  }
  
  get_details <- list()
  count <- 0
  for (num in 1:nrow(all_movie_frame)) {
    resource <- paste0("/movie/", all_movie_frame$id[num])
    uri_full <- paste0(base_uri, resource)
    query_params <- list(api_key = api_key)
    
    response <- GET(uri_full, query = query_params)
    body <- content(response, "text")
    one_page <- fromJSON(body)
    get_details[[num]] <- one_page
    count <- count + 1
    if (count == 35) {
      Sys.sleep(10)
      count <- 0
    }
  }
  
  budget <- list()
  status <- list()
  overview <- list()
  popularity <- list()
  vote_count <- list()
  production_companies <- list()
  production_countries <- list()
  release_date <- list()
  revenue <- list()
  runtime <- list()
  title <- list()
  
  for (num in 1:length(get_details)) {
    budget[num] <- get_details[[num]]$budget
    overview[num] <- get_details[[num]]$overview
    popularity[num] <- get_details[[num]]$popularity
    vote_count[num] <- get_details[[num]]$vote_count
    string <- ""
    for (company in 1:length(get_details[[num]]$production_companies$name)) {
       string <- paste0(string, get_details[[num]]$production_companies$name[company], ", ")
    }
    production_companies[num] <- string
    string <- ""
    for (country in 1:length(get_details[[num]]$production_countries$name)) {
      string <- paste0(string, get_details[[num]]$production_countries$name[country], ", ")
    }
    production_countries[num] <- string
    status[num] <- get_details[[num]]$status
    release_date[num] <- get_details[[num]]$release_date
    revenue[num] <- get_details[[num]]$revenue
    runtime[num] <- get_details[[num]]$runtime
    title[num] <- get_details[[num]]$title
  }
  
  # Convert empty values into NA
  budget[sapply(budget, is.null)] <- NA
  overview[sapply(overview, is.null)] <- NA
  popularity[sapply(popularity, is.null)] <- NA
  vote_count[sapply(vote_count, is.null)] <- NA
  production_companies[sapply(production_companies, is.null)] <- NA
  production_countries[sapply(production_countries, is.null)] <- NA
  status[sapply(status, is.null)] <- NA
  release_date[sapply(release_date, is.null)] <- NA
  revenue[sapply(revenue, is.null)] <- NA
  runtime[sapply(runtime, is.null)] <- NA
  title[sapply(title, is.null)] <- NA
  
  # For some reason runtime list has rows off by one compared to the other lists
  # in Drama and Western genres.
  # The runtime list does not get the last value if it has a null so I had to do:
  # runtime[length(get_details]) < - NA manually 
  # Also had to change the max of the for loop from 1:length(genre_list$genres$id) to 
  # 8:length(genre_list$genres$id) after drama genre error. This was in order
  # to get all of the data.
  
  df_string <- paste0(genre_list$genres$name[i], "_df")
  df <- assign(
    df_string, 
    data.frame(
      budget = unlist(budget), 
      revenue = unlist(revenue),
      title = unlist(title), 
      overview = unlist(overview), 
      popularity = unlist(popularity), 
      vote_count = unlist(vote_count),
      release_date = unlist(release_date),
      status = unlist(status),
      runtime = unlist(runtime),
      production_companies = unlist(production_companies),
      production_countries = unlist(production_countries),
      stringsAsFactors = F
    )
  )
  
  write.csv(df, file = paste0("../files/", genre_list$genres$name[i], "_df.csv"))
  Sys.sleep(10)
}

