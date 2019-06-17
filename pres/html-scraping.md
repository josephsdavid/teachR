---
title: "HTML Scraping in R"
author: "David Josephs"
output: html_document
---


# Lord of the Rings Example

## Setup

First, lets load up two libraries which will make our life easier. First is rvest, which is a great library for reading html, it is basically an extension of the xml2 package. It has some easy syntax and is quite helpful going forwards.

The second one is in my opinion, one of the most useful libraries for doing any sort of data science or data analysis in R, the tidyverse. Just google it and see the documentation, it is a set of packages in which all of the functions have similar APIs and arguments, allowing for consistency throughout our programmig. They are also all pretty fast, with nice syntax. Examples from the tidyverse are: readr (data loading), dplyr(data analysis/cleaning/general utility), tidyr(data cleaning again, reshaping), caret(machine learning), and ggplot2(data viz). 


```r
library(rvest)
library(tidyverse)
```

Next lets load up our data. In this example we will be looking at the imdb page for lord of the rings. So we will assign a variable to the url of the page we are interested in:


```r
lotr  <- 'https://www.imdb.com/title/tt0120737/fullcredits?ref_=tt_cl_sm#cast'
```

## Reading the data

### The pipe operator

Before we can read in the data, lets first learn about `%>%` pipes. A pipe is basically saying, take the thing on the left, and make it an argument of a thing on the right. For example, lets say we want to take the mean of mtcars, the classic R example dataset, with all columns. We can do that with:


```r
lapply(mtcars,mean)
```

```
## $mpg
## [1] 20.09062
## 
## $cyl
## [1] 6.1875
## 
## $disp
## [1] 230.7219
## 
## $hp
## [1] 146.6875
## 
## $drat
## [1] 3.596563
## 
## $wt
## [1] 3.21725
## 
## $qsec
## [1] 17.84875
## 
## $vs
## [1] 0.4375
## 
## $am
## [1] 0.40625
## 
## $gear
## [1] 3.6875
## 
## $carb
## [1] 2.8125
```

This is mapping the mean function over the mtcars dataset. Now, the output of this is not very pretty, so we will turn it into a nice, horizontal data frame:


```r
as.data.frame(lapply(mtcars,mean))
```

```
##        mpg    cyl     disp       hp     drat      wt     qsec     vs
## 1 20.09062 6.1875 230.7219 146.6875 3.596563 3.21725 17.84875 0.4375
##        am   gear   carb
## 1 0.40625 3.6875 2.8125
```

Still ugly. Lets try and use the pander library to make this look nice:


```r
pander(as.data.frame(lapply(mtcars,mean)))
```


-----------------------------------------------------------------------------------------
  mpg     cyl    disp     hp     drat     wt     qsec      vs       am     gear    carb  
------- ------- ------- ------- ------- ------- ------- -------- -------- ------- -------
 20.09   6.188   230.7   146.7   3.597   3.217   17.85   0.4375   0.4062   3.688   2.812 
-----------------------------------------------------------------------------------------

Much better, but look at how many parentheses we wrote, and how difficult this is to read. Imagine if we had 4 or 5 more steps. We would have to repeatedly assign things to new variables, and keep working and working and putting things in our computers memory to have readable code. Even then, if we assigned a variable on every step, someone reviewing your code would end up having to know 20 or so lines of code above, just to understand the final printing line. This leads to errors and is not reproducible. Instead, lets try it with the pipe operator. Mathematically, `f(x,y) = x %>% f(y)`, if that helps:


```r
mtcars %>% lapply(mean) %>% as.data.frame %>% pander
```


-----------------------------------------------------------------------------------------
  mpg     cyl    disp     hp     drat     wt     qsec      vs       am     gear    carb  
------- ------- ------- ------- ------- ------- ------- -------- -------- ------- -------
 20.09   6.188   230.7   146.7   3.597   3.217   17.85   0.4375   0.4062   3.688   2.812 
-----------------------------------------------------------------------------------------

This reads from left to right (as we english speakers are in the habit of doing):
First, we take the mtcars dataset. Then, we apply the mean function onto every column of the dataset, outputting into the form of a list. We then turn the list, which is hard to read, into a nice flat data frame, and then we pretty up the data frame in a final step. This is the pipe operator.

### Actually reading in the data

So, with our knowledge of the pipe operator, what can we do? Lets use rvest functions to turn the raw xml and/or html data into something nice and human human readbale. 

