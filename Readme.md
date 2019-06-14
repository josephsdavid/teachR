# TeachR
![alt text](https://imgur.com/gOXtA3f.jpg)
## Repository for lectures and notes from my office hours etc

### Contents:
* [R](R/): contains all R code. Contents below:
	* [logo.R](R/logo.R)
		* R code used to make the logo for this repository
	* [scraping.R](R/scraping.R)
		* Example html scraping code
	* [tidy1.R](R/tidy1.R)
		* a quick primer on dplyr
	* [count-and-pipes.R](R/count-and-pipes.R)
		* Counting with dplyr and piping with magrittr 
* [pres](pres/): contains all Rmarkdown and knitted results. Contents below:
	* [copyonmodify](pres/copyonmodify.md)
		* Discusses how we should avoid for loops and "growing vectors" in general, due to some of the fun little quirks of R.
* [src](src/): contains C/C++ code that is used to speed up R. Currently this is empty, and we may not use this directory. Interested parties can make an issue request, email me, or message me on slack and we will work on this. For now, it is enough to know this is part of the structure of a big R project.
* [fig](fig/): contains images and figures generated



## The basic structure of a good R project

This repository is a glimpse of what a well structured R project looks like. In general, we put R code in the **R** directory, the pretty output in its own directory, images in a directory, and low level code in a src directory. If you intend on developing an R package, which i would be happy to discuss, a good reading is [Hadley's "package structure"](http://r-pkgs.had.co.nz/package.html). This is also just useful information to use on your own R projects. I will provide (opinionated) thoughts on workflow, project structure, etc. later on.
