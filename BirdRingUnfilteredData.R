library(tidyverse)
library(ggplot2)

## Combined model : General code to fit all models using Blackbird data as example 127
# constant and time dependent models for :phi1 , phia , lambda1 & lambda2 128
# Example with numbers set for the C/T/T/C model 129
# Formed by: 1. Standard Model + 2. Historic Model + 130
# 3. Likelihood for Combined Model + 4. MLE for Combined Model 131
# Note that with small changes in the code the standard and historic model can be fitted separetely 132
###################################################################################### 133
########################## Create expit and logit functions ########################## 134
expit <- function ( xval ) 
{ 
  1/(1+ exp(- xval )) 
} 

logit <- function ( xval ) 
{ 
  log ( xval /(1 - xval )) 
}
###################################################################################### 144
###################### 1. Standard Model : birds ringed as pulli ###################### 145
###################################################################################### 146
###### DATA 147
###### Datamatrix : matrix of recoveries for birds ringed as pulli 148
Datamatrix <- matrix (c( 
  52 , 15 , 10 , 2 , 8 , 5, 3, 1, 0, 1, 0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 
  0, 74 , 30 , 14 , 18 , 7, 12 , 2, 1, 3, 1, 1, 0, 0, 0 , 0, 0 , 0, 0, 0, 
  0, 0, 78 , 29 , 20 , 11 , 4, 4, 2, 0 , 2, 1 , 0, 1, 0, 0, 0, 0, 0, 0, 
  0, 0, 0 , 67 , 22 , 12 , 4 , 7, 4 , 2, 2, 1, 4, 1, 2, 0 , 0, 0 , 0, 0 , 
  0, 0, 0 , 0, 101 , 30 , 10 , 8, 8, 6 , 3, 6 , 1, 1, 1, 0, 0, 0, 0, 0, 
  0, 0, 0 , 0, 0 , 81 , 27 , 10 , 11 , 10 , 4, 1, 3, 1, 3 , 1, 0 , 0, 1, 0, 
  0, 0, 0 , 0, 0 , 0, 58 , 15 , 8, 5, 4, 4, 3 , 2, 0 , 0, 1, 1, 0, 0, 
  0, 0, 0 , 0, 0 , 0, 0 , 55 , 19 , 11 , 10 , 6 , 6, 5, 3, 0, 1, 1, 0, 0,
  0, 0, 0 , 0, 0 , 0, 0 , 0, 67 , 21 , 14 , 6, 7, 6, 1, 0 , 2, 2 , 0, 1, 
  0, 0, 0 , 0, 0 , 0, 0 , 0, 0, 54 , 26 , 6, 8 , 2, 4 , 2, 1, 0, 1, 1, 
  0, 0, 0 , 0, 0 , 0, 0 , 0, 0, 0, 42 , 17 , 5 , 9, 3 , 1, 1, 3, 0, 0, 
  0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 0, 57 , 12 , 8, 4 , 2, 5, 0, 0, 1, 
  0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 0, 0, 58 , 15 , 10 , 5 , 8, 2 , 3, 2, 
  0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 64 , 13 , 7, 7, 4, 3, 1, 
  0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0 , 60 , 21 , 8, 10 , 9, 1, 
  0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 62 , 15 , 11 , 4, 9, 
  0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0 , 54 , 15 , 8, 9, 
  0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0 , 0, 57 , 18 , 8, 
  0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0 , 0, 0, 41 , 14 , 
  0, 0, 0 , 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0 , 0, 0, 0, 70 
) ,nrow =20 , ncol =20 , byrow = TRUE ) 

n1 <-nrow ( Datamatrix ) # number of years of ringing 172
n2 <-ncol ( Datamatrix ) # number of years of recovery 173
###### f: Total number of birds never recovered that were ringed as pulli 174
f <- c(2391 ,3420 ,4366 ,4187 ,4172 ,4364 ,3347 ,3344 ,3618 ,3034 ,2730 ,3077 ,3038 ,3436 ,3537 ,3817 ,3317 ,3427 ,2872 ,4080)

