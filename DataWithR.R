library(pacman)

p_load(dlookr,
       DMwR2, # Data Mining with R functions
       GGally, # Pair-wise plots using ggplot2
       Hmisc, # Data analysis 
       palmerpenguins, # Alternative to the Iris dataset
       tidyverse) # Data wrangling, manipulation, visualization

#load the data
data(algae, package = "DMwR2")

algae |> glimpse()

#Central Tendency: Mean, Median and Mode
algae$a1 |>
  mean()
algae$a1 |>
  median()
Mode <- function(x, na.rm=FALSE){
  if(na.rm) x<-x[!is.na(x)]
  ux <- unique (x)
  return (ux[which.max(tabulate(match(x, ux)))])
}

algae$a2 |> Mode()

# DMwR centralValue() function
# Numerical variable
algae$a1 |> centralValue()
# Nominal variable
algae$speed |> centralValue()

# Statistics of spread (variation)
algae$a1 |> var() # variance
algae$a1 |> sd() # standard deviation
algae$a1 |> range() # range
algae$a1 |> max() # maximum value
algae$a1 |> min() # minimum value
algae$a1 |> IQR() # Interquartile Range
algae$a1 |> quantile() # Quantile
algae$a1 |> quantile(probs = c(0.2, 0.8)) # Specifying specific quantile

# Missing values
library(purrr)
# Compute the total number of NA values in the dataset
nas <- algae %>% 
  purrr::map_dbl(~sum(is.na(.))) %>% 
  sum()

cat("The dataset contains ", nas, "NA values. \n")

# Compute the number of incomplete rows in the dataset
incomplete_rows <- algae %>% 
  summarise_all(~!complete.cases(.)) %>%
  nrow()
cat("The dataset contains ", incomplete_rows, "(out of ", nrow(algae),") incomplete rows. \n")

# Summary of the dataset

# base r's summary()
algae |> summary() 

# Hmisc’s describe()
data("penguins")
penguins |> Hmisc::describe()

# dlookr’s describe()
penguins |> dlookr::describe()

# Summaries on a subset of data
algae |>
  summarise(avgNO3 = mean(NO3, na.rm=TRUE),
            medA1 = median(a1))
algae |>
  select(mxPH:Cl) |>
  summarise_all(list(mean, median), na.rm = TRUE)
algae |>
  select(a1:a7) |>
  summarise_all(funs(var))
algae |>
  select(a1:a7) |>
  summarise_all(c("min", "max"))
algae |>
  group_by(season, size) |>
  summarise(nObs = n(), mA7 = median(a7))
penguins |> 
  group_by(species) |>
  summarise(var = var(bill_length_mm, na.rm = TRUE))

# Aggregating data
penguins |>
  group_by(species) |>
  reframe(var = quantile(bill_length_mm, na.rm = TRUE))
penguins |>
  group_by(species) |>
  dlookr::describe(bill_length_mm)
