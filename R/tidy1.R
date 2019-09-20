library(tidyverse)

# readr, ggplot2, dplyr, stringr, tidyr

ds <- read_csv("http://codeasmanuscript.org/states_data.csv")


View(ds)
ds
# # A tibble: 50 x 13
#    StateName   Population Income Illiteracy LifeExp Murder HSGrad Frost   Area Region    Division           Longitude Latitude
#    <chr>            <dbl>  <dbl>      <dbl>   <dbl>  <dbl>  <dbl> <dbl>  <dbl> <chr>     <chr>                  <dbl>    <dbl>
#  1 Alabama           3615   3624        2.1    69.0   15.1   41.3    20  50708 South     East South Central     -86.8     32.6
#  2 Alaska             365   6315        1.5    69.3   11.3   66.7   152 566432 West      Pacific               -127.      49.2
#  3 Arizona           2212   4530        1.8    70.6    7.8   58.1    15 113417 West      Mountain              -112.      34.2
#  4 Arkansas          2110   3378        1.9    70.7   10.1   39.9    65  51945 South     West South Central     -92.3     34.7
#  5 California       21198   5114        1.1    71.7   10.3   62.6    20 156361 West      Pacific               -120.      36.5
#  6 Colorado          2541   4884        0.7    72.1    6.8   63.9   166 103766 West      Mountain              -106.      38.7
#  7 Connecticut       3100   5348        1.1    72.5    3.1   56     139   4862 Northeast New England            -72.4     41.6
#  8 Delaware           579   4809        0.9    70.1    6.2   54.6   103   1982 South     South Atlantic         -75.0     38.7
#  9 Florida           8277   4815        1.3    70.7   10.7   52.6    11  54090 South     South Atlantic         -81.7     27.9
# 10 Georgia           4931   4091        2      68.5   13.9   40.6    60  58073 South     South Atlantic         -83.4     32.3
# # … with 40 more rows
colnames(ds)
#  [1] "StateName"  "Population" "Income"     "Illiteracy" "LifeExp"    "Murder"     "HSGrad"     "Frost"      "Area"       "Region"     "Division"   "Longitude"  "Latitude"  
library(dplyr)
head(mtcars)
mtcars %>% head
ds 



# select
# 
ds %>% select(StateName,Frost, Region,Murder)
# # A tibble: 50 x 4
#    StateName   Frost Region    Murder
#    <chr>       <dbl> <chr>      <dbl>
#  1 Alabama        20 South       15.1
#  2 Alaska        152 West        11.3
#  3 Arizona        15 West         7.8
#  4 Arkansas       65 South       10.1
#  5 California     20 West        10.3
#  6 Colorado      166 West         6.8
#  7 Connecticut   139 Northeast    3.1
#  8 Delaware      103 South        6.2
#  9 Florida        11 South       10.7
# 10 Georgia        60 South       13.9
# # … with 40 more rows

?order
df[,]

states <- ds
states %>% select(StateName,Frost, Region, Murder) %>% arrange(desc(Murder))
# # A tibble: 50 x 4
#    StateName      Frost Region        Murder
#    <chr>          <dbl> <chr>          <dbl>
#  1 Alabama           20 South           15.1
#  2 Georgia           60 South           13.9
#  3 Louisiana         12 South           13.2
#  4 Mississippi       50 South           12.5
#  5 Texas             35 South           12.2
#  6 South Carolina    65 South           11.6
#  7 Nevada           188 West            11.5
#  8 Alaska           152 West            11.3
#  9 Michigan         125 North Central   11.1
# 10 North Carolina    80 South           11.1
# # … with 40 more rows
?select
?spread
?gather

# with regular expressions
states %>% select(starts_with('Fr'))
states %>% select(starts_with('Fr'), contains('tude'))

# # A tibble: 50 x 3
#    Frost Longitude Latitude
#    <dbl>     <dbl>    <dbl>
#  1    20     -86.8     32.6
#  2   152    -127.      49.2
#  3    15    -112.      34.2
#  4    65     -92.3     34.7
#  5    20    -120.      36.5
#  6   166    -106.      38.7
#  7   139     -72.4     41.6
#  8   103     -75.0     38.7
#  9    11     -81.7     27.9
# 10    60     -83.4     32.3
# # … with 40 more rows

