# Load libraries

library(shiny)
library(plotly)

# Get filter data of midwest from analysis file

# Get column names except state column name

# Create ui

ui <- navbarPage(
  "Navigation Bar",
  # First Tab
  tabPanel(
    title = "Home",
    titlePanel("Title")
  ),
  # Second Tab
  tabPanel(
    title = "Genres"
  ),
  # Third Tab
  tabPanel(
    title = "Actors/Actresses"
  ),
  # Fourth Tab
  tabPanel(
    title = "Companies"
  )
)

shinyUI(ui)
