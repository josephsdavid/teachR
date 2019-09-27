library(jsonlite)
library(RCurl)
library(httr)

site <- "https://public.opendatasoft.com/api/records/1.0/search/?dataset=titanic-passengers&rows=2000&facet=survived&facet=pclass&facet=sex&facet=age&facet=embarked"

JSON2 <- GET(site)
head(JSON2)
# getURL of the site
# convert that json to an R object with fromJSON
# use str to figure out where the data we want is
# have the data
JSON <- getURL(site)

titanic <- fromJSON(JSON)
head(titanic)
str(titanic)
# List of 4
#  $ nhits       : int 891
#  $ parameters  :List of 5
#   ..$ dataset : chr "titanic-passengers"
#   ..$ timezone: chr "UTC"
#   ..$ rows    : int 2000
#   ..$ format  : chr "json"
#   ..$ facet   : chr [1:5] "survived" "pclass" "sex" "age" ...
#  $ records     :'data.frame':	891 obs. of  4 variables:
#   ..$ datasetid       : chr [1:891] "titanic-passengers" "titanic-passengers" "titanic-passengers" "titanic-passengers" ...
#   ..$ recordid        : chr [1:891] "eea7ba75804a635bbda037c6f1b0c3d2aa692676" "cd86858c28b1f1089d1da74a4da9c16ee7552a3a" "a9f68f2c2ffa9dc96c153cbeed93383095e5d8e9" "db6e63fcab7b6af79944143027f60f7cb66d846f" ...
#   ..$ fields          :'data.frame':	891 obs. of  12 variables:
#   .. ..$ fare       : num [1:891] 7.78 7.92 7.92 18.75 89.1 ...
#   .. ..$ name       : chr [1:891] "Birkeland, Mr. Hans Martin Monsen" "Heikkinen, Miss. Laina" "Sundman, Mr. Johan Julian" "Richards, Mrs. Sidney (Emily Hocking)" ...
#   .. ..$ embarked   : chr [1:891] "S" "S" "S" "S" ...
#   .. ..$ age        : num [1:891] 21 26 44 24 NA 33 28 16 30 32 ...
#   .. ..$ parch      : int [1:891] 0 0 0 3 0 0 0 0 0 0 ...
#   .. ..$ pclass     : int [1:891] 3 3 3 2 1 3 2 2 3 2 ...
#   .. ..$ sex        : chr [1:891] "male" "female" "male" "female" ...
#   .. ..$ survived   : chr [1:891] "No" "Yes" "Yes" "Yes" ...
#   .. ..$ ticket     : chr [1:891] "312992" "STON/O2. 3101282" "STON/O 2. 3101269" "29106" ...
#   .. ..$ passengerid: int [1:891] 409 3 415 438 850 882 884 792 287 71 ...
#   .. ..$ sibsp      : int [1:891] 0 0 0 2 1 0 0 0 0 0 ...
#   .. ..$ cabin      : chr [1:891] NA NA NA NA ...
#   ..$ record_timestamp: chr [1:891] "2016-09-20T22:34:51.313000+00:00" "2016-09-20T22:34:51.313000+00:00" "2016-09-20T22:34:51.313000+00:00" "2016-09-20T22:34:51.313000+00:00" ...
#  $ facet_groups:'data.frame':	5 obs. of  2 variables:
#   ..$ facets:List of 5
#   .. ..$ :'data.frame':	88 obs. of  4 variables:
#   .. .. ..$ count: int [1:88] 30 27 26 25 25 25 24 23 22 20 ...
#   .. .. ..$ path : chr [1:88] "24.0" "22.0" "18.0" "19.0" ...
#   .. .. ..$ state: chr [1:88] "displayed" "displayed" "displayed" "displayed" ...
#   .. .. ..$ name : chr [1:88] "24.0" "22.0" "18.0" "19.0" ...
#   .. ..$ :'data.frame':	2 obs. of  4 variables:
#   .. .. ..$ count: int [1:2] 577 314
#   .. .. ..$ path : chr [1:2] "male" "female"
#   .. .. ..$ state: chr [1:2] "displayed" "displayed"
#   .. .. ..$ name : chr [1:2] "male" "female"
#   .. ..$ :'data.frame':	2 obs. of  4 variables:
#   .. .. ..$ count: int [1:2] 549 342
#   .. .. ..$ path : chr [1:2] "No" "Yes"
#   .. .. ..$ state: chr [1:2] "displayed" "displayed"
#   .. .. ..$ name : chr [1:2] "No" "Yes"
#   .. ..$ :'data.frame':	3 obs. of  4 variables:
#   .. .. ..$ count: int [1:3] 491 216 184
#   .. .. ..$ path : chr [1:3] "3" "1" "2"
#   .. .. ..$ state: chr [1:3] "displayed" "displayed" "displayed"
#   .. .. ..$ name : chr [1:3] "3" "1" "2"
#   .. ..$ :'data.frame':	3 obs. of  4 variables:
#   .. .. ..$ count: int [1:3] 644 168 77
#   .. .. ..$ path : chr [1:3] "S" "C" "Q"
#   .. .. ..$ state: chr [1:3] "displayed" "displayed" "displayed"
#   .. .. ..$ name : chr [1:3] "S" "C" "Q"
#   ..$ name  : chr [1:5] "age" "sex" "survived" "pclass" ...
# NULL
