library(tswgewrapped)
library(ggthemes)
library(ggplot2)
library(cowplot)
source("../R/preprocessing.R", echo = TRUE)
source("../R/helpers.R", echo = TRUE)


# data import
# imports the data as a hash table
fine_china <- preprocess("../data/")
names(fine_china)
# [1] "ChengduPM_"   "ShenyangPM_"  "ShanghaiPM_"  "BeijingPM_"   "GuangzhouPM_"
# <environment: 0x7bf3c10>


# shanghai
shang_US <- fine_china$ShanghaiPM_$PM_US

usShang <- resample(shang_US)
plotts.sample.wge(usShang$day)
plotts.sample.wge(usShang$week)
plotts.sample.wge(usShang$month)
plotts.sample.wge(usShang$sea)
decompose(usShang$day, "multiplicative") %>>% autoplot+ theme_economist()
decompose(usShang$day,   "additive") %>>% autoplot+ theme_economist()
decompose(usShang$week, "multiplicative") %>>% autoplot+ theme_economist()
decompose(usShang$week,  "additive") %>>% autoplot+ theme_economist()
decompose(usShang$month, "multiplicative") %>>% autoplot+ theme_economist()
decompose(usShang$month, "multiplicative") %>>% autoplot+ theme_economist()
decompose(usShang$sea, "additive") %>>% autoplot+ theme_economist()
decompose(usShang$sea, "additive") %>>% autoplot+ theme_economist()
usShang$week %>>%  lagplot+ theme_economist()
usShang$day %>>% seasonplot + theme_economist()
usShang$day %>>% seasonplot(polar = TRUE) + theme_economist()
usShang$week %>>% seasonplot+ theme_economist()
usShang$week %>>% seasonplot(polar = T)+ theme_economist()
usShang$month %>>% seasonplot+ theme_economist()
usShang$month %>>% seasonplot(polar = T)+ theme_economist()
usShang$seas %>>% seasonplot(polar = T) + theme_economist()
usShang$seas %>>% seasonplot + theme_economist()



# next lets look at ses and holt models

library(fpp2)

sesd <- ses(usShang$day)
sesw <- ses(usShang$week)
sesm <- ses(usShang$month)
par(mfrow = c(1,3))
lapply(list(sesd,sesw,sesm), plot)


accuracy(fitted(sesd))

accuracy(fitted(sesw))

accuracy(fitted(sesm))


## Problem: implement the above for holt



# below is extra, see analysis2 for more complex fun








# We see with the weekly plot we have a lot of seasonality


# lets just for fun do some predictions with the daily data

shang <- usShang$day
plotts.sample.wge(shang)
# we have clear seasonality, and maybe a wandering behavior. I believe we have a biannual seasonality, based off of the monthly graph
shang %>>% ( difference(seasonal,., (365)) ) -> shang2
difference(arima, shang2, 1) -> shang3
aics <- shang3 %>>% aicbic(p=0:10)
pander(aics)
# 
# 
#   *
# 
#     ------------------------
#      &nbsp;   p   q    aic
#     -------- --- --- -------
#      **20**   3   1   13.51
# 
#      **6**    0   5   13.52
# 
#      **4**    0   3   13.52
# 
#      **10**   1   3   13.52
# 
#      **3**    0   2   13.55
#     ------------------------
# 
#   *
# 
#     ------------------------
#      &nbsp;   p   q    bic
#     -------- --- --- -------
#      **20**   3   1   13.54
# 
#      **4**    0   3   13.55
# 
#      **6**    0   5   13.55
# 
#      **10**   1   3   13.56
# 
#      **3**    0   2   13.57
#     ------------------------
# 
# 
# <!-- end of list -->
# 
# 
# NULL
aicss <- shang %>>% ( difference(seasonal,., 365) ) %>>% aicbic(p=0:10)
pander(aics)
# 
# 
#   *
# 
#     -----------------------
#      &nbsp;   p   q   aic
#     -------- --- --- ------
#      **20**   3   1   13.5
# 
#      **11**   1   4   13.5
# 
#      **26**   4   1   13.5
# 
#      **16**   2   3   13.5
# 
#      **24**   3   5   13.5
#     -----------------------
# 
#   *
# 
#     ------------------------
#      &nbsp;   p   q    bic
#     -------- --- --- -------
#      **13**   2   0   13.53
# 
#      **3**    0   2   13.53
# 
#      **8**    1   1   13.53
# 
#      **7**    1   0   13.53
# 
#      **20**   3   1   13.53
#     ------------------------
# 
# 
# <!-- end of list -->
# 
# 
# NULL
par(mfrow = c(1,1))
est_shang <- estimate(shang2, p=2, q = 0)
acf(est_shang$res)
ljung_box(est_shang$res, p =2, q =0)
shang_seasonal <- fore_and_assess(type = aruma,
                                  x = shang,
                                  s = 365,
                                  phi = est_shang$phi,
                                  n.ahead = 24,
                                  limits = F
)