####### DEFINE PARAMETERS NEEDED FOR THE STANDARD MODEL 178
# Number of rows define the year i.e: time dependency 179
# Number of columns define the age , i.e: age dependency 180
# For parameters with time dependency : change the number of pars needed in the model [ year1 : year21 ] 181
pars_fun_ccc <- function ( pars_in ){ 
  
  #If phia is constant use the line below : 183
  # This is because we assume birds ringed as pulli to become adults in their 2nd year of life 184
  #phia <- matrix ( rep (c(0 , expit ( pars_in [1]) ) ,c(1 ,(n1 -1) )) ,n1 ,n2 , byrow = TRUE ) 185
  #If phia is time dependent , use the line below ( notice phia would start from 2 now ): 186
  phia <- matrix (c(0 , expit ( pars_in [2:20]) ) ,n1 ,n2 , byrow = TRUE ) 
  phi1 <- matrix ( expit ( pars_in [21]) ,n1 , n2 , byrow = TRUE ) 
  #If there is no age dependency in lambda , lambda1 and lambda2 share the same parameter numbers as in this 189
  example 
  lambda1 <- matrix ( expit ( pars_in [22:41]) ,n1 , n2 , byrow = TRUE ) 
  lambda2 <- matrix ( expit ( pars_in [22:41]) ,n1 ,n2 , byrow = TRUE ) 
  #If there is an age dependency , for example in the C/T/ CA1 :2 model , use : 193
  # lambda1 <- matrix ( expit ( pars_in [22]) ,n1 , n2 , byrow = TRUE ) 194
  # lambda2 <- matrix ( expit ( pars_in [23]) ,n1 ,n2 , byrow = TRUE ) 195
  ringlik ( Datamatrix , phia , phi1 , lambda1 , lambda2 ) 
} 
##################################### Likelihood ##################################### 198
nprob <-rep (1 , n1) 
ringlik <- function ( Datamatrix , phia , phi1 , lambda1 , lambda2 ) 
{ 
  lik =0 
  for (i in 1: nrow ( Datamatrix )) { 
    for (j in i: ncol ( Datamatrix )) { 
      if(i==j) { 
        prob =(1 - phi1 [i,j]) * lambda1 [i,j] 
      } 
      else { 
        if(j > (i+1) ) prodphi <- prod ( phia [i ,(i +1) :(j -1) ]) else prodphi <- 1 
        prob = phi1 [i,j]* prodphi *(1 - phia [i,j]) * lambda2 [i,j]} 
      nprob [i]= nprob [i]- prob 
      lik = lik + Datamatrix [i,j]* log ( prob ) 
    } 
    lik = lik +f[i]* log ( nprob [i]) 
  } 
  lik =- lik 
  return ( lik ) 
} 

# pars_in : Starting values for the parameters in the same order : phia , phi1 , lambda1 , lambda2 220
pars_in <- logit ( rep (c (0.6 ,0.5 ,0.01) ,c (20 ,1 ,20) )) 
pars_fun_ccc ( pars_in ) # gives likelihood for the standard model 222
223
###################################################################################### 224
#################### 2. Historic Model : birds ringed as full - grown ################### 225
###################################################################################### 226
###### DATA 227
###### Datamatrixj : matrix of recoveries for birds ringed as juvenile 228
###### Datamatrixa : matrix of recoveries for birds ringed as adult 229
Datamatrixj <- matrix (c( 
  114 , 39 , 17 , 12 , 10 , 12 , 8, 5, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 93 , 26 , 31 , 19 , 16 , 6 , 7 , 3 , 6, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 
  0, 0, 70 , 32 , 19 , 20 , 8, 5, 4, 4, 2, 1 , 1 , 1 , 0 , 0 , 0 , 0, 0, 0, 
  0, 0, 0, 85 , 34 , 21 , 25 , 13 , 11 , 4, 2, 4, 3, 0, 2, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 75 , 30 , 34 , 18 , 16 , 8, 11 , 5, 6, 2, 1, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 76 , 30 , 28 , 25 , 20 , 9, 7, 5, 5, 2, 2, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 61 , 27 , 23 , 21 , 13 , 6, 7, 4, 3, 2, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 53 , 34 , 15 , 14 , 11 , 10 , 4, 8, 1, 1, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 74 , 21 , 17 , 14 , 11 , 8, 9, 6, 3, 1, 1, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 81 , 28 , 25 , 19 , 14 , 13 , 9, 6, 5, 2, 2, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 67 , 16 , 11 , 11 , 11 , 10 , 2, 1, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 71 , 33 , 17 , 15 , 7 , 6, 1, 5, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 68 , 28 , 17 , 11 , 13 , 5, 8, 4, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82 , 34 , 23 , 13 , 9, 7, 3, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74 , 30 , 13 , 15 , 8, 7, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 75 , 29 , 17 , 17 , 13 , 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 61 , 35 , 24 , 13 , 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 62 , 31 , 22 , 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 59 , 36 , 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 0 , 99 
) ,nrow =20 , ncol =20 , byrow = TRUE ) 

