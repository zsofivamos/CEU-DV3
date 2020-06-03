library(shiny)
library(shinydashboard)
library(data.table)

source("global.R")

ui <- dashboardPage(
  dashboardHeader(title = "Movie Scripts"), 
  dashboardSidebar(
    sidebarMenu(
      menuItem("Movies", tabName = "movies"),
      menuItem("Characters", tabName = "characters"),
      menuItem("Other", tabName = "other")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "movies",
        fluidRow(
          box(width = 12, uiOutput('movie_filter'))
        ),
        fluidRow(
          box(infoBoxOutput('imdb_score')),
          box(infoBoxOutput('movie_year'))
        ),
        fluidRow(
          box(plotOutput('word_plot'), height = 100),
          box(dataTableOutput('my_data'), height = 100)
        )
      ),
      tabItem(tabName = "characters"),
      tabItem(tabName = "other")
    )
  )
)


