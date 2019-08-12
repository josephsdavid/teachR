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
length(BostonHousing)
str(BostonHousing)
skim(BostonHousing)
# Skim summary statistics
#  n obs: 506 
#  n variables: 14 
# 
# ── Variable type:factor ──────────────────────────────────────────────────
#  variable missing complete   n n_unique                     top_counts
#      chas       0      506 506        2           0: 471, 1: 35, NA: 0
#       rad       0      506 506        9 24: 132, 5: 115, 4: 110, 3: 38
#  ordered
#    FALSE
#    FALSE
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
#    6.62   8.78 ▁▁▂▇▇▂▁▁
#  666    711    ▃▇▂▅▁▁▁▆
#   12.5  100    ▇▁▁▁▁▁▁▁


## Define a function using AES_STRING to put strings in ggplot objects
scatterplotfun <- function(df, x,y){
  ggplot(data = df, aes_string(x = x, y = y))+ geom_point()
}

## Define the name of the Y variable
yname  <-  "medv"

# Get the names off the numeric x variables
BostonNumeric  <- BostonHousing %>% keep(is.numeric)
xname  <-  names(BostonNumeric[-ncol(BostonNumeric)])

# ggplot with lapply
lapply(xname, function(x) scatterplotfun(df = BostonNumeric, x = x, y = yname))
plist <- lapply(xname, function(x) scatterplotfun(df = BostonNumeric, x = x, y = yname))

library(cowplot)
plot_grid(plotlist = plist)

# make this a factor to show an example
BostonHousing$rad  <- as.factor(BostonHousing$rad)
str(BostonHousing)
# 'data.frame':	506 obs. of  14 variables:
#  $ crim   : num  0.00632 0.02731 0.02729 0.03237 0.06905 ...
#  $ zn     : num  18 0 0 0 0 0 12.5 12.5 12.5 12.5 ...
#  $ indus  : num  2.31 7.07 7.07 2.18 2.18 2.18 7.87 7.87 7.87 7.87 ...
#  $ chas   : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
#  $ nox    : num  0.538 0.469 0.469 0.458 0.458 0.458 0.524 0.524 0.524 0.524 ...
#  $ rm     : num  6.58 6.42 7.18 7 7.15 ...
#  $ age    : num  65.2 78.9 61.1 45.8 54.2 58.7 66.6 96.1 100 85.9 ...
#  $ dis    : num  4.09 4.97 4.97 6.06 6.06 ...
#  $ rad    : Factor w/ 9 levels "1","2","3","4",..: 1 2 2 3 3 3 5 5 5 5 ...
#  $ tax    : num  296 242 242 222 222 222 311 311 311 311 ...
#  $ ptratio: num  15.3 17.8 17.8 18.7 18.7 18.7 15.2 15.2 15.2 15.2 ...
#  $ b      : num  397 397 393 395 397 ...
#  $ lstat  : num  4.98 9.14 4.03 2.94 5.33 ...
#  $ medv   : num  24 21.6 34.7 33.4 36.2 28.7 22.9 27.1 16.5 18.9 ...
# NULL


# visualizing factor vs factor

# reverse levels so we can read it in a human way
# save column to vector
chas  <- BostonHousing$chas
levels(chas)
# [1] "0" "1"
rev(levels(chas))
# [1] "1" "0"
BostonHousing$chas  <- factor(chas, levels = rev(levels(chas)))

# position = "fill"  is the key here
# please make your plots look good and theme them consistently
ggplot(BostonHousing, aes(x = rad, fill = chas)) +
  geom_bar(alpha = 0.9, position = "fill") +
  coord_flip() +
  labs(x = "rad", y = "Proportion", title = "Income bias based on Education",
       subtitle = "Stacked bar plot") + 
theme_hc() + scale_fill_hc()

# coreelation plot function we defined last week
library(corrplot)
correlator  <-  function(df){
	df %>%
		keep(is.numeric) %>%
		tidyr::drop_na() %>%
		cor %>%
		corrplot( addCoef.col = "white", number.digits = 2,
			 number.cex = 0.5, method="square",
			 order="hclust", title="Variable Corr Heatmap",
			 tl.srt=45, tl.cex = 0.8)
}


BostonHousing %>%keep(is.numeric) %>%tidyr::drop_na() %>%cor 

## interpret this
correlator(BostonHousing)

## Now you do your LMs

## Useful variable importance plot
## Look at the plot on the left
library(randomForest)
rfreg <- randomForest(medv ~., data = BostonHousing, impotance = TRUE)
varImpPlot(rfreg)



# amazing library for categoricals/factors. No examples here but it rocks
library(forcats)


## classification dataset

