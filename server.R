library(shiny)
library(shinydashboard)
library(data.table)

server <- function(input, output) {
  
  ## create menu items
  output$movies <- renderMenu({
   sidebarMenu(
     menuItem("Movies")
   ) 
  })
  
  output$characters <- renderMenu({
    sidebarMenu(
      menuItem("Characters")
    ) 
  })
  
  output$search <- renderMenu({
    sidebarMenu(
      menuItem("Word Search")
    ) 
  })
  
  ## create dropdown filter with titles
  output$movie_filter <- renderUI({
    selectInput('title', label = 'Choose a movie', choices = titles$title, multiple = FALSE)
  })
  
  ## get most popular words for df and the word plot as a reactive
  reactive_df <- reactive({
    df<- select_title(input$title)
    return(df)
  })
  
  ## get IMDB score based on the selection of the filter
  imdb_score <- reactive({
   get_imdb_score(input$title) 
  })
  
  ## display score  
  output$imdb_score <- renderInfoBox({
    infoBox("IMDB Score", imdb_score(), icon = icon("edit"))
  })
  
  ## get year based on selection
  movie_year <- reactive({
    get_year(input$title) 
  })
  
  ## display year
  output$movie_year <- renderInfoBox({
    infoBox("Year", movie_year(), icon = icon("calendar"))
  })
  
  ## display the dataframe
  output$my_data <- DT::renderDataTable({
    reactive_df() %>% select( -title)
  })
  
  ## top 15 words plot
  output$word_plot <- renderPlot(
    plot_popular_words(reactive_df())
  )
  
}
