# regression EDA
data(mtcars)

mtcars
#                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
# Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
# Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
# Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
# Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
# Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
# Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
# Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
# Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
# Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
# Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
# Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
# Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
# Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
# Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
# Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
# Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
# Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
# Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
# Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
# Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
# Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
# Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
# AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
# Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
# Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
# Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
# Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
# Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
# Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
# Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
# Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
# Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
mtcars[c("cyl","vs","am","gear","carb")]
#                     cyl vs am gear carb
# Mazda RX4             6  0  1    4    4
# Mazda RX4 Wag         6  0  1    4    4
# Datsun 710            4  1  1    4    1
# Hornet 4 Drive        6  1  0    3    1
# Hornet Sportabout     8  0  0    3    2
# Valiant               6  1  0    3    1
# Duster 360            8  0  0    3    4
# Merc 240D             4  1  0    4    2
# Merc 230              4  1  0    4    2
# Merc 280              6  1  0    4    4
# Merc 280C             6  1  0    4    4
# Merc 450SE            8  0  0    3    3
# Merc 450SL            8  0  0    3    3
# Merc 450SLC           8  0  0    3    3
# Cadillac Fleetwood    8  0  0    3    4
# Lincoln Continental   8  0  0    3    4
# Chrysler Imperial     8  0  0    3    4
# Fiat 128              4  1  1    4    1
# Honda Civic           4  1  1    4    2
# Toyota Corolla        4  1  1    4    1
# Toyota Corona         4  1  0    3    1
# Dodge Challenger      8  0  0    3    2
# AMC Javelin           8  0  0    3    2
# Camaro Z28            8  0  0    3    4
# Pontiac Firebird      8  0  0    3    2
# Fiat X1-9             4  1  1    4    1
# Porsche 914-2         4  0  1    5    2
# Lotus Europa          4  1  1    5    2
# Ford Pantera L        8  0  1    5    4
# Ferrari Dino          6  0  1    5    6
# Maserati Bora         8  0  1    5    8
# Volvo 142E            4  1  1    4    2
str(mtcars)
# 'data.frame':	32 obs. of  11 variables:
#  $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
#  $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
#  $ disp: num  160 160 108 258 360 ...
#  $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
#  $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
#  $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
#  $ qsec: num  16.5 17 18.6 19.4 17 ...
#  $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
#  $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
#  $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
#  $ carb: num  4 4 1 1 2 1 4 2 2 4 ...
# NULL
mtcars[c("cyl","vs","am","gear","carb")] <- lapply(mtcars[c("cyl","vs","am","gear","carb")], as.factor)
hist(mtcars$mpg)

# facet 


str(mtcars)

library(tidyverse)
mtcars %>% keep(is.numeric) %>%gather %>% ggplot(aes(x = value)) + facet_wrap(~key, scales = "free")+ geom_histogram()
plotAllNumeric <- function(df){
    df%>%keep(is.numeric) %>%
    gather() %>%
    ggplot(aes(value)) +
    facet_wrap(~ key, scales = "free") +
    geom_density()+geom_histogram() + theme_fivethirtyeight()
}

plotAllNumeric(mtcars)

library(RColorBrewer)
library(gplots)


# heatmap

my_palette <- colorRampPalette(c("red", "white", "black"))
heatmapper <- function(df){
	df %>%
		keep(is.numeric) %>%
		tidyr::drop_na() %>%
		cor %>%
		heatmap.2(col = my_palette ,
		density.info = "none", trace = "none",
		dendogram = c("both"), symm = F,
		symkey = T, symbreaks = T, scale = "none",
		key = T)
}

data(iris)
heatmapper(iris)
heatmapper(mtcars)



library(corrplot) 

?corrplot
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
correlator(mtcars)



# Categorical variables
# box plots
mtcars %>% keep(is.factor) %>% names -> label
# [1] "cyl"  "vs"   "am"   "gear" "carb"
ggplot(data = mtcars, aes(x = cyl, y = mpg, fill = cyl)) + geom_boxplot() + scale_fill_few(palette = "Dark") + theme_few()
ggplot(data = mtcars, aes(x = vs, y = mpg, fill = vs)) + geom_boxplot() + scale_fill_few(palette = "Dark") + theme_few()
ggplot(data = mtcars, aes(x = am, y = mpg, fill = am)) + geom_boxplot() + scale_fill_few(palette = "Dark") + theme_few()
ggplot(data = mtcars, aes(x = gear, y = mpg, fill = gear)) + geom_boxplot() + scale_fill_few(palette = "Dark") + theme_few()
ggplot(data = mtcars, aes(x = carb, y = mpg, fill = carb)) + geom_boxplot() + scale_fill_few(palette = "Dark") + theme_few()

