library(tidyverse)
library(broom)
library(caret)
data(iris)
head(iris)
nrow(iris)


samp_size <- floor(nrow(iris)*0.6)
samp_size

train_ind <- sample(1:(nrow(iris)), size = samp_size)
?seq_len
seq_len(nrow(iris))
1:nrow(iris)
nrow(iris)

train <- iris[train_ind,]
test <- iris[-train_ind,]
head(train)
head(test)

s_size <- function(df,split) {
	floor(nrow(df)*split)
}
sampler <- function(data, split, sn = 0){
	if (sn != 0) set.seed(sn)	
	train_ind <- sample(seq_len(nrow(data)), size = s_size(data, split))
	train <- data[train_ind,]
	test <- data[-train_ind, ]
	list("train" = train,  "test" = test)

}

partitions  <- sampler(data = iris, split = 0.6, sn = 0)
train <- partitions$train
test <- partitions$test
head(train)
#    Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
# 27          5.0         3.4          1.6         0.4     setosa
# 20          5.1         3.8          1.5         0.3     setosa
# 43          4.4         3.2          1.3         0.2     setosa
# 88          6.3         2.3          4.4         1.3 versicolor
# 35          4.9         3.1          1.5         0.2     setosa
# 97          5.7         2.9          4.2         1.3 versicolor
head(test)
#    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 2           4.9         3.0          1.4         0.2  setosa
# 3           4.7         3.2          1.3         0.2  setosa
# 5           5.0         3.6          1.4         0.2  setosa
# 7           4.6         3.4          1.4         0.3  setosa
# 10          4.9         3.1          1.5         0.1  setosa

# y ~ x
plot(train$Sepal.Length ~ train$Petal.Width)


iris_fit_simple <- lm(data = train, Sepal.Length ~ Petal.Width)

abline(iris_fit_simple)

iris_fit_simple <- lm( train$Sepal.Length ~ train$Petal.Width)
summary(iris_fit_simple)
iris_fit_simple$resid
par(mfrow = c(1,1))
x = 1:10
y = x^4
plot(y~x)
x_lm <- lm( x~x)
# Are the residuals normal
# Do the residuals have a constant variance
# Is the data the independent

ggplot(data = iris_fit_simple, aes(x = .fitted, y = .resid))+ geom_point() + geom_line(aes(y = 0))
par(mfrow = c(2,1))
plot(iris_fit_simple, which = 1)
plot(iris_fit_simple, which = 2)
histogram(iris_fit_simple$resid)

# Do the residuals look like a random cloud around the line y = 0
# if yes, the data probably has constant mean and variance
# if no, the data probably doesnt

hist(iris_fit_simple$resid)
# does the histogram look normal?
# does the width look constant on both sides?


summary(iris_fit_simple)

# Sepal Length = 4.7 + .92* petal width

broom::tidy(iris_fit_simple)
# # A tibble: 2 x 5
#   term        estimate std.error statistic   p.value
#   <chr>          <dbl>     <dbl>     <dbl>     <dbl>
# 1 (Intercept)    4.78     0.0729      65.5 3.34e-111
# 2 Petal.Width    0.889    0.0514      17.3 2.33e- 37
broom::augment(iris_fit_simple)

glance(iris_fit_simple)


broom::confint_tidy(iris_fit_simple)


pred_iris <- predict.lm(iris_fit_simple, test)

pred_iris
test$Sepal.Length
error <- pred_iris - test$Sepal.Length
error

square_error <- error^2

square_error

ASE <- mean(square_error)
ASE




ASE <- function(pred, obs) {
	(pred - obs) %>% `^`(2) %>% mean
}

ASE(pred_iris, test$Sepal.Length)


## the caret way
data(USArrests)
head(USArrests)
# createDataPartition(AnyColumn, proportion, list = F)

train_ind <- caret::createDataPartition(1:nrow(USArrests),  p = .6, list = F)
train_ind
train <- USArrests[train_ind,]
test <- USArrests[-train_ind,]
head(train)
head(test)
nrow(train)
nrow(test)

plot(train$Murder ~ train$UrbanPop)
arrest_lm <- lm(data = train, Murder~UrbanPop)
abline(arrest_lm)
histogram(arrest_lm$resid)
par(mfrow = c(1,1))
plot(arrest_lm, which = 1)
plot(arrest_lm, which = 2)


# train test split
# scatterplot
# linear model
# draw line on scatterplot
# histogram
# residuals vs fitted (which = 1)
# q-q (which = 2)
# say whether or not assumptions were met
# (LATER) adjust to meet assumptions
# summary
# confidence intervals
# interpret coeff.
# predict on test
# ASE
# compare to other models


