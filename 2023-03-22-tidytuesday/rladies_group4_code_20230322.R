
library(lterdatasampler)
library(tidyverse)
library(showtext)

sysfonts::font_add_google(name = "Alfa Slab One", family = "alfa") # name = name as it appears on Google Fonts; family = a string that you'll refer to your imported font by
sysfonts::font_add_google(name = "Sen", family = "sen")

# automatically use {showtext} to render text for future devices ----
showtext::showtext_auto()

# tell showtext the resolution for the device ----
showtext::showtext_opts(dpi = 300)

# bison_clean <- knz_bison |> 
  # drop_na() |> 
  # group_by(rec_year) |> 
  # summarize(
  #   num = n()
  # )

bison90s <- knz_bison |> 
  filter(rec_year %in% c(1994:1999))

ggplot(bison90s, aes(x = animal_sex, y = animal_weight, fill = animal_sex)) +
  geom_violin() +
  facet_wrap(~rec_year) +
  scale_fill_manual(values = c("#f890e7", "#0bd3d3")) +
  labs(x = "Sex", y = "Bison Weight (lbs)",
       title = "Bison Weights from the '90s",
       fill = "Sex") +
  theme_minimal() +
  theme(
    plot.title = element_text(family = "alfa"),
    axis.title = element_text(family = "alfa"),
    legend.title = element_text(family = "alfa")
  )
  
