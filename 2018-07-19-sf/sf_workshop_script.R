# r-ladies rtp exploring spatial data with sf workshop

# last updated: 20180719
# script prepared by: sheila saia
# contact: ssaia at ncsu dot edu

# ---- Activity 1 ----

# let's get started using sf

# install sf package and tidyverse (3 ways)
# if you already have done this you don't need to do it again

# instalation method #1
#install.packages("sf")
#install.packages("tidyverse")
#install.packages("Cairo") # ONLY FOR WINDOWS USERS!

# instalation method #2
# you can also go to tools > install packages... on rstudio menu

# instalation method #3
# if you want the development version of sf use...
#install.package("devtools")
#library(devtools)
#install_github("r-spatial/sf")
#install.packages("tidyverse")
#install.packages("Cairo") # ONLY FOR WINDOWS USERS!

# load sf and tidyverse libraries
library(sf)
library(tidyverse)
library(Cairo) # ONLY FOR WINDOWS USERS!
# NOTE! if you have a Windows machine, you'll have to change all instances of cairo_pdf() in this code to CairoPDF()

# save page to your data
my_desktop_path <- "/Users/ssaia/Desktop/"
my_workshop_data_path <- "/Users/ssaia/Desktop/r-ladies-rtp-sf-workshop/workshop_data/"
# NOTE! if you have a mac you can use / but if you have a pc you need to switch /'s to \\

# import se state bounds
se_states_raw <- st_read(paste0(my_workshop_data_path,"spatial_data/southeast_state_bounds.shp"))
attributes(st_geometry(se_states_raw)) # no EPSG projection defined even though there should be
# EPSG - European Petrolium Survey Group, standardized projection codes (see http://epsg.io/)

# so let's define epsg projection (not changing it, just setting!)
se_states <- se_states_raw %>%
  st_set_crs(5070) # this shp file was originally in CONUS Albers Equal Area from the USGS
attributes(st_geometry(se_states)) # ok, now it's set

# import watershed bounds (for non-ref se plains)
ws_bounds_seplains <- st_read(paste0(my_workshop_data_path, "spatial_data/bas_nonref_SEPlains.shp")) %>%
  st_set_crs(5070)

# import stream gages and define projection (for all us)
gages <- st_read(paste0(my_workshop_data_path, "spatial_data/gagesII_9322_sept30_2011.shp")) %>%
  st_set_crs(5070)

# import gage attribute data
basin_id_data <- read_csv(paste0(my_workshop_data_path, "tabular_data/conterm_basinid.txt"))
climate_data <- read_csv(paste0(my_workshop_data_path, "tabular_data/conterm_climate.txt"))
geology_data <- read_csv(paste0(my_workshop_data_path, "tabular_data/conterm_geology.txt"))
hydrology_data <- read_csv(paste0(my_workshop_data_path, "tabular_data/conterm_hydro.txt"))
topo_data <- read_csv(paste0(my_workshop_data_path, "tabular_data/conterm_topo.txt"))
# errors are ok here! it's R just telling you what it's doing.

# look at se_state
class(se_states) # look at data type. what is it?
glimpse(se_states) # view sf dataframe. what do you notice that's different about it than a regular dataframe? hint: there's one column in particular...


# ---- Activity 2 ----

# let's practice using different sf functions

# separate out geometry using st_geometry()
se_states_geom <- st_geometry(se_states)
names(se_states_geom) # this is NULL have to use View() to see it
class(se_states_geom) # now we see it's sfc for simple features with only geometry (simple features coordinates?)

# separate out attributes using st_set_geometry(NULL)
se_states_attribs <- se_states %>%
  st_set_geometry(NULL)
names(se_states_attribs) # this works like any data frame or tibble
head(se_states_attribs) # this works too
class(se_states_attribs) # we see it's just a data frame now, not an sf class

# plot all se states
setwd(my_desktop_path)
cairo_pdf("test.pdf",width=11,height=8.5)
plot(se_states_geom) # for now we'll just use base R ;)
dev.off()

# pick your state
my_state <- se_states %>%
  filter(NAME == "Virginia") # change this to your favorite (options are: NC, SC, VA, GA, FL)
# there's a funny coincendence that all sf tutorials use NC data from here (https://cran.r-project.org/web/packages/spdep/vignettes/sids.pdf) so feel free to go with this wave or not ;)

# save your geometry separately
my_state_geom <- st_geometry(my_state)

# plot your state
setwd(my_desktop_path)
cairo_pdf("test.pdf",width=11,height=8.5)
plot(my_state_geom) # for now we'll just use base R ;)
dev.off()

# find area of my_state_geom using st_area()
st_area(my_state_geom) # in square meters
as.numeric(st_area(my_state_geom)) / 1000^2 # in square km
as.numeric(st_area(my_state_geom)) * 0.00062137^2 # in square mi

# find centroid of my_state_geom using st_centroid()
st_centroid(my_state_geom)

