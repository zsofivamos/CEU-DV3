

## this function takes a word as an input argument and returns the number of times 
## that word appears in the data set

search_word <- function(word_input){
  
  df <- fread("df.csv") %>% 
    filter(speaker != "NO SPEAKER") %>% 
    unnest_tokens(word, script)
  
  df %>%
    filter(word == word_input) %>% 
    group_by(title) %>% 
    count() %>% 
    arrange(-n) %>% 
    ggplot(aes(reorder(title,n), n, fill = title)) +
    geom_col(show.legend = FALSE) +
    coord_flip() +
    labs(title = paste0("Total appearances of the word '", word_input,"'"), x="", y = "")+
    theme_bw()

}

search_word("fly")
