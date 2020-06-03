library(shiny)
library(shinydashboard)
library(data.table)


ui <- dashboardPage(
  dashboardHeader(), 
  dashboardSidebar(),
  dashboardBody(
    uiOutput('movie_filter'),
    infoBoxOutput('imdb_score'),
    infoBoxOutput('movie_year'),
    plotOutput('word_plot'),
    dataTableOutput('my_data'),
  )
)


