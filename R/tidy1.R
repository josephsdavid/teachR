library(tidyverse)


ds <- read_csv("http://codeasmanuscript.org/states_data.csv")
View(ds)
colnames(ds)
#  [1] "StateName"  "Population" "Income"     "Illiteracy" "LifeExp"    "Murder"     "HSGrad"     "Frost"      "Area"       "Region"     "Division"   "Longitude"  "Latitude"  
library(dplyr)
head(mtcars)
mtcars %>% head
ds 
ds %>% select(StateName,Frost, Region,Murder) %>% arrange(desc(Murder))
?select
?spread
?gather
ds %>% select(starts_with('Fr'), contains('tude'))

ds %>% 	select(matches('Pop|Fr'))

ds %>% .$Population %>% mean
f  <- . %>% sum %>% sqrt

ds %>% select(Population) %>% f
sqrt(sum(ds$Population))
library(magrittr)
ds %$% f(Population)

ds
# rename(new = old)
ds %>% rename(cannotread = Illiteracy, LifeExpectancty = LifeExp)



ds %>% select(StateName,Population, Illiteracy,Income,Region) %>% filter(Illiteracy<2, Population == 365)
ds %>% select(Population, Illiteracy, Income, Region) -> ds_sub
head(ds_sub)
ds_sub %>% filter(Region == 'Northeast')

ds_sub %>% filter(Region == 'Northeast'| Region  == 'West')
ds_sub %>% filter(Region %in% c('Northeast','West','South')) %>% data.frame

# Mutate with numbers
ds_sub %>% mutate(IncPop = Income/Population)
# Mutate with ifelse
?ifelse
# Mutate with case_when
# Mutate with gsub

ds %>% mutate(Region = gsub("^S","J",Region), StateName = gsub("a$","s",StateName)) 
# Some basic grouping 
# Chain time (also arrAangA)
df <- mtcars
is_whole <- function(x) {
	all(floor(x) == x)

}
df %>% select_if( is_whole, toupper)
?toupper
#                     CYL  HP VS AM GEAR CARB
# Mazda RX4             6 110  0  1    4    4
# Mazda RX4 Wag         6 110  0  1    4    4
# Datsun 710            4  93  1  1    4    1
# Hornet 4 Drive        6 110  1  0    3    1
# Hornet Sportabout     8 175  0  0    3    2
# Valiant               6 105  1  0    3    1
# Duster 360            8 245  0  0    3    4
# Merc 240D             4  62  1  0    4    2
# Merc 230              4  95  1  0    4    2
# Merc 280              6 123  1  0    4    4
# Merc 280C             6 123  1  0    4    4
# Merc 450SE            8 180  0  0    3    3
# Merc 450SL            8 180  0  0    3    3
# Merc 450SLC           8 180  0  0    3    3
# Cadillac Fleetwood    8 205  0  0    3    4
# Lincoln Continental   8 215  0  0    3    4
# Chrysler Imperial     8 230  0  0    3    4
# Fiat 128              4  66  1  1    4    1
# Honda Civic           4  52  1  1    4    2
# Toyota Corolla        4  65  1  1    4    1
# Toyota Corona         4  97  1  0    3    1
# Dodge Challenger      8 150  0  0    3    2
# AMC Javelin           8 150  0  0    3    2
# Camaro Z28            8 245  0  0    3    4
# Pontiac Firebird      8 175  0  0    3    2
# Fiat X1-9             4  66  1  1    4    1
# Porsche 914-2         4  91  0  1    5    2
# Lotus Europa          4 113  1  1    5    2
# Ford Pantera L        8 264  0  1    5    4
# Ferrari Dino          6 175  0  1    5    6
# Maserati Bora         8 335  0  1    5    8
# Volvo 142E            4 109  1  1    4    2

# with tidyr( a frined )

ds %>% select(-Division, -StateName, -matches('itude$'))
?gather
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
