# re introducing lapply
# lapply(X,FUN,...)
# X is a list (or data frame, which is also a list)
# FUN is the function
# ... are extra arguments to the function


a <- list(1:3, c(1.2,4.5,NA,46,-84),c(4,5), 2:25, c(4,5,6,7,8,9,10))
a

meanfun <-  function(x){ 
	res <- c()
       	for(i in seq_along(x)){
		      res[i] <- (mean(x[[i]]))
  }
	return(res)
}

as.data.frame(lapply(mtcars,mean))
library(tidyverse)
lapply(mtcars,mean) %>% as.data.frame
meanfun(a)
lapply(a, mean)
?lapply
data(mtcars)
typeof(mtcars)


meanfun2 <-  function(x){ 
	res <- c()
       	for(i in seq_along(x)){
		res[i] <- (mean(x[[i]], na.rm = T))
	}
	return(res)
}

meanfun2(a)
lapply(a, mean, na.rm = T) %>% as.data.frame

# nameless functions
data(mtcars)

# lets say we want to find the square of every sum of mtcars

squaresum <- function(x){
	(sum(x)^2)
}

lapply(mtcars, squaresum) %>% as.data.frame
lapply(mtcars, function(x) (sum(x))^2) # they are the same

# list of functions

operator <- list(
		 mea = function(x) mean(x),
		 med = function(x) median(x),
		 squaresum = function(x) (sum(x))^2,
		 summ = function(x) summary(x)
)


x <- rnorm(n = 500,5,2)
operator$mea(x)
operator$med(x)
operator$squaresum(x)
operator$summ(x)

# useful but how do we go on

# lets use lapply now, in R, it is a little know fact that everything,
# including data works as a function
# so we can lapply the data onto our list
# wild

call_fun <- function(f, ...){
 	f(...)
}
# lets bring it all together now
lapply(operator, call_fun, x)

x <- rnorm(n = 500,5,2)
lapply(operator, function(f) f(x))

# wild stuff

# function factories

power  <- function(exponent){
	myfunction <- function(x){
		x ^ exponent
	}
	return(myfunction)
}
2^4
4^7
4^9


eitght <-power(8)
power(13)


thirteenth <- power(13)
thirteenth2 <- function(x){
  x^13
}
square2<- function(x){
  x^2
}
thirteenth(2)
thirteenth(3)
thirteenth(4)

square <- power(2)
cube <- power(3)
quart <- power(4)
square(3)
cube(4)
quart(5)

# now lets really bring it all together with an in the wild example, a function factory list for time series (apply to your own work, especially in stats :) 

library(tswge)
gen.sigplusnoise.wge(n=200, phi = c(0.2,0.4,-0.2),sn =4)
gen.arima.wge(n=200, d= 1)
gen.aruma.wge(n=200,s=11)

?gen.sigplusnoise.wge

?lapply



tswgen <- function(n,sn = 0){
	sig <- function(...){
		gen.sigplusnoise.wge(n=n,...,sn=sn)
	}
	ari <- function(...){
		gen.arima.wge(n=n,...,sn=sn)
	}
	aru <- function(...){
		gen.aruma.wge(n=n,..., sn=sn)
	}
	list("sig"=sig,"ari"=ari,"aru"=aru)
}


mtcars %>% something %>% something
mtcars %>% somethingelse 


ts200 <- tswgen(200, 30)
ts200$sig(phi = c (0.2,0.4,-0.2))
ts200$ari(d = 1)
ts200$aru(s=11)

phis <- c(0.2,0.4,-0.2)
lapply(ts200, function(f) f(phis))
ts200_37 <- tswgen(200,sn=2)
ts200_37$sig(phi = c (0.2,0.4,-0.2))
ts200_37$ari(d = 4)
ts200_37$aru(s=1)
