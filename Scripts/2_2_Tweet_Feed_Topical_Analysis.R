#######################
# Twiter Feed Topical Analysis
#######################

#install.packages("topicmodels")
#install.packages("tm")
#install.packages("tidytext")
#install.packages("ggplot2")
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("stringr")

library(topicmodels)
library(tm)
library(tidytext)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)

disk <- "" #(C: or nothing)
user <- "Nico"
setwd(paste(disk, "/Users/", user, "/Dropbox/DataPiche/Political_Clusters_Project/Input"
            , sep = ""))

#######################################
# Understanding topicmodels Course 
#######################################

data("AssociatedPress")
ap_lda <- LDA(AssociatedPress, k = 2, control = list(seed = 1234))
ap_topics <- tidy(ap_lda, matrix = "beta")
ap_topics
# 
# ap_top_terms <- ap_topics %>%
#   group_by(topic) %>%
#   top_n(10, beta) %>%
#   ungroup() %>%
#   arrange(topic, -beta)
# 
# ap_top_terms %>%
#   mutate(term = reorder(term, beta)) %>%
#   ggplot(aes(term, beta, fill = factor(topic))) +
#   geom_col(show.legend = FALSE) +
#   facet_wrap(~ topic, scales = "free") +
#   coord_flip()
# 
# beta_spread <- ap_topics %>%
#   mutate(topic = paste0("topic", topic)) %>%
#   spread(topic, beta) %>%
#   filter(topic1 > .001 | topic2 > .001) %>%
#   mutate(log_ratio = log2(topic2 / topic1))
# ap_documents <- tidy(ap_lda, matrix = "gamma")
# ap_documents
# 
# tidy(AssociatedPress) %>%
#   filter(document == 6) %>%
#   arrange(desc(count))



# Import data
twitter_feeds <- read.csv(paste("twitter_feed_scrape.csv", sep = ""))


test <- Corpus(VectorSource(twitter_feeds$CoryBooker))
test2 <- TermDocumentMatrix(test)

setwd("/Users/Nico/Downloads")
tweets <- read.csv("tweets.csv")

replace_reg <- "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https"
unnest_reg <- "([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"

tidy_tweets <- tweets %>%  
#  filter(!str_detect(text, "^RT")) %>%  
#  mutate(text = str_replace_all(text, replace_reg, "")) %>%  
  unnest_tokens(word, text, token = "regex", pattern = unnest_reg) %>%  
  filter(!word %in% stop_words$word,
         str_detect(word, "[a-z]"))


text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")
text_df <- data_frame(line = 1:4, text = text)

text_df %>% unnest_tokens(word, text)


install.packages("janeaustenr")

library(janeaustenr)

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()


tidy_books <- original_books %>%
  unnest_tokens(word, text)

tidy_books <- tidy_books %>%
  anti_join(stop_words)


install.packages("gutenbergr")
library(gutenbergr)

hgwells <- gutenberg_download(c(35, 36, 5230, 159))
tidy_hgwells <- hgwells %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_hgwells %>%
  count(word, sort = TRUE)

bronte <- gutenberg_download(c(1260, 768, 969, 9182, 767))
tidy_bronte <- bronte %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_bronte %>%
  count(word, sort = TRUE)



frequency <- bind_rows(mutate(tidy_bronte, author = "Bronte Sisters"),
                       mutate(tidy_hgwells, author = "H.G. Wells"), 
                       mutate(tidy_books, author = "Jane Austen")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  spread(author, proportion) %>% 
  gather(author, proportion, `Bronte Sisters`:`H.G. Wells`)

install.packages("scales")
library(scales)

ggplot(frequency, aes(x = proportion, y = `Jane Austen`, color = abs(`Jane Austen` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Jane Austen", x = NULL)


