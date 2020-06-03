library(dplyr)
library(tidytext)
library(tidyverse)

### data prep

df <- read_csv("df.csv") 

### add year for slider input
df$year <- case_when(
  df$title == "The Shawshank Redemption" ~ 1994,
  df$title == "Godfather" ~ 1972,
  df$title == "Pulp Fiction" ~ 1994,
  df$title == "Fight Club" ~ 1999,
  df$title == "Forrest Gump" ~ 1994,
  df$title == "Inception" ~ 1994,
  df$title == "The Matrix" ~ 1999,
  df$title == "One Flew Over the Cuckoo's Nest" ~ 1975,
  df$title == "Seven" ~ 1995,
  df$title == "Silence of the Lambs" ~ 1991
)

## add IMDB score
df$score <- case_when(
  df$title == "The Shawshank Redemption" ~ 9.2,
  df$title == "Godfather" ~ 9.2,
  df$title == "Pulp Fiction" ~ 8.9,
  df$title == "Fight Club" ~ 8.8,
  df$title == "Forrest Gump" ~ 8.8,
  df$title == "Inception" ~ 8.7,
  df$title == "The Matrix" ~ 8.7,
  df$title == "One Flew Over the Cuckoo's Nest" ~ 8.7,
  df$title == "Seven" ~ 8.6,
  df$title == "Silence of the Lambs" ~ 8.6
)


## remove non-speech
df <- df %>% 
  filter(speaker != "NO SPEAKER") %>% 
  unnest_tokens(word, script)

bad_words <- data_frame(word = c("ass", "asses", "asshole", "assholes","fuck", "fucker", "fuckers", "fucking", "fuckin", "fucked",
                                 "motherfucker", "motherfuckers", "butt", "bitch", "cock", "cunt",
                                 "dick", "nigger", "shit", "tits"))

extra_stop_words <- data_frame(word = c("yeah","â","gonna","wanna",
                                        "hey","ya","gotta","uh","ah",
                                        "muh","shhh","sh","wh","er","ha","em", "du")
)

names <- read_csv("characters_clean.csv") %>% select(word=speaker) %>% mutate(word=tolower(word))
## plus I know of a couple of names on the screen that will not show up in either e.g. "Dufresne"
## so let's fix that
hidden_names <- data_frame(word = c("mcmurphy", "gump", "dom","dufresne", "mills", "somerset", "starling", "lecter", "ratched", "pilbow",
                                    "corleone", "hannibal"))
all_names <- rbind(names, as.tibble(hidden_names))

df <- df %>% 
  anti_join(stop_words) %>% 
  anti_join(all_names) %>% 
  anti_join(bad_words) %>% 
  anti_join(extra_stop_words)

write_csv(df, "word_df.csv")

##### Data for plotly

## scatterplot -----------------------------------------------------------------------------------------------
line_count_df <- read_csv("df.csv") %>% 
  filter(speaker != "NO SPEAKER") %>% 
  group_by(title, speaker) %>% 
  summarise(line_count = n()) %>% 
  arrange(-line_count) %>% 
  mutate(grouped_ranking = row_number()) %>% 
  ungroup %>% 
  mutate(overall_ranking = row_number())

## count words
word_count_df <- read_csv("df.csv") %>% 
  filter(speaker != "NO SPEAKER") %>%  
  group_by(title, speaker) %>% 
  unnest_tokens(word, script) %>%
  count(word, sort = TRUE) %>% 
  anti_join(stop_words) %>% 
  anti_join(all_names) %>% 
  anti_join(bad_words) %>% 
  anti_join(extra_stop_words) %>% 
  ungroup() 

movie_stats <- merge(line_count_df, word_count_df, by = c("title", "speaker")) 

write_csv("movie_stats.csv")
