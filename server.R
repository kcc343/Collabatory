# Load libraries

# Load libraries

library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

source("scripts/act_functions.R")

server <- function(input, output) {
  # First bar plot
  output$bar <- renderPlotly({
    
  })
}
# Put server into shiny app
shinyServer(server)