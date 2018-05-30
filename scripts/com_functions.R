# load library

library(dplyr)
library(plotly)

# takes in the name of company and revenue/budget to explore
com_trend <- function(name) {
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
  
  # set the customed margin
  m <- list(
    l = 90,
    r = 50,
    b = 100,
    t = 100,
    pad = 4
  )

  p <- plot_ly(mean_yr,
    x = ~ release_year,
    y = ~ mean_revenue,
    type = "scatter",
    mode = "lines",
    name = "revenue"
  ) %>% 
    add_trace(
    x = ~ release_year,
    y = ~ mean_budget,
    type = "scatter",
    mode = "lines",
    name = "budget"
  ) %>%
    layout(
      autosize = F, width = 500, height = 500, margin = m,
      title = paste0(name, "\'s movie B/R trend"),
      xaxis = list(
        title = "year released"
      ),
      yaxis = list(
        title = "average"
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
  
  m <- list(
    l = 90,
    r = 50,
    b = 100,
    t = 100,
    pad = 4
  )
  
  p <- plot_ly(
    x = companies_list,
    y = mean,
    type = "bar"
  ) %>%
    layout(
      autosize = F, width = 500, height = 500, margin = m,
      title = paste("6 companies' overall average", type)
    )
  p
}
