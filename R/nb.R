library(caret)
library(fastNaiveBayes)
library(readr)
library(ggplot2)
library(tidyverse)


dataurl <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"

wine <- read.csv(dataurl, header = F)

library(skimr)

skim(wine)
colnames(wine)
#  [1] "V1"  "V2"  "V3"  "V4"  "V5"  "V6"  "V7"  "V8"  "V9"  "V10" "V11"
# [12] "V12" "V13" "V14"
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

unique(wine$V1)
# [1] 1 2 3

wine  <- wine %>% filter(V1 != 3)

unique(wine$V1)
# [1] 1 2
nrow(wine)
# [1] 130
fix_cols <- function(df){
	colnames(df) <- good_cols
	df$class <- as.factor(df$class)
	df
}
wine <- fix_cols(wine)
glimpse(wine)

# train test split

makeSampleIndices <- function(x, perc, seed = NULL) {
  set.seed(seed)
  smpSize <- floor(perc * nrow(x))
  return(sample(seq_len(nrow(x)), size = smpSize))
}


trainInd <- makeSampleIndices(wine, 0.7, seed = 47)

training <- wine[trainInd,]

test <- wine[-trainInd,]

nrow(training)
# [1] 91
nrow(test)
# [1] 39

nrow(training)/nrow(wine)
# [1] 0.7

nrow(test)/nrow(wine)
# [1] 0.3

# response is a factor
# explanatory is a number
# density plot
# response is a factor
# explanatory is a number
# density plotss
ggplot(data = training, aes(x = malic_acid, fill = class)) + geom_density()
ggplot(data = training, aes(x = alkalinity, fill = class)) + geom_density()
ggplot(data = training, aes(x = ash, fill = class)) + geom_density()
ggplot(data = training, aes(x = magnesium, fill = class)) + geom_density()






# looping through seeds

# for loop













# automate 

numPlot <- function(dat, x, y){
  ggplot(data = dat, aes_string(x = x, fill =y)) + geom_density()
}


response <- "class"

# you would worry about types here


# lapply through column names

plotList <- lapply(colnames(training), function(x) numPlot(training, x, response))

plotList

library(cowplot)

plot_grid(plotlist = plotList, nrow = 3)



# show off automated plots


# set up model assessment


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
get_scores <- function(predictions, test){
	f1 <- f1_score(predictions,test)
	acc <- accuracy(predictions,test)
	scores <- c(accuracy = acc, f1 = f1)	
	scores
}
pander(get_scores(test_pred, test))


# fit with caret

# define training method

trainMethod <- trainControl(method = "cv", number = 3)



nb_fit <- train(class ~ ., data = training,
		trControl = trainMethod,
		method = "nb",
		tuneLength = 10
)
nb_fit
# k-Nearest Neighbors 
# 
# 91 samples
# 13 predictors
#  2 classes: '1', '2' 
# 
# No pre-processing
# Resampling: Cross-Validated (3 fold) 
# Summary of sample sizes: 60, 61, 61 
# Resampling results across tuning parameters:
# 
#   k   Accuracy   Kappa    
#    5  0.9448029  0.8890302
#    7  0.9559140  0.9116519
#    9  0.9448029  0.8890302
#   11  0.9555556  0.9105132
#   13  0.9225806  0.8438981
#   15  0.9225806  0.8438981
#   17  0.9444444  0.8880926
#   19  0.9444444  0.8880926
#   21  0.9444444  0.8880926
#   23  0.9444444  0.8880926
# 
# Accuracy was used to select the optimal model using the largest value.
# The final value used for the model was k = 7.
# Naive Bayes 
# 
# 91 samples
# 13 predictors
#  2 classes: '1', '2' 
# 
# No pre-processing
# Resampling: Cross-Validated (3 fold) 
# Summary of sample sizes: 61, 61, 60 
# Resampling results across tuning parameters:
# 
#   usekernel  Accuracy   Kappa    
#   FALSE      0.9784946  0.9567643
#    TRUE      0.9677419  0.9352818
# 
# Tuning parameter 'fL' was held constant at a value of 0
# Tuning
#  parameter 'adjust' was held constant at a value of 1
# Accuracy was used to select the optimal model using the largest value.
# The final values used for the model were fL = 0, usekernel = FALSE
#  and adjust = 1.
plot(nb_fit)


# model_fit
# modelFit

nb_pred <- predict(nb_fit, newdata = test)
nb_pred



confusionMatrix(nb_pred, test$class)
get_scores(nb_pred, test)
#  accuracy        f1 
# 0.9743590 0.9737374 

conmat(nb_pred, test)
#       Predicted
# Actual  1  2
#      1 16  0
#      2  1 22


# lets talk about speedy naivebayes, as well as maybe look at probabalistic programming



#

seeds <- 1:100

# looping through seeds


# train and test function

accuracyVector <- numeric(100)

for (i in 1:length(seeds)) {
  
  set.seed(seeds[i])  
 

############################################# 
  # interchangeable
  fit <- train(class ~ ., data = training,
  		trControl = trainMethod,
  		method = "nb",
  		tuneLength = 10)
###########################################


  preds <- predict(fit, newdata = test)

  acc <- accuracy(preds, test)

  accuracyVector[i]  <- acc

}

# apply family

# foreach




accuracyVector

mean(accuracyVector)
# [1] 0.9882051


data.frame(seed =  seeds, acc = accuracyVector)


set.seed(NULL)



