library(mlbench)
library(caret)
library(mlr)
library(tidyverse)
library(ggthemes)
library(gplots)
library(randomForest)


library(skimr) # skimr is sweet

data(BostonHousing)
head(BostonHousing)
#      crim zn indus chas   nox    rm  age    dis rad tax ptratio      b
# 1 0.00632 18  2.31    0 0.538 6.575 65.2 4.0900   1 296    15.3 396.90
# 2 0.02731  0  7.07    0 0.469 6.421 78.9 4.9671   2 242    17.8 396.90
# 3 0.02729  0  7.07    0 0.469 7.185 61.1 4.9671   2 242    17.8 392.83
# 4 0.03237  0  2.18    0 0.458 6.998 45.8 6.0622   3 222    18.7 394.63
# 5 0.06905  0  2.18    0 0.458 7.147 54.2 6.0622   3 222    18.7 396.90
# 6 0.02985  0  2.18    0 0.458 6.430 58.7 6.0622   3 222    18.7 394.12
#   lstat medv
# 1  4.98 24.0
# 2  9.14 21.6
# 3  4.03 34.7
# 4  2.94 33.4
# 5  5.33 36.2
# 6  5.21 28.7
length(BostonHousing)
# [1] 14
skim(BostonHousing)
# Skim summary statistics
#  n obs: 506 
#  n variables: 14 
# 
# ── Variable type:factor ──────────────────────────────────────────────────
#  variable missing complete   n n_unique           top_counts ordered
#      chas       0      506 506        2 0: 471, 1: 35, NA: 0   FALSE
# 
# ── Variable type:numeric ─────────────────────────────────────────────────
#  variable missing complete   n   mean     sd       p0     p25    p50
#       age       0      506 506  68.57  28.15   2.9     45.02   77.5 
#         b       0      506 506 356.67  91.29   0.32   375.38  391.44
#      crim       0      506 506   3.61   8.6    0.0063   0.082   0.26
#       dis       0      506 506   3.8    2.11   1.13     2.1     3.21
#     indus       0      506 506  11.14   6.86   0.46     5.19    9.69
#     lstat       0      506 506  12.65   7.14   1.73     6.95   11.36
#      medv       0      506 506  22.53   9.2    5       17.02   21.2 
#       nox       0      506 506   0.55   0.12   0.39     0.45    0.54
#   ptratio       0      506 506  18.46   2.16  12.6     17.4    19.05
#       rad       0      506 506   9.55   8.71   1        4       5   
#        rm       0      506 506   6.28   0.7    3.56     5.89    6.21
#       tax       0      506 506 408.24 168.54 187      279     330   
#        zn       0      506 506  11.36  23.32   0        0       0   
#     p75   p100     hist
#   94.07 100    ▁▂▂▂▂▂▃▇
#  396.23 396.9  ▁▁▁▁▁▁▁▇
#    3.68  88.98 ▇▁▁▁▁▁▁▁
#    5.19  12.13 ▇▅▃▃▂▁▁▁
#   18.1   27.74 ▃▆▅▁▁▇▁▁
#   16.96  37.97 ▆▇▆▅▂▁▁▁
#   25     50    ▂▅▇▆▂▂▁▁
#    0.62   0.87 ▇▆▇▆▃▅▁▁
#   20.2   22    ▁▂▂▂▅▅▇▃
#   24     24    ▂▇▁▁▁▁▁▅
#    6.62   8.78 ▁▁▂▇▇▂▁▁
#  666    711    ▃▇▂▅▁▁▁▆
#   12.5  100    ▇▁▁▁▁▁▁▁


# lapply(df, sd)

# step 0
# get rid of zero variance variables (ones that only have one value)
# check and make sure categorical variables are stored as factors
# use common sense!!!!

library(corrplot) 
library(tidyverse)

# library(purrr)

# cor function: Calculate correlation between columns of a df or matrix
# conditions:
# cant handle not numeric
# cant handle NAs


bh <- BostonHousing

bh2 <- bh
bh2$notNum <- "cat"
bh2 %>% keep(is.numeric) %>% head
# opposite of keep: discard

#purrr
# keep(condition)

library(corrplot)
corrplot


