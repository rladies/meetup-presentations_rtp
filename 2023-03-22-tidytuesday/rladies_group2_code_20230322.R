## ---------------------------
## R-Ladies SB x R-Ladies RTP Meetup
## Tidy Tuesday on a Wednesday!
## 2023-03-22
##
## Breakout Room #2
##
## ---------------------------

### Load packages ###

# install.packages("remotes")
# remotes::install_github("lter/lterdatasampler")
library(lterdatasampler)
library(ggplot2)
library(paletteer)

# Poke around the sugar maple dataset
head(hbr_maples)
names(hbr_maples)

### Make some plots! ###

# Elevation x stem length
ggplot(hbr_maples, aes(x = elevation, y = stem_length, color = elevation)) +
  geom_violin() +
  geom_boxplot(width = 0.2) +
  scale_color_paletteer_d("beyonce::X1", na.value = "gray") +
  theme_classic()

# Calcium treatment x stem length x elevation

pos <- position_dodge(0.9)

ggplot(hbr_maples, aes(x = watershed, y = stem_length, color = elevation)) +
  geom_violin(position = pos) +
  geom_boxplot(position = pos, width = 0.2) +
  scale_color_paletteer_d("wesanderson::GrandBudapest1", na.value = "gray") +
  labs(title = "The effect of calcium treatments on stem length") +
  theme_classic()

#### Lessons learned: ###
# - When layering a geom violin and geom boxplot, sometimes they are misaligned. Assigning them the same dodge width aligns them!
# - scale_color_paletteer_d() seems to not plot NAs unless you explicitly provide an NA color 
