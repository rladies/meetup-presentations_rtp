library(tidyverse)
library(censusapi)

findvars <- makeVarlist(name="acs/acs5", vintage=2020, find="occupancy", output="dataframe")

library(tidycensus)

findvars_tidy <- load_variables(year=2020, dataset="acs5")


pv_2020 <- pums_variables %>%
  filter(year==2020, survey=="acs5")
