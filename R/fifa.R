library(tidyverse)
# dplyr, readr, ggplot2, 

fifa <- read_csv("https://raw.githubusercontent.com/BivinSadler/MDS-6306-Doing-Data-Science-Fall-2019/Master/Unit%203/FIFA%20Players.csv")

fifa$Value %>% str
str(fifa$Value)
#  chr [1:18207] "€110.5M" "€77M" "€118.5M" "€72M" "€102M" "€93M" "€67M" ...
# NULL
#  chr [1:18207] "€110.5M" "€77M" "€118.5M" "€72M" "€102M" "€93M" "€67M" ...
# NULL

fifa$Value <- gsub("€", "", fifa$Value)

head(fifa$Value)
# [1] "110.5M" "77M"    "118.5M" "72M"    "102M"   "93M"   
# [1] "60K" "60K" "60K" "60K" "60K" "60K"

fifa$Value %>% str

grepl("M", fifa$Value[i])

datacleaner <- function(col, ind) {
  ifelse(
    grepl("M", col[ind]),
    return(as.numeric(gsub("M","", col[ind])) * 1e6),
    return(as.numeric(gsub("K","", col[ind])) * 1000)
  )
}


# always preallocate space
values <- double(nrow(fifa))
for (i in 1:nrow(fifa)) {
  values[i] <- datacleaner(fifa$Value, i)
}

library(reticulate)
os <- import("os")
pd <- import("pandas")
pd$read_csv



# apply family way
values2 <- vapply(1:nrow(fifa), function(i) datacleaner(fifa$Value, i), numeric(1))

all.equal(values2, values)
# [1] TRUE

sum(abs(values2 - values))
# [1] 0


# apply family of functions
# *apply(data, function, extrargs)
# lapply
data(mtcars)
mtcars


vapply(mtcars, mean, numeric(1))
#        mpg        cyl       disp 
#  20.090625   6.187500 230.721875 
#         hp       drat         wt 
# 146.687500   3.596563   3.217250 
#       qsec         vs         am 
#  17.848750   0.437500   0.406250 
#       gear       carb 
#   3.687500   2.812500 
# $mpg
# [1] 20.09062
# 
# $cyl
# [1] 6.1875
# 
# $disp
# [1] 230.7219
# 
# $hp
# [1] 146.6875
# 
# $drat
# [1] 3.596563
# 
# $wt
# [1] 3.21725
# 
# $qsec
# [1] 17.84875
# 
# $vs
# [1] 0.4375
# 
# $am
# [1] 0.40625
# 
# $gear
# [1] 3.6875
# 
# $carb
# [1] 2.8125
# 

head(values)

fifa$Value <- values

head(fifa$Value)

hist(fifa$Value)

fifa <- fifa %>% mutate(logVal = log(Value))

hist(fifa$logVal)

# ggthemes is great!
library(ggthemes)
fifa %>% ggplot(aes(x= logVal, fill = Position)) + geom_histogram() 

as.numeric(gsub("M","", fifa$Value[1]))






x <- 1:3
# [1] 1 2 3

as.numeric(fifa$Value)
