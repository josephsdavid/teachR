head(mtcars)
#                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
# Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
# Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
# Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
# Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
# Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
# Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
library(tidyverse)
mtcars %>% count(cyl,gear)
# # A tibble: 8 x 3
#     cyl  gear     n
#   <dbl> <dbl> <int>
# 1     4     3     1
# 2     4     4     8
# 3     4     5     2
# 4     6     3     2
# 5     6     4     4
# 6     6     5     1
# 7     8     3    12
# 8     8     5     2
mtcars%>% group_by(cyl) %>% tally
# # A tibble: 3 x 2
#     cyl     n
#   <dbl> <int>
# 1     4    11
# 2     6     7
# 3     8    14
mtcars %>% group_by(gear) %>% summarise(count=n())
# # A tibble: 3 x 2
#    gear count
#   <dbl> <int>
# 1     3    15
# 2     4    12
# 3     5     5

# A functio
sumsqrt <- function(x){
  sqrt(sum(x))
}

mathfun <- function(m,o,p){
  out <- p+o-m
}

df <- data.frame(matrix(1:9,nrow=3))
library(magrittr)
# magrittr is where %>% originally comes from, we have a lot more
# pipe operators which we can show off here

# %<>% assigns the variable as well as pipes
df %<>% rename(x = X1, y = X2, z = X3)
# equivalent to
# df <- df %>% rename(x = X1, y = X2, z = X3)

sumsqrt(df$x)
# [1] 2.44949

mathfun(df$x,df$y,df$z)
# [1] 10 11 12

# Now this is a little hard to run with the %>% because we dont have a tidy ( fun(data = ...)  )
# API
# How can we do this?
# magrittr has a lovely %$% operator, which looks like a swear word or something, but it is a pipe 
# that spreads the dollar sign operator. That is, df %$% (a+b-c) is equivalent to:
# df$a + df$b - df$c

# Let us now show off this new pipe syntax

# bad
df %>% mathfun(.$x, .$y, .$z) 
# This will not run because it is piping df into the function, which doesnt work
# Lets try with our knew dollar sign pipe
df %$% mathfun(x, y, z)
# [1] 10 11 12
# amazing

# We can still chain our pipes together as we do

df %$% mathfun(x,y,z) %>% sumsqrt
# [1] 5.744563

# Finally, we can use pipes and dots for quick alternate function definition
# This is nice for working fast, as well as for something we will cover a bit later,
# function closures (a slightly more advanced R topic)
# Lets try quickly defining a new function with the pipes, by putting a . at the leading enf
# We tell R that we will give it some data later but please remember this function

dotfun  <- . %>% cos %>% sin %>% exp %>% sqrt
dotfun(45)
# [1] 1.284983
dotfun(-56)
# [1] 1.457468
# This is the equivalent of, without pipes
plainfun <- function(x){
  sqrt(exp(sin(cos(x))))
}
plainfun(45)
# [1] 1.284983
plainfun(-56)
# [1] 1.457468

# We can even include the pipes and the dots within our function definition, to write concise functions
