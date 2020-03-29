library(caret)

data(BreastCancer, package='mlbench')


library(skimr)


skim(BreastCancer)
# ── Data Summary ────────────────────────
#                            Values      
# Name                       BreastCancer
# Number of rows             699         
# Number of columns          11          
# _______________________                
# Column type frequency:                 
#   character                1           
#   factor                   10          
# ________________________               
# Group variables            None        
# 
# ── Variable type: character ──────────────────────────────────────────────
#   skim_variable n_missing complete_rate   min   max empty n_unique
# 1 Id                    0             1     5     8     0      645
#   whitespace
# 1          0
# 
# ── Variable type: factor ─────────────────────────────────────────────────
#    skim_variable   n_missing complete_rate ordered n_unique
#  1 Cl.thickness            0         1     TRUE          10
#  2 Cell.size               0         1     TRUE          10
#  3 Cell.shape              0         1     TRUE          10
#  4 Marg.adhesion           0         1     TRUE          10
#  5 Epith.c.size            0         1     TRUE          10
#  6 Bare.nuclei            16         0.977 FALSE         10
#  7 Bl.cromatin             0         1     FALSE         10
#  8 Normal.nucleoli         0         1     FALSE         10
#  9 Mitoses                 0         1     FALSE          9
# 10 Class                   0         1     FALSE          2
#    top_counts                   
#  1 1: 145, 5: 130, 3: 108, 4: 80
#  2 1: 384, 10: 67, 3: 52, 2: 45 
#  3 1: 353, 2: 59, 10: 58, 3: 56 
#  4 1: 407, 2: 58, 3: 58, 10: 55 
#  5 2: 386, 3: 72, 4: 48, 1: 47  
#  6 1: 402, 10: 132, 2: 30, 5: 30
#  7 2: 166, 3: 165, 1: 152, 7: 73
#  8 1: 443, 10: 61, 3: 44, 2: 36 
#  9 1: 579, 2: 35, 3: 33, 10: 14 
# 10 ben: 458, mal: 241           

bc <- BreastCancer
bc$ID <- NULL

bc

library(tidyverse)
ggplot(data = bc) + geom_bar(aes_string(x = Cell.size, fill = Class), position = "fill", alpha = 0.9) + coord_flip()


catplot <- function(df, x,y){
  ggplot(data = df, aes_string(x = x, fill = y)) + 
    geom_bar(position = "fill", alpha = 0.9) + 
    coord_flip()
}


bc$Id <- NULL
rev(names(bc))
#  [1] "Class"           "Mitoses"         "Normal.nucleoli"
#  [4] "Bl.cromatin"     "Bare.nuclei"     "Epith.c.size"   
#  [7] "Marg.adhesion"   "Cell.shape"      "Cell.size"      
# [10] "Cl.thickness"   
#  [1] "Cl.thickness"    "Cell.size"       "Cell.shape"     
#  [4] "Marg.adhesion"   "Epith.c.size"    "Bare.nuclei"    
#  [7] "Bl.cromatin"     "Normal.nucleoli" "Mitoses"        
# [10] "Class"          

explanatory <- rev(names(bc))[2:length(names(bc))]
# [1] "Mitoses"         "Normal.nucleoli" "Bl.cromatin"    
# [4] "Bare.nuclei"     "Epith.c.size"    "Marg.adhesion"  
# [7] "Cell.shape"      "Cell.size"       "Cl.thickness"   
target <- "Class"

plotlist <- lapply(explanatory, function(x) catplot(bc, x, target))

library(cowplot)
plot_grid(plotlist = plotlist)

trainIDS <- createDataPartition(bc$Class, list=FALSE, p = 0.7)

trainIDS

training <- bc[trainIDS,]
test <- bc[-trainIDS, ]

table(bc$Class) / sum(table(bc$Class))
# 
#    benign malignant 
# 0.6552217 0.3447783 

table(training$Class) / sum(table(training$Class))
# 
#    benign malignant 
#  0.655102  0.344898 
table(test$Class) / sum(table(test$Class))
# 
#    benign malignant 
# 0.6555024 0.3444976 

nrow(test) / nrow(bc)

trainMethod <- trainControl(method = "cv", number = 3)
# train, validation, test

nb_fit <- train(Class ~ ., data = na.omit(training),
		trControl = trainMethod,
		method = "nb",
		tuneLength = 10
)
nb_fit


preds <- predict(nb_fit, newdata=test)

preds

test <- na.omit(test)

length(preds)
length(test$Class)

