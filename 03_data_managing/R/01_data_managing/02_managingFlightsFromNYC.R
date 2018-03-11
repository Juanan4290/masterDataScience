# import libraries
library(dplyr)
library(nycflights13)

# all the content of this script is done using dplyr and avoiding the classic 
# programming method in R.

# select all the variables that end with "_delay" filtering carrier by "UA" 
# and get a 10 observations random sample
flights %>%
  filter(carrier == "UA") %>%
  select( ends_with("_delay")) %>%
  sample_n(10) %>% View

# filter the following variables and keep them in a new dataframe: 
# delay variables, origin, destination, carrier and distance

flightsColsSample <- flights %>%
  select(contains("delay"), origin, dest, carrier, distance)

# calculate the distance mean for each origin-destination pair
flights %>%
  group_by(origin, dest) %>%
  summarise(meanDistance = mean(distance, na.rm = T))

# calculate the correlation between the distance and the total delay
flights %>%
  mutate(totalDelay = arr_delay + dep_delay) %>%
  select(totalDelay, distance) %>%
  cor(use="complete.obs")

# what aiport has the higest average delay?
flights %>%
  select(origin, arr_delay, dep_delay) %>%
  mutate(totalDelay = arr_delay + dep_delay) %>%
  group_by(origin) %>%
  summarise(averageDelay = mean(totalDelay, na.rm = T)) %>%
  arrange(-averageDelay) %>%
  head(1)

# filter the flights that exceed the arr_delay average
flights %>%
  filter(arr_delay > mean(arr_delay, na.rm = T))

# filter the routes that exceed the average of the total delay route mean 
flights %>%
  group_by(origin, dest) %>%
  summarise(avgRoute = mean(arr_delay+dep_delay, na.rm = T)) %>%
  filter(avgRoute > mean(avgRoute, na.rm = T)) %>% 
  arrange(-avgRoute)