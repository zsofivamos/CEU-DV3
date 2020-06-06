library(dplyr)
library(tidyverse)
library(plotly)
library(data.table)
library(DT)

words_df <-read_csv("word_df.csv") %>% 
  group_by(title) %>% 
  count(word, sort = TRUE) %>% 
  mutate(rank_within_movie = row_number()) %>% 
  ungroup() %>% 
  mutate(overall_rank = row_number())

titles <- data_frame(title = unique(words_df$title))

years <- read_csv("word_df.csv") %>% 
  group_by(year, title) %>% 
  summarise(score = mean(score))

### GET FILTERED DATA ------------------------------------------------------------------------------------------
### this one just pulls in the word data selected by the drop down

## title
select_title <- function(filter_selection){
  return(words_df %>% filter(title == filter_selection))
}

## imdb score
get_imdb_score <- function(filter_selection){
  
score <- years %>% filter(title == filter_selection)

  return(score$score)
}

## year
get_year <- function(filter_selection){
  
  movie_year <- years %>% filter(title == filter_selection)
  
  return(movie_year $year)
}


### FREQUENT WORDS PLOT ------------------------------------------------------------------------------------
### this function grabs the content for the movie filter
### it will show the 15 most popular words per movie

plot_popular_words <- function(df) {

plot <- df %>% 
  top_n(-15) %>%
  arrange(-n) %>% 
  ggplot(aes(reorder(word, n), n)) +
  geom_col() +
  geom_text(aes(label = n), hjust = -0.6) +
  coord_flip() +
  labs(title = paste0("Most frequent words in '", df$title, "'"), x = "", y = "Count") +
  theme_bw() +
  theme(panel.border = element_blank(),
        panel.grid = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_text(size = 12),
        title = element_text(size = 14))

return(plot)
}

### PLOTLY ------------------------------------------------------------------------------------------------
## read in data

movie_stats <- read_csv("movie_stats.csv")


## SLIDER INPUT
## filter character df based on slider input

filter_word_count <- function(min, max) {
  
  df <- movie_stats %>% 
    filter(word_count %in% min:max)
  
  return(df)
  
}

## create plotly viz
## I'm using ggplot because the available plotly colors are all very pastelly
## and I don't like that

create_plotly <- function(df) {
  
  plot <- df %>% 
    ggplot(aes(word_count, line_count, text = speaker,  color = title, size = word_count)) +
    geom_point() +
    theme_bw() +
    labs(title = "Characters", x = "Word count", y = "Line count") +
    theme(legend.title = element_blank(),
          legend.position = "bottom")
  
  plotly_plot <- ggplotly(plot, tooltip = c("speaker"))
  
  return(plotly_plot)
}

### Display gender count

plot_gender_count <- function(df) {
  
  plot <- df %>% 
    ggplot(aes(reorder(gender, -word_count), word_count, fill = gender)) + 
    geom_col(show.legend = FALSE) +
    labs(title = "Gender distribution", x = "", y = "Word count") +
    theme_bw() +
    theme(panel.grid = element_blank())

  return(plot)
}

### characters captured
## this function returns the percentage of words captured in the slidebar as a valuebox

get_percentage <- function(df){
  
  row_count <- df %>% count()
  total <- movie_stats %>% count()
  
  result <- paste0(round((row_count/total)*100, 1), "%")
  return(result)
  
}

# ### WORD COUNTER ------------------------------------------------------------------------------------------
# ### this function takes a word argument and searches for all the appearances of that word in the data
# ### it returns the count grouped by character

word_search_df <- read_csv("word_search_df.csv")

filter_for_movie <- function(word_input){
  df <- word_search_df %>% 
    filter(word == word_input) %>% 
    group_by(title) %>% 
    count()
  return(df)
}

count_per_movie <- function(df){

per_movie_plot <- df %>% 
    ggplot(aes(reorder(title,n), n)) +
    geom_col(show.legend = FALSE) +
    geom_text(aes(label = n), hjust = -0.6) +
    coord_flip() +
    labs(title = "Total appearances of the word", x="", y = "")+
    theme_bw() +
    theme(panel.border = element_blank(),
          panel.grid = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text.y = element_text(size = 12),
          title = element_text(size = 14))

return(per_movie_plot)

}

### USED BY -----------------------------------------------------------------------------------------------------
## this function returns the characters that used the searched term
## if there are more than 15 I'll retur the first 15 only
word_input <- "mister"
filter_for_character <- function(word_input){
  
  character_plot_df <- word_search_df %>% 
    filter(word == word_input) %>% 
    group_by(title, speaker) %>% 
    count() 
  
  if (nrow(character_plot_df) < 15){
    
    character_plot_df <- character_plot_df
    
  } else {
    character_plot_df <- character_plot_df[1:15,]
    
  }
  
  return(character_plot_df)
}

said_by_character <- function(df){
  
  character_plot <- df %>% 
    ggplot(aes(reorder(speaker, n), n, fill = title))+
    geom_col() +
    geom_text(aes(label = n), hjust = -0.6) +
    coord_flip() +
    labs(title = paste0("Used by"), x="", y = "")+
    theme_bw() +
    theme(panel.border = element_blank(),
          panel.grid = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text.y = element_text(size = 12),
          title = element_text(size = 14),
          legend.position = "bottom",
          legend.title = element_blank())
  
  return(character_plot)
  
}


