library(magick)
library(tidyverse)
# From the docs for the excellent magick package
bigdata <- image_read('https://jeroen.github.io/images/bigdata.jpg')
frink <- image_read("https://jeroen.github.io/images/frink.png")
logo <- image_read("https://jeroen.github.io/images/Rlogo.png")
combo  <- c(bigdata, frink,logo)
combo  %>% image_flatten('Add') %>% 
  image_write(path = "../fig/logo.png", format = "png")
