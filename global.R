library(dplyr)
library(tidyverse)
library(plotly)

## count lines spoken per character

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

movie_stats <- merge(line_count_df, word_count_df, by = c("title", "speaker"))

str(movie_stats)

plot1 <- ggplot(movie_stats, aes(word_count, line_count, color = title, size = word_count)) +
  geom_point() +
  theme_bw() +
  labs(title = "Word count per line count", x = "Word count", y = "Line count") +
  theme(legend.title = element_blank(),
        legend.position = "bottom")

ggplotly(plot1, tooltip = "movie_stats$speaker")

plot_ly(movie_stats, 
        x = test_data$word_count, 
        y = test_data$line_count, 
        colors = "Accent",
        type = "scatter", 
        hoverinfo = "text",
        text = paste("Name: ", test_data$speaker, '<br> Word count: ', test_data$word_count,
                     '<br> Line_count: ', test_data$line_count, '<br> Movie: ', test_data$title),
        mode = "markers", color = test_data$title, size = test_data$word_count 
        )

### get most popular words


## this function grabs the content for the movie filter
## it will show the 15 most popular words per movie

show_popular_words <- function(movie_title) {
  
fread("df.csv") %>% 
    filter(speaker != "NO SPEAKER") %>%
    group_by(title) %>% 
    unnest_tokens(word, script) %>%
    anti_join(stop_words) %>%
    count(word, sort = TRUE) %>% 
    mutate(per_movie_rank = row_number()) %>%
    ungroup() %>% 
    arrange(-n) %>% 
    mutate(overall_rank = row_number()) %>% 
    filter(title == movie_title) %>% 
    filter(per_movie_rank <=15) 
  
    # ggplot(aes(reorder(word, n), n)) +
    # geom_col() +
    # coord_flip() +
    # labs(title = paste0("Most frequent words in '", movie_title, "'"), x = "", y = "Count") +
    # theme_bw() 

}

plot_pop_words <- function(df) {
  ggplot(aes(reorder(word, n), n)) +
  geom_col() +
  coord_flip() +
# labs(title = paste0("Most frequent words in '", df$title, "'"), x = "", y = "Count") +
  theme_bw()
}

show_popular_words("The Shawshank Redemption")

## this function takes a word as an input argument and returns the number of times 
## that word appears in the data set

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

word_count("bag")
