
# 0. libraries ------------------------------------------------------------

library(lterdatasampler)
library(tidyverse)
library(plotly)
library(ggiraph)

# 1. wrangling and mutating -----------------------------------------------

# add marker text column to and_vertebrates (will come in handy later)
and_vertebrates_marker <- and_vertebrates %>% 
  mutate(marker_text = paste(
    "Species: ", species, "<br>",
    "Weight (g): ", weight_g, "<br>",
    "Length (mm): ", length_1_mm, "<br>"
  ))

# fyi: tooltip = the box that pops up when you hover over/click something

# 2. ggplotly -------------------------------------------------------------

# step 1. create a static plot
and_vert_static <- ggplot(and_vertebrates_marker, 
                          aes(x = weight_g, y = length_1_mm, text = marker_text)) +
  geom_point(aes(color = species)) +
  labs(x = "Weight (g)", y = "Length (mm)",
       title = "Vertebrates of Andrews Forest") +
  theme_bw() +
  theme(legend.position = "none",
        text = element_text(family = "Garamond"))

# specify font and label formatting (from https://plotly-r.com/controlling-tooltips.html)
font <- list(
  family = "Garamond",
  size = 15,
  color = "white"
)
label <- list(
  bgcolor = "#232F34",
  bordercolor = "transparent",
  font = font
)

# step 2. use ggplotly!
ggplotly(and_vert_static, tooltip = "text") %>% 
  style(hoverlabel = label) %>%
  layout(font = font)


# 3. ggiraph --------------------------------------------------------------

# step 1: create a static plot
and_vert_ggiraph_static <- ggplot(and_vertebrates_marker, aes(x = weight_g, y = length_1_mm,
                                                # specify a tooltip and data id (the interactive part)
                                                tooltip = marker_text, data_id = marker_text)) +
  # add this geom point interactive from ggiraph
  geom_point_interactive(aes(color = species)) +
  labs(x = "Weight (g)", y = "Length (mm)",
       title = "Vertebrates of Andrews Forest") +
  theme_bw() +
  theme(legend.position = "none",
        text = element_text(family = "Garamond"))

and_vert_interactive <- girafe(ggobj = and_vert_ggiraph_static,
                               options = list(
                                 opts_sizing(width = 0.7), 
                                 opts_tooltip(css = "font-family: Garamond;")
                               ))

and_vert_interactive