est_shang2 <- estimate(shang3, p = 3, q = 1)
acf(est_shang2$res)
ljung_box(est_shang2$res, 3, 1)
#            [,1]             [,2]            
# test       "Ljung-Box test" "Ljung-Box test"
# K          24               48              
# chi.square 14.14806         35.92178        
# df         20               44              
# pval       0.8229101        0.8017901       

shang_aruma <- fore_and_assess(type = aruma,
                               x = shang,
                               s = 365,
                               d = 1,
                               phi = est_shang2$phi,
                               theta = est_shang2$theta,
                               n.ahead = 24,
                               limits = F
)

shang_seasonal$ASE
# [1] 1154198
shang_aruma$ASE
# [1] 1154911
test <- window(shang_US, start = 7)[1:24]
ase(test, shang_aruma)
# [1] 1977888
ase(test, shang_seasonal)
# [1] 3278672

forecast(aruma, shang, s = 365, d = 1, phi  = est_shang2$phi,theta = est_shang2$theta, n.ahead=500)
forecast(aruma, shang, s = 365, phi  = est_shang$phi, n.ahead=500)

# ok looking damn good with the shang aruma


# Beijing

bj_US <- fine_china$BeijingPM_$PM_US
usBJ <- resample(bj_US)
plotts.sample.wge(usBJ$day)
plotts.sample.wge(usBJ$week)
plotts.sample.wge(usBJ$month)
plotts.sample.wge(usBJ$sea)
decompose(usBJ$day, "multiplicative") %>>% autoplot+ theme_economist()
decompose(usBJ$day,   "additive") %>>% autoplot+ theme_economist()
decompose(usBJ$week, "multiplicative") %>>% autoplot+ theme_economist()
decompose(usBJ$week,  "additive") %>>% autoplot+ theme_economist()
decompose(usBJ$month, "multiplicative") %>>% autoplot+ theme_economist()
decompose(usBJ$month, "multiplicative") %>>% autoplot+ theme_economist()
decompose(usBJ$sea, "additive") %>>% autoplot+ theme_economist()
decompose(usBJ$sea, "additive") %>>% autoplot+ theme_economist()
usBJ$week %>>%  lagplot+ theme_economist()
usBJ$day %>>% seasonplot + theme_economist()
usBJ$day %>>% seasonplot(polar = TRUE) + theme_economist()
usBJ$week %>>% seasonplot+ theme_economist()
usBJ$week %>>% seasonplot(polar = T)+ theme_economist()
usBJ$month %>>% seasonplot+ theme_economist()
usBJ$month %>>% seasonplot(polar = T)+ theme_economist()
usBJ$seas %>>% seasonplot(polar = T) + theme_economist()
usBJ$seas %>>% seasonplot + theme_economist()
bj <- usBJ$day

bj %>>%  (difference(seasonal,.,365)) -> bjtr
aicbj <- bj %>>%  (difference(seasonal,.,365)) %>>% 
  aicbic(p = 0:10) 
pander(aicbj)
# 
# 
#   *
# 
#     ------------------------
#      &nbsp;   p   q    aic
#     -------- --- --- -------
#      **41**   6   4   15.31
# 
#      **53**   8   4   15.31
# 
#      **59**   9   4   15.31
# 
#      **47**   7   4   15.31
# 
#      **60**   9   5   15.31
#     ------------------------
# 
#   *
# 
#     ------------------------
#      &nbsp;   p   q    bic
#     -------- --- --- -------
#      **13**   2   0   15.35
# 
#      **3**    0   2   15.35
# 
#      **8**    1   1   15.35
# 
#      **14**   2   1   15.35
# 
#      **19**   3   0   15.35
#     ------------------------
# 
# 
# <!-- end of list -->
# 
# 
# NULL

est_bj <- estimate(bjtr, 6,4)
acf(est_bj$res)
ljung_box(est_bj$res,6,4)
#            [,1]             [,2]            
# test       "Ljung-Box test" "Ljung-Box test"
# K          24               48              
# chi.square 28.84052         45.85887        
# df         14               38              
# pval       0.01098179       0.1784661       

bj_seas <- fore_and_assess(type = aruma,
                           x = bj,
                           s = 365,
                           phi = est_bj$phi,
                           theta = est_bj$theta,
                           n.ahead = 24,
                           limits = F
)
test <- window(bj_US, start = 7)[1:24]
ase(test, bj_seas)
