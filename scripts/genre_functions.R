# load library

library(dplyr)
library(plotly)

# takes in genre name and type of budget or reveneu
genre_pop <- function(genre_name, type) {
  data <- read.csv(
    paste0("../files/", genre_name, "_df.csv"),
    stringsAsFactors = FALSE
  )
  # do some basic filtering
  data <- data %>%
    filter(budget != 0 & revenue != 0) %>%
    filter(popularity >= 10)

  # Get x and y max
  xmax <- max(data[, "popularity"]) * 1.05
  ymax <- max(data[, type]) * 1.05

  # Plot data
  p <- plot_ly(
    x = data[, "popularity"],
    y = data[, type],
    type = "scatter",
    mode = "markers",
    marker = list(
      opacity = .4,
      size = 4,
      color = "red"
    ),
    hoverinfo = "text",
    text = paste0(
      "Title: ", data[, "title"], "<br />",
      type, ": ", data[, type], "<br />",
      "popularity: ", data[, "popularity"]
    )
  ) %>%
    layout(
      title = paste("popularity v.s.", type),
      xaxis = list(
        range = c(0, xmax),
        title = "popularity"
      ),
      yaxis = list(
        range = c(0, ymax),
        title = paste(type, "of", genre_name, "movies")
      )
    )
  p
}

# takes in the genre name and b/r
genre_runtime <- function(genre_name, type) {
  data <- read.csv(
    paste0("../files/", genre_name, "_df.csv"),
    stringsAsFactors = FALSE
  )
  # do some basic filtering
  data <- data %>%
    filter(budget != 0 & revenue != 0) %>%
    filter(popularity >= 10)

  # Get x and y max
  xmax <- max(data[, "runtime"]) * 1.05
  ymax <- max(data[, type]) * 1.05

  # Plot data
  p <- plot_ly(
    x = data[, "runtime"],
    y = data[, type],
    type = "scatter",
    mode = "markers",
    marker = list(
      opacity = .4,
      size = 4,
      color = "hotpink"
    ),
    hoverinfo = "text",
    text = paste0(
      "title: ", data[, "title"], "<br />",
      type, ": ", data[, type], "<br />",
      "runtime: ", data[, "runtime"], "min"
    )
  ) %>%
    layout(
      title = paste("runtime v.s.", type),
      xaxis = list(
        range = c(0, xmax),
        title = "runtime"
      ),
      yaxis = list(
        range = c(0, ymax),
        title = paste(type, "of", genre_name, "movies")
      )
    )
  p
}

# takes in the genre name and b/r
genre_vote <- function(genre_name, type) {
  data <- read.csv(
    paste0("../files/", genre_name, "_df.csv"),
    stringsAsFactors = FALSE
  )
  # do some basic filtering
  data <- data %>%
    filter(budget != 0 & revenue != 0) %>%
    filter(popularity >= 10)

  # Get x and y max
  xmax <- max(data[, "vote_count"]) * 1.05
  ymax <- max(data[, type]) * 1.05

  # Plot data
  p <- plot_ly(
    x = data[, "vote_count"],
    y = data[, type],
    type = "scatter",
    mode = "markers",
    marker = list(
      opacity = .4,
      size = 4,
      color = "blue"
    ),
    hoverinfo = "text",
    text = paste0(
      "title: ", data[, "title"], "<br />",
      type, ": ", data[, type], "<br />",
      "number of votes: ", data[, "vote_count"]
    )
  ) %>%
    layout(
      title = paste("number of votes v.s.", type),
      xaxis = list(
        range = c(0, xmax),
        title = "number of votes"
      ),
      yaxis = list(
        range = c(0, ymax),
        title = paste(type, "of", genre_name, "movies")
      )
    )
  p
}

# takes in type of budget or reveneu
genre_mean <- function(type) {
  mean <- c()

  # list selected genres
  genre <- c(
    "Action", "Adventure", "Animation", "Comedy", "Crime", "Drama",
    "Family", "Fantasy", "Horror", "Mystery", "Romance",
    "Science Fiction", "Thriller"
  )

  # read in the file and basic filtering
  for (i in 1:length(genre)) {
    data <- read.csv(
      paste0("../files/", genre[i], "_df.csv"),
      stringsAsFactors = FALSE
    )
    data <- data %>%
      filter(budget != 0 & revenue != 0) %>%
      filter(popularity >= 10)
    mean[i] <- mean(data[, type])
  }

  # make a data frame of mean info
  mean_df <- data.frame(genre, mean)

  # plot the mean barplot
  p <- plot_ly(mean_df,
    x = ~ genre,
    y = ~ mean,
    type = "bar"
  ) %>%
    layout(
      title = paste("Each genre's overall average", type)
    )
  p
}