ds %>% 	select(matches('Pop|Fr'))
# # A tibble: 50 x 2
#    Population Frost
#         <dbl> <dbl>
#  1       3615    20
#  2        365   152
#  3       2212    15
#  4       2110    65
#  5      21198    20
#  6       2541   166
#  7       3100   139
#  8        579   103
#  9       8277    11
# 10       4931    60
# # … with 40 more rows

ds %>% .$Population %>% mean
f  <- . %>% sum %>% sqrt

ds %>% select(Population) %>% f
sqrt(sum(ds$Population))
library(magrittr)
ds %$% f(Population)

ds
# rename(new = old)
states
# # A tibble: 50 x 13
#    StateName   Population Income Illiteracy LifeExp Murder HSGrad Frost   Area Region    Division           Longitude Latitude
#    <chr>            <dbl>  <dbl>      <dbl>   <dbl>  <dbl>  <dbl> <dbl>  <dbl> <chr>     <chr>                  <dbl>    <dbl>
#  1 Alabama           3615   3624        2.1    69.0   15.1   41.3    20  50708 South     East South Central     -86.8     32.6
#  2 Alaska             365   6315        1.5    69.3   11.3   66.7   152 566432 West      Pacific               -127.      49.2
#  3 Arizona           2212   4530        1.8    70.6    7.8   58.1    15 113417 West      Mountain              -112.      34.2
#  4 Arkansas          2110   3378        1.9    70.7   10.1   39.9    65  51945 South     West South Central     -92.3     34.7
#  5 California       21198   5114        1.1    71.7   10.3   62.6    20 156361 West      Pacific               -120.      36.5
#  6 Colorado          2541   4884        0.7    72.1    6.8   63.9   166 103766 West      Mountain              -106.      38.7
#  7 Connecticut       3100   5348        1.1    72.5    3.1   56     139   4862 Northeast New England            -72.4     41.6
#  8 Delaware           579   4809        0.9    70.1    6.2   54.6   103   1982 South     South Atlantic         -75.0     38.7
#  9 Florida           8277   4815        1.3    70.7   10.7   52.6    11  54090 South     South Atlantic         -81.7     27.9
# 10 Georgia           4931   4091        2      68.5   13.9   40.6    60  58073 South     South Atlantic         -83.4     32.3
# # … with 40 more rows
ds %>% rename(cannotread = Illiteracy, LifeExpectancy = LifeExp)
# # A tibble: 50 x 13
#    StateName   Population Income cannotread LifeExpectancy Murder HSGrad Frost   Area Region    Division           Longitude Latitude
#    <chr>            <dbl>  <dbl>      <dbl>          <dbl>  <dbl>  <dbl> <dbl>  <dbl> <chr>     <chr>                  <dbl>    <dbl>
#  1 Alabama           3615   3624        2.1           69.0   15.1   41.3    20  50708 South     East South Central     -86.8     32.6
#  2 Alaska             365   6315        1.5           69.3   11.3   66.7   152 566432 West      Pacific               -127.      49.2
#  3 Arizona           2212   4530        1.8           70.6    7.8   58.1    15 113417 West      Mountain              -112.      34.2
#  4 Arkansas          2110   3378        1.9           70.7   10.1   39.9    65  51945 South     West South Central     -92.3     34.7
#  5 California       21198   5114        1.1           71.7   10.3   62.6    20 156361 West      Pacific               -120.      36.5
#  6 Colorado          2541   4884        0.7           72.1    6.8   63.9   166 103766 West      Mountain              -106.      38.7
#  7 Connecticut       3100   5348        1.1           72.5    3.1   56     139   4862 Northeast New England            -72.4     41.6
#  8 Delaware           579   4809        0.9           70.1    6.2   54.6   103   1982 South     South Atlantic         -75.0     38.7
#  9 Florida           8277   4815        1.3           70.7   10.7   52.6    11  54090 South     South Atlantic         -81.7     27.9
# 10 Georgia           4931   4091        2             68.5   13.9   40.6    60  58073 South     South Atlantic         -83.4     32.3
# # … with 40 more rows

states %>% rename(pop = Population)

# massive homework 5 hint

!grepl("South",states$StateName)
#  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
# [27] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
states[!grepl("South",states$StateName),]


