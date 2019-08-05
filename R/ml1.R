library(caret)
library(FNN)
library(fastNaiveBayes)
library(tidyverse)
library(doParallel)
library(foreach)
library(functional)

## reading data
dataurl <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"
wine <- read_csv(dataurl, col_names = F)

## Actual columns
good_cols <- c("class",
               "alcohol",
               'malic_acid',
               'ash',
               'alkalinity',
               'magnesium',
               'total_phenols',
               'flavanoids',
               'nonflavonoids_phenols',
               'proanthocyanins',
               'color_intensity',
               'hue',
               'dilution',
               'proline'
)

## Column rename (data processing)
fix_cols <- function(df){
  colnames(df) <- good_cols
  df$class <- (df$class)
  df
}
wine <- fix_cols(wine)

## Train test split
split <- function(df, p = 0.75, list = FALSE, ...) {
  train_ind <- createDataPartition(df[[1]], p = p, list = list)
  cat("creating training dataset...\n")
  training <<- df[train_ind, ]
  cat("completed training dataset, creating test set\n")
  test <<- df[-train_ind, ]
  cat("done")
}
split(wine)

## Making Model
train_knn <- function(k) {
  FNN::knn(train = training[-1], test = test[-1],  cl = as.factor(training$class), k)
}

## Making metrics
conmat <- function(predicted, expected){
  cm <- as.matrix(table(Actual = as.factor(expected$class), Predicted = predicted))
  cm
}
f1_score <- function(predicted, expected, positive.class="1") {
  cm = conmat(predicted, expected)

  precision <- diag(cm) / colSums(cm)
  recall <- diag(cm) / rowSums(cm)
  f1 <-  ifelse(precision + recall == 0, 0, 2 * precision * recall / (precision + recall))

  #Assuming that F1 is zero when it's not possible compute it
  f1[is.na(f1)] <- 0

  #Binary F1 or Multi-class macro-averaged F1
  ifelse(nlevels(expected) == 2, f1[positive.class], mean(f1))
}

accuracy <- function(predicted, expected){
  cm <- conmat(predicted, expected)
  sum(diag(cm)/length(test$class))
}

## Testing
3 %>% train_knn %>% conmat(test)
3 %>% train_knn %>% accuracy(test)
3 %>% train_knn %>% f1_score(test)
get_scores <- function(k){
  predictions <- train_knn(k)
  f1 <- f1_score(predictions,test)
  acc <- accuracy(predictions,test)
  scores <- c(accuracy = acc, f1 = f1)	
  scores
}
get_scores(3)


## Tuning K without a grid search

registerDoParallel(detectCores() -1)

# parallel KNN for k 1:33
# see how it is literally instantaneous
foreach(i = 1:33, .combine = "rbind", .multicombine = T) %dopar% get_scores(i) %>% as_tibble -> scores




scores$index <- 1:33

library(ggplot2)
library(reshape2)

ggplot(data = melt(scores, id.vars = "index", variable.name = "metric"), aes(index, value)) + geom_line(aes(color = metric))

# making a pipeline for knn predictions
readfile <- function(url) read_csv(url, col_names = F)

split2 <- function(df, p = 0.75, list = FALSE, ...) {
  train_ind <- createDataPartition(df[[1]], p = p, list = list)
  training <- df[train_ind, ]
  test <- df[-train_ind, ]
  list(training = training, test = test)
}
res <- split2(wine)

make_knn <- function(k) {
  function(lst) {
    training <- lst$training
    test <- lst$test
    train_knn(k)
  }
}

knn11 <- make_knn(11)
knn_pipeline <- Compose(readfile, fix_cols, split2,knn11)
knn_pipeline(dataurl)


caret_knn <- function(k) {
  knn3Train(train = training[-1], test = test[-1], cl = as.factor(training$class), k = k, prob = F)

}
caret_knn(11)
train_knn(11)
