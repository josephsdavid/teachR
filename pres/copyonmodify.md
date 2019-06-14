---
title: "R copy on modify"
author: "David Josephs"
output: rmarkdown::github.document
---

For this little lesson, we will learn about the cool things R does when we copy objects, and some of the pitfalls of for loops. 
We will be using Hadley's pryr package, which "prys back the covers of R"


```r
library(pryr)
size_and_addr <- function(x){
	cat(rep('-',30), '\n')
	cat("Object size: ", object_size(x),"\n")
	cat(rep('-',30), '\n')
	cat("Address in memory: ", address(x))
}
```

First, let us create a simple data frame:


```r
a <- data.frame(matrix(1:9, nrow=3))
```

Next, let's see how big it is in your computer's memory (RAM), and where it is stored


```r
size_and_addr(a)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  1032 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x2fabf60
```

Now lets create a new object, b, which is just a, and then see where it lies in your computer's memory. Lets also create a new object, x, for later use


```r
x <- a
b <- a

size_and_addr(b)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  1032 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x2f32c88
```

```r
size_and_addr(x)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  1032 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x28c80b0
```

It is in the same place, which is pretty cool and efficient. But what happens if we modify b and leave A the same?


```r
b$X4 <- c(10:12)
address(a)
```

```
## [1] "0x2e813e8"
```

```r
size_and_addr(b)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  1152 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x18ce4b8
```

So on modification, we create a copy, and put it in a new place. What do you think the size of a and b is?


```r
object_size(a,b)
```

```
## 1.48 kB
```

Pretty cool, R is saving you memory. All the columns that match are stored in the same location, and only the new ones take more space.


```r
address(x)
```

```
## [1] "0x2e813e8"
```

```r
size_and_addr(a)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  1032 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x3f33038
```

```r
object_size(a,x)
```

```
## 1.03 kB
```

```r
x <- rbind(x,1:3)
size_and_addr(x)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  1032 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x406d818
```

```r
object_size(a,x)
```

```
## 1.53 kB
```


Note that this is a little bigger. This is because row indexes take up a little more space than columns.

Lets now see what happens in a for loop, when we "grow a vector". Lets also run our code effic


```r
vec <- c()
size_and_addr(vec)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  0 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x446bd88
```

```r
vec[1] <- 1
size_and_addr(vec)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  56 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x4532240
```

```r
vec[2] <- 2
size_and_addr(vec)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  64 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x45f86f8
```

```r
vec[3] <- 3
size_and_addr(vec)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  80 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x46c6820
```

```r
vec[4] <- 4
size_and_addr(vec)
```

```
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Object size:  80 
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Address in memory:  0x478ccd8
```

Wow, so each time we add an element to a vector, we are not only using more memory, but actually moving our object from point to point. This is not a fast process, which is why doing a dirty for loop takes so long in R. Instead, we should ***IN GENERAL*** use functions which call speedy compiled code, such as the apply family and/or purr::map

For futher reading, see:
[Row wise modification in a loop](https://milesmcbain.xyz/rstats-anti-pattern-row-wise/)
