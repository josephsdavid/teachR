library(caret)
data(BreastCancer, package = "mlbench")

bc  <-  BreastCancer


makeSampleIndices <- function(x, perc, seed = NULL) {
  set.seed(seed)
  smpSize <- floor(perc * nrow(x))
  return(sample(seq_len(nrow(x)), size = smpSize))
}

bc$Id <- NULL
trainInd <- makeSampleIndices(bc, 0.7, seed = 47)

training <- bc[trainInd,]

testing <- bc[trainInd,]

# check for a class imbalance!!!

# show off automated plots


model <- train(Class ~ .)