bh %>% keep(is.numeric) %>% na.omit %>% cor %>% corrplot("upper", addCoef.col = "white", number.digits = 2,
			 number.cex = 0.5, method="square",
			 order="hclust", title="Variable Corr Heatmap",
			 tl.srt=45, tl.cex = 0.8)


# function to do this all in one go
correlator  <-  function(df){
	df %>%
		keep(is.numeric) %>%
		tidyr::drop_na() %>%
		cor %>%
		corrplot("upper", addCoef.col = "white", number.digits = 2,
			 number.cex = 0.5, method="square",
			 order="hclust", title="Variable Corr Heatmap",
			 tl.srt=45, tl.cex = 0.8)
}


# correlation analysis
# usage: this is step 1! Batch elimination of numeric variables
# this can narrow things down a lot
# do not forget to use human logic


# key plots

# x : y
# numeric : categorical

data(mtcars)

head(mtcars)
#                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
# Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
# Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
# Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
# Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
# Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
# Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$vs <- as.factor(mtcars$vs)
mtcars$am <- as.factor(mtcars$am)
mtcars$gear <- as.factor(mtcars$gear)
mtcars$carb <- as.factor(mtcars$carb)

skim(mtcars)


# x : y
# numeric : categorical

mtcars$rvar <- rnorm(nrow(mtcars))

length(unique(mtcars$vs))
# [1] 2

ggplot(data = mtcars) + geom_density(aes_string(x = "mpg", fill = "am"), alpha = 0.5)

# automated EDA!!!!!!!!!!!!
# step 1, save target variable name
target <- "am"
# step 2, save explanator variable names
numvars <- mtcars %>% keep(is.numeric) %>% colnames
# [1] "mpg"  "disp" "hp"   "drat" "wt"   "qsec" "rvar"


numplot <- function(df, explan, resp) {
  ggplot(data = df) + geom_density(aes_string(x = explan, fill = resp), alpha = 0.5)
}

numplot(mtcars, explan = "mpg", resp = "am")

plotlist <- lapply(numvars, function(x) numplot(mtcars, x, "am"))
library(cowplot)
plot_grid(plotlist = plotlist)


png()
lapply(numvars, function(x) numplot(mtcars, x, "am"))
dev.off()



# categorical vs categorical
str(mtcars)
# 'data.frame':	32 obs. of  12 variables:
#  $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
#  $ cyl : Factor w/ 3 levels "4","6","8": 2 2 1 2 3 2 3 1 1 2 ...
#  $ disp: num  160 160 108 258 360 ...
#  $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
#  $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
#  $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
#  $ qsec: num  16.5 17 18.6 19.4 17 ...
#  $ vs  : Factor w/ 2 levels "0","1": 1 1 2 2 1 2 1 2 2 2 ...
#  $ am  : Factor w/ 2 levels "0","1": 2 2 2 1 1 1 1 1 1 1 ...
#  $ gear: Factor w/ 3 levels "3","4","5": 2 2 2 1 1 1 1 2 2 2 ...
#  $ carb: Factor w/ 6 levels "1","2","3","4",..: 4 4 1 1 2 1 4 2 2 4 ...
#  $ rvar: num  0.584 -0.573 0.582 -0.221 0.409 ...
# NULL


ggplot(data = mtcars) + geom_bar(aes(x = cyl, fill = am), position = "fill", alpha = 0.9) + coord_flip()


ones <- rep(1, nrow(mtcars))
zeroes <- rep(0, nrow(mtcars))
onezeroes <- c(ones, zeroes)

mtcars$rcat <- sample(onezeroes, nrow(mtcars))


ggplot(data = mtcars) + geom_bar(aes(x = rcat, fill = am), position = "fill", alpha = 0.9) + coord_flip()

# step 1: Name target variable:

target <- "am"

# step 2: name explanatory vars

expls <- mtcars %>% keep(is.factor) %>% colnames


catplot <- function(df, x,y){
  ggplot(data = df, aes_string(x = x, fill = y)) + 
    geom_bar(position = "fill", alpha = 0.9) + 
    coord_flip()
}


plotlist2 <- lapply(expls, function(x) catplot(mtcars, x, target))
plot_grid(plotlist = plotlist2)
