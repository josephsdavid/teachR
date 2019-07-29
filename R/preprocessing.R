library(functional) # to compose the preprocessing pipeline
library(data.table)# to read csvs FAST
library(rlist) # for list manipulations
library(pipeR) # fast, dumb pipes
library(imputeTS) # to impute NAs
library(pander) # so i can read the output
library(foreach) # go fast
library(doParallel) # go fast

# Data import
#  datadir <- "../data/"
# function which imports the data as a list, then fixes up the names to be nice
import <- function(path){
	# first we list the files in the directory we specify
	files <- list.files(path)
	# we fund csvs
	files <- files[grepl(files, pattern = ".csv")]
	# we paste the path to our filename
	filepaths <- sapply(files, function(x) paste0(path,x))
	# We read in all the files
	out <- lapply(filepaths, fread)
	# we clean up the names
	fnames <- gsub(".csv","",files)
	fnames <- gsub("[[:digit:]]+","", fnames)
	names(out) <- fnames
	# return the list of data frames
	out
}
#  datas <- import(datadir)

# count the nas of a data frame

# sum up the NAs and combine into a vector, note we are using percentages here
count_nas_single <- function(df){
	sapply(df, function(x) sum(is.na(x))/length(x))

}

# count the NAs of a whole list
count_nas <- function(xs){
	lapply(xs, count_nas_single)
}

# pander(count_nas(datas))
# 
# 
#   * **BeijingPM_**:
# 
#     ---------------------------------------------------------------------
#      No   year   month   day   hour   season   PM_Dongsi   PM_Dongsihuan
#     ---- ------ ------- ----- ------ -------- ----------- ---------------
#      0     0       0      0     0       0       0.5236         0.61
#     ---------------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     ----------------------------------------------------------------------------
#      PM_Nongzhanguan   PM_US Post     DEWP        HUMI       PRES       TEMP
#     ----------------- ------------ ----------- ---------- ---------- -----------
#          0.5259         0.04178     9.509e-05   0.006447   0.006447   9.509e-05
#     ----------------------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     --------------------------------------------------
#        cbwd         Iws      precipitation    Iprec
#     ----------- ----------- --------------- ----------
#      9.509e-05   9.509e-05     0.009204      0.009204
#     --------------------------------------------------
# 
#   * **ChengduPM_**:
# 
#     ---------------------------------------------------------------------
#      No   year   month   day   hour   season   PM_Caotangsi   PM_Shahepu
#     ---- ------ ------- ----- ------ -------- -------------- ------------
#      0     0       0      0     0       0         0.5356        0.5323
#     ---------------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     --------------------------------------------------------------------------
#      PM_US Post    DEWP      HUMI       PRES      TEMP       cbwd       Iws
#     ------------ --------- --------- ---------- --------- ---------- ---------
#        0.4504     0.01006   0.01017   0.009908   0.01002   0.009908   0.01014
#     --------------------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     ------------------------
#      precipitation   Iprec
#     --------------- --------
#         0.0562       0.0562
#     ------------------------
# 
#   * **GuangzhouPM_**:
# 
#     --------------------------------------------------------------
#      No   year   month   day   hour    season     PM_City Station
#     ---- ------ ------- ----- ------ ----------- -----------------
#      0     0       0      0     0     1.902e-05       0.3848
#     --------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     -----------------------------------------------------------------------
#      PM_5th Middle School   PM_US Post     DEWP        HUMI        PRES
#     ---------------------- ------------ ----------- ----------- -----------
#             0.5988            0.3848     1.902e-05   1.902e-05   1.902e-05
#     -----------------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     ---------------------------------------------------------------
#        TEMP        cbwd         Iws      precipitation     Iprec
#     ----------- ----------- ----------- --------------- -----------
#      1.902e-05   1.902e-05   1.902e-05     1.902e-05     1.902e-05
#     ---------------------------------------------------------------
# 
#   * **ShanghaiPM_**:
# 
#     -----------------------------------------------------------------------------
#      No   year   month   day   hour   season   PM_Jingan   PM_US Post   PM_Xuhui
#     ---- ------ ------- ----- ------ -------- ----------- ------------ ----------
#      0     0       0      0     0       0       0.5303       0.3527      0.521
#     -----------------------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     -----------------------------------------------------------------------
#        DEWP        HUMI        PRES        TEMP        cbwd         Iws
#     ----------- ----------- ----------- ----------- ----------- -----------
#      0.0002472   0.0002472   0.0005325   0.0002472   0.0002282   0.0002282
#     -----------------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     -------------------------
#      precipitation    Iprec
#     --------------- ---------
#         0.07624      0.07624
#     -------------------------
# 
#   * **ShenyangPM_**:
# 
#     ----------------------------------------------------------------------
#      No   year   month   day   hour   season   PM_Taiyuanjie   PM_US Post
#     ---- ------ ------- ----- ------ -------- --------------- ------------
#      0     0       0      0     0       0         0.5362         0.5877
#     ----------------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     --------------------------------------------------------------------------
#      PM_Xiaoheyan    DEWP      HUMI      PRES      TEMP      cbwd       Iws
#     -------------- --------- --------- --------- --------- --------- ---------
#         0.5317      0.01316   0.01293   0.01316   0.01316   0.01316   0.01316
#     --------------------------------------------------------------------------
# 
#     Table: Table continues below
# 
# 
#     ------------------------
#      precipitation   Iprec
#     --------------- --------
#         0.2427       0.2427
#     ------------------------
# 
# 
# <!-- end of list -->
# 
# 
# NULL

