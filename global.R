library(dplyr)
library(tidyverse)
library(plotly)
library(data.table)
library(tidytext)
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
  coord_flip() +
  labs(title = paste0("Most frequent words in '", df$title, "'"), x = "", y = "Count") +
  theme_bw()

return(plot)
}

# ### WORD COUNTER ------------------------------------------------------------------------------------------
# ### this function takes a word argument and searches for all the appearances of that word in the data
# ### it returns the count grouped by movie
# 
# word_count <- function(word_input){
#   
#  fread("df.csv") %>% 
#     filter(speaker != "NO SPEAKER") %>% 
#     unnest_tokens(word, script) %>%
#     filter(word == word_input) %>% 
#     group_by(title) %>% 
#     count() %>% 
#     arrange(-n) %>% 
#     ggplot(aes(reorder(title,n), n)) +
#     geom_col(show.legend = FALSE) +
#     coord_flip() +
#     labs(title = paste0("Total appearances of the word '", word_input,"'"), x="", y = "")+
#     theme_bw()
# 
# }
# 

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
    labs(title = "Word count per line count", x = "Word count", y = "Line count") +
    theme(legend.title = element_blank(),
          legend.position = "bottom")
  
  plotly_plot <- ggplotly(plot, tooltip = "speaker")
  
  return(plotly_plot)
}

# movie_stats_plot <- movie_stats %>%
#   ggplot(aes(word_count, line_count, text = speaker,  color = title, size = word_count)) +
#   geom_point() +
#   theme_bw() +
#   labs(title = "Word count per line count", x = "Word count", y = "Line count") +
#   theme(legend.title = element_blank(),
#         legend.position = "bottom")
# 
# plotly_plot <- ggplotly(movie_stats_plot, tooltip = "speaker")




