library(tidyverse)
library(RMark)
library(ggplot2)
BlackbirdData = read_csv('PulliBlackbirds.csv')
head(BlackbirdData)
#basic CJS model for data
BlackbirdModel = mark(BlackbirdData)

#input for CJS annually
Phidot=list(formula=~1)
Phitime=list(formula=~time)
#outfput for CJS annually
pdot=list(formula=~1)
ptime=list(formula=~time)

#CJS with phi and p estimates year by year
Tern.phiage.ptime = mark(BlackbirdData, model.parameters = list(Phi=Phitime, p = ptime))

#Year by year probability for recapture p in vector form
CapProb = c(0.0492643, 0.0240814, 0.021784, 0.0253501, 0.0305672, 0.0220467, 0.0234167, 0.0180681, 0.0199426, 0.0175239, 0.0182425, 0.023292,
            0.020789, 0.0270455, 0.0201497, 0.0201527, 0.0228601, 0.0236721, 0.0299981, 0.0165172)

#Years in vector form
Time = c(1964:1983)

#two vectors converted to a data frame
Probdata = data.frame(CapProb, Time)

#plot of the recapture probabilities with their respective dates
ggplot(Probdata, aes(Time, CapProb)) + geom_point() +geom_smooth(method = "loess") + labs(title = "Recapture probability of Pulli Blackbirds annually",y="Recapture probability", x="year")

