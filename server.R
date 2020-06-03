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
  
  output$my_data <- DT::renderDataTable({
    reactive_df() %>% select( -title)
  })
  
  output$word_plot <- renderPlot(
    plot_popular_words(reactive_df())
  )
  
}
