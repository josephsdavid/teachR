library(jsonlite)
library(ggplot2)
## requires: jsonlite, ggplot2

myjson <- fromJSON("output.json")


myjson$bodies
# [[1]]
#   body pos.x pos.y mass
# 1    0     1     1   10
# 2    1     3     3   10
# 3    2     5     5  100
# 
# [[2]]
#   body pos.x pos.y mass
# 1    0  2.75  2.75   10
# 2    1  3.75  3.75   10
# 3    2  4.75  4.75  100
# 
# [[3]]
#   body pos.x pos.y mass
# 1    0 3.625 3.625   10
# 2    1 4.125 4.125   10
# 3    2 4.625 4.625  100
# 
# [[4]]
#   body  pos.x  pos.y mass
# 1    0 4.0625 4.0625   10
# 2    1 4.3125 4.3125   10
# 3    2 4.5625 4.5625  100
# 
# [[5]]
#   body   pos.x   pos.y mass
# 1    0 4.28125 4.28125   10
# 2    1 4.40625 4.40625   10
# 3    2 4.53125 4.53125  100
# 

str(myjson$bodies)

x <- 1:5
y <- 6:10
z  <- 11:15


xydf <- data.frame(a = x, b = y)

zdf <- data.frame(c = z)

xyzdf <- data.frame(xydf, zdf)
#   a  b  c
# 1 1  6 11
# 2 2  7 12
# 3 3  8 13
# 4 4  9 14
# 5 5 10 15

str(xyzdf)
# 'data.frame':	5 obs. of  3 variables:
#  $ a: int  1 2 3 4 5
#  $ b: int  6 7 8 9 10
#  $ c: int  11 12 13 14 15

xyzdf
#   a  b  c
# 1 1  6 11
# 2 2  7 12
# 3 3  8 13
# 4 4  9 14
# 5 5 10 15


squareSum <- function(vec) {
  sum((vec)^2)
}


squareSum(z)
# [1] 855
# [1] 330
# [1] 55

squareSum(xyzdf$a)
# [1] 55


# *apply




#lapply(data, function)



lapply(xyzdf, squareSum)

str(myjson$bodies[[1]])
# 'data.frame':	3 obs. of  3 variables:
#  $ body: int  0 1 2
#  $ pos :'data.frame':	3 obs. of  2 variables:
#   ..$ x: num  1 3 5
#   ..$ y: num  1 3 5
#  $ mass: num  10 10 100
# NULL



str(data.frame(myjson$bodies[[1]]))
# 'data.frame':	3 obs. of  3 variables:
#  $ body: int  0 1 2
#  $ pos :'data.frame':	3 obs. of  2 variables:
#   ..$ x: num  1 3 5
#   ..$ y: num  1 3 5
#  $ mass: num  10 10 100
# NULL



dfs <- lapply(myjson$bodies, data.frame, stringsAsFactors = FALSE )
# [[1]]
#   body pos.x pos.y mass
# 1    0     1     1   10
# 2    1     3     3   10
# 3    2     5     5  100
# 
# [[2]]
#   body pos.x pos.y mass
# 1    0  2.75  2.75   10
# 2    1  3.75  3.75   10
# 3    2  4.75  4.75  100
# 
# [[3]]
#   body pos.x pos.y mass
# 1    0 3.625 3.625   10
# 2    1 4.125 4.125   10
# 3    2 4.625 4.625  100
# 
# [[4]]
#   body  pos.x  pos.y mass
# 1    0 4.0625 4.0625   10
# 2    1 4.3125 4.3125   10
# 3    2 4.5625 4.5625  100
# 
# [[5]]
#   body   pos.x   pos.y mass
# 1    0 4.28125 4.28125   10
# 2    1 4.40625 4.40625   10
# 3    2 4.53125 4.53125  100
# 

str(dfs)
# List of 5
#  $ :'data.frame':	3 obs. of  3 variables:
#   ..$ body: int [1:3] 0 1 2
#   ..$ pos :'data.frame':	3 obs. of  2 variables:
#   .. ..$ x: num [1:3] 1 3 5
#   .. ..$ y: num [1:3] 1 3 5
#   ..$ mass: num [1:3] 10 10 100
#  $ :'data.frame':	3 obs. of  3 variables:
#   ..$ body: int [1:3] 0 1 2
#   ..$ pos :'data.frame':	3 obs. of  2 variables:
#   .. ..$ x: num [1:3] 2.75 3.75 4.75
#   .. ..$ y: num [1:3] 2.75 3.75 4.75
#   ..$ mass: num [1:3] 10 10 100
#  $ :'data.frame':	3 obs. of  3 variables:
#   ..$ body: int [1:3] 0 1 2
#   ..$ pos :'data.frame':	3 obs. of  2 variables:
#   .. ..$ x: num [1:3] 3.62 4.12 4.62
#   .. ..$ y: num [1:3] 3.62 4.12 4.62
#   ..$ mass: num [1:3] 10 10 100
#  $ :'data.frame':	3 obs. of  3 variables:
#   ..$ body: int [1:3] 0 1 2
#   ..$ pos :'data.frame':	3 obs. of  2 variables:
#   .. ..$ x: num [1:3] 4.06 4.31 4.56
#   .. ..$ y: num [1:3] 4.06 4.31 4.56
#   ..$ mass: num [1:3] 10 10 100

p <- ggplot()

p+geom_point(data = dfs[[1]], aes(x = pos$x, y = pos$y, color = as.factor(body)))


myplot <- function(df) {
  p + geom_point(data = df, aes(x = pos$x, y = pos$y, color = as.factor(body))) +
    coord_cartesian(xlim = c(0,5), ylim = c(0,5))
}
png()
lapply(dfs,myplot)
dev.off()

# imageMagick
system("convert -delay 60 *.png example_1.gif")



lazplotter <- function(json) {
	myjson <- fromJSON(json)
	dfs <- lapply(myjson$bodies, data.frame, stringsAsFactors = FALSE)
	p <- ggplot()
	plot <- function(df) {
		p <- p + geom_point(data = df, aes(pos$x, pos$y, 
						    color = as.factor(body))) +
                        coord_cartesian(xlim = c(0,5), ylim = c(0,5))
	}
	lapply(dfs,plot)
}

lazplotter("output.json")



library(dplyr) # for bind_rows
tidyplotter <- function(json) {
	jason <- fromJSON(json)
	dfs <- lapply(jason$bodies, data.frame, stringsAsFactors = FALSE)
	
	pos2vec <- function(l) {
		df <- l$pos
		x <- df$x
		y <- df$y
		data.frame("body" = l$body, "x" = x, "y" = y, "mass" = l$mass)
	
	}
	
	dfs <- lapply(dfs,pos2vec)
	dfs %>% bind_rows(.id = "step") -> tabl
	ggplot(tabl, aes(x,y, label = step))  + geom_point(aes(color = step, size = 5)) + facet_wrap(body~.) + geom_line() +guides(size = F)
}
tidyplotter("output.json")

