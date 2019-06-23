---
title: "recursion"
author: "David Josephs"
output: html_document
---




```r
is_empty = function(xs) { # xs: a vector of any type
        length(xs) == 0
}

# Get the first element of a vector, raising an exception if the vector is empty.
hd = function(xs) { # xs: a vector of any type
        if (is_empty(xs)) stop("Vector is empty.")
        else xs[1]
}

# Get the tail of a vector without its first element, raising an exception if the vector is empty.
tl = function(xs) { # xs: a vector of any type
        if (is_empty(xs)) stop("Vector is empty.")
        else xs[-1]
}
```


```r
recsum <- function(xs) {
	if (is_empty(xs)) 0
	else hd(xs) + recsum(tl(xs))
}
```

Make a countdown function


```r
# <<countdown>>
```


## work with lists


```r
a <- list(1:2,3:4)

is_empty <- function(l){
	length(l)==0
}

hd <- function(l){
	if (is_empty(l)) stop("List is empty")
	else l[[1]]
}

tl <- function(l){
	if(is_empty(l)) stop("List is empty")
	else l[-1]
}
```



```r
sum_pairs <- function(l){
	if (is_empty(l)) 0
	else hd(l)[1] + hd(l)[2] + sum_pairs(tl(l))
}
```


```r
firstitems <- function(l) {
	if (is_empty(l)) list()
	else c(hd(l)[1], firstitems(tl(l)))
}
```


```r
#<<seconds>>
```
