# Load libraries

library(tools)
library(dplyr)
library(plotly)
library(ggplot2)
library(scales)

# Access each of the actor/actress csv files and returns a box plot for specified data
# (budget or revenue)
act_analysis <- function(name, type) {
  
  # Read in csv data of actor/actress
  data <- read.csv(
    paste0("./files/", tolower(name), "_df.csv"),
    stringsAsFactors = FALSE
  )
  
  # filter data so there is no zero budget or revenue
  data <- data %>%
    filter(budget != 0 & revenue != 0)
  
  # Plot data into box plot
  p <- ggplot(data, 
              aes(x = factor(1),
                  y = data[, type], 
                  text = paste0(toTitleCase(type) , ": ", dollar_format()(data[, type]))
                  )
              ) +
    geom_boxplot() + 
    geom_jitter(size = 2, position = position_jitter(0.2)) +
    ggtitle(paste0(toTitleCase(name), "'s Movie ", toTitleCase(type), " Boxplot")) +
    scale_y_continuous(name = toTitleCase(type), labels = dollar) +
    theme(
      axis.text.x = element_blank(),
      axis.title.x = element_blank(),
      axis.text.y = element_text(angle = 35)
    )
  
  ggplotly(p, tooltip = c("text"))
}

act_analysis("Matt Damon", "revenue")
