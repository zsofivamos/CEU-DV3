library(dplyr)
library(tidytext)
library(tidyverse)

### data prep

df <- read_csv("df.csv") %>% 
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