Datamatrixa <- matrix (c( 
  39 , 18 , 19 , 8, 9, 3, 0, 2, 5, 0, 0, 0, 0, 0, 0 , 0 , 0 , 0 , 0 , 0 , 
  0, 44 , 23 , 16 , 15 , 16 , 4 , 6 , 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 32 , 27 , 10 , 11 , 10 , 6 , 3, 4, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 42 , 29 , 24 , 12 , 10 , 6, 4, 4, 4, 3, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 38 , 31 , 15 , 14 , 11 , 4, 6, 5, 1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 62 , 29 , 18 , 20 , 15 , 12 , 8, 4, 2, 2, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 47 , 25 , 21 , 20 , 18 , 7, 3, 3, 0, 2, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 32 , 39 , 20 , 15 , 11 , 13 , 3, 2, 4, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 38 , 28 , 25 , 20 , 14 , 9, 3, 3, 0, 0, 1, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 42 , 33 , 24 , 17 , 10 , 7, 5, 1, 1, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 35 , 28 , 26 , 16 , 11 , 3, 6, 2, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37 , 25 , 15 , 10 , 9 , 10 , 4, 4, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36 , 31 , 19 , 12 , 8 , 6, 1, 2, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 41 , 23 , 17 , 15 , 11 , 2, 2, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 38 , 16 , 18 , 13 , 10 , 8, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 41 , 31 , 28 , 7, 9 , 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50 , 38 , 23 , 16 , 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 48 , 26 , 30 , 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 25 , 21 , 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 0 , 41 
) ,nrow =20 , ncol =20 , byrow = TRUE ) 

###### fhist : Total number of birds never recovered that were ringed as full - grown birds 276
fhist <- c (6076 ,6755 ,6308 ,7858 ,8098 ,7815 ,7170 ,7026 ,7586 ,7834, 8951 ,8815 ,9101 ,8668 ,8933 ,10041 ,10237 ,9551 ,11472) 

####### DEFINE PARAMETERS NEEDED FOR THE HISTORIC MODEL 280
# Note that the order for the parameters must be the same than the order used for the standard model 281
pars_fun_cccc <- function (pars_in){ 
  # Here line for phia is the same when constant or time dependent , as we have information of adults since 283
  # the first year of ringing . Note we still need to change from 1 to 1:20 depending if the model is 284
 # constant 
  # or time dependent 286
  phia <- matrix ( expit ( pars_in [1:20]) ,n1 , n2 , byrow = TRUE ) 
  phi1 <- matrix ( expit ( pars_in [21]) ,n1 , n2 , byrow = TRUE ) 
  lambda1 <- matrix ( expit ( pars_in [22:41]) ,n1 , n2 , byrow = TRUE ) 
  lambda2 <- matrix ( expit ( pars_in [22:41]) ,n1 , n2 , byrow = TRUE ) 
  #If there is an age dependency , for example in the C/T/ CA1 :2/ C model , we use : 291
  # lambda1 <- matrix ( expit ( pars_in [22]) ,n1 , n2 , byrow = TRUE ) 292
  # lambda2 <- matrix ( expit ( pars_in [23]) ,n1 ,n2 , byrow = TRUE ) 293
  #then , prop <- matrix ( expit ( pars_in [24]) ,n1 , n2 , byrow = TRUE ) 294
  prop <- matrix ( expit ( pars_in [42]) ,n1 , n2 , byrow = TRUE ) 
  ringlikhist ( Datamatrixj , Datamatrixa , phia , phi1 , lambda1 , lambda2 , prop ) 
} 
####### LIKELIHOOD FOR THE HISTORIC MODEL 298
nprob <-rep (1 , n1) 
ringlikhist <- function ( Datamatrixj , Datamatrixa , phia , phi1 , lambda1 , lambda2 , prop ) 
{ 
  lik =0 
  for (i in 1: nrow ( Datamatrixj )) { 
    for (j in i: ncol ( Datamatrixj )) { 
      if(j > i) prodphia <- prod ( phia [i,i:(j -1) ]) else prodphia <- 1 
      proba = prodphia *(1 - phia [i,j]) * lambda2 [i,j]*(1 - prop [i,j]) 
      if(i==j) { 
        probj =(1 - phi1 [i,j]) * lambda1 [i,j]* prop [i,j] 
      } 
      else { 
        if(j > (i+1) ) prodphi <- prod ( phia [i ,(i +1) :(j -1) ]) else prodphi <- 1 
        probj = phi1 [i,j]* prodphi *(1 - phia [i,j]) * lambda2 [i,j]* prop [i,j]} 
      nprob [i]= nprob [i]-probj - proba 
      lik = lik + Datamatrixj [i,j]* log( probj )+ Datamatrixa [i,j]* log( proba ) 
    } 
    lik = lik + fhist [i]* log ( nprob [i]) 
  } 
  lik =- lik 
  return ( lik ) 
} 
# pars_in : Starting values for the parameters in the same order : phia , phi1 , lambda1 , lambda2 321
pars_in <- logit ( rep (c(0.6 ,0.5 ,0.01 ,0.3) ,c(20 ,1 ,20 ,1) )) 
pars_fun_cccc ( pars_in ) # returns the likelihood for the historic model 323


