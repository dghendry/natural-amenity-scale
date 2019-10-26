# filename: viz.R
#----------------------------------------------
# Plot the Natural Amenity Scale
#----------------------------------------------

# install.packages("ggplot2")
library(ggplot2)
library(stringr)

#----------------------------------------------
# Returns 7 colors to be used in a discrete scale
# See http://colorbrewer2.org/
#----------------------------------------------
get_7green_colors <- function() {
  t <- c(
    "1" = "#edf8e9",
    "2" = "#c7e9c0",
    "3" = "#a1d99b",
    "4" = "#74c476",
    "5" = "#41ab5d",
    "6" = "#238b45",
    "7" = "#005a32"
  )
  return(t)
}

#----------------------------------------------
# Returns 7 colors to be used in a discrete scale
#----------------------------------------------
get_7ugly_colors <- function() {
  t <- c(
    "1" = "black",
    "2" = "brown",
    "3" = "pink",
    "4" = "red",
    "5" = "blue",
    "6" = "darkgreen",
    "7" = "orange"
  )
  return(t)
}

#----------------------------------------------
# This function will draw a county map
#----------------------------------------------
draw_county_map <- function(state_code, county_name, map_df, show_nums = FALSE) {
  # The list of points representing the polygon
  county_polygon_df <- get_county_polygon(state_code, county_name, map_df)

  # Clean-up the state_code and the county_name
  state_code <- str_to_upper(state_code)
  county_name <- str_to_title(county_name)
  no_points <- nrow(county_polygon_df)
  county_title <- paste0(
    "Place: ",
    county_name, ",",
    state_code,
    " (No. Points: ", no_points, ")"
  )

  # Create the plot with one geometic object (a layer)
  p <- ggplot(
    county_polygon_df,
    aes(x = lat, y = long, label = seq(from = 1, to = no_points))
  ) +
    geom_polygon(fill = "grey75", color = "black", linetype = "dotted") +
    labs(title = county_title)

  # Add a second geometic object (either a point or a label)
  if (show_nums == FALSE) {
    p <- p + geom_point(color = "red")
  }
  else {
    p <- p + geom_text(nudge_x = 0.0, nudge_y = 0.0, color = "red", size = 9 / .pt)
  }

  return(p)
}

#----------------------------------------------
# Create the visualization with a continuous scale
#----------------------------------------------
create_viz_with_continuous_scale <- function(na_df) {
  na_df$Natural.Amenity.Rank <- as.numeric(na_df$Natural.Amenity.Rank)

  p <- ggplot(na_df, aes(long, lat)) +
    xlab("lat") +
    ylab("long")

  p <- p + geom_polygon(
    aes(group = group, fill = Natural.Amenity.Rank),
    colour = "grey75",
    size = 0.15
  )

  # low = "#132B43", high = "#56B1F7"

  p <- p + scale_fill_gradient(
    limits = c(1, 7),
    low = "#FF0000", high = "#00FF00",
    space = "Lab", na.value = "grey50", guide = "colourbar",
    aesthetics = "fill"
  )
  return(p)
}

#----------------------------------------------
# Create the visualization with a discrete scale
# Since the Natural Amenity Scales goes from 1-7
# the number of colors in the list should be 7.
#----------------------------------------------
create_viz_with_discrete_scale <- function(na_df, color_list) {
  na_df$Natural.Amenity.Rank <- as.factor(na_df$Natural.Amenity.Rank)

  p <- ggplot(na_df, aes(long, lat)) +
    xlab("lat") +
    ylab("long")

  p <- p + geom_polygon(
    aes(group = group, fill = Natural.Amenity.Rank),
    colour = "black"
  )
  p <- p + scale_fill_manual(limits = c("1", "2","3","4","5","6","7"), values = color_list)
  return(p)
}
