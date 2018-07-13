
# Load packages -----------------------------------------------------------
library(twitteR)
library(dplyr)
library(gganimate)
library(ggplot2)
library(bigrquery)

# Twitter Creds -----------------------------------------------------------
consumer_key <- ""
consumer_secret <- ""
access_token <- ""
access_secret <- ""

# Set up ------------------------------------------------------------------
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# Exploring Twitter -------------------------------------------------------
tweets <- searchTwitter("#rladies", n = 100, retryOnRateLimit = 120)
stripped_rt <- strip_retweets(tweets, strip_manual = TRUE, strip_mt = TRUE)

# Exploring users ---------------------------------------------------------
joyce <- getUser("joyceisms")
str(joyce)
joyce$getDescription()
joyce$getFriends(n = 5)
joyce$getFavorites(n = 5)

# Exploring Timelines -----------------------------------------------------
rladies_tweets <- userTimeline("rladiesRTP")
my_tweets <- homeTimeline()

# Exploring Trends --------------------------------------------------------
avail_trends <- availableTrendLocations()
closest_trends <- closestTrendLocations(35.784999, -78.666806)
trends <- getTrends(closest_trends$woeid)

# Conversion to data.frames -----------------------------------------------
df <- twListToDF(tweets)
View(df)

# Visualization -----------------------------------------------------------
tweets <- searchTwitter("#Thanksgiving", n = 10000, retryOnRateLimit = 120)
df <- twListToDF(tweets)
# Filter for geocoded ones and clean up times
df.geocoded <- df %>% 
  filter(!is.na(latitude)) %>%
  mutate(long = as.numeric(longitude), 
         lat = as.numeric(latitude)) %>%
  mutate(created_at = as.POSIXct(created)) %>%
  mutate(time = format(created_at, "%H:%M:%S"))
df.geocoded$times <- sapply(strsplit(df.geocoded$time, ":"), function(x){ x <- as.numeric(x)
          x[1] + x[2]/60})
df.geocoded <- df.geocoded %>%
  mutate(frame = round(times, 0))
# Mapping it
map.world <- map_data("world")
map.world2 <- subset(map.world, region != "Antarctica")
gg2 <- ggplot() +
  geom_polygon(data = map.world2, aes(x = long, y = lat, group = group)) +
  geom_point(data = df.geocoded, aes(x = long, y = lat, frame = frame, cumulative = TRUE), color = "#9ba306", size = 2) +
  theme(text = element_text(family = "Helvetica", color = "#FFFFFF")
        ,panel.background = element_rect(fill = "#444444")
        ,plot.background = element_rect(fill = "#444444")
        ,panel.grid = element_blank()
        ,plot.title = element_text(size = 20, face = "bold")
        ,plot.subtitle = element_text(size = 10)
        ,axis.text = element_blank()
        ,axis.title = element_blank()
        ,axis.ticks = element_blank()
        ,legend.position = "none")
# Output gif
gganimate(gg2, filename = "output.gif", interval = 1, ani.height = 400, ani.width = 600)

# Database Persistence ----------------------------------------------------
insert_upload_job("prac-dataviz", "rladies", "df", df)
sql <- paste("SELECT * FROM `prac-dataviz.rladies.df`")
results <- query_exec(sql, project = "prac-dataviz", use_legacy_sql = FALSE)