#######
library(ggplot2)

# Load necessary libraries (if not already installed)
# install.packages("tidyverse")
library(tidyverse)

# Create data frames for pulli, juveniles, and adults
pulli_data <- data.frame(
  Year = 1964:1983,
  Ringed = c(
    52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    15, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    10, 30, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    2, 14, 29, 67, 101, 81, 58, 55, 67, 54, 42, 57, 58, 64, 60, 62, 54, 57, 41, 70
  )
)

juveniles_data <- data.frame(
  Year = 1964:1983,
  Ringed = c(
    114, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    39, 93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    17, 26, 70, 85, 75, 76, 61, 53, 39, 54, 67, 71, 68, 82, 74, 75, 61, 62, 59, 99
  )
)

adults_data <- data.frame(
  Year = 1964:1983,
  Ringed = c(
    39, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    18, 44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    19, 23, 32, 42, 38, 62, 47, 32, 38, 42, 35, 37, 36, 41, 38, 41, 50, 48, 25, 41
  )
)

# Calculate cumulative counts
pulli_data <- pulli_data %>%
  mutate(Cumulative_Count = cumsum(Ringed))
juveniles_data <- juveniles_data %>%
  mutate(Cumulative_Count = cumsum(Ringed))
adults_data <- adults_data %>%
  mutate(Cumulative_Count = cumsum(Ringed))

# Merge the data frames
merged_data <- merge(pulli_data, juveniles_data, by = "Year")
merged_data <- merge(merged_data, adults_data, by = "Year")
colnames(merged_data) <- c("Year", "Pulli_Ringed", "Pulli_Cumulative", "Juveniles_Ringed", "Juveniles_Cumulative", "Adults_Ringed", "Adults_Cumulative")

# Load necessary libraries (if not already installed)
# install.packages("ggplot2")
library(ggplot2)

# Create cumulative count plots
ggplot(merged_data, aes(x = Year)) +
  geom_line(aes(y = Pulli_Cumulative, color = "Pulli")) +
  geom_line(aes(y = Juveniles_Cumulative, color = "Juveniles")) +
  geom_line(aes(y = Adults_Cumulative, color = "Adults")) +
  labs(title = "Cumulative Count of Blackbirds by Age",
       x = "Historical Year",
       y = "Cumulative Count") +
  scale_color_manual(values = c("Pulli" = "blue", "Juveniles" = "red", "Adults" = "green")) +
  theme_minimal()

library(reshape2)

# Create a data frame from the Datamatrix
data_df <- as.data.frame(Datamatrix)

# Add a "Year" column to the data frame
data_df$Year <- 1:n1

# Reshape the data to long format for plotting
data_long <- melt(data_df, id.vars = "Year", variable.name = "Variable", value.name = "Value")

# Create a line plot for all variables over time
ggplot(data = data_long, aes(x = Year, y = Value, color = Variable)) +
  geom_line() +
  labs(x = "Year", y = "Value") +
  ggtitle("Line Plot of All Variables Over Time") +
  theme_minimal() +
  theme(legend.position = "top")  # Adjust the legend position as needed