First, lets read in the website:


```r
# not run
read_html(lotr)
```

Next lets choose all the tables (we know all of our data is in tables) in the raw data, with the `html_nodes()` function:


```r
read_html(lotr) %>% html_nodes("table")
```

Next, lets choose the right table. By looking at the website, we know that the third table contains the info on the cast. To choose the third table of an unnamed object, we are going to have to use the `.` operator, which we will see is just a placeholder for the thing on the left.



```r
read_html(lotr) %>% html_nodes("table") %>% .[[3]]
```

#### An Aside on lists
Why did we do `[[]]`?
This is because html_nodes outputs a list, and there are three ways we can get items from a list, `$`, for named items, keeps the type of the item if it is some sort of vector. `[]` allows us to index the list, but the output is always in the form of a list, eg, data type is extracted at some other set. Third, we have `[[]]`, which allows us to index the list and get the proper data type in an output. Experiment with this by using the following list as well as the built in `typeof()` function.


```r
x <- list("char" = c("cat","dog"), "nest" = list((1:3),2:4), "int" = 4:5, "logical" = c(T,F,T,F), "float" = c(87.5, -962.4))
```

### Back to Business

Now that we understand what `.[[3]]` is doing, we can now extract the full dataset:


```r
read_html(lotr) %>% html_nodes("table") %>% .[[3]]  %>% html_table -> cast
(head(cast))
```

```
##   X1           X2  X3                                    X4
## 1                                                          
## 2     Alan Howard ... Voice of the Ring \n  \n  \n  (voice)
## 3    Noel Appleby ...                     Everard Proudfoot
## 4      Sean Astin ...                                   Sam
## 5      Sala Baker ...                                Sauron
## 6       Sean Bean ...                               Boromir
```

Great. Now that process was pretty painful, and took a lot of typing, and in the future we may not know which table we are looking for, so lets write a nice little function to do this all in one step:



```r
tablescraper <- function(url, item){
  read_html(url) %>% html_nodes("table") %>% . [[item]] %>% html_table -> out
  return(out)
}
```

Now that we have a nice function, we can iteratively search through the IMDB site:


```r
tablescraper(lotr,1) %>% head
```

```
##              X1 X2 X3
## 1 Peter Jackson NA NA
```

```r
tablescraper(lotr,2) %>% head
```

```
##                X1  X2             X3
## 1  J.R.R. Tolkien ...        (novel)
## 2                                   
## 3      Fran Walsh ... (screenplay) &
## 4 Philippa Boyens ... (screenplay) &
## 5   Peter Jackson ...   (screenplay)
```

```r
tablescraper(lotr,3) -> cast
```

We can even imagine, for a large project, just writing a for loop to do all of this.
Next, lets check out the first and last ten items of cast:


```r
ht <- function(x,...){
	head(x,...)
	tail(x,...)
}
ht(cast,10)
```

```
##     X1                     X2  X3
## 124                Chris Ryan ...
## 125             Paul Shapcott ...
## 126           Samuel E. Shore ...
## 127              Mike Stearne ...
## 128            Andrew Stehlin ...
## 129              Ken Stratton ...
## 130               Jo Surgison ...
## 131    James Waterhouse-Brown ...
## 132                  Tim Wong ...
## 133              Robert Young ...
##                                                                                                                                     X4
## 124                                                                                                Breelander \n  \n  \n  (uncredited)
## 125                                                                                        Burning Ringwraith \n  \n  \n  (uncredited)
## 126                                                                              Refugee /  \n            Orc \n  \n  \n  (uncredited)
## 127                                                                                                  Uruk-hai \n  \n  \n  (uncredited)
## 128                                                                                                  Uruk-hai \n  \n  \n  (uncredited)
## 129 Isengard Orc /  \n            Last Alliance Soldier /  \n            Morgul Orc /  \n            Uruk-hai \n  \n  \n  (uncredited)
## 130                                                                                                    Hobbit \n  \n  \n  (uncredited)
## 131                                                                                                    Goblin \n  \n  \n  (uncredited)
## 132                                                                                                  Uruk-hai \n  \n  \n  (uncredited)
## 133                                                                                                    Goblin \n  \n  \n  (uncredited)
```

***NOTE***: the `...` in our function allows for extra arguments. We do this so we can throw in the extra parameter, `10` which changes head and tail to showing the first and last 10 instead of the first and last 6 items.

