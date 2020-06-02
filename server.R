library(shiny)
library(tidytext)
library(dplyr)
library(data.table)
library(plotly)
library(shinydashboard)
library(dplyr)
library(tidyverse)
library(plotly)
library(data.table)

source("global.R")

## scatterplot -----------------------------------------------------------------------------------------------
line_count_df <- fread("df.csv") %>% 
  filter(speaker != "NO SPEAKER") %>% 
  group_by(title, speaker) %>% 
  summarise(line_count = n()) %>% 
  arrange(-line_count) %>% 
  mutate(grouped_ranking = row_number()) %>% 
  ungroup %>% 
  mutate(overall_ranking = row_number())

## count words
word_count_df <- fread("df.csv") %>% 
  filter(speaker != "NO SPEAKER") %>%
  group_by(title, speaker) %>% 
  unnest_tokens(word, script) %>%
  anti_join(stop_words) %>% 
  summarise(word_count = n()) %>% 
  ungroup() %>% 
  arrange(-word_count)

movie_stats <- merge(line_count_df, word_count_df, by = c("title", "speaker")) %>% 
  ggplot(aes(word_count, line_count, text = speaker,  color = title, size = word_count)) +
  geom_point() +
  theme_bw() +
  labs(title = "Word count per line count", x = "Word count", y = "Line count") +
  theme(legend.title = element_blank(),
        legend.position = "bottom")

plotly_plot <- ggplotly(movie_stats, tooltip = "speaker")
## end of scatterplot ---------------------------------------------------------------------------------------



## server ---------------------------------------------------------------------------------------------------
server <- function(input, output) {
  
  df <- get_df()
  
  output$movie_title <- renderUI({
    selectInput('title', label = 'Select a movie', choices = df$title,
                multiple = FALSE)
  })
  
  reactive_df <- reactive({
    if (is.null(input$title)){
      return(df)
    } else {
    df<- get_selected_data(input$title)
    return(df)}
  })
  
  output$my_data <- DT::renderDataTable({
    reactive_df()
  })
  
  output$word_plot <- renderPlot(
    plot_popular_words(reactive_df())
  )
  output$plotly_plot <- renderPlotly(plotly_plot)
 
}





