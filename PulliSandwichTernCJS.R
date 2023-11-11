library(tidyverse)
library(RMark)
library(ggplot2)
TernData = read_csv('PulliSandwichTern.csv')
head(TernData)
#basic CJS model for data
TernModel = mark(TernData)

#input for CJS annually
Phidot=list(formula=~1)
Phitime=list(formula=~time)
#outfput for CJS annually
pdot=list(formula=~1)
ptime=list(formula=~time)

#CJS with phi and p estimates year by year
Tern.phitime.ptime = mark(TernData, model.parameters = list(Phi=Phitime, p = ptime))

#Year by year probability for recapture p in vector form
CapProb = c(0.0085662, 0.0057177, 0.0050089, 0.0040911, 0.0059918, 0.0040684, 0.002983, 0.0038825, 0.0017843, 0.0042458, 0.0023595, 0.0023275,
            0.0030655, 0.0028184, 0.002321, 0.0017594, 0.0021836, 0.0022437, 0.0016264, 0.0031549)
#Years in vector form
Time =c(1971:1990)

#two vectors converted to a data frame
Probdata = data.frame(CapProb, Time)

#plot of the recapture probabilities with their respective dates
ggplot(Probdata, aes(Time, CapProb)) + geom_point() +geom_smooth(method = "loess") + labs(title = "Recapture probability of Pulli Sandwich Terns annually", y="Recapture probability", x="year")