# convert a vector to a time series with the proper frequency (we will say years in this case)
tots <- function(v){
	ts(v, frequency = 365*24)
}
# tots(datas[[1]]$PM_US) %>>% tail

# convert a data frame into a list of time series objects, given column names
totslist <- function(df){
	# vector of column names which we do not want to convert to a time series
	badlist <- c(
		     "No",
		     "year",
		     "month",
		     "day",
		     "hour",
		     "season",
		     "cbwd"
	)
	# names of out data frame
	nms <- colnames(df)
	# coerce to a list
	df <- as.list(df)
	# if the column at [[name]] is on our list, return it, otherwise, convert 
	# to a time series. This allows us to deal with different amounts of data 
	# collections of time series data (some series have more PM collecting
	# stations than others)
	for (name in nms){
		if (name %in% badlist){
			df[[name]] <- df[[name]]
		} else {
			df[[name]]  <- tots(df[[name]])
		}
	}
	df
	

}
# datas[[1]] %>>% totsdf %>>%str
# datas[[1]] %>>% totslist%>>%str
# turn all data frames in a list of data frames to time series objects
totsall <- function(xs){
	lapply(xs, totslist)
}
# str(datas[[1]]$PM_US)
# datas %>>% totsall -> datas

# impute NAs of a single list with spline interpolation
# try na.ma but dont fail on error, instead just do standard type checking
# if the output is a time series, impute the NAs, otherwise do nothing
imp_test <- function(v){
	out <- try(na.interpolation(v, "spline"))
	ifelse(
	       is.ts(out),
	       return(out),
	       return(v)
	)
}
# impute the NAs of a single list, keep column names (.final)
impute <- function(xs){
	foreach(i = 1:length(xs),
		.final = function(x){
			setNames(x, names(xs))
		}) %dopar% 
		imp_test(xs[[i]])
}
# example of parallel computing
# cl <- makeCluster(11, type = "FORK")
# registerDoParallel(cl)
# na.ma(datas[[1]][["PM_"]], k=200)
# na.interpolation(datas[[1]][["PM_Dongsi"]], "spline") %>>% head
# impute(datas[[1]]) %>>% names

# impute NAs of the parent list
impute_list <- function(xs){
	lapply(xs, impute)
}

# make a fast hash table
# hash tables are an excellent and flexible way to store large amounts of data
# can be indexed with $ and [[]] nicely
# but the data is represented in a memory efficient way, an can be manipulated in complex ways
# Think of it like a realy fast database for searching and inserting
to_hash <- function(xs){
	list2env(xs, envir = NULL, hash = TRUE)
}
# final preprocessing function:

preprocess <- Compose(import, totsall, impute_list, to_hash)
