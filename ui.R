library(shiny)
library(shinydashboard)
library(data.table)
library(shinythemes)

source("global.R")

ui <- dashboardPage(skin = "green",
  dashboardHeader(title = "Movie Scripts"), 
  dashboardSidebar(
    sidebarMenu(
      menuItem("Movies", tabName = "movies", icon = icon("film")),
      menuItem("Characters", tabName = "characters", icon = icon("users")),
      menuItem("Other", tabName = "other", icon = icon("edit") )
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
          box(plotOutput('word_plot')),
          box(dataTableOutput('my_data'))
        )
      ),
      tabItem(tabName = "characters",
              fluidRow(
                plotlyOutput("plotly_plot")
              )),
      tabItem(tabName = "other")
    )
  )
)