plot_grid(p,p1,p2,p3,p4, ncol = 3, labels = label)


p <-ggplot(data = mtcars, aes(x = cyl, y = mpg, fill = cyl)) + geom_violin() + scale_fill_few(palette = "Dark") + theme_few()
p1<-ggplot(data = mtcars, aes(x = vs, y = mpg, fill = vs)) + geom_violin() + scale_fill_few(palette = "Dark") + theme_few()
p2<-ggplot(data = mtcars, aes(x = am, y = mpg, fill = am)) + geom_violin() + scale_fill_few(palette = "Dark") + theme_few()
p3<-ggplot(data = mtcars, aes(x = gear, y = mpg, fill = gear)) + geom_violin() + scale_fill_few(palette = "Dark") + theme_few()
p4<-ggplot(data = mtcars, aes(x = carb, y = mpg, fill = carb)) + geom_violin() + scale_fill_few(palette = "Dark") + theme_few()

plot_grid(p,p1,p2,p3,p4, ncol = 3, labels = label)


# disp or weight = eliminate one
# maybe eliminate gear or lm
model1 <- lm(data = mtcars, mpg ~.) 
summary(model1)
# 
# Call:
# lm(formula = mpg ~ ., data = mtcars)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -3.5087 -1.3584 -0.0948  0.7745  4.6251 
# 
# Coefficients:
#             Estimate Std. Error t value
# (Intercept) 23.87913   20.06582   1.190
# cyl6        -2.64870    3.04089  -0.871
# cyl8        -0.33616    7.15954  -0.047
# disp         0.03555    0.03190   1.114
# hp          -0.07051    0.03943  -1.788
# drat         1.18283    2.48348   0.476
# wt          -4.52978    2.53875  -1.784
# qsec         0.36784    0.93540   0.393
# vs1          1.93085    2.87126   0.672
# am1          1.21212    3.21355   0.377
# gear4        1.11435    3.79952   0.293
# gear5        2.52840    3.73636   0.677
# carb2       -0.97935    2.31797  -0.423
# carb3        2.99964    4.29355   0.699
# carb4        1.09142    4.44962   0.245
# carb6        4.47757    6.38406   0.701
# carb8        7.25041    8.36057   0.867
#             Pr(>|t|)  
# (Intercept)   0.2525  
# cyl6          0.3975  
# cyl8          0.9632  
# disp          0.2827  
# hp            0.0939 .
# drat          0.6407  
# wt            0.0946 .
# qsec          0.6997  
# vs1           0.5115  
# am1           0.7113  
# gear4         0.7733  
# gear5         0.5089  
# carb2         0.6787  
# carb3         0.4955  
# carb4         0.8096  
# carb6         0.4938  
# carb8         0.3995  
# ---
# Signif. codes:  
#   0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’
#   0.1 ‘ ’ 1
# 
# Residual standard error: 2.833 on 15 degrees of freedom
# Multiple R-squared:  0.8931,	Adjusted R-squared:  0.779 
# F-statistic:  7.83 on 16 and 15 DF,  p-value: 0.000124
# 

mtcars2 <- mtcars %>% keep(is.numeric)
mtcars2$disp  <- NULL

model2  <- lm(data = mtcars2, mpg~.)

summary(model2)
# 
# Call:
# lm(formula = mpg ~ ., data = mtcars2)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -3.5775 -1.6626 -0.3417  1.1317  5.4422 
# 
# Coefficients:
#             Estimate Std. Error t value
# (Intercept) 19.25970   10.31545   1.867
# hp          -0.01784    0.01476  -1.209
# drat         1.65710    1.21697   1.362
# wt          -3.70773    0.88227  -4.202
# qsec         0.52754    0.43285   1.219
#             Pr(>|t|)    
# (Intercept) 0.072785 .  
# hp          0.237319    
# drat        0.184561    
# wt          0.000259 ***
# qsec        0.233470    
# ---
# Signif. codes:  
#   0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’
#   0.1 ‘ ’ 1
# 
# Residual standard error: 2.539 on 27 degrees of freedom
# Multiple R-squared:  0.8454,	Adjusted R-squared:  0.8225 
# F-statistic: 36.91 on 4 and 27 DF,  p-value: 1.408e-10
# 


mtcars3 <- mtcars %>% keep(is.numeric)

