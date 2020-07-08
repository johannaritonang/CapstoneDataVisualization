
# library -----------------------------------------------------------------

# shiny apps
library(shiny)
library(shinydashboard)

# data wrangling
library(tidyverse)
library(lubridate)
library(zoo)

# plot
library(ggplot2)

# interactive plot
library(plotly)

# map plot
library(leaflet)
library(rgdal)
library(raster)

# showing up data frame
library(DT)


# data reading -----------------------------------------------------------

hotels <- readRDS("data_input/hotels.rds")


# data cleaning -----------------------------------------------------------

# put data type into appropriate type
hotels <- hotels %>% 
  mutate(is_canceled = ifelse(
    is_canceled== 0, "Not Canceled","Canceled"
  ),
  date = glue::glue("{arrival_date_year}-{arrival_date_month}-{arrival_date_day_of_month}"),
  date = parse_date(date, format = "%Y-%B-%d"),
  )

hotels[  , c("agent","arrival_date_day_of_month","assigned_room_type","company","country","customer_type","deposit_type",
             "distribution_channel","is_canceled","is_repeated_guest","market_segment","meal","reservation_status",
             "reserved_room_type","is_canceled")] <- lapply(hotels[  , c("agent","arrival_date_day_of_month","assigned_room_type","company","country","customer_type","deposit_type",
                                                                         "distribution_channel","is_canceled","is_repeated_guest","market_segment","meal","reservation_status",
                                                                         "reserved_room_type", "is_canceled")], as.factor)


# for map data
map <- hotels %>% 
  filter(arrival_date_year == 2017) %>%
  group_by(country, hotel) %>% 
  summarise(n = n()) %>%
  mutate(hotel = str_replace(hotel, " ", "_")) %>% 
  pivot_wider(names_from = hotel, values_from = n) %>% 
  mutate_if(is.integer, replace_na, replace = 0) %>% 
  mutate(text = paste0(
    "Country: ", country,"<br>",
    "City Hotel:" , City_Hotel, "<br>",
    "Resort Hotel:", Resort_Hotel)
  ) %>% 
  rename(ISO3 = country)

# map data ----------------------------------------------------------------

# reading map data in shape file
worldmap <- shapefile("data_input/map/TM_WORLD_BORDERS_SIMPL-0.3.shp")

# combining tabular data into shape data
worldmap@data <- worldmap@data %>% dplyr::left_join(map, by = "ISO3")

# plot theme ------------------------------------------------------------

soft_blue_theme <- theme(
  panel.background = element_rect(fill="lemonchiffon"),
  plot.background = element_rect(fill="slategray3"),
  panel.grid.minor.x = element_blank(),
  panel.grid.major.x = element_blank(),
  panel.grid.minor.y = element_blank(),
  text = element_text(color="black"),
  axis.text = element_text(color="black"),
  strip.background =element_rect(fill="snow3"),
  strip.text = element_text(colour = 'black')
)
