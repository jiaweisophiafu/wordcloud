#UIUC Communication Faculty Publications Word Cloud
#Read data
library(readxl)
data_SP2 <- read_excel("SP2_Faculty_Full.xlsx")

#Create a combined column of title, abstract, keywords (to turn into tokens later)
#New column name, merged, is 2nd in the function
library(tidyr)
relevant_data_SP2 <- unite(data_SP2, merged, Title, Abstract, Keywords, sep = " ", remove = TRUE)

          #NOTE
          #Use this function instead of the above if you'd like to INCLUDE the 
          #bios in the wordcloud
          relevant_data_SP2 <- unite(data_SP2, merged, Title, Abstract, 
                                 Keywords, Bio, sep = " ", remove = TRUE)

#Turn above terms in the merged column into tokens
library(quanteda)
library(corpustools)
tokens_SP2 = quanteda::tokens(relevant_data_SP2$merged)
tokens_SP2

#Pre-process the text (remove stop words, punctuation, and lowercase)
tokens_SP2 = tokens_remove(tokens_SP2, c(stopwords("english")))
tokens_SP2 = quanteda::tokens(tokens_SP2, remove_punct = T)
tokens_SP2 = tokens_tolower(tokens_SP2)
tokens_SP2

#Lemmatize using words from the dictionary (lexicon)
tokens_SP2 = tokens_replace(tokens_SP2, pattern = lexicon::hash_lemmas$token, 
                        replacement = lexicon::hash_lemmas$lemma)

#Create a document feature matrix (shows frequency of words within text and between texts)
dfm_SP2 = dfm(tokens_SP2)
dfm_SP2 = dfm_trim(dfm_SP2, min_docfreq = 3)
dfm_SP2
dfm_SP2 <- dfm_remove(dfm_SP2, c("and", "na", "datum", "="))
dfm_SP2 <- dfm_remove(dfm_SP2, stopwords("english"))

#Create a wordcloud of the data
library("quanteda.textplots")
library("RColorBrewer")
textplot_wordcloud(dfm_SP2, max_words = 100, color = rev(RColorBrewer::brewer.pal(10, "RdBu")))
textplot_wordcloud(dfm_SP2, max_words = 100, color = RColorBrewer::brewer.pal(10, "RdBu")) 
textplot_wordcloud(dfm_SP2, max_words = 100, color = RColorBrewer::brewer.pal(10, "BrBG"))
textplot_wordcloud(dfm_SP2, max_words = 100, color = rev(RColorBrewer::brewer.pal(10, "Accent")))
textplot_wordcloud(dfm_SP2, max_words = 100, color = RColorBrewer::brewer.pal(100, "Reds")) 
textplot_wordcloud(dfm_SP2, max_words = 100, color = rev(RColorBrewer::brewer.pal(10, "Spectral")))
textplot_wordcloud(dfm_SP2, max_words = 100, color = RColorBrewer::brewer.pal(16, "Greys"))
textplot_wordcloud(dfm_SP2, max_words = 100, color = "red")
textplot_wordcloud(dfm_SP2, max_words = 100, color = "gray40") ## final one used
textplot_wordcloud(dfm_SP2, max_words = 100, color = "brown4")
textplot_wordcloud(dfm_SP2, max_words = 100, color = "azure4")