model3 <- lm(data = mtcars3, mpg~.)
summary(model3)
# 
# Call:
# lm(formula = mpg ~ ., data = mtcars3)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -3.5404 -1.6701 -0.4264  1.1320  5.4996 
# 
# Coefficients:
#             Estimate Std. Error t value
# (Intercept) 16.53357   10.96423   1.508
# disp         0.00872    0.01119   0.779
# hp          -0.02060    0.01528  -1.348
# drat         2.01578    1.30946   1.539
# wt          -4.38546    1.24343  -3.527
# qsec         0.64015    0.45934   1.394
#             Pr(>|t|)   
# (Intercept)  0.14362   
# disp         0.44281   
# hp           0.18936   
# drat         0.13579   
# wt           0.00158 **
# qsec         0.17523   
# ---
# Signif. codes:  
#   0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’
#   0.1 ‘ ’ 1
# 
# Residual standard error: 2.558 on 26 degrees of freedom
# Multiple R-squared:  0.8489,	Adjusted R-squared:  0.8199 
# F-statistic: 29.22 on 5 and 26 DF,  p-value: 6.892e-10
# 


# exploring with base R and lapply
# modify for your own data, this is geared for mtcars
# for example train$income ~ train[[x]] instead of mtcars
plot_vs_response <- function(x){
  plot(mtcars$mpg ~ mtcars[[x]], xlab = x)
  lw1 <- loess(mtcars$mpg ~ mtcars[[x]])
  j <- order(mtcars[[x]])
  lines(mtcars[[x]][j],lw1$fitted[j],col="red",lwd=3)
}
mtcars %>% keep(is.numeric) %>% names -> numNames
numNames
# [1] "mpg"  "disp" "hp"   "drat" "wt"   "qsec"
# remove mpg
numNames <- numNames[-1]
length(numNames)
# [1] 5
# set up graphical parameters:

par(mfrow = c(2,3))
# plot all numeric variables as x vs response with lapply
# works like 
lapply(numNames, plot_vs_response)

# how do you interpret this? remember how wt and disp are highly correlated??



# Classification EDA(light example)


library(caret)
library(fastNaiveBayes)
library(readr)
library(functional)
library(ggplot2)
library(magrittr)
library(tidyverse)

dataurl <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"

wine <- read_csv(dataurl, col_names = F)
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

fix_cols <- function(df){
	colnames(df) <- good_cols
	df$class <- as.factor(df$class)
	df
}
wine <- fix_cols(wine)
glimpse(wine)


set.seed(3033)
## WARNING: Danger function
split <- function(df, p = 0.75, list = FALSE, ...) {
	train_ind <- createDataPartition(df[[1]], p = p, list = list)
	cat("creating training dataset...\n")
	training <<- df[train_ind, ]
	cat("completed training dataset, creating test set\n")
	test <<- df[-train_ind, ]
	cat("done")
}

split(wine)

ggplot(data = wine, aes(x = malic_acid, fill = class)) + geom_density()
ggplot(data = wine, aes(x = alkalinity, fill = class)) + geom_density()
ggplot(data = wine, aes(x = ash, fill = class)) + geom_density()
ggplot(data = wine, aes(x = magnesium, fill = class)) + geom_density()


library(doParallel)
numcores <- parallel::detectCores() - 1
cl <- makePSOCKcluster(numcores)
registerDoParallel(cl)


set.seed(3333)
trainMethod <- trainControl(method = "repeatedcv",
			    number = 10,
			    repeats = 3)
# k-folds cross validation
# y ~ x
# use train to do a grid search for best model, see 
# https://topepo.github.io/caret/model-training-and-tuning.html#model-training-and-parameter-tuning
knn_fit <- train(class ~ ., 
		 data = training, 
		 method = "knn",
		 trControl = trainMethod,
		 preProcess = c("center", "scale"),
		 tuneLength = 10)

knn_fit
# k-Nearest Neighbors 
# 
# 135 samples
#  13 predictor
#   3 classes: '1', '2', '3' 
# 
# Pre-processing:
#  centered (13), scaled (13) 
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 121, 122, 122, 121, 121, 121, ... 
# Resampling results across tuning parameters:
# 
#   k   Accuracy   Kappa    
#    5  0.9700549  0.9548756
#    7  0.9676740  0.9516351
#    9  0.9609280  0.9418362
#   11  0.9579426  0.9370280
#   13  0.9702686  0.9552588
#   15  0.9722527  0.9579543
#   17  0.9752442  0.9625294
#   19  0.9681013  0.9519242
#   21  0.9726496  0.9588742
#   23  0.9726496  0.9589829
# 
# Accuracy was used to
#  model using the
#  largest value.
# The final value used
#  for the model was k = 17.


plot(knn_fit)


test_pred <- predict(knn_fit, newdata = test)
test_pred


confusionMatrix(test_pred, test$class)

# try with different predictors as per your EDA
# an idea to do programaticly: try writing a function then lapplying all the different iterations (may require instead %dopar% or mclapply)
