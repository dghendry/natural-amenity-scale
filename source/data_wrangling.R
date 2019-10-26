#filename: data_wranglng.R
#----------------------------------------------
# Plot the Natural Amenity Scale
#----------------------------------------------
library(dplyr)
library(ggplot2)
library(maps)
library(stringr)

#----------------------------------------------
# Read natural amenity data file
#----------------------------------------------
create_natural_amenity_scale_df <- function() {
  # Read the file
  df <- read.csv("./data/natural-amenity-simplified.csv",
    header = TRUE,
    stringsAsFactors = FALSE
  )
  return(df)
}

#----------------------------------------------
# Create a data frame with State Names, Abbreviations,
# and Codes
#----------------------------------------------
create_state_name_code_df <- function() {
  df <- read.csv("./data/state_names_to_codes.csv",
    header = TRUE,
    stringsAsFactors = FALSE
  )
  return(df)
}

#----------------------------------------------
# Return a data frame of the polygone for a
# county_name and state_code.
#----------------------------------------------
get_county_polygon <- function(state_code, county_name, map_df) {
  polygon <- map_df %>%
    filter(Code == str_to_upper(state_code) &
      County == str_to_lower(county_name)) %>%
    select(long, lat, order)
  return(polygon)
}

#----------------------------------------------
# Returns data frame of all map data for a vector
# of state names. c(".") will get all states.
#----------------------------------------------
get_map_data_for_county <- function(state_names) {
  m <- map_data("county", state_names)
  return(m)
}

#----------------------------------------------
# Select the shape information for all counties
# in the vector of state_names. In addition,
# add State Codes and Abbreviations to the
# map information.
# state_name <- c(".") will get all states
#----------------------------------------------
create_map_info <- function(state_names) {
  state_names <- tolower(state_names)

  m <- map_data("county", state_names) %>%
    rename(County = subregion) %>%
    rename(STATE = region)

  state_name_code_df <- create_state_name_code_df() %>%
    rename(STATE = State) %>%
    mutate(STATE = tolower(STATE))

  map_info <- left_join(m, state_name_code_df, by = "STATE")
  return(map_info)
}

#----------------------------------------------
# Create the data frame to be visualized
#----------------------------------------------
create_df_for_NAS_map <- function(state_names) {
  # Get all necessary map information
  map_info <- create_map_info(state_names)

  # Join map information and Natural Amenity Ranks
  na_df <- create_natural_amenity_scale_df() %>%
    mutate(County = tolower(County)) %>%
    select(STATE, County, Natural.Amenity.Rank) %>%
    rename(Code = STATE) %>%
    inner_join(map_info, by = c("Code", "County")) %>%
    select(Code, County, Natural.Amenity.Rank, long, lat, group, order)

  return(na_df)
}