# # A tibble: 2 x 13
#   StateName      Population Income Illiteracy LifeExp Murder HSGrad Frost  Area Region        Division           Longitude Latitude
#   <chr>               <dbl>  <dbl>      <dbl>   <dbl>  <dbl>  <dbl> <dbl> <dbl> <chr>         <chr>                  <dbl>    <dbl>
# 1 South Carolina       2816   3635        2.3    68.0   11.6   37.8    65 30225 South         South Atlantic         -80.5     33.6
# 2 South Dakota          681   4167        0.5    72.1    1.7   53.3   172 75955 North Central West North Central     -99.7     44.3


states %>% select(StateName,Population, Illiteracy,Income,Region) %>% filter(Illiteracy < 2, Population == 365)
# # A tibble: 1 x 5
#   StateName Population Illiteracy Income Region
#   <chr>          <dbl>      <dbl>  <dbl> <chr> 
# 1 Alaska           365        1.5   6315 West  
states2 <- ds %>% select(Population, Illiteracy, Income, Region) 
head(states2)
# # A tibble: 6 x 4
#   Population Illiteracy Income Region
#        <dbl>      <dbl>  <dbl> <chr> 
# 1       3615        2.1   3624 South 
# 2        365        1.5   6315 West  
# 3       2212        1.8   4530 West  
# 4       2110        1.9   3378 South 
# 5      21198        1.1   5114 West  
# 6       2541        0.7   4884 West  
states2 %>% filter(Region == 'Northeast')
# # A tibble: 9 x 4
#   Population Illiteracy Income Region   
#        <dbl>      <dbl>  <dbl> <chr>    
# 1       3100        1.1   5348 Northeast
# 2       1058        0.7   3694 Northeast
# 3       5814        1.1   4755 Northeast
# 4        812        0.7   4281 Northeast
# 5       7333        1.1   5237 Northeast
# 6      18076        1.4   4903 Northeast
# 7      11860        1     4449 Northeast
# 8        931        1.3   4558 Northeast
# 9        472        0.6   3907 Northeast

states2 %>% filter(Region == 'Northeast' | Region  == 'West'| Region == 'South')
states2 %>% filter(Region %in% c('Northeast','West','South')) %>% data.frame

# Mutate with numbers
# new column = function of other columns
states2 %>% mutate(IncPop = Income/Population)

# 2015
# name count 

# 2016
# name count

# allnames
# name count.x count.y, 

# ----mutate ---->
# name count.x count.y total


# allnames <- allnames %>% mutate(total = count.x + count.y)
# equivalent to
# allnames$total = allnames$count.x + allnames$count.y


# # A tibble: 50 x 5
#    Population Illiteracy Income Region    IncPop
#         <dbl>      <dbl>  <dbl> <chr>      <dbl>
#  1       3615        2.1   3624 South      1.00 
#  2        365        1.5   6315 West      17.3  
#  3       2212        1.8   4530 West       2.05 
#  4       2110        1.9   3378 South      1.60 
#  5      21198        1.1   5114 West       0.241
#  6       2541        0.7   4884 West       1.92 
#  7       3100        1.1   5348 Northeast  1.73 
#  8        579        0.9   4809 South      8.31 
#  9       8277        1.3   4815 South      0.582
# 10       4931        2     4091 South      0.830
# # … with 40 more rows
# Mutate with ifelse
# Mutate with case_when
# Mutate with gsub

states %>% mutate(Region = gsub("^S","J",Region), StateName = gsub("a$","s",StateName))
# # A tibble: 50 x 13
#    StateName   Population Income Illiteracy LifeExp Murder HSGrad Frost   Area Region    Division           Longitude Latitude
#    <chr>            <dbl>  <dbl>      <dbl>   <dbl>  <dbl>  <dbl> <dbl>  <dbl> <chr>     <chr>                  <dbl>    <dbl>
#  1 Alabams           3615   3624        2.1    69.0   15.1   41.3    20  50708 Jouth     East South Central     -86.8     32.6
#  2 Alasks             365   6315        1.5    69.3   11.3   66.7   152 566432 West      Pacific               -127.      49.2
#  3 Arizons           2212   4530        1.8    70.6    7.8   58.1    15 113417 West      Mountain              -112.      34.2
#  4 Arkansas          2110   3378        1.9    70.7   10.1   39.9    65  51945 Jouth     West South Central     -92.3     34.7
#  5 Californis       21198   5114        1.1    71.7   10.3   62.6    20 156361 West      Pacific               -120.      36.5
#  6 Colorado          2541   4884        0.7    72.1    6.8   63.9   166 103766 West      Mountain              -106.      38.7
#  7 Connecticut       3100   5348        1.1    72.5    3.1   56     139   4862 Northeast New England            -72.4     41.6
#  8 Delaware           579   4809        0.9    70.1    6.2   54.6   103   1982 Jouth     South Atlantic         -75.0     38.7
#  9 Florids           8277   4815        1.3    70.7   10.7   52.6    11  54090 Jouth     South Atlantic         -81.7     27.9
# 10 Georgis           4931   4091        2      68.5   13.9   40.6    60  58073 Jouth     South Atlantic         -83.4     32.3
# # … with 40 more rows
# Some basic grouping 
# Chain time (also arrAangA)
df <- mtcars
is_whole <- function(x) {
  all(floor(x) == x)

}
df %>% select_if( is_whole, toupper)
?toupper

