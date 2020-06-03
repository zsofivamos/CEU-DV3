library(shiny)
library(shinydashboard)
library(data.table)


ui <- dashboardPage(
  dashboardHeader(), 
  dashboardSidebar(
    sidebarMenuOutput('movies'),
    sidebarMenuOutput('characters'),
    sidebarMenuOutput('search')
  ),
  dashboardBody(
    
    fluidRow(
        box(uiOutput('movie_filter')),
        box(infoBoxOutput('imdb_score')),
        box(infoBoxOutput('movie_year'))
    ),
    
    fluidRow(
      box(plotOutput('word_plot'), height = 100),
      box(dataTableOutput('my_data'), height = 100)
    )
  )
)


