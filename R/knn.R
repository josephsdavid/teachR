# Building our own machine learning library

# I am following an amazing blog series on this, which I will share. We will go a bit further than the blog posts
# http://enhancedatascience.com/2018/05/23/create-your-machine-learning-library-from-scratch-with-r-3-5-knn/
# absolutely great stuff

# Always set a seed, or else you can get in trouble
set.seed(49)

# create a train test split
# Do this always!
# Or something similar

# create KNN Class (S3 Object)
# DNN for davids nearest neighbors
# sqrt(x^2 + y^2 + z^2 + whatever^2) = distance
# pairwise distance matrix
# rank distances per observation from closest to furthest


# overall structure of knn

# 1 Take in data
# 2 Calculate pairwise distance matrix
#   Note euclidean distance
# find nearest neighbors

# 



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
# https://www.r-bloggers.com/pairwise-distances-in-r/
# https://blog.smola.org/post/969195661/in-praise-of-the-second-binomial-formula
compute_pairwise_distance=function(X,Y){
  xn = rowSums(X ** 2)
  yn = rowSums(Y ** 2)
  outer(xn, yn, '+') - 2 * tcrossprod(X, Y)
}

# prediction methods
# discuss here


predict
# function (object, ...) 
# UseMethod("predict")
# <bytecode: 0x2086598>
# <environment: namespace:stats>

###

# do knn by hand
# compute distance graph

# minkowski distance
# jaccard distance

predict.DNN = function(my_knn,x, distance = compute_pairwise_distance){
  if (!is.matrix(x))
  {
    x = as.matrix(x)
  }
  ##Compute pairwise distance
  dist_pair = distance(x,my_knn$points)
  # rank distances computing a lovely graph
  crossprod(
            apply(dist_pair,1,order) <= my_knn[['k']], 
            my_knn[["value"]]) / my_knn[['k']]  
  # turn points more than k neighbors away  to zero, otherwise one
}
head(iris)
iris_class <- iris
#   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 1          5.1         3.5          1.4         0.2  setosa
# 2          4.9         3.0          1.4         0.2  setosa
# 3          4.7         3.2          1.3         0.2  setosa
# 4          4.6         3.1          1.5         0.2  setosa
# 5          5.0         3.6          1.4         0.2  setosa
# 6          5.4         3.9          1.7         0.4  setosa
str(iris_class)
# 'data.frame':	100 obs. of  5 variables:
#  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
# NULL
iris_class$Species = (iris_class$Species == "setosa")
head(iris_class$Species)
# [1] TRUE TRUE TRUE TRUE TRUE TRUE


head(iris_class, 15)
unique(iris_class$Species)

head(as.numeric(iris_class$Species))

as.numeric(iris_class$Species)
names(iris_class[,1:2])
# [1] "Sepal.Length" "Sepal.Width" 


# Set k to an odd number
knn_class  <-  DNN(iris_class[,1:2], as.numeric(iris_class$Species), k = 7)


# do it by hand before we show the predict function in action
dists <- compute_pairwise_distance(knn_class$points, as.matrix(iris_class[,1:2]))
View(dists)
# ranks the distances in the graph and sorts them
sorted_dists <- apply(dists, 2,order)
View(sorted_dists)
onehot_sorted <- sorted_dists <= knn_class$k 
View(onehot_sorted)
head(t(onehot_sorted) %*% knn_class$value/knn_class$k)
#           [,1]
# [1,] 1.0000000
# [2,] 0.8571429
# [3,] 0.8571429
# [4,] 0.8571429
# [5,] 1.0000000
# [6,] 0.8571429


head(predict(knn_class, iris_class[,1:2]))
#           [,1]
# [1,] 1.0000000
# [2,] 0.8571429
# [3,] 0.8571429
# [4,] 0.8571429
# [5,] 1.0000000
# [6,] 0.8571429


x_coord = seq(min(iris_class[,1]) - 0.2,max(iris_class[,1]) + 0.2,length.out = 200)
length(x_coord)
y_coord = seq(min(iris_class[,2])- 0.2,max(iris_class[,2]) + 0.2 , length.out = 200)
length(y_coord)
coord = expand.grid(x = x_coord, y = y_coord)

nrow(coord)
# [1] 40000

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

p <- predict(knn_class, iris_class[,1:2])
head(p)
#           [,1]
# [1,] 1.0000000
# [2,] 0.8571429
# [3,] 0.8571429
# [4,] 0.8571429
# [5,] 1.0000000
# [6,] 0.8571429
preds <- ifelse(p < 0.5, FALSE, TRUE)
head(preds)
#      [,1]
# [1,] TRUE
# [2,] TRUE
# [3,] TRUE
# [4,] TRUE
# [5,] TRUE
# [6,] TRUE

# Here we go

(cm <- table(preds, iris_class$Species))
#        
# preds   FALSE TRUE
#   FALSE   100    4
#   TRUE      0   46

(acc <- sum(diag(cm))/sum(c(cm)))
# [1] 0.9733333

(precision <- cm[2,2]/(sum(cm[,2])))
# [1] 0.92

(recall <- cm[2,2] / sum(cm[2,]))
# [1] 1

(F1 <- 2 * (precision * recall) / (precision + recall))
# [1] 0.9583333

