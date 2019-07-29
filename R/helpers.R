# fix up outliers
clean <- forecast::tsclean

# Generator function to fix up sampling rate to something reasonable

change_samples <- function(n){
	function(xs){
		# tapply does table apply, or grouped apply
		# this time we are grouping by divisors of n
		# try 1:20 %/% 5 as an example.
		# we are summing every n things in this case
		out <- unname(tapply(
				     xs,
				     (seq_along(xs)-1) %/% n,
				     sum
				     ))
		out <- ts(out, frequency = (8760/n))
		out
	}
}

# daily and weekly sampling, monthly is 4 weeks
to_daily <- change_samples(24)
to_weekly <- change_samples(24*7)
to_monthly <- change_samples(24*7*4)
to_season <- change_samples(24*(365/4))

# pipelining final cleaning and conversion, fixing insane outliers
# and negatives
cleandays <- function(xs) {
	xs %>>% clean %>>% abs %>>% to_daily
}

cleanweeks <- function(xs) {
	xs %>>% clean %>>% abs %>>% to_weekly
}
cleanmonths <- function(xs) {
	xs %>>% clean %>>% abs %>>% to_monthly
}
cleanseas <- function(xs) {
	xs %>>% clean %>>% abs %>>% to_season
}

# some polts
seasonplot <- forecast::ggseasonplot
subseriesplot <- forecast::ggsubseriesplot
lagplot <- forecast::gglagplot
# resampling our dataset with a window, this allows us to git a test set
resample <- function(xs){
	xs %>>% cleandays %>>% window(end = 5) -> day
	xs %>>% cleanweeks %>>% window(end = 5) -> week
	xs %>>% cleanmonths %>>% window(end = 5) -> month
	xs %>>% cleanseas %>>% window(end = 5) -> seas
	list(day = day, week = week, month = month, season = seas)
}

# forecast and assess

fore_and_assess <- function(...){
	f <- forecast(...)
	out <- assess(..., plot = FALSE)
	f$ASE <- out
	f
}

getASE <- function(model){
	accuracy(model)[2]^2
}
