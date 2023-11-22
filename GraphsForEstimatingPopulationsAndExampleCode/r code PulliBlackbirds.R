# Install 'tidyverse' package once first and then load using library.
library(tidyverse)

# Set working directory to folder location and then get csv file.
PulliBlackbirds = read_csv('PulliBlackbirds.csv') 

# Install 'Rmark' package once first and then load using library.
library(RMark)

# Process our data into usable form.
PulliBlackbirds.rmark.processed <- RMark::process.data(PulliBlackbirds,
                                              model = "POPAN")

# Our formulae for the model.
Phi.dot <- list(formula=~1)
p.dot <- list(formula=~1)
pent.dot <- list(formula=~1)
N.dot <- list(formula=~1)

# Fits user specified models to various types of capture-recapture data, in this
# case the POPAN Jolly-Seber model.
PulliBlackbirds.rmark <- mark(PulliBlackbirds, model = "POPAN",
                     model.parameters = list(Phi = Phi.dot, p= p.dot,
                                             pent = pent.dot, N = N.dot),
                     realvcv = TRUE)


# The popan.derived function from RMark estimates our population N 
# and estimates the standard error and 95% confidence interval for each
# estimate using the delta method.
PulliBlackbirds.derived.rmark <- popan.derived(PulliBlackbirds.rmark.processed,
                                      PulliBlackbirds.rmark)$N
# Look at our results.
PulliBlackbirds.derived.rmark



# Plot our results.
require(ggplot2)
ggplot(PulliBlackbirds.derived.rmark, aes(x = Occasion+1963, y = N)) +
  theme(panel.background = element_rect(fill = "#FFFFFF", color = "black")) +
  theme(plot.background = element_rect(fill = "#FFFFFF", color = "black")) +
  geom_point(size = 4) +
  geom_errorbar(aes(ymax = UCL, ymin = LCL)) +
  geom_line() +
  xlab('Capture year') +
  ylab('Estimated population of Pulli Blackbirds')