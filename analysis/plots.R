# Map fatal accidents

world_data <- map_data("world")
world_map <- ggplot() + 
  geom_polygon(data = world_data, aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  theme_void()

col <- c("Minor" = "#ffcca8", "Substantial" = "#F08986", "Destroyed" = "#DC1C13", "Unknown" = "#d4d4d4")
plot1 <- world_map + 
  geom_point(data = df_fatal, aes(Longitude, Latitude, color=Aircraft.Damage, size=Total.Fatal.Injuries)) + 
  scale_color_manual(values = col, breaks = c("Minor", "Substantial", "Destroyed", "Unknown")) + 
  labs(title = "Location of Accidents, Aircraft Damage and Number of Fatal Injuries", color = "Aircraft Damage", size = "Total Fatal Injuries") +
  theme_void() + 
  theme(plot.title = element_text(vjust=2))
plot1

# Time series

plot2 <- ggplot(accidents_date, aes(Date, total, group=1)) +
  geom_line() +
  # scale_x_discrete(breaks = unique(accidents_date$Date)[seq(1, 500, 12)]) + # Show one label per year, only works if Date is not class date (a character)
  scale_x_date(date_breaks = "years" , date_labels = "%Y") +
  coord_cartesian(xlim = as.Date(c("1983-01-01", "2018-06-01"))) + 
  labs(title = "Number of Total Accidents per Year", x = "Accident Date", y = "Number of Accidents") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, margin = margin(b = 20)),
        axis.text.y = element_text(margin = margin(l = 20)),
        plot.title = element_text(vjust=2))
plot2

plot3 <- ggplot(fatal_accidents_date, aes(Date, total, group=1)) +
  geom_line() +
  # scale_x_discrete(breaks = unique(accidents_date$Date)[seq(1, 500, 12)]) + # Show one label per year, only works if Date is not class date (a character)
  scale_x_date(date_breaks = "years", date_labels = "%Y") +
  labs(title = "Number of Fatal Accidents per Year", x = "Accident Date", y = "Number of Accidents") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, margin = margin(t = 5, b = 20)),
        axis.text.y = element_text(margin = margin(r = 5, l = 20)),
        plot.title = element_text(vjust=2))
plot3

plot4 <-  ggplot(fatal_injuries_date, aes(Date, total, group=1)) +
  geom_line() +
  scale_x_date(date_breaks = "years" , date_labels = "%Y") +
  coord_cartesian(xlim = as.Date(c("1983-01-01", "2018-06-01"))) + 
  labs(title = "Number of Fatal Injuries per Year", x = "Accident Date", y = "Number of Fatal Injuries") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, margin = margin(t = 5, b = 20)),
        axis.text.y = element_text(margin = margin(r = 5, l = 20)),
        plot.title = element_text(vjust=2))
plot4

# Bar charts

plot5 <- ggplot(df, aes(IsFatal, fill = IsFatal)) + 
  geom_bar() +
  facet_wrap(~ Broad.Phase.of.Flight, scales = "free") +
  labs(title = "Number of Fatal and Not Fatal Accidents per Flight Phase", x = "Is the Accident Fatal?", y = "Number of Accidents", fill = "Is the Accident Fatal?") + 
  theme_bw() +
  theme(axis.text.x = element_text(margin = margin(t = 5, b = 20)),
        axis.text.y = element_text(margin = margin(r = 5, l = 20)),
        plot.title = element_text(vjust=2))
plot5

# We see that when IMC --> fatal > non fatal
plot6 <- ggplot(subset(df, !Weather.Condition == "UNK"), aes(Weather.Condition, fill = IsFatal)) + # Ignore UNK weather conditions
  geom_bar(position = "dodge2") +
  facet_wrap(~ Broad.Phase.of.Flight, scales = "free") +
  labs(title = "Number of Accidents per Weather Condition, Fatality and Flight Phase", x = "Weather Condition", y = "Number of Accidents", fill = "Is the Accident Fatal?") + 
  theme_bw() +
  theme(axis.text.x = element_text(margin = margin(t = 5, b = 20)),
        axis.text.y = element_text(margin = margin(r = 5, l = 20)),
        plot.title = element_text(vjust=2))
plot6

plot7 <- ggplot(subset(accidents_manufacturer, !Manufacturer == "Other"), aes(Manufacturer, total, fill = IsFatal)) + # Only keep Airbus and Boeing
  geom_col(position = "dodge2") +
  labs(title = "Number of Accidents per Manufacturer from January 2000", x = "Manufacturer", y = "Number of Accidents", fill = "Is the Accident Fatal?") + 
  theme_bw() +
  theme(axis.text.x = element_text(margin = margin(t = 5, b = 20)),
        axis.text.y = element_text(margin = margin(r = 5, l = 20)),
        plot.title = element_text(vjust=2))
plot7