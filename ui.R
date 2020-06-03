library(shiny)
library(shinydashboard)
library(data.table)


ui <- dashboardPage(
  dashboardHeader(), 
  dashboardSidebar(),
  dashboardBody(
    uiOutput('movie_filter'),
    plotOutput('word_plot'),
    dataTableOutput('my_data'),
  )
)


