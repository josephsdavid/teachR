## @knitr setup

is_empty = function(xs) { # xs: a vector of any type
  length(xs) == 0
}

is_empty(c(1,2,3,4))
c()
integer()
is_empty(c())
# Get the first element of a vector, raising an exception if the vector is empty.
hd = function(xs) { # xs: a vector of any type
  if (is_empty(xs)) stop("Vector is empty.")
  else xs[1]
}
x <- c(2,3,4,5,6)
hd(x)

# Get the tail of a vector without its first element, raising an exception if the vector is empty.
tl = function(xs) { # xs: a vector of any type
  if (is_empty(xs)) stop("Vector is empty.")
  else xs[-1]
}


tl(x)


## @knitr first

recsum <- function(xs) {
  if (is_empty(xs)) {
    return(0)
  }
  else {
    hd(xs) + recsum(tl(xs))
  }
}
y = c(3,4,5,6)
hd(y)
y2 = c(4,5,6)
hd(y2)
y3=c(5,6)
hd(y3)
y4 = 6
hd(y4)
hd(y)+hd(y2)+hd(y3)+hd(y4)
recsum(y)
## @knitr listtool

a <- list(1:2,3:4)
a
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

data(mtcars)


mtcars[,-1]
head(a,1)
## @knitr sumpair

sum_pairs <- function(l){
  if (is_empty(l)) 0
  else hd(l)[1] + hd(l)[2] + sum_pairs(tl(l))
}

## @knitr firstitem

hd(a)[1]

list()


firstitems <- function(l) {
  if (is_empty(l)) list()
  else c(hd(l)[1], firstitems(tl(l)))
}

firstitems(b)

h1 = hd(b)[1]

b2 = tl(b)
b2
h2 =hd(b2)[1]

b3 = tl(b2)
b3
h3 = hd(b3)[1]
list(h1,h2,h3)
b<- list(1:4,4:7,c("cat","dog","mouse"))
b
firstitems(a)
hd(a)[1]
a2 <-tl(a)
hd(a2)[1]
## @knitr countdown

countdown <- function(n){
  if (n == 0) integer()
  else c(n,countdown(n-1))
}

## @knitr seconds


seconds <- function(l) {
  if (is_empty(l)) list()
  else c(hd(l)[2], seconds(tl(l)))
}
