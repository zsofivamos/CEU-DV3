library(shiny)
library(shinydashboard)
library(data.table)

source("global.R")

server <- function(input, output) {
  
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
    validate(
      need(!is.na(input$title), "Fetching data, one sec!")
    )
    infoBox("IMDB Score", imdb_score(), icon = icon("star"), color = "purple", fill = TRUE)
  })
  
  ## get year based on selection
  movie_year <- reactive({
    get_year(input$title) 
  })
  
  ## display year
  output$movie_year <- renderInfoBox({
    validate(
      need(!is.na(input$title), "Fetching data, one sec!")
    )
    infoBox("Year", movie_year(), icon = icon("calendar"), color = "purple", fill = TRUE)
  })
  
  ## display the dataframe
  output$my_data <- DT::renderDataTable({
    
    validate(
      need(!is.na(input$title), "Fetching data, one sec!")
    )
    
    reactive_df() %>% select( -title)
  })
  
  ## top 15 words plot
  output$word_plot <- renderPlot({
    
    validate(
      need(!is.na(input$title), "Fetching data, one sec!")
    )
    
    plot_popular_words(reactive_df())
  })
  
  ## create slider to filter word count
  output$word_count <- renderUI({
    sliderInput('slider', label = "Select word count", min = 1, max = max(movie_stats$word_count), value = c(min, max))
  })
  
  ## filter df based on slider input's values
  character_df <- reactive({
    df <- filter_word_count(input$slider[1], input$slider[2])
    return(df)
  })
  
  output$plotly_plot <- renderPlotly({
    
    validate(
      need(!is.na(input$slider), "Fetching data, one sec!")
    )
    
    create_plotly(character_df())
  })
  
  output$gender_plot <- renderPlot({
    
    validate(
      need(!is.na(input$slider), "Fetching data, one sec!")
    )
    
    plot_gender_count(character_df())
  })
  
  percentage_reactive <- reactive({
    get_percentage(character_df())
  })
  
  output$percentage <- renderValueBox({

    validate(
      need(!is.na(input$slider), "Fetching data, one sec!")
    )
    valueBox(percentage_reactive(), "of characters captured", color = "purple")
  })
  
  output$search_box <- renderUI({
    textInput('search', label = "Search for a word", value = "word", placeholder = "word")
  })
  
  output$search_plot <- renderPlot({
    
    validate(
      need(
        !is.na(input$search), "No word detected by the word detectives :("
      )
    )
    
        count_per_movie(input$search)
  })
  
  output$used_by_plot <- renderPlot({
    
    validate(
      need(
        !is.na(input$search), "No word detected by the word detectives :("
      ))
    
 said_by_character(input$search)

  })
  
  
  
}
