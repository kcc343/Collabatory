# Load libraries

# Load libraries

library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

source("scripts/act_functions.R")
source("scripts/home_page.R")

server <- function(input, output) {
  # Home Page Text Output
  output$selected <- renderText({
    if (input$choice == 1) {
      paste(home_page[1])
    } else if (input$choice == 2) {
      paste(home_page[2])
    } else {
      paste(home_page[3])
    }
  })
}
# Put server into shiny app
shinyServer(server)