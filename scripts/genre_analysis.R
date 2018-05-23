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
  
  budget <- c()
  status <- c()
  overview <- c()
  popularity <- c()
  vote_count <- c()
  # production_companies <- c()
  # production_countries <- c()
  release_date <- c()
  revenue <- c()
  # runtime <- list()
  title <- c()
  
  for (num in 1:length(get_details)) {
    budget <- c(budget, get_details[[num]]$budget)
    overview <- c(overview, get_details[[num]]$overview)
    popularity <- c(popularity, get_details[[num]]$popularity)
    vote_count <- c(vote_count, get_details[[num]]$vote_count)
    # string <- ""
    # for (company in 1:length(get_details[[num]]$production_companies$name)) {
    #   string <- paste0(string, get_details[[num]]$production_companies$name[company], ", ")
    # }
    # production_companies[num] <- string
    # string <- ""
    # for (country in 1:length(get_details[[num]]$production_countries$name)) {
    #   string <- paste0(string, get_details[[num]]$production_countries$name[country], ", ")
    # }
    # production_countries[num] <- string
    status <- c(status, get_details[[num]]$status)
    release_date <- c(release_date, get_details[[num]]$release_date)
    revenue <- c(revenue, get_details[[num]]$revenue)
    # runtime[num] <- get_details[[num]]$runtime
    title <- c(title, get_details[[num]]$title)
  }
  
  df_string <- paste0(genre_list$genres$name[i], "_df")
  movie_df <- assign(
    df_string, 
    data.frame(
      budget, 
      revenue,
      title, 
      overview, 
      popularity,
      vote_count,
      #production_companies,
      #production_countries,
      release_date,
      status,
      #runtime,
      stringsAsFactors = F
    )
)
  
  write.csv(movie_df, file = paste0("../files/", genre_list$genres$name[i], "_df.csv"))
  Sys.sleep(10)
}

