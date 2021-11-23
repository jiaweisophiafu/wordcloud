#UIUC Communication Faculty Publications Word Cloud
#Read data
library(readxl)
data_UIUC <- read_excel("UIUC_Faculty.xlsx")

#Create a combined column of title, abstract, keywords (to turn into tokens later)
#New column name, merged, is 2nd in the function
library(tidyr)
relevant_data_UIUC <- unite(data_UIUC, merged, Title, Abstract, Keywords, sep = " ", remove = TRUE)

          #NOTE
          #Use this function instead of the above if you'd like to INCLUDE the 
          #bios in the wordcloud
          relevant_data_UIUC <- unite(data_UIUC, merged, Title, Abstract, 
                                 Keywords, Bio, sep = " ", remove = TRUE)

#Turn above terms in the merged column into tokens
library(quanteda)
library(corpustools)
tokens_UIUC = quanteda::tokens(relevant_data_UIUC$merged)
tokens_UIUC

#Pre-process the text (remove stop words, punctuation, and lowercase)
tokens_UIUC = tokens_remove(tokens_UIUC, c(stopwords("english")))
tokens_UIUC = quanteda::tokens(tokens_UIUC, remove_punct = T)
tokens_UIUC = tokens_tolower(tokens_UIUC)
tokens_UIUC

#Lemmatize using words from the dictionary (lexicon)
tokens_UIUC = tokens_replace(tokens_UIUC, pattern = lexicon::hash_lemmas$token, 
                        replacement = lexicon::hash_lemmas$lemma)

#Create a document feature matrix (shows frequency of words within text and between texts)
dfm_UIUC = dfm(tokens_UIUC)
dfm_UIUC = dfm_trim(dfm_UIUC, min_docfreq = 3)
dfm_UIUC
dfm_UIUC <- dfm_remove(dfm_UIUC, c("and", "na", "datum"))
dfm_UIUC <- dfm_remove(dfm_UIUC, stopwords("english"))

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
textplot_wordcloud(dfm_UIUC, max_words = 100, color = "gray40") ## final one used
textplot_wordcloud(dfm_MIT, max_words = 100, color = "brown4")
textplot_wordcloud(dfm_MIT, max_words = 100, color = "azure4")
