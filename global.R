library(dplyr)
library(tidyverse)
library(plotly)
library(data.table)

### FREQUENT WORDS PLOT ------------------------------------------------------------------------------------
### this function grabs the content for the movie filter
### it will show the 15 most popular words per movie

plot_popular_words <- function(df) {
  
plot <- df %>% 
    top_n(-15) %>% 
    ggplot(aes(reorder(word, n), n)) +
    geom_col() +
    coord_flip() +
    labs(title = paste0("Most frequent words in '", df$title, "'"), x = "", y = "Count") +
    theme_bw()

return(plot)

}

plot_popular_words(df)

### WORD COUNTER ------------------------------------------------------------------------------------------
### this function takes a word argument and searches for all the appearances of that word in the data
### it returns the count grouped by movie

word_count <- function(word_input){
  
 fread("df.csv") %>% 
    filter(speaker != "NO SPEAKER") %>% 
    unnest_tokens(word, script) %>%
    filter(word == word_input) %>% 
    group_by(title) %>% 
    count() %>% 
    arrange(-n) %>% 
    ggplot(aes(reorder(title,n), n)) +
    geom_col(show.legend = FALSE) +
    coord_flip() +
    labs(title = paste0("Total appearances of the word '", word_input,"'"), x="", y = "")+
    theme_bw()

}



### get data2 ------------------------------------------------------------------------------------------
### this one gets the data broken up to word tokens
get_df <- function() {
  df <- fread("df.csv") %>% 
    filter(speaker != "NO SPEAKER") %>% 
    group_by(title) %>%
    unnest_tokens(word, script) %>%
    anti_join(stop_words) %>%
    count(word, sort = TRUE) %>%
    mutate(per_movie_rank = row_number()) %>%
    ungroup() %>%
    arrange(-n) %>%
    mutate(overall_rank = row_number())
  
}

### GET DATA1 ------------------------------------------------------------------------------------------
### this one just pulls in the word data selected by the drop down

get_selected_data <- function(movie_title) {
  if (is.na(movie_title)){
    return(df)
  }else{
    df <- df %>% 
      filter(title == movie_title)
    return(df)
  }}

