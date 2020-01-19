# Map fatal accidents

world_data <- map_data("world")
world_map <- ggplot() + 
  geom_polygon(data = world_data, aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  theme_void()

col <- c("Minor" = "#ffcca8", "Substantial" = "#F08986", "Destroyed" = "#DC1C13")
plot1 <- world_map + 
  geom_point(data = df_fatal, aes(Longitude, Latitude, color=Aircraft.Damage, size=Total.Fatal.Injuries)) + 
  scale_color_manual(values = col, breaks = c("Minor", "Substantial", "Destroyed")) + 
  labs(color = "Aircraft Damage", size = "Total Fatal Injuries") +
  theme_void()
plot1

# Time series
plot2 <- ggplot(accidents_date, aes(Date, total, group=1)) +
  geom_line() +
  scale_x_discrete(breaks = unique(accidents_date$Date)[seq(1,500,12)]) + # Show one label per year
  # scale_x_date(date_breaks = "years" , date_labels = "%Y") + # Oly works if Date is class date (not character)
  labs(x = "Accident Date", y = "Number of Accidents") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45, hjust = 1, margin = margin(b = 20)), axis.text.y = element_text(margin = margin(l = 20))) # Rotate x axis labels
plot2