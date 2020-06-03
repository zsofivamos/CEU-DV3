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

### GET FILTERED DATA ------------------------------------------------------------------------------------------
### this one just pulls in the word data selected by the drop down
# 

select_title <- function(filter_selection){
  return(words_df %>% filter(title == filter_selection))
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



