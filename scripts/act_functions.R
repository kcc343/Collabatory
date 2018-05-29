library(tools)
library(dplyr)
library(plotly)
library(ggplot2)

act_analysis <- function(name, type) {
  data <- read.csv(
    paste0("./files/", tolower(name), "_df.csv"),
    stringsAsFactors = FALSE
  )

  data <- data %>%
    filter(budget != 0 & revenue != 0)

  p <- ggplot(data, aes(x = factor(1), y = data[, type], text = paste0(type , ": ", data[, type]))) +
    geom_boxplot() + 
    geom_jitter(size = 2, position = position_jitter(0.2)) +
    ggtitle(paste0(toTitleCase(name), "'s movie ", type, " boxplot")) +
    theme(
      axis.text.x = element_blank()
    )
  
  ggplotly(p, tooltip = c("text"))
  
  # p <- plot_ly(data,
  #   y = data[, type],
  #   name = toTitleCase(name),
  #   type = "box",
  #   boxpoints = "all",
  #   hoverinfo = "text",
  #   text = paste0(
  #      "title: ", data[, "title"], "<br />",
  #      type, ": ", data[, type]
  #   )
  # ) %>%
  #   layout(
  #     title = paste0(toTitleCase(name), "'s movie ", type, " boxplot")
  #   )
  # p
}

act_analysis("Matt Damon", "revenue")
