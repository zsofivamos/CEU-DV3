library(shiny)
library(shinydashboard)
library(data.table)

source("global.R")

ui <- dashboardPage(skin = "purple",
  dashboardHeader(title = "Movie Scripts Dashboard", titleWidth = 350), 
  dashboardSidebar(width = 350,
    sidebarMenu(
      menuItem("Movies", tabName = "movies", icon = icon("film")),
      menuItem("Characters", tabName = "characters", icon = icon("users")),
      menuItem("Words", tabName = "words", icon = icon("edit"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "movies",
        fluidRow(
          box(uiOutput('movie_filter'), width = 4, height = 150),
          box(infoBoxOutput('imdb_score', width = 12), width = 4, height = 150),
          box(infoBoxOutput('movie_year', width = 12), width = 4, height = 150)
        ),

        fluidRow(
          box(plotOutput('word_plot', height = 550), width = 7),
          box(dataTableOutput('my_data', height = 550), width = 5)
        )
      ),
      tabItem(tabName = "characters",
              fluidRow(
                box(uiOutput('word_count'), width = 6, height = 150),
                box(valueBoxOutput('percentage', width = 12), width = 6, height = 150)
              ),
              fluidRow(
                box(plotlyOutput("plotly_plot", height = 600), width = 9),
                box(plotOutput('gender_plot', height = 600), width = 3)
              )
              ),
      tabItem(tabName = "words",
              fluidRow(
                box(uiOutput('search_box'))
              ),
              fluidRow(
                box(plotOutput('search_plot', height = 600), width = 6),
                box(plotOutput('used_by_plot', height = 600), width = 6)
              )
              
    )
  )
))


