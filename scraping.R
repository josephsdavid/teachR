


library(tidyverse)
library(rvest)
library("humaniformat")

harrypotter = 'http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1'
html_scraper <-function(url,elem) {
  read_html(url)%>% html_nodes("table")%>%.[[elem]] %>% html_table ->out
  return(out)
}
html_scraper(harrypotter,3)-> cast
head(cast,10)
#    X1               X2  X3                         X4
# 1                                                    
# 2        Ralph Fiennes ...             Lord Voldemort
# 3       Michael Gambon ... Professor Albus Dumbledore
# 4         Alan Rickman ...    Professor Severus Snape
# 5     Daniel Radcliffe ...               Harry Potter
# 6         Rupert Grint ...                Ron Weasley
# 7          Emma Watson ...           Hermione Granger
# 8         Evanna Lynch ...              Luna Lovegood
# 9     Domhnall Gleeson ...               Bill Weasley
# 10      Clémence Poésy ...             Fleur Delacour
cast$X1<-NULL
cast$X3<-NULL
head(cast,10)
#                  X2                         X4
# 1                                             
# 2     Ralph Fiennes             Lord Voldemort
# 3    Michael Gambon Professor Albus Dumbledore
# 4      Alan Rickman    Professor Severus Snape
# 5  Daniel Radcliffe               Harry Potter
# 6      Rupert Grint                Ron Weasley
# 7       Emma Watson           Hermione Granger
# 8      Evanna Lynch              Luna Lovegood
# 9  Domhnall Gleeson               Bill Weasley
# 10   Clémence Poésy             Fleur Delacour
cast<- cast[-1,]
head(cast,10)
#                  X2                                                  X4
# 2     Ralph Fiennes                                      Lord Voldemort
# 3    Michael Gambon                          Professor Albus Dumbledore
# 4      Alan Rickman                             Professor Severus Snape
# 5  Daniel Radcliffe                                        Harry Potter
# 6      Rupert Grint                                         Ron Weasley
# 7       Emma Watson                                    Hermione Granger
# 8      Evanna Lynch                                       Luna Lovegood
# 9  Domhnall Gleeson                                        Bill Weasley
# 10   Clémence Poésy                                      Fleur Delacour
# 11    Warwick Davis Griphook /  \n            Professor Filius Flitwick

sapply(cast, function(x){gsub("[\r\n]","",x)}) -> cast
cast<-as.data.frame(cast)
sapply(cast, function(x){gsub("\\s+","",x)})->cast
cast<-as.data.frame(cast)
head(cast,10)
#               cast
# 1     RalphFiennes
# 2    MichaelGambon
# 3      AlanRickman
# 4  DanielRadcliffe
# 5      RupertGrint
# 6       EmmaWatson
# 7      EvannaLynch
# 8  DomhnallGleeson
# 9    ClémencePoésy
# 10    WarwickDavis
colnames(cast)<-c("Actor","Character")
first<-first_name(cast$Actor)
middle<-middle_name(cast$Actor)
middle[is.na(middle)]<-""
last<-last_name(cast$Actor)
firstName<-paste(first,middle)
cleancast<-data.frame("FirstName"=firstName,"Surname"=last,"Character"=cast$Character)
head(cleancast)

