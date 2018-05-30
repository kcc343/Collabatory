# Load libraries

library(shiny)
library(plotly)

source("scripts/genre_list.R")
source("scripts/actor_list.R")
source("scripts/com_list.R")
# Get filter data of midwest from analysis file

# Get column names except state column name

# Create ui

ui <- fluidPage(theme = 'bootstrap.css', id = 'bg-primary',
    navbarPage("Hollywood B&R", id = 'navbar',
    # First Tab
    navbarMenu("Home",
      tabPanel(
        title = "About Us",
        titlePanel("About Us"),
        mainPanel(
          imageOutput("kelly_image"),
          textOutput("about_us_kelly"),
          imageOutput("anna_image"),
          textOutput("about_us_anna"),
          imageOutput("emily_image"),
          textOutput("about_us_emily")
        )
      ),
      tabPanel(id = 'navbar',
        title = "Our Mission",
        titlePanel("Our Mission"),
        mainPanel(id = 'main',
          textOutput("our_mission")
        )),
      tabPanel(id = 'navbar',
        title = "Goals",
        titlePanel("Our Goals"),
        mainPanel(id = 'main',
          textOutput("goals")
        ))
    ),
    # Second Tab
    tabPanel(id = 'navbar',
      title = "Genres",
      titlePanel("Filter By Movie Generes"),
      sidebarLayout(
        sidebarPanel(id = 'card-body',
          selectInput(
            "genre",
            label = "Select Genre",
            choices = genre_list
          ),
          helpText("Note: This selection does not apply to 'Mean'."),
          radioButtons(
            "type1",
            label = "Type",
            choices = list(
              "Budget" = "budget",
              "Revenue" = "revenue"), 
            selected = "budget")
        ),
        mainPanel(id = 'main',
          tabsetPanel(id = 'nav-tab',
            tabPanel("Popularity", plotlyOutput("pop")), 
            tabPanel("Runtime", plotlyOutput("runtime")), 
            tabPanel("Vote", plotlyOutput("vote")),
            tabPanel("Mean", plotlyOutput("mean"))
          )
        )
      )
    ),
    # Third Tab
    tabPanel(id = 'navbar',
      title = "Actors/Actresses",
      titlePanel("Filter by Actors/Actresses Names"),
      sidebarLayout(
        sidebarPanel(id = 'card-body',
          selectInput(
            "actors",
            label = "Actors/Actresses",
            choices = act_list
          ),
          radioButtons(
            "type2",
            label = "Type",
            choices = list(
              "Budget" = "budget",
              "Revenue" = "revenue"), 
              selected = "budget")
        ),
        mainPanel(id = 'main',
          plotlyOutput("act")
        )
      )
    ),
    # Fourth Tab
    tabPanel(id = 'navbar',
      title = "Companies",
      titlePanel("Filter By Company Names"),
      sidebarLayout(
        sidebarPanel(id = 'card-body',
          selectInput(
            "com",
            label = "Companies",
            choices = com_list
          ),
          helpText("Note: This selection is not applicable to 'Mean'."),
          radioButtons(
            "type3",
            label = "Type",
            choices = list(
              "Budget" = "budget",
              "Revenue" = "revenue"),
            selected = "budget")
        ),
        mainPanel(id = 'main',
            tabsetPanel(
              tabPanel("Trend", plotlyOutput("trend")),
              tabPanel("Mean", plotlyOutput("com_mean"))
            )
        )
      )
    )
  )
)

shinyUI(ui)
