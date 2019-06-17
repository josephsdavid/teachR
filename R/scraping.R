## @knitr libs
library(rvest)
library(tidyverse)


## @knitr datadef
lotr  <- 'https://www.imdb.com/title/tt0120737/fullcredits?ref_=tt_cl_sm#cast'

## @knitr html_read-1
read_html(lotr)
## @knitr html_read-2
rawdata <- read_html(lotr)

## @knitr html_read-3
tables <- html_nodes(rawdata, "table")

## @knitr nodes
ateam <- read_html("http://www.boxofficemojo.com/movies/?id=ateam.htm")
center <- html_nodes(ateam, "center") 

## @knitr list
x <- list("char" = c("cat","dog"), "nest" = list((1:3),2:4), "int" = 4:5, "logical" = c(T,F,T,F), "float" = c(87.5, -962.4))

## @knitr table_choose
table1 <- tables[[1]]
table2 <- tables[[2]]
table3 <- tables[[3]]

## @knitr table_clean
cast <- rvest::html_table(table3)
## @knitr pipes
read_html(lotr) %>% html_nodes("table") %>% .[[3]]  %>% html_table -> cast

## @knitr scraper
tablescraper <- function(url, item){
  read_html(url) %>% html_nodes("table") %>% . [[item]] %>% html_table -> out
  return(out)
}

## @knitr search
tablescraper(lotr,1) %>% head

tablescraper(lotr,2) %>% head

tablescraper(lotr,3) -> cast
## @knitr clean-1
cast <- cast[-1,]
cast$X1 <- NULL
cast$X3 <- NULL

## @knitr rename
cast %>% rename(Actor = X2, Character = X4) -> cast

## @knitr grepl
cast<-cast[!grepl("Rest of cast listed alphabetically:", cast$Actor),]
## @knitr regex1
cast$Character<-gsub("[\r\n]","",cast$Character)
## @knitr regex2
cast$Character<-gsub("\\s+"," ",cast$Character)

## @knitr trash

head(cast)
html_table(html_nodes(pokemon,table)[[2]])
ateam <- read_html("http://www.boxofficemojo.com/movies/?id=ateam.htm")
html_nodes(ateam, "center") 


data(mtcars)
library(ggplot2)
head(mtcars)
ggplot(data = mtcars, aes(x = cyl, y = mpg, fill = gear))+geom_bar(stat ="identity") + theme_minimal()



