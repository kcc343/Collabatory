# Load libraries

library(dplyr)
library(httr)
library(jsonlite)

# Source api key

source("api_key.R")

# Create vector of popular companies

companies_list <- c(
  "Walt Disney Animation Studios",
  "Sony Pictures",
  "Universal Pictures",
  "Paramount",
  "Warner Bros. Pictures",
  "20th Century Fox"
)
# Get movie companies IDs

base_uri <- "https://api.themoviedb.org/3"
ids <- c()
for (i in 1:length(companies_list)) {
  resource <- "/search/company"
  uri_full <- paste0(base_uri, resource)
  query_params <- list(api_key = api_key, query = companies_list[i])
  
  # Send HTTP request
  
  response <- GET(uri_full, query = query_params)
  body <- content(response, "text")
  company_info <- fromJSON(body)
  company_id <- company_info$results$id[1]
  ids[i] <- company_id
}

ids[length(companies_list)] <- 25

for (id in 1:length(ids)) {
  get_details <- list()
  
  resource <- "/discover/movie"
  uri_full <- paste0(base_uri, resource)
  query_params <- list(
    api_key = api_key,
    with_companies = ids[id]
  )
  
  response <- GET(uri_full, query = query_params)
  body <- content(response, "text")
  movie_data <- fromJSON(body)
  
  df_string <- paste0(companies_list[id], "_movies")
  df <- assign(df_string, movie_data$results)
  
  count <- 0
  for (num in 2:movie_data$total_pages) {
    response <- GET(uri_full, query = c(query_params, page = num))
    body <- content(response, "text")
    one_page <- fromJSON(body)
    df <- rbind(df, one_page$results)
    count <- count + 1
    if (count == 24) {
      Sys.sleep(10)
      count <- 0
    }
  }
  
  count <- 0
  for (num in 1:nrow(df)) {
    resource <- paste0("/movie/", df$id[num])
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
  vote_count <- list()
  popularity <- list()
  release_date <- list()
  revenue <- list()
  title <- list()
  
  for (num in 1:length(get_details)) {
    budget[num] <- get_details[[num]]$budget
    title[num] <- get_details[[num]]$title
    overview[num] <- get_details[[num]]$overview
    vote_count[num] <- get_details[[num]]$vote_count
    popularity[num] <- get_details[[num]]$popularity
    status[num] <- get_details[[num]]$status
    release_date[num] <- get_details[[num]]$release_date
    revenue[num] <- get_details[[num]]$revenue
  }
  
  # Convert empty values into NA
  budget[sapply(budget, is.null)] <- NA
  overview[sapply(overview, is.null)] <- NA
  popularity[sapply(popularity, is.null)] <- NA
  vote_count[sapply(vote_count, is.null)] <- NA
  status[sapply(status, is.null)] <- NA
  release_date[sapply(release_date, is.null)] <- NA
  revenue[sapply(revenue, is.null)] <- NA
  title[sapply(title, is.null)] <- NA
  
  assign_string <- paste0(companies_list[i], "_df")
  df <- assign(
    assign_string,
    data.frame(
      budget = unlist(budget), 
      revenue = unlist(revenue), 
      title = unlist(title), 
      overview = unlist(overview), 
      popularity = unlist(popularity),
      vote_count = unlist(vote_count),
      release_date = unlist(release_date), 
      status = unlist(status),
      stringsAsFactors = F
    )
  )
  
  write.csv(df, file = paste0("../files/", companies_list[id], "_df.csv"))
  Sys.sleep(10)
}

# Get movies with company
