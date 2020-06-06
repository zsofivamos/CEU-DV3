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
  
  
  ## create interactive plotly
  output$plotly_plot <- renderPlotly({
    
    # add buffer message while data is loading
    validate(
      need(!is.na(input$slider), "Fetching data, one sec!")
    )
    
    create_plotly(character_df())
  })
  
  ## create gender distribution chart
  output$gender_plot <- renderPlot({
    
    # add buffer message while data is loading
    validate(
      need(!is.na(input$slider), "Fetching data, one sec!")
    )
    
    plot_gender_count(character_df())
  })
  
  ## calculate percentage of characters covered
  percentage_reactive <- reactive({
    get_percentage(character_df())
  })
  
  ## display dynamic change in value box
  output$percentage <- renderValueBox({

    # add buffer message while data is loading
    validate(
      need(!is.na(input$slider), "Fetching data, one sec!")
    )
    valueBox(percentage_reactive(), "of characters captured", color = "purple")
  })
  
  ## add search box
  output$search_box <- renderUI({
    textInput('search', label = "Search for a word", value = "word", placeholder = "word")
  })
  
  ## filter for movies the term appeared in
  reactive_search_df <- reactive({
    df <- filter_for_movie(input$search)
    return(df)
  })
  
  ## visualize them
  output$search_plot <- renderPlot({
    
    # if no input is provided return error message
    validate(
      need(
        !is.na(input$search), "No word detected by the word detectives :("
      )
    )
    
    # if the word isn't found return error message
      validate(need(
        try(nrow(reactive_search_df())>0), "Try again with something else"
      ))
    
    count_per_movie(reactive_search_df())
  })
  
  ## filter for characters that used the searched word
  reactive_char_df <- reactive({
    df <- filter_for_character(input$search)
    return(df)
  })
  
  output$used_by_plot <- renderPlot({
    
    # if no input is provided return error message
    validate(
      need(
        !is.na(input$search), "No word detected by the word detectives :("
      ))
    
    # if the word isn't found return error message
    validate(need(
      try(nrow(reactive_char_df())>0), "Nobody uses words like that"
    ))
 
 said_by_character(reactive_char_df())

  })
  
}
