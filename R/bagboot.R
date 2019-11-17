library(party)
library(ranger)
#library(randomforest)
library(gbm)


data(BreastCancer, package = "mlbench")
bc <- BreastCancer

head(bc)
#        Id Cl.thickness Cell.size Cell.shape Marg.adhesion Epith.c.size Bare.nuclei Bl.cromatin
# 1 1000025            5         1          1             1            2           1           3
# 2 1002945            5         4          4             5            7          10           3
# 3 1015425            3         1          1             1            2           2           3
# 4 1016277            6         8          8             1            3           4           3
# 5 1017023            4         1          1             3            2           1           3
# 6 1017122            8        10         10             8            7          10           9
#   Normal.nucleoli Mitoses     Class
# 1               1       1    benign
# 2               2       1    benign
# 3               1       1    benign
# 4               7       1    benign
# 5               1       1    benign
# 6               7       1 malignant

bc$Id <- NULL

str(bc)
# 'data.frame':	699 obs. of  10 variables:
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
# NULL

# do a train test split

trainInd <- sample(1:nrow(bc), floor(0.7*nrow(bc)))
training<- bc[trainInd,]
testing <- bc[-trainInd,]
tree <- ctree(Class ~ ., data = training)

plot(tree)


predict(tree, newdata = testing, type = "prob")[[1]][2]

plot(tree)


# bias variance tradeoff


# bootstrap = random sample
# it is here
L_tree  <-  list()
n  <-  nrow(df)
for(s in 1:1000){
  idx  <-  sample(1:nrow(training), size = nrow(training), replace = TRUE)
  L_tree[[s]]  <-  ctree(Class ~ ., data = training[idx,])
}


# agg

predict2 <- function(df) {
  res <- data.frame(lapply(1:1000, function(x) {
                  predict(L_tree[[x]], newdata = df, type = "prob")[2]
}))
  (res)
}

preds <- predict2(testing)
preds

head(bc$Class)

preds_numeric <- ifelse(preds <= 0.5, 1, 2)

preds_factor <- factor(preds, levels = c("benign","malignant"))


caret::confusionMatrix(table(testing$Class, preds_factor))


# talk about forests and boosting now, then show an example



# random forest



rf <- randomForest(Class ~ ., data = na.omit(training), importance = TRUE)


varImpPlot(rf)


rfPred <- predict(rf, testing)
rfPred

# boosting 



library(xgboost)
library(dplyr)

features <- training %>% dplyr::select(-Class)
xgb <- xgboost(data = data.matrix(features), label = training$Class, nrounds = 300)


features2 <- testing %>% dplyr::select(-Class) %>% data.matrix
predict(xgb, features2)


library(mlr)


