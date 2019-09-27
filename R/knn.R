# Building our own machine learning library

# I am following an amazing blog series on this, which I will share. We will go a bit further than the blog posts

# Always set a seed, or else you can get in trouble
set.seed(49)

# create a train test split

# create KNN Class (S3 Object)
# DNN for davids nearest neighbors


# overall structure of knn

# 1 Take in data
# 2 Calculate pairwise distance matrix
#   Note euclidean distance
# find nearest neighbors



DNN <- function(x, y, k = 5){
  if (!is.matrix(x)) {
    x  <-  as.matrix(x)
  }
  if (!is.matrix(y)) {
    y  <-  as.matrix(y)
  }
  results <- list()
  results$points <- x
  results$value  <- y
  results$k  <- k
  results <- structure(results, class = "DNN")
  return(results)
}





# f ∥xi−xj∥2=∥xi∥2+∥xj∥2−2(xi⋅xj)
# will not get into math but share link afterwards
compute_pairwise_distance=function(X,Y){
  xn = rowSums(X ** 2)
  yn = rowSums(Y ** 2)
  outer(xn, yn, '+') - 2 * tcrossprod(X, Y)
}

# prediction methods




###

predict(model, data)

predict
# function (object, ...) 
# UseMethod("predict")
# <bytecode: 0x84d400>
# <environment: namespace:stats>






















predict.DNN = function(my_knn,x){
  if (!is.matrix(x))
  {
    x = as.matrix(x)
  }
  ##Compute pairwise distance
  dist_pair = compute_pairwise_distance(x,my_knn$points)
  ##as.matrix(apply(dist_pair,2,order)<=my_knn[['k']]) orders the points by distance and select the k-closest points
  ##The M[i,j]=1 if x_j is on the k closest point to x_i
  crossprod(apply(dist_pair,1,order) <= my_knn$k, 
            my_knn$value) / my_knn$k
}
head(iris)
#   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 1          5.1         3.5          1.4         0.2  setosa
# 2          4.9         3.0          1.4         0.2  setosa
# 3          4.7         3.2          1.3         0.2  setosa
# 4          4.6         3.1          1.5         0.2  setosa
# 5          5.0         3.6          1.4         0.2  setosa
# 6          5.4         3.9          1.7         0.4  setosa
iris_class = iris[iris$Species !="versicolor",]
str(iris_class)
# 'data.frame':	100 obs. of  5 variables:
#  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
# NULL
iris_class$Species = (iris_class$Species == "setosa")


head(iris_class, 15)
#    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 1           5.1         3.5          1.4         0.2   FALSE
# 2           4.9         3.0          1.4         0.2   FALSE
# 3           4.7         3.2          1.3         0.2   FALSE
# 4           4.6         3.1          1.5         0.2   FALSE
# 5           5.0         3.6          1.4         0.2   FALSE
# 6           5.4         3.9          1.7         0.4   FALSE
# 7           4.6         3.4          1.4         0.3   FALSE
# 8           5.0         3.4          1.5         0.2   FALSE
# 9           4.4         2.9          1.4         0.2   FALSE
# 10          4.9         3.1          1.5         0.1   FALSE
# 11          5.4         3.7          1.5         0.2   FALSE
# 12          4.8         3.4          1.6         0.2   FALSE
# 13          4.8         3.0          1.4         0.1   FALSE
# 14          4.3         3.0          1.1         0.1   FALSE
# 15          5.8         4.0          1.2         0.2   FALSE

tail(as.numeric(iris_class$Species))
# [1] 1 1 1 1 1 1
# [1] 0 0 0 0 0 0


knn_class  <-  DNN(iris_class[,1:2], as.numeric(iris_class$Species))
str(knn_class)
# List of 3
#  $ points: num [1:100, 1:2] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#   ..- attr(*, "dimnames")=List of 2
#   .. ..$ : chr [1:100] "1" "2" "3" "4" ...
#   .. ..$ : chr [1:2] "Sepal.Length" "Sepal.Width"
#  $ value : num [1:100, 1] 0 0 0 0 0 0 0 0 0 0 ...
#  $ k     : num 5
#  - attr(*, "class")= chr "DNN"
# NULL
head(predict(knn_class, iris_class[,1:2]))
#   [,1]
# 1  0.0
# 2  0.0
# 3  0.0
# 4  0.0
# 5  0.0
# 6  0.2

x_coord = seq(min(iris_class[,1]) - 0.2,max(iris_class[,1]) + 0.2,length.out = 200)
y_coord = seq(min(iris_class[,2])- 0.2,max(iris_class[,2]) + 0.2 , length.out = 200)
coord = expand.grid(x = x_coord, y = y_coord)

#predict probabilities
coord$prob = predict(knn_class, coord[,1:2])
 
library(ggplot2)
ggplot() + 
  ##Ad tiles according to probabilities
  geom_tile(data=coord,mapping=aes(x, y, fill=prob)) + scale_fill_gradient(low = "lightblue", high = "red") +
  ##add points
  geom_point(data=iris_class,mapping=aes(Sepal.Length,Sepal.Width, shape=Species),size=3 ) + 
  #add the labels to the plots
  xlab('Sepal length') + ylab('Sepal width') + ggtitle('Decision boundaries of KNN')+
  #remove grey border from the tile
  scale_x_continuous(expand=c(0,0))+scale_y_continuous(expand=c(0,0))

# implement a confusing matrix (confusion matrix)

table(predict())

table(predict())
iris_class$Species
table(predict(knn_class, iris_class[,1:2]), iris_class$Species)
p <- predict(knn_class, iris_class[,1:2])
preds <- ifelse(p < 0.5, FALSE, TRUE)

# Here we go

cm <- table(preds, iris_class$Species)
#        
# preds   FALSE TRUE
#   FALSE    49    2
#   TRUE      1   48
#        

acc <- sum(diag(cm))/sum(c(cm))
# [1] 0.97

precision <- cm[2,2]/(sum(cm[,2]))
# [1] 0.96

recall <- cm[2,2] / sum(cm[2,])
# [1] 0.9795918

F1 <- 2 * (precision * recall) / (precision + recall)
# [1] 0.969697

table(as.factor(preds), as.factor(iris_class$Species))

# calculate sensitivity specificity etc our selves:

# will do live after we walk through them


caret::confusionMatrix(preds, iris_class$Species)

library(dplyr)

library(MASS)


mtcars %>% select(mpg)
?select

MASS::select
# function (obj) 
# UseMethod("select")
# <bytecode: 0x6fe498>
# <environment: namespace:MASS>
dplyr::select
# function (.data, ...) 
# {
#     UseMethod("select")
# }
# <bytecode: 0x260ec48>
# <environment: namespace:dplyr>