# Naive Bayes 
# 
# 478 samples
#   9 predictor
#   2 classes: 'benign', 'malignant' 
# 
# No pre-processing
# Resampling: Cross-Validated (3 fold) 
# Summary of sample sizes: 319, 318, 319 
# Resampling results across tuning parameters:
# 
#   usekernel  Accuracy   Kappa    
#   FALSE            NaN        NaN
#    TRUE      0.9602463  0.9142473
# 
# Tuning parameter 'fL' was held constant at a value of 0
# Tuning
#  parameter 'adjust' was held constant at a value of 1
# Accuracy was used to select the optimal model using the largest value.
# The final values used for the model were fL = 0, usekernel = TRUE
#  and adjust = 1.
# Random Forest 
# 
# 478 samples
#   9 predictor
#   2 classes: 'benign', 'malignant' 
# 
# No pre-processing
# Resampling: Cross-Validated (3 fold) 
# Summary of sample sizes: 319, 318, 319 
# Resampling results across tuning parameters:
# 
#   mtry  Accuracy   Kappa    
#    2    0.9581892  0.9083623
#   10    0.9540225  0.8989660
#   19    0.9519392  0.8943769
#   28    0.9498428  0.8894839
#   36    0.9540225  0.8988541
#   45    0.9561059  0.9036828
#   54    0.9581892  0.9084716
#   62    0.9623690  0.9178711
#   71    0.9623690  0.9178711
#   80    0.9602725  0.9133694
# 
# Accuracy was used to select the optimal model using the largest value.
# The final value used for the model was mtry = 62.
# k-Nearest Neighbors 
# 
# 478 samples
#   9 predictor
#   2 classes: 'benign', 'malignant' 
# 
# No pre-processing
# Resampling: Cross-Validated (3 fold) 
# Summary of sample sizes: 319, 318, 319 
# Resampling results across tuning parameters:
# 
#   k   Accuracy   Kappa    
#    5  0.9330713  0.8478567
#    7  0.9226022  0.8231873
#    9  0.9142296  0.8029820
#   11  0.9058569  0.7824233
#   13  0.8953878  0.7565026
#   15  0.8932914  0.7513188
#   17  0.8870152  0.7354032
#   19  0.8828223  0.7240868
#   21  0.8786426  0.7124809
#   23  0.8765592  0.7063262
# 

plot(nb_fit)

# Accuracy was used to select the optimal model using the largest value.
# The final value used for the model was k = 5.
# Naive Bayes 
# 
# 478 samples
#   9 predictor
#   2 classes: 'benign', 'malignant' 
# 
# No pre-processing
# Resampling: Cross-Validated (3 fold) 
# Summary of sample sizes: 318, 319, 319 
# Resampling results across tuning parameters:
# 
#   usekernel  Accuracy   Kappa    
#   FALSE            NaN        NaN
#    TRUE      0.9644392  0.9225881
# 
# Tuning parameter 'fL' was held constant at a value of 0
# Tuning
#  parameter 'adjust' was held constant at a value of 1
# Accuracy was used to select the optimal model using the largest value.
# The final values used for the model were fL = 0, usekernel = TRUE
#  and adjust = 1.


conmat <- function(predicted, expected){
  cm <- as.matrix(table(Actual = as.factor(expected), Predicted = predicted))
  cm
}

cm <- table(preds, test$Class)
#            
# preds       benign malignant
#   benign       128         1
#   malignant      6        70


accuracy <- sum(diag(cm)) / sum(as.matrix(cm))
# [1] 0.9704433

precision <-  diag(cm)[2] / rowSums(cm)[2]
# malignant 
# 0.9577465 
# malignant 
# 0.9210526 

recall <- diag(cm)[2] / colSums(cm)[2]
# malignant 
# 0.9577465 

specificity <- diag(cm)[1] / colSums(cm)[1]
#    benign 
# 0.9772727 

confusionMatrix(cm, positive='malignant')
# Confusion Matrix and Statistics
# 
#            
# preds       benign malignant
#   benign       129         3
#   malignant      3        68
#                                           
#                Accuracy : 0.9704          
#                  95% CI : (0.9368, 0.9891)
#     No Information Rate : 0.6502          
#     P-Value [Acc > NIR] : <2e-16          
#                                           
#                   Kappa : 0.935           
#                                           
#  Mcnemar's Test P-Value : 1               
#                                           
#             Sensitivity : 0.9577          
#             Specificity : 0.9773          
#          Pos Pred Value : 0.9577          
#          Neg Pred Value : 0.9773          
#              Prevalence : 0.3498          
#          Detection Rate : 0.3350          
#    Detection Prevalence : 0.3498          
#       Balanced Accuracy : 0.9675          
#                                           
#        'Positive' Class : malignant       
#                                           
# Confusion Matrix and Statistics
# 