ds %>% select(-Division, -StateName, -matches('itude$'))
# # A tibble: 50 x 9
#    Population Income Illiteracy LifeExp Murder HSGrad Frost   Area Region   
#         <dbl>  <dbl>      <dbl>   <dbl>  <dbl>  <dbl> <dbl>  <dbl> <chr>    
#  1       3615   3624        2.1    69.0   15.1   41.3    20  50708 South    
#  2        365   6315        1.5    69.3   11.3   66.7   152 566432 West     
#  3       2212   4530        1.8    70.6    7.8   58.1    15 113417 West     
#  4       2110   3378        1.9    70.7   10.1   39.9    65  51945 South    
#  5      21198   5114        1.1    71.7   10.3   62.6    20 156361 West     
#  6       2541   4884        0.7    72.1    6.8   63.9   166 103766 West     
#  7       3100   5348        1.1    72.5    3.1   56     139   4862 Northeast
#  8        579   4809        0.9    70.1    6.2   54.6   103   1982 South    
#  9       8277   4815        1.3    70.7   10.7   52.6    11  54090 South    
# 10       4931   4091        2      68.5   13.9   40.6    60  58073 South    
# # … with 40 more rows

ds %>% select(-Division, -StateName, -matches('itude$'))%>%
  gather(Measure, Value, -Region)%>% data.frame


ds %>% select(-Division, -Region, -matches('itude$'))%>%
  gather(Measure, Value, -StateName) -> messy
?tidyr
messy
messy %>%	spread(Measure, Value)
?spread
# Summaries
mtcars %>% group_by(cyl)
ds %>%
  select(-Division, -Region, -StateName) ->ds1
ds1
ds1 %>%gather(Measure, Value) -> ds2
ds2 %>%
  group_by(Measure) %>%
  summarise(Mean = mean(Value),
            SD = sd(Value),
            Median = median(Value),
            SampleSize = n())
  beer %>% group_by(type) %>% summarise(Mean = mean(ABV))
  # show off our broomies  
  library(broom)
  data(swiss)
  swiss
  swiss.model <- lm(Fertility ~ ., data = swiss)
  tidy(swiss.model)
  # gather (Key, Value, Column, column,...)
  swiss %>%
    gather(key = Indep, value = Xvalue, Agriculture, Fertility) -> swiss1
  swiss1

  swiss1 %>% filter(Indep == 'Agriculture', Xvalue == 17.0)
  swiss1 %>%gather(Dep, Yvalue, Education, Catholic)-> swiss2
  swiss2 %>% spread(Dep, Yvalue) %>% spread(Indep, Xvalue)
  group_by(Dep, Indep) %>% 
    do(tidy(lm(Yvalue ~ Xvalue + Infant.Mortality + Examination, data = .)))

  head(swiss)
  library(tidyverse)
  library(broom)
  data(swiss)
  swiss %>%
    gather( Indep, Xvalue, Agriculture, Fertility)  %>%gather(gather(Dep, Yvalue, Education, Catholic)) %>%group_by(Dep, Indep) %>% do(tidy(lm(Yvalue ~ Xvalue + Infant.Mortality + Examination, data = .)))
  library(broom)
  # Using the swiss practice dataset.
  swiss %>%
    gather(Indep, Xvalue, Fertility, Agriculture) %>%
    gather(Dep, Yvalue, Education, Catholic) %>% 
    group_by(Dep, Indep) %>% 
    do(tidy(lm(Yvalue ~ Xvalue + Infant.Mortality + Examination, data = .)))
