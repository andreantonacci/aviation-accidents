library(data.table)
library(tidyverse)
library(dplyr)
library(stringr)
library(mapproj)
library(maps)
library(lubridate)

# Wrangling ------------
# rm(list = ls(all.names = TRUE))

df <- read.delim("../data/raw/AviationDataCleaned.csv", sep ="\t", header = TRUE, fill = TRUE, dec =".", strip.white=TRUE) # Remove white trailing with strip.white, if any

# Transform factors to dates
df$Event.Date <- as.Date(df$Event.Date, format = "%m/%d/%Y")

# Update empty cells
df$Broad.Phase.of.Flight[df$Broad.Phase.of.Flight == ""] <- "UNKNOWN"
df$Weather.Condition[df$Weather.Condition == ""] <- "UNK"
df$Aircraft.Damage[df$Aircraft.Damage == ""] <- NA

# Add dummy for fatalities in accident
df <- mutate(df, IsFatal = ifelse(!Injury.Severity %in% c("Non-Fatal", "Unavailable", "Incident"), "Fatal", "Not Fatal"))

# Retrieve fatal accidents only
df_fatal <- df %>%
  filter(Aircraft.Category == "Airplane" & IsFatal == "Fatal")

# Count # of accidents per date
accidents_date <- df %>%
  mutate(Date = format(Event.Date, "%Y-%m")) %>%
  group_by(Date) %>%
  summarize(total = n())
accidents_date$Date <- as.Date(paste(accidents_date$Date, "-01", sep = ""), format = "%Y-%m-%d") # Transform Date as class date again, adding a fake day

fatal_accidents_date <- df_fatal %>%
  mutate(Date = format(Event.Date, "%Y-%m")) %>%
  group_by(Date) %>%
  summarize(total = n())
fatal_accidents_date$Date <- as.Date(paste(fatal_accidents_date$Date, "-01", sep = ""), format = "%Y-%m-%d") # Transform Date as class date again, adding a fake day

# Count # of fatal injuries per date
fatal_injuries_date <- df_fatal %>%
  mutate(Date = format(Event.Date, "%Y")) %>%
  group_by(Date) %>%
  summarize(total = sum(Total.Fatal.Injuries))
fatal_injuries_date$Date <- as.Date(paste(fatal_injuries_date$Date, "-01-01", sep = ""), format = "%Y-%m-%d") # Transform Date as class date again, adding a fake day

# Count # of accidents per manufacturer
accidents_manufacturer <- subset(df, Event.Date > as.Date("2000-01-01")) %>%
  mutate(Manufacturer = ifelse(Make %in% c("BOEING", "Boeing"), "Boeing", ifelse(Make %in% c("AIRBUS", "Airbus"), "Airbus", "Other"))) %>%
  group_by(Manufacturer, IsFatal) %>%
  summarize(total = n())

# Exploration ------------

# Fatal accidents per flight phase
df_fatal %>% count(Broad.Phase.of.Flight, sort=TRUE)

# Most dangerous airports
subset(df, !Airport.Code %in% c("", "NONE", "None", "PVT", "N/A")) %>% count(as.character(Airport.Code), sort=TRUE)

# Misc
# df %>% count(Weather.Condition, sort=TRUE)
# df %>% count(Make %in% c("AIRBUS", "BOEING", "Boeing", "Airbus"), sort=TRUE)
# View(subset(df, Make %in% c("AIRBUS", "BOEING", "Boeing", "Airbus") & Event.Date > as.Date("2000-01-01")))