data(BreastCancer)
bc <- BreastCancer
skim(bc)
# Skim summary statistics
#  n obs: 699 
#  n variables: 11 
# 
# ── Variable type:character ───────────────────────────────────────────────
#  variable missing complete   n min max empty n_unique
#        Id       0      699 699   5   8     0      645
# 
# ── Variable type:factor ──────────────────────────────────────────────────
#         variable missing complete   n n_unique
#      Bare.nuclei      16      683 699       10
#      Bl.cromatin       0      699 699       10
#       Cell.shape       0      699 699       10
#        Cell.size       0      699 699       10
#     Cl.thickness       0      699 699       10
#            Class       0      699 699        2
#     Epith.c.size       0      699 699       10
#    Marg.adhesion       0      699 699       10
#          Mitoses       0      699 699        9
#  Normal.nucleoli       0      699 699       10
#                     top_counts ordered
#  1: 402, 10: 132, 2: 30, 5: 30   FALSE
#  2: 166, 3: 165, 1: 152, 7: 73   FALSE
#   1: 353, 2: 59, 10: 58, 3: 56    TRUE
#   1: 384, 10: 67, 3: 52, 2: 45    TRUE
#  1: 145, 5: 130, 3: 108, 4: 80    TRUE
#      ben: 458, mal: 241, NA: 0   FALSE
#    2: 386, 3: 72, 4: 48, 1: 47    TRUE
#   1: 407, 2: 58, 3: 58, 10: 55    TRUE
#   1: 579, 2: 35, 3: 33, 10: 14   FALSE
#   1: 443, 10: 61, 3: 44, 2: 36   FALSE

# 16 missing

# get rid of ID column, get rid of NAs
bc  <- bc %>% select(-Id) %>% tidyr::drop_na()
str(bc)
# 'data.frame':	683 obs. of  10 variables:
#  $ Cl.thickness   : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 5 5 3 6 4 8 1 2 2 4 ...
#  $ Cell.size      : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 1 4 1 8 1 10 1 1 1 2 ...
#  $ Cell.shape     : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 1 4 1 8 1 10 1 2 1 1 ...
#  $ Marg.adhesion  : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 1 5 1 1 3 8 1 1 1 1 ...
#  $ Epith.c.size   : Ord.factor w/ 10 levels "1"<"2"<"3"<"4"<..: 2 7 2 3 2 7 2 2 2 2 ...
#  $ Bare.nuclei    : Factor w/ 10 levels "1","2","3","4",..: 1 10 2 4 1 10 10 1 1 1 ...
#  $ Bl.cromatin    : Factor w/ 10 levels "1","2","3","4",..: 3 3 3 3 3 9 3 3 1 2 ...
#  $ Normal.nucleoli: Factor w/ 10 levels "1","2","3","4",..: 1 2 1 7 1 7 1 1 1 1 ...
#  $ Mitoses        : Factor w/ 9 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 5 1 ...
#  $ Class          : Factor w/ 2 levels "benign","malignant": 1 1 1 1 1 2 1 1 1 1 ...
glimpse(bc)
library(pander)
skim(bc) %>% pander

# practice aes string and categorical plot here

# catplot = category plot
catplot <- function(df, x,y){
  ggplot(data = df, aes_string(x = x, fill = y)) + 
    geom_bar(position = "fill", alpha = 0.9) + 
    coord_flip()
}

## Define the name of the Y variable
yname  <-  "Class"

# Get the names off the numeric x variables
xname  <-  names(bc[-ncol(bc)])

# ggplot with lapply
lapply(xname, function(x) catplot(df = bc, x = x, y = yname))
plist <- lapply(xname, function(x) catplot(df = bc, x = x, y = yname))
plist
cowplot::plot_grid(plotlist = plist)

# superassignment split practice
split <- function(df, p = 0.75, list = FALSE, ...) {
	train_ind <- createDataPartition(df[[1]], p = p, list = list)
	cat("creating training dataset...\n")
	training <<- df[train_ind, ]
	cat("completed training dataset, creating test set\n")
	test <<- df[-train_ind, ]
	cat("done")
}

split(bc)


# 

library(doParallel)
cores <- parallel::detectCores()
# [1] 12

# Generally do one less
workers <- makeCluster(11L)

# register for parallel computation
registerDoParallel(workers)

# train method for optimized specificity
trainMethod <- trainControl( method = "repeatedcv", number = 25, repeats = 5, summaryFunction = twoClassSummary, classProbs = TRUE)


# naive bayes classifier
fit.nb <- train(Class ~ . data = training, method = "nb", metric = "Spec", trControl = trainMethod)

# knn classifier
fit.knn <- train(Class ~ . data = training, method = "knn", metric = "Spec", trControl = trainMethod)

# learn more about caret
browseURL("https://topepo.github.io/caret/index.html")
# if this fails try:
# getOption("browser")
# options(browser = "firefox")
