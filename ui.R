# Load libraries

library(shiny)
library(plotly)

source("scripts/genre_list.R")
source("scripts/actor_list.R")
source("scripts/com_list.R")
# Get filter data of midwest from analysis file

# Get column names except state column name

# Create ui

ui <- fluidPage(
    #includeCSS("style.css"),
    navbarPage("Catagories", id = "tabbar",
    # First Tab
    navbarMenu("Home",
      tabPanel(id = 'tab',
        title = "About Us",
        titlePanel("About Us"),
        mainPanel(
          textOutput("about_us")
        )
      ),
      tabPanel(id = 'tab',
        title = "Our Mission",
        titlePanel("Our Mission"),
        mainPanel(
          textOutput("our_mission")
        )),
      tabPanel(id = 'tab',
        title = "Goals",
        titlePanel("Our Goals"),
        mainPanel(
          textOutput("goals")
        ))
    ),
    # Second Tab
    tabPanel(id = 'tab',
      title = "Genres",
      titlePanel("Filter By Movie Generes"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "genre",
            label = "Select Genre",
            choices = genre_list
          ),
          radioButtons(
            "type1",
            label = h3("Type"),
            choices = list(
              "Budget" = "budget",
              "Revenue" = "revenue"), 
            selected = "budget")
        ),
        mainPanel(
          tabsetPanel(
            tabPanel("Popularity", plotlyOutput("pop")), 
            tabPanel("Runtime", plotlyOutput("runtime")), 
            tabPanel("Vote", plotlyOutput("vote")),
            tabPanel("Mean", plotlyOutput("mean"))
          )
        )
      )
    ),
    # Third Tab
    tabPanel(id = 'tab',
      title = "Actors/Actresses",
      titlePanel("Filter by Actors/Actresses Names"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "actors",
            label = "Actors/Actresses",
            choices = act_list
          ),
          radioButtons(
            "type2",
            label = h4("Type"),
            choices = list(
              "Budget" = "budget",
              "Revenue" = "revenue"), 
              selected = "budget")
        ),
        mainPanel(
          plotlyOutput("act")
        )
      )
    ),
    # Fourth Tab
    tabPanel(id = 'tab',
      title = "Companies",
      titlePanel("Filter By Company Names"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "com",
            label = "Companies",
            choices = com_list
          ),
          radioButtons(
            "type3",
            label = h4("Type"),
            choices = list(
              "Budget" = "budget",
              "Revenue" = "revenue"), 
            selected = "budget")
        ),
        mainPanel(
          mainPanel(
            tabsetPanel(
              tabPanel("Trend", plotlyOutput("trend")),
              tabPanel("Mean", plotlyOutput("com_mean"))
            )
          )
        )
      )
    )
  )
)

shinyUI(ui)