## Cleaning the data
Wow, this data is a mess. The first thing we see is that the first row is entirely blank, and then that the first and third columns are completely empty. Lets get rid of that:


```r
cast <- cast[-1,]
cast$X1 <- NULL
cast$X3 <- NULL
ht(cast)
```

```
##                         X2
## 128         Andrew Stehlin
## 129           Ken Stratton
## 130            Jo Surgison
## 131 James Waterhouse-Brown
## 132               Tim Wong
## 133           Robert Young
##                                                                                                                                     X4
## 128                                                                                                  Uruk-hai \n  \n  \n  (uncredited)
## 129 Isengard Orc /  \n            Last Alliance Soldier /  \n            Morgul Orc /  \n            Uruk-hai \n  \n  \n  (uncredited)
## 130                                                                                                    Hobbit \n  \n  \n  (uncredited)
## 131                                                                                                    Goblin \n  \n  \n  (uncredited)
## 132                                                                                                  Uruk-hai \n  \n  \n  (uncredited)
## 133                                                                                                    Goblin \n  \n  \n  (uncredited)
```

Next, lets rename with dplyr:


```r
cast %>% rename(Actor = X2, Character = X4) -> cast
```

Looking better, now we know from the IMDB website that the table contains"Rest of cast listed alphabetically:", so lets get rid of that. To do this, we are going to use `grepl()`

`grepl()` searches for a pattern and then returns a logical (true/false) vector of whether or not there is a match. We can then index `cast` for all rows where the result of `grepl` are not true, eliminating the unwanted line:


```r
cast<-cast[!grepl("Rest of cast listed alphabetically:", cast$Actor),]
```


Try and see how this dplyr syntax is different from doing it in base R as a learning challenge, and see which one you prefer.

Next lets get rid of those nasty `\n`'s. To do this, lets use `gsub()`, short for global substite. Since we dont know how all newlines are delimited, we will search for all types of newlines, `\n` (unix) `\r\n` (windows) and `\r` (old web line endings). To do this, we will use the regular expression `[\r\n]`. This allows us to search for `\r`,`\n`, and `\r\n` (thats what the brackets do). Lets turn those all into nothing.


```r
cast$Character<-gsub("[\r\n]","",cast$Character)
ht(cast)
```

```
##                      Actor
## 128         Andrew Stehlin
## 129           Ken Stratton
## 130            Jo Surgison
## 131 James Waterhouse-Brown
## 132               Tim Wong
## 133           Robert Young
##                                                                                                                  Character
## 128                                                                                            Uruk-hai       (uncredited)
## 129 Isengard Orc /              Last Alliance Soldier /              Morgul Orc /              Uruk-hai       (uncredited)
## 130                                                                                              Hobbit       (uncredited)
## 131                                                                                              Goblin       (uncredited)
## 132                                                                                            Uruk-hai       (uncredited)
## 133                                                                                              Goblin       (uncredited)
```

Now, we have a ton of whitespace. Lets get rid of that. The regular expression for a single space is `\s`. But, we want to get rid of more than one space, and the regular expression for that is `\s+`. Lets combine the two so we are looking for all spaces, by doing `\s\s+`. That however is not very pretty, so lets combine one step further, and rewrite as `\\s+`. This is going to match with all amounts of whitespace. Lets turn all of these into a single space:


```r
cast$Character<-gsub("\\s+"," ",cast$Character)
ht(cast)
```

```
##                      Actor
## 128         Andrew Stehlin
## 129           Ken Stratton
## 130            Jo Surgison
## 131 James Waterhouse-Brown
## 132               Tim Wong
## 133           Robert Young
##                                                                     Character
## 128                                                     Uruk-hai (uncredited)
## 129 Isengard Orc / Last Alliance Soldier / Morgul Orc / Uruk-hai (uncredited)
## 130                                                       Hobbit (uncredited)
## 131                                                       Goblin (uncredited)
## 132                                                     Uruk-hai (uncredited)
## 133                                                       Goblin (uncredited)
```

Excellent work, we have now turned a once very ugly raw frame into something we can work with. 

# A challenge:

Two challenges here:

* Is there another way we could have cleaned up the `\n` or the `\s`? Try out `library(stringr)` and explore the functions there.

* Try separating first name from last name  (eg make a first and last name column), using whatever means necessary (this is in your homework assignment this week)

# Note

To see more examples and play around with the source code for this document, see `R/scraping.R`
