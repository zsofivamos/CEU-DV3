library(shiny)

source("global.R")

df <- get_df()

ui <- dashboardPage(

  dashboardHeader(title = 'Movie Script Dashboard'),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Movies", tabName = "movies"),
      menuItem("Characters", tabName = "characters"),
      menuItem("Last Tab", tabName = "last_tab")
    )
  ),
  # dashboardBody(uiOutput('movie_title'),
  #               # plotlyOutput('plotly_plot'),
  #               plotOutput('word_plot'),
  #               dataTableOutput('my_data'),
  #               )
  
  dashboardBody(
    
    tabItems(
      tabItem(tabName = "movies",
              fluidRow(
                box(uiOutput('movie_title')),
              ),
              fluidRow(
                box(plotOutput('word_plot'), height = 12),
                box(dataTableOutput('my_data'), height = 12))),
      tabItem(tabName = "characters",
              plotlyOutput('plotly_plot')),
      tabItem(tabName = "last_tab")
     
    )
  )
  )



