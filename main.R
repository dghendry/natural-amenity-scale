# filename: main.R
#----------------------------------------------
# This code is used to present the Natural
# Amenity Scale for counties in the US.
#----------------------------------------------
library(ggplot2)
# Set your working directory
setwd("~/Documents/__INFO-201/12code/nas")

# Source these R files (note directory location)
source("./source/data_wrangling.R")
source("./source/viz.R")

#----------------------------------------------
# Specify the states to be visualized. All
# counties in these states.
#----------------------------------------------
#state_names = c("washington", "oregon", "California", "New York")
#state_names = c("washington")

# All counties, in all states, in the US
state_names = c(".")

#----------------------------------------------
# Get the data frame to be vizualized - all 
# data wrangling is handled by this call
#----------------------------------------------
na_df <- create_df_for_NAS_map(state_names)

#----------------------------------------------
# Example visualizations
#----------------------------------------------
# Create a vizualization with a conintuous color scale
p <- create_viz_with_continuous_scale(na_df)
print(p)

# Create a visualization with 7 ugly colors 
color_list <- get_7ugly_colors();
p <- create_viz_with_discrete_scale(na_df,color_list)
print(p)

# And, wth 7 nice green colors 
color_list <- get_7green_colors();
p <- create_viz_with_discrete_scale(na_df,color_list)
print(p)

# Get polygon information for a county
df <- get_county_polygon("wa", "adams", na_df)
View(nrow(df))

# Get polygon information for a county - show numbers
df <- get_county_polygon("wa", "adams", na_df)
View(nrow(df))

# Get get the county plot -- show points 
p <- draw_county_map("WA","adams",na_df)
print(p)

# Get get the county plot -- show numbers 
p <- draw_county_map("WA","adams",na_df, TRUE)
print(p)


