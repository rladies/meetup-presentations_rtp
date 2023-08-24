# tidy tuesday aug 22, 2023

# question ideas
# 1. regional changes over time? (by energy company)
# 2. correlation between gdp and coal_consumption?
# 3. consumption by country and color? (by type of energy consumed, add in population?)
# 4. which is most efficient (per consumption)?

# question idea to plot
# plot consumption vs time color by country and seperate plots for each type of energy.

# load libraries
library(tidyverse)

# load data
energy_data <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-06/owid-energy.csv')

# names of columns
names(energy_data)

# wrangling data
region_list <- c("High-income countries", "Upper-middle-income countries", "Lower-middle-income countries", "Low-income countries")
energy_data_sel <- energy_data |>
  select(country, year, population, ends_with("_consumption")) |>
  filter(year >= 2000) |>
  filter(country %in% region_list)

# plot
ggplot(data = energy_data_sel) +
  geom_line(mapping = aes(x = year, y = primary_energy_consumption)) +
  facet_wrap(~ country)

# pivot longer
energy_data_long <- energy_data_sel |>
  pivot_longer(cols = biofuel_consumption:wind_consumption,
               names_to = "consumption")

# plot
ggplot(data = energy_data_long) +
  geom_line(mapping = aes(x = year, y = value, color = consumption)) +
  facet_wrap(~ country)
