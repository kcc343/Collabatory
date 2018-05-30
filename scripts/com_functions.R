# load library

library(dplyr)
library(plotly)

# takes in the name of company and revenue/budget to explore
com_trend <- function(name, type) {
  # read in the company's data
  data <- read.csv(
    paste0("./files/", name, "_df.csv"),
    stringsAsFactors = FALSE
  )
  # basic filtering
  data <- data %>%
    filter(budget != 0 & revenue != 0)

  # add release year column
  mean_yr <- data %>%
    mutate(release_year = substring(data[, "release_date"], 1, 4)) %>%
    group_by(release_year) %>%
    summarise(
      # find the average budget and revenue each yr
      mean_budget = mean(budget),
      mean_revenue = mean(revenue)
    )

  p <- plot_ly(mean_yr,
    x = ~ release_year,
    y = ~ mean_revenue,
    type = "scatter",
    mode = "lines"
  ) %>%
    layout(
      title = paste0(name, "\'s movie ", type, " trend"),
      xaxis = list(
        title = "year released"
      ),
      yaxis = list(
        title = paste("mean", type)
      )
    )
  p
}

# takes in the option of revenue/budget
com_mean <- function(type) {
  companies_list <- c(
    "Walt Disney Animation Studios",
    "Sony Pictures",
    "Universal Pictures",
    "Paramount",
    "Warner Bros. Pictures",
    "20th Century Fox"
  )
  mean <- list()
  for (i in 1:length(companies_list)) {
    data <- read.csv(
      paste0("./files/", companies_list[i], "_df.csv"),
      stringsAsFactors = FALSE
    )
    # filtering the data
    data <- data %>%
      filter(budget != 0 & revenue != 0)
    # record the mean
    mean[i] <- mean(data[, type])
  }
  p <- plot_ly(
    x = companies_list,
    y = mean,
    type = "bar"
  ) %>%
    layout(
      title = paste("6 companies' overall average", type)
    )
  p
}
