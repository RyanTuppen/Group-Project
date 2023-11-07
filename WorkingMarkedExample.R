library(tidyverse)
library(RMark)
BlackbirdData = read_csv('AdultblackbirdData.csv')
head(BlackbirdData)
BlackbirdModelk = mark(BlackbirdData)
#duplicate in line 44-45

Phidot=list(formula=~1)
Phitime=list(formula=~time)
pdot=list(formula=~1)
ptime=list(formula=~time)

Blackbird.phitime.ptime = mark(BlackbirdData, model.parameters = list(Phi=Phitime, p = ptime))

Surv = c(1, 0.9999986, 0.9998558, 0.8219377, 0.8800423, 0.9999459, 0.798121, 0.8681229, 0.9547848, 0.8626481, 0.8763687, 0.7765887,
         0.8059266, 0.779494, 0.7182347, 0.7860431, 0.9648213, 0.9999961, 0.5371317, 0.7425338)
Time = (1964:1:1983)

ggplot() + geom_point(aes(x=Time, y=Surv)) +geom_line(aes(x=Time, y=Surv))
plot(Time, Surv)
