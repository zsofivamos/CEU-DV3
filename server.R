library(shiny)
library(shinydashboard)
library(data.table)

server <- function(input, output) {
  output$movie_filter <- renderUI({
    selectInput('title', label = 'Choose a movie', choices = titles$title, multiple = FALSE)
  })
  
  
  reactive_df <- reactive({
    df<- select_title(input$title)
    return(df)
  })
  
  imdb_score <- reactive({
   get_imdb_score(input$title) 
  })
    
  output$imdb_score <- renderInfoBox({
    infoBox("IMDB Score", imdb_score(), icon = icon("edit"))
  })
  
  movie_year <- reactive({
    get_year(input$title) 
  })
  
  output$movie_year <- renderInfoBox({
    infoBox("Year", movie_year(), icon = icon("calendar"))
  })
  
  output$my_data <- DT::renderDataTable({
    reactive_df() %>% select( -title)
  })
  
  output$word_plot <- renderPlot(
    plot_popular_words(reactive_df())
  )
  
}
