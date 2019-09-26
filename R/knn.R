# Building our own machine learning library - helpers

# Always set a seed, or else you can get in trouble
set.seed(49)

# create a train test split

# create KNN Class (S3 Object)
# DNN for davids nearest neighbors

DNN <- function(x, y, k = 5, normalize = TRUE){
  if (!is.matrix(x))
  {
    x  <-  as.matrix(x)
  }
  if (!is.matrix(y))
  {
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

predict.DNN = function(my_knn,x){
  if (!is.matrix(x))
  {
    x = as.matrix(x)
  }
  ##Compute pairwise distance
  dist_pair = compute_pairwise_distance(x,my_knn[['points']])
  ##as.matrix(apply(dist_pair,2,order)<=my_knn[['k']]) orders the points by distance and select the k-closest points
  ##The M[i,j]=1 if x_j is on the k closest point to x_i
  crossprod(apply(dist_pair,1,order) <= my_knn$k, my_knn$value) / my_knn$k
}

iris_class = iris[iris[["Species"]]!="versicolor",]
print(iris_class)
iris_class[["Species"]] = iris_class[["Species"]] != "setosa"
knn_class = DNN(iris_class[,1:2], as.numeric(iris_class[,5]))
predict(knn_class, iris_class[,1:2])

x_coord = seq(min(iris_class[,1]) - 0.2,max(iris_class[,1]) + 0.2,length.out = 200)
y_coord = seq(min(iris_class[,2])- 0.2,max(iris_class[,2]) + 0.2 , length.out = 200)
coord = expand.grid(x = x_coord, y = y_coord)
#predict probabilities
coord[['prob']] = predict(knn_class, coord[,1:2])
 
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
# ooops

preds <- ifelse(predict(knn_class, iris_class[,1:2]) < 0.5, FALSE, TRUE)
# Here we go

table(preds, iris_class$Species)

table(as.factor(preds), as.factor(iris_class$Species))

# calculate sensitivity specificity etc our selves:

# will do live after we walk through them


caret::confusionMatrix(preds, iris_class$Species)



