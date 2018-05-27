# Load libraries

library(dplyr)
library(httr)
library(jsonlite)

# Source api key

source("api_key.R")

# Create vector of actors and actresses

act_list <- c("Keira Knightley", 
              "Benedict Cumberbatch", 
              "Leonardo Dicaprio",
              "Robert Downey Jr",
              "Matt Damon",
              "Will Smith",
              "Gal Gadot",
              "Angelina Jolie",
              "Emma Watson",
              "Natalie Portman"
              )


base_uri <- "https://api.themoviedb.org/3"
ids <- c()

for (i in 1:length(act_list)) {
  # Create HTTP request to get actor/actress id
  
  resource <- "/search/person"
  uri_full <- paste0(base_uri, resource)
  query_params <- list(api_key = api_key, query = act_list[i])
  
  # Send HTTP request to get the id
  
  response <- GET(uri_full, query = query_params)
  body <- content(response, "text")
  act_data <- fromJSON(body)
  act_id <- act_data$results$id[1]
  ids[i] <- act_id 
  
  # Get all movies for specific actor/actress
  
  resource <- "/discover/movie"
  uri_full <- paste0(base_uri, resource)
  query_params <- list(api_key = api_key, with_people = paste(act_id))
  
  response <- GET(uri_full, query = query_params)
  body <- content(response, "text")
  act_movie_list <- fromJSON(body)
  
  # Get budget and revenue
  
  movie_data <- list()
  
  query_params <- list(api_key = api_key)
  
  count <- 0
  
  for (num in 1:length(act_movie_list$results$id)) {
    resource <- paste0("/movie/", act_movie_list$results$id[num])
    uri_full <- paste0(base_uri, resource)
    response <- GET(uri_full, query = query_params)
    body <- content(response, "text")
    one_movie <- fromJSON(body)
    movie_data[[num]] <- one_movie
    count <= count + 1
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
  
  for (num in 1:length(movie_data)) {
    budget[num] <- movie_data[[num]]$budget
    title[num] <- movie_data[[num]]$title
    overview[num] <- movie_data[[num]]$overview
    vote_count[num] <- movie_data[[num]]$vote_count
    popularity[num] <- movie_data[[num]]$popularity
    status[num] <- movie_data[[num]]$status
    release_date[num] <- movie_data[[num]]$release_date
    revenue[num] <- movie_data[[num]]$revenue
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
  
  assign_string <- paste0(act_list[i], "_df")
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
  
  write.csv(df, file = paste0("../files/", act_list[i], "_df.csv"))
  Sys.sleep(10)
}

# Use actors/actresses ids to get day of birth (convert date of birth to age)

age <- list()
bio <- list()

for (num in 1:length(act_list)) {
  # Create HTTP request for person
  
  resource <- paste0("/person/", ids[num])
  uri_full <- paste0(base_uri, resource)
  query_params <- list(api_key = api_key)
  
  # Send HTTP request for age
  
  response <- GET(uri_full, query = query_params)
  body <- content(response, "text")
  act_info <- fromJSON(body)
  age[num] <- floor((Sys.Date() - as.Date(act_info$birthday)) / 365)
  bio[num] <- act_info$biography
}


act_df <- data.frame(
  name = act_list, 
  age = unlist(age), 
  bio = unlist(bio), 
  stringsAsFactors = F
)

write.csv(act_df, file = "../files/actor_info.csv")

