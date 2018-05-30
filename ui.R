# Load libraries

library(shiny)
library(plotly)

# Get filter data of midwest from analysis file

# Get column names except state column name

# Create ui

ui <- fluidPage(
    #includeCSS("style.css"),
     navbarPage("Catagories", id = "tabbar",
    # First Tab
    tabPanel(id = 'tab',
      title = "Home",
      titlePanel("Home"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "choice",
            label = "Home Page",
            choices = list(
              "About Us" = 1,
              "Our Mission" = 2,
              "Goals" = 3
            )
          )
        ),
        mainPanel(
          textOutput("selected")
        )
      )
    ),
    # Second Tab
    tabPanel(id = 'tab',
      title = "Genres",
      titlePanel("Filter By Movie Generes")
    ),
    # Third Tab
    tabPanel(id = 'tab',
      title = "Actors/Actresses",
      titlePanel("Filter by Actors/Actresses Names")
      
    ),
    # Fourth Tab
    tabPanel(id = 'tab',
      title = "Companies",
      titlePanel("Filter By Company Names")
    )
  )
)

shinyUI(ui)
