#Sophia Fu Publications Word Cloud

#Read data
library(readxl)
data_SF <- read_excel("SF_Papers.xlsx")

#Create a combined column of title, abstract, keywords (to turn into tokens later)
#New column name, merged, is 2nd in the function
library(tidyr)
relevant_data_SF <- unite(data_SF, merged, Title, Abstract, Keywords, sep = " ", remove = TRUE)

          #NOTE
          #Use this function instead of the above if you'd like to INCLUDE the 
          #bios in the wordcloud
          relevant_data_SF <- unite(data_SF, merged, Title, Abstract, 
                                 Keywords, Bio, sep = " ", remove = TRUE)

#Turn above terms in the merged column into tokens
library(quanteda)
library(corpustools)
tokens_SF = quanteda::tokens(relevant_data_SF$merged)
tokens_SF

#Pre-process the text (remove stop words, punctuation, and lowercase)
tokens_SF = tokens_remove(tokens_SF, c(stopwords("english")))
tokens_SF = quanteda::tokens(tokens_SF, remove_punct = T)
tokens_SF = tokens_tolower(tokens_SF)
tokens_SF

#Lemmatize using words from the dictionary (lexicon)
tokens_SF = tokens_replace(tokens_SF, pattern = lexicon::hash_lemmas$token, 
                        replacement = lexicon::hash_lemmas$lemma)

#Create a document feature matrix (shows frequency of words within text and between texts)
dfm_SF = dfm(tokens_SF)
dfm_SF = dfm_trim(dfm_SF, min_docfreq = 3)
dfm_SF <- dfm_remove(dfm_SF, c("and", "n", "na", "e.g", "also", "datum", "=", "i.e"))
dfm_SF <- dfm_remove(dfm_SF, stopwords("english"))
dfm_SF
#write.csv(dfm_SF, "word_SF.csv")

#Create a wordcloud of the data
library("quanteda.textplots")
library("RColorBrewer")
textplot_wordcloud(dfm_SF, max_words = 100, color = RColorBrewer::brewer.pal(10, "RdBu")) 
textplot_wordcloud(dfm_SF, max_words = 100, color = RColorBrewer::brewer.pal(10, "Reds")) 
textplot_wordcloud(dfm_SF, max_words = 100, color = "gray40") ##final one
