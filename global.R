

## this function takes a word as an input argument and returns the number of times 
## that word appears in the data set

search_function <- function(word_input){
  df %>% filter(word == word_input) %>% 
    group_by(title) %>% 
    count()

}

search_function("dr")
