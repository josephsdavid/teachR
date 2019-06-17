?save
library(readr)
read_csv('demo.csv')->df

saveRDS(df, "demographaic.rds")
