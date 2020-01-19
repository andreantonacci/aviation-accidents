library(data.table)
library(tidyverse)
library(dplyr)
library(stringr)
library(mapproj)
library(maps)
library(lubridate)

# rm(list = ls(all.names = TRUE))

df <- read.delim("../data/raw/AviationDataCleaned.csv", sep ="\t", header = TRUE, fill = TRUE, dec =".", strip.white=TRUE) # Remove white trailing with strip.white, if any

# Transform factors to dates
df$Event.Date <- as.Date(df$Event.Date, format = "%m/%d/%Y")

# Update empty cells
df$Broad.Phase.of.Flight[df$Broad.Phase.of.Flight == ""] <- "UNKNOWN"

# Retrieve fatal accidents only
df_fatal <- df %>%
  filter(Investigation.Type == "Accident" & Aircraft.Category == "Airplane" & !Injury.Severity %in% c("Non-Fatal", "Unavailable") & !Aircraft.Damage == "")

# Count # of accidents per date
accidents_date <- df %>%
  mutate(month = format(Event.Date, "%m"), year = format(Event.Date, "%Y"), Date = format(Event.Date, "%Y-%m")) %>%
  group_by(Date) %>%
  summarize(total = n())
accidents_date$Date <- as.Date(accidents_date$Date, format = "%Y-%m-%d")

# Exploration
df_fatal %>%
  count(Aircraft.Damage, sort=TRUE)

df %>%
  count(Broad.Phase.of.Flight, sort=TRUE)