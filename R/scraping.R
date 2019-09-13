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


str(tables)

## @knitr nodes
ateam <- read_html("http://www.boxofficemojo.com/movies/?id=ateam.htm")
center <- html_nodes(ateam, "center") 

## @knitr list
x <- list("char" = c("cat","dog"), "nest" = list((1:3),2:4), "int" = 4:5, "logical" = c(T,F,T,F), "float" = c(87.5, -962.4))

x[[1]]
# [1] "cat" "dog"

x[1:3]

(tables)

## @knitr table_choose
table1 <- tables[[1]]
# {html_node}
# <table class="simpleTable simpleCreditsTable">
# [1] <colgroup>\n<col class="column1">\n<col class="column2">\n<col class="column3">\n</colgrou ...
# [2] <tbody><tr>\n<td class="name">\n<a href="/name/nm0001392/?ref_=ttfc_fc_dr1"> Peter Jackson ...
table2 <- tables[[2]]
# {html_node}
# <table class="simpleTable simpleCreditsTable">
# [1] <colgroup>\n<col class="column1">\n<col class="column2">\n<col class="column3">\n</colgrou ...
# [2] <tbody>\n<tr>\n<td class="name">\n<a href="/name/nm0866058/?ref_=ttfc_fc_wr1"> J.R.R. Tolk ...
table3 <- tables[[3]]

## @knitr table_clean
cast <- html_table(table3)
## @knitr pipes


f(x,y) = x %>% f(y) = f(.,y)


mtcars %>% filter(cyl == 4) %>% .$mpg


cast <- read_html(lotr) %>% html_nodes("table") %>% .[[3]]  %>% html_table

## @knitr scraper
tablescraper <- function(url, item){
  out <- read_html(url) %>% html_nodes("table") %>% .[[item]] %>% html_table
  return(out)
}

## @knitr search
tablescraper(lotr,1) %>% head
#              X1 X2 X3
# 1 Peter Jackson NA NA

tablescraper(lotr,2) %>% head
#                X1  X2             X3
# 1  J.R.R. Tolkien ...        (novel)
# 2                                   
# 3      Fran Walsh ... (screenplay) &
# 4 Philippa Boyens ... (screenplay) &
# 5   Peter Jackson ...   (screenplay)

tablescraper(lotr,3) %>% head

cast <- tablescraper(lotr,3)

head(cast)
#   X1           X2  X3                                    X4
# 1                                                          
# 2     Alan Howard ... Voice of the Ring \n  \n  \n  (voice)
# 3    Noel Appleby ...                     Everard Proudfoot
# 4      Sean Astin ...                                   Sam
# 5      Sala Baker ...                                Sauron
# 6       Sean Bean ...                               Boromir
#   X1           X2  X3                                    X4
# 1                                                          
# 2     Alan Howard ... Voice of the Ring \n  \n  \n  (voice)
# 3    Noel Appleby ...                     Everard Proudfoot
# 4      Sean Astin ...                                   Sam
# 5      Sala Baker ...                                Sauron
# 6       Sean Bean ...                               Boromir
## @knitr clean-1
cast$X1 <- NULL
cast$X3 <- NULL

head(cast)

## @knitr rename
cast <- cast %>% rename(Actor = X2, Character = X4)
head(cast)

animals  <- c("cat","dog","mouse","hamster","komodo dragon")

#grep(pattern, object)

grep("d", animals)
# [1] 2 5

grepl("d", animals)
# [1] FALSE  TRUE FALSE FALSE  TRUE

animals[grep("d",animals)]
# [1] "dog"           "komodo dragon"

animals[grepl("d", animals)]
# [1] "dog"           "komodo dragon"


# do it this way
animals[!grepl("d",animals)]
# [1] "cat"     "mouse"   "hamster"

animals[-grep("d",animals)]



## @knitr grepl

truefalse <- grepl

#   X1           X2  X3                                    X4
# 1                                                          
# 2     Alan Howard ... Voice of the Ring \n  \n  \n  (voice)
# 3    Noel Appleby ...                     Everard Proudfoot
# 4      Sean Astin ...                                   Sam
# 5      Sala Baker ...                                Sauron
# 6       Sean Bean ...                               Boromir

!grepl("Rest of cast listed alphabetically:", cast$Actor)
#   [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#  [19] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#  [37] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
#  [55] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#  [73] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#  [91] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
# [109] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
# [127] FALSE FALSE FALSE FALSE FALSE FALSE FALSE
cast<-cast[!grepl("Rest of cast listed alphabetically:", cast$Actor),]



## @knitr regex1

# gsub("pattern","replacement",object)
cast$Character<-gsub("[\r\n]","",cast$Character)

head(cast)
## @knitr regex2
cast$Character <- gsub("\\s+"," ",cast$Character)
cast$Character <- str_squish(cast$Character)

head(cast,10)
#             Actor                 Character
# 1                                          
# 2     Alan Howard Voice of the Ring (voice)
# 3    Noel Appleby         Everard Proudfoot
# 4      Sean Astin                       Sam
# 5      Sala Baker                    Sauron
# 6       Sean Bean                   Boromir
# 7  Cate Blanchett                 Galadriel
# 8   Orlando Bloom                   Legolas
# 9      Billy Boyd                    Pippin
# 10  Marton Csokas                  Celeborn

head(cast)
html_table(html_nodes(pokemon,table)[[2]])
ateam <- read_html("http://www.boxofficemojo.com/movies/?id=ateam.htm")
html_nodes(ateam, "center") 


data(mtcars)
library(ggplot2)
head(mtcars)
ggplot(data = mtcars, aes(x = cyl, y = mpg, fill = gear))+geom_bar(stat ="identity") + theme_minimal()


cast$isGoblin <- grepl("Goblin", cast$Character)

cast$isGoblin <- as.numeric(cast$isGoblin)

numGoblins <- sum(cast$isGoblin)
# [1] 24




cast

# if condition do thing else do other
#ifelse(condition, what to do on true, what to do on false)
cast$isGoblin <- ifelse(
                        cast$isGoblin == TRUE,
                        "i am a goblin",
                        "i am not a goblin"
)

View(cast)
