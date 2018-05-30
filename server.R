# Load libraries

# Load libraries

library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

source("scripts/home_page.R")
source("scripts/genre_functions.R")
source("scripts/act_functions.R")
source("scripts/com_functions.R")


server <- function(input, output) {
  # Home Page Text Output
  output$about_us <- renderText({
    paste(home_page[1])
  })
  output$our_mission <- renderText({
    paste(home_page[2])
  })
  output$goals <- renderText({
    paste(home_page[3])
  })
  
  
  # First Tab - Genre Output Plot
  output$pop <- renderPlotly({
    return(genre_pop(input$genre, input$type1))
  })
  output$runtime <- renderPlotly({
    return(genre_runtime(input$genre, input$type1))
  })
  output$vote <- renderPlotly({
    return(genre_vote(input$genre, input$type1))
  })
  output$mean <- renderPlotly({
    return(genre_mean(input$type1))
  })
  
  #Second Tab - Actor/Actresses Output Plot
  output$act <- renderPlotly({
   return(act_analysis(input$actors, input$type2))
  })
 
 #Third Tab - Companies Output Plot
 output$trend <- renderPlotly({
   return(com_trend(input$com))
 })
 output$com_mean <- renderPlotly({
   return(com_mean(input$type3))
 })
 
}

# Put server into shiny app
shinyServer(server)