# extra credit: can you plot the centroid of your state with that state's bounds?

# remove my_state from se_states using st_difference()
se_states_geom_without_my_state <- st_difference(se_states_geom, my_state_geom)

# plot se states without your state
setwd(my_desktop_path)
cairo_pdf("test.pdf",width=11,height=8.5)
plot(se_states_geom_without_my_state)
dev.off()


# ---- Activity 3 ----

# let's try some sf operations with a real-world dataset

# plot my_state and se plains ws's together to take a look at our data together using geom_sf()
setwd(my_desktop_path)
cairo_pdf("test.pdf",width=11,height=8.5)
# this time we'll use ggplot!
ggplot() + 
  geom_sf(data = ws_bounds_seplains, aes(fill = GAGE_ID)) +
  geom_sf(data = my_state_geom, alpha = 0.5) +
  theme_bw() +
  theme(legend.position="none") # this supresses the legend because the key is really big
dev.off()

# let's look at se plains ws's in more detail by clipping them to our state bounds using st_intersection()
my_state_ws <- st_intersection(ws_bounds_seplains, my_state_geom) # first one will define dataframe of output
# not sure why there are 90 observations, we're expecting ~30

# plot intersection
setwd(my_desktop_path)
cairo_pdf("test.pdf",width=11,height=8.5)
ggplot() +
  geom_sf(data = my_state_geom) +
  geom_sf(data = my_state_ws, aes(fill = GAGE_ID)) +
  theme_bw() +
  theme(legend.position="none")
dev.off()

# extra credit: can someone figure out how to get the whole watershed and not just the part inside (i'm stumped!)?
# maybe use st_within() and some dplyr functions? it gives 1 for True (it's within) 0 for False...


# ---- Activity 4 ----

# let's see how sf works with the tidyverse

# select gages in your state using st_intersection()
my_gages <- st_intersection(gages, my_state_geom) # first one will define dataframe of output

# plot watersheds and gages for your state
setwd(my_desktop_path)
cairo_pdf("test.pdf",width=11,height=8.5)
ggplot() +
  geom_sf(data = my_state_geom) +
  geom_sf(data = my_state_ws, aes(fill = GAGE_ID)) +
  geom_sf(data = my_gages, size = 5) +
  theme_bw() +
  theme(legend.position="none")
dev.off()

# plot gages colored by reference or non-reference
# reference refers to 
setwd(my_desktop_path)
cairo_pdf("test.pdf",width=11,height=8.5)
ggplot() +
  geom_sf(data = my_state_geom) +
  geom_sf(data = my_gages, size = 5, aes(color = CLASS)) + # reference vs non-reference
  theme_bw()
dev.off()
# reference = less to no human impact on streamflow (e.g., forested with no development)
# non-reference = human impact on streamflow (e.g., has an urban area or town)

# use dplry left_join() to join gage spatial data with gage attributes
my_gages_join <- my_gages %>%
  left_join(climate_data, by = "STAID") # you can also join geology_data or hydrology_data depending on what you prefer

# plot gages colored by reference or non-reference
setwd(my_desktop_path)
cairo_pdf("test.pdf",width=11,height=8.5)
ggplot() +
  geom_sf(data = my_state_geom) +
  geom_sf(data = my_gages_join, size = 5, aes(color = PPTAVG_BASIN)) + # average annual precipitation for the associated watershed in cm
  theme_bw()
dev.off()

# using gather and facet wrap to compare variables of interest
my_gages_sel <- my_gages_join %>%
  select(STAID, PPTAVG_BASIN, PPTAVG_SITE) %>%
  gather(PPTAVG_BASIN, PPTAVG_SITE, key = "SCALE", value = "PPTAVG") # saves geometry too!
# comparing average annual precipitation at the gage site to average annual precipitation at the associated watershed

# extra credit: what if we add in elevation? is there a visual spatial relationship between precipitation and elevation? (you'll need topo_data)

# plot PPTAVG_BASIN and PPTAVG_SITE together for comparison
setwd(my_desktop_path)
cairo_pdf("test.pdf",width=11,height=8.5)
ggplot() +
  geom_sf(data = my_state_geom) +
  geom_sf(data = my_gages_sel, size = 5, aes(color = PPTAVG)) +
  facet_wrap(~SCALE) +
  theme_bw()
dev.off()


# ---- unsolved mysteries... (please let me and your fellow r-ladies know if you solve them!) ----

# using/learning sf is still a work in progress!

# some questions for extra credit (i also don't know the answers to these!)
# 1. why does it sometimes take a while for geom_sf to plot? why is this time shortened by exporting?
# 2. what is the difference between filter.sf() and filter()? why do we get an error when we try to use filter.sf() "count not find function filter.sf"
# 3. why do some projections not read in automatically and other's do (UTM does vs Albers doesn't)
# 4. what's the difference between some of the sf opperations like st_intersection() and st_intersects()?
# 5. < place holder for more you or i might think of! >
