library(dplyr)
library(tidyr)
library(plyr)
library(rjson)
library(jsonlite)
library(pander)


NYTIMES_KEY = "ULAGIigdFMCFsmJgB5cxcwKmCjnISU6W";

# Let's set some parameters
term <- "Trump" # Need to use + to string together separate words
begin_date <- "20190101"
end_date <- "20190106"

baseurl <- paste0("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=",term,
                  "&begin_date=",begin_date,"&end_date=",end_date,
                  "&facet_filter=true&api-key=",NYTIMES_KEY, sep="")

initialQuery <- jsonlite::fromJSON(baseurl)
pander(head(initialQuery,1))
str(initialQuery)
maxPages <- round((initialQuery$response$meta$hits[1] / 10)-1)
# [1] 18


#for(i in 1:100000000)
#{
#  j = (i + 1 -1 )/i
#}

### This will be slow
pages <- list()
for(i in 0:maxPages){
  nytSearch <- jsonlite::fromJSON(paste(baseurl, "&page=", i), flatten = TRUE) %>% data.frame()
  message("Retrieving page ", i)
  pages[[i+1]] <- nytSearch
  Sys.sleep(4)
}

