# r-ladies meetup 2023-03-22

# install package
remotes::install_github("lter/lterdatasampler")

# load packages
library(lterdatasampler)
library(tidyverse)
library(lubridate)

# load data
stream_data <- lterdatasampler::luq_streamchem

# check structure
str(stream_data)

# plot gage height vs time
ggplot(data = stream_data) +
  geom_line(mapping = aes(x = sample_date, y = gage_ht))

# column names
colnames(stream_data)
unique(stream_data$sample_id)

# make label column for hurricane months
stream_data_lab <- stream_data %>%
  mutate(month = month(sample_date),
         hurricane_season = case_when(month %in% c(6:11) ~ "june-nov",
                                      month %in% c(1:5, 12) ~ "other"))

# plot gage height vs time
ggplot(data = stream_data_lab) +
  geom_line(mapping = aes(x = sample_date, y = gage_ht, color = hurricane_season))

# plot gage height vs hurricane_season
ggplot(data = stream_data_lab) +
  geom_boxplot(mapping = aes(x = hurricane_season, y = gage_ht))
