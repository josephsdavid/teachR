# TeachR
![alt text](https://imgur.com/gOXtA3f.jpg)
## Repository for lectures and notes from my office hours etc

### Contents:

* [pres](pres/): contains all Rmarkdown and knitted results. Contents below:
	* [ml2](pres/ml2.Rmd)
		* Contains an overview of caret, knn, and naive bayes 
	* [ml1](pres/ml1.Rmd)
		* contains overcomplicated knn code, good for an excercise in overly fancy R code and not much else
	* [html-scraping](pres/html-scraping.md)
		* Contains a primer on scraping websites with `rvest`, as well as a slight introduction to pipes, and a few user created functions. Read this then [scraping.R](R/scraping.R) as a followup with more code to play with. 
	* [copyonmodify](pres/copyonmodify.md)
		* Discusses how we should avoid for loops and "growing vectors" in general, due to some of the fun little quirks of R.
* [R](R/): contains all R code. Contents below:
	* [final.R](R/final.R) 
		* R example of automated EDA, some training of models, from our final office hours :( 
	* [logo.R](R/logo.R)
		* R code used to make the logo for this repository
	* [scraping.R](R/scraping.R)
		* Example html scraping code
	* [tidy1.R](R/tidy1.R)
		* a quick primer on dplyr
	* [count-and-pipes.R](R/count-and-pipes.R)
		* Counting with dplyr and piping with magrittr 
	* [applied.R](R/applied.R)
		* Contains the first really advanced stuff that we will do in here, apply/lapply review, which is the equivalent mathematically of mapping, anonymous functions, lists of functions, "function factories" (closures), and finally brings everything together in one crazy example. Will be made into a .Rmd soon enough
	* [lm_1.R](R/lm_1.R) 
		* Contains the basics of linear modeling 
	* [ml1.R](R/ml1.R)
		* Contains overcomplicated knn 
	* [json2gif](R/json2gif.R)
		* Contains simple sample code where a JSON is used to show the movement of bodies through time
* [src](src/): contains C/C++ code that is used to speed up R. Currently this is empty, and we may not use this directory. Interested parties can make an issue request, email me, or message me on slack and we will work on this. For now, it is enough to know this is part of the structure of a big R project.
* [fig](fig/): contains images and figures generated
* [data](data/): contains minimal data. It is best to save data here not in csv format, but as RData/rda, because it is much much lighter.





## The basic structure of a good R project

This repository is a glimpse of what a well structured R project looks like. In general, we put R code in the **R** directory, the pretty output in its own directory, images in a directory, and low level code in a src directory. If you intend on developing an R package, which i would be happy to discuss, a good reading is [Hadley's "package structure"](http://r-pkgs.had.co.nz/package.html). This is also just useful information to use on your own R projects. I will provide (opinionated) thoughts on workflow, project structure, etc. later on.

## FAQ

### Why won't my file knit?

#### Trying to use CRAN without setting a mirror

Simple solution: don't put install.packages in Rmarkdown files.

More complex solution: `install.packages(packagename,repos = "http://cran.us.r-project.org")`

#### Cannot find my file

First attempt at answering: setwd() does not work in knitr. Instead, in the R setup chunk, do `knitr::opts_knit$set(root.dir = '/path/to/root/dir/of/project')`, or set the root directory with the R studio GUI

A simpler, but far less reproducible attempt is to just use the absolute path. But in general, it is better to use relative paths, so see above solution. Setting the root project dir tells knitr to execute your R code in a session where the working directory is what you specified. Then all your paths should work. 

A final solution, is lets say you have a Rmarkdown file in pres, and a data file in data. Then, we can in the rmd file, say:

```R
df<-load('../data/myfile.RData')
```

## Links to other useful sites and readings
* [caret documentation](https://topepo.github.io/caret/index.html)
* [ml metrics](https://towardsdatascience.com/accuracy-precision-recall-or-f1-331fb37c5cb9)
* [naive bayes overview](https://towardsdatascience.com/whats-so-naive-about-naive-bayes-58166a6a9eba)
* [naive bayes math/fast naive bayes](https://cran.r-project.org/web/packages/fastNaiveBayes/vignettes/fastnaivebayes.html)
* [awesome-msds](https://github.com/drake-smu/awesome-msds-smu)
	* a MSDS student's repository containing awesome resources for the program 
* [awesome-r](https://awesome-r.com/#awesome-r)
	* awesome R packages
* [rmarkdown manual](https://bookdown.org/yihui/rmarkdown/)
	* an amazing resource for knitting
* [knitr options](https://yihui.name/knitr/options/) 
	* More knitting resources
* [why should I use functions](https://nicercode.github.io/guides/functions/)
	* Functions not only make your code more readable, but they can also make repitive tasks easier. In my ***opinion***, we should write many small functions and combine them in a bigger function. This makes our code more readable, and more overall useful. See below for an example:
```R
# let us say we want to be able to take the log of any number, and if it is negative
# we want to make it the absolute value. This is not directly useful, but in math
# it pops up a lot (see differential equations)
square <- function(x){
	x*x
}

# yes there is an absolute value function, abs(), but this is for demonstration purpuses
absval <- function(x){
	sqrt(square(x))
}

# We are including `...` because the log() function can take extra arguments, e.g.
# base. We want to be able to have those be allowed in our function too.
abslog <- function(x,...){
	log(absval(x),...)
}

abslog(-2)
# [1] 0.6931472
abslog(2)
# [1] 0.6931472

# Now lets see the ...
abslog(-10, base = 10)
# [1] 1
abslog(3432, base = 2)
# [1] 11.74483
abslog(-3432, base = 2)
# [1] 11.74483
```


- [ ] more to come
- [ ] even more
