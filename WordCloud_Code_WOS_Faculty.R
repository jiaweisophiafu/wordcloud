#MIT Sloan WOS Faculty Publications Word Cloud
#Read data
library(readxl)
data_MIT <- read_excel("WOS_Faculty.xlsx")

#Create a combined column of title, abstract, keywords (to turn into tokens later)
#New column name, merged, is 2nd in the function
library(tidyr)
relevant_data_MIT <- unite(data_MIT, merged, Title, Abstract, Keywords, sep = " ", remove = TRUE)

          #NOTE
          #Use this function instead of the above if you'd like to INCLUDE the 
          #bios in the wordcloud
          relevant_data_MIT <- unite(data_MIT, merged, Title, Abstract, 
                                 Keywords, Bio, sep = " ", remove = TRUE)

#Turn above terms in the merged column into tokens
library(quanteda)
library(corpustools)
tokens_MIT = quanteda::tokens(relevant_data_MIT$merged)
tokens_MIT

#Pre-process the text (remove stop words, punctuation, and lowercase)
tokens_MIT = tokens_remove(tokens_MIT, c(stopwords("english")))
tokens_MIT = quanteda::tokens(tokens_MIT, remove_punct = T)
tokens_MIT = tokens_tolower(tokens_MIT)
tokens_MIT

#Lemmatize using words from the dictionary (lexicon)
tokens_MIT = tokens_replace(tokens_MIT, pattern = lexicon::hash_lemmas$token, 
                        replacement = lexicon::hash_lemmas$lemma)

#Create a document feature matrix (shows frequency of words within text and between texts)
dfm_MIT = dfm(tokens_MIT)
dfm_MIT = dfm_trim(dfm_MIT, min_docfreq = 5)
dfm_MIT
dfm_MIT <- dfm_remove(dfm_MIT, c("and", "na", "datum"))
dfm_MIT <- dfm_remove(dfm_MIT, stopwords("english"))

#Create a wordcloud of the data
library("quanteda.textplots")
library("RColorBrewer")
textplot_wordcloud(dfm_MIT, max_words = 100, color = rev(RColorBrewer::brewer.pal(10, "RdBu")))
textplot_wordcloud(dfm_MIT, max_words = 100, color = RColorBrewer::brewer.pal(10, "RdBu")) 
textplot_wordcloud(dfm_MIT, max_words = 100, color = RColorBrewer::brewer.pal(10, "BrBG"))
textplot_wordcloud(dfm_MIT, max_words = 100, color = rev(RColorBrewer::brewer.pal(10, "Accent")))
textplot_wordcloud(dfm_MIT, max_words = 100, color = RColorBrewer::brewer.pal(100, "Reds")) 
textplot_wordcloud(dfm_MIT, max_words = 100, color = rev(RColorBrewer::brewer.pal(10, "Spectral")))
textplot_wordcloud(dfm_MIT, max_words = 100, color = RColorBrewer::brewer.pal(16, "Greys"))
textplot_wordcloud(dfm_MIT, max_words = 100, color = "red")
textplot_wordcloud(dfm_MIT, max_words = 100, color = "gray40") ## final one used
textplot_wordcloud(dfm_MIT, max_words = 100, color = "brown4")
textplot_wordcloud(dfm_MIT, max_words = 100, color = "azure4")
