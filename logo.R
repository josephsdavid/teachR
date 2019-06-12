library(magick)
library(tidyverse)
bIgDaTa <- image_read('https://jeroen.github.io/images/bigdata.jpg')
fRiNk <- image_read("https://jeroen.github.io/images/frink.png")
LoGo <- image_read("https://jeroen.github.io/images/Rlogo.png")
combo  <- c(bIgDaTa, fRiNk,LoGo)
combo  %>% image_flatten('Add') %>% 
	image_write(path = "mastRRace.png", format = "png")
