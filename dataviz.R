# install.packages("leaflet")
# install.packages("sf")
# install.packages("maps")
# install.packages("plotly")
library(shiny)
library(leaflet)
library(sf)
library(maps)
library(ggplot2)
library(plotly)
library(rnaturalearth)

library(shiny)
library(dplyr)
library(tidyr)


df <- read.csv("datasets/energy-cleaned-dataset.csv")


library(dplyr)
library(tidyr)

# Calcul du total d'électricité
df <- df %>%
  mutate("Total electricity" = rowSums(select(., c("Electricity.from.Fossil.Fuels",
                                                   "Electricity.from.Nuclear",
                                                   "Electricity.from.Renewables")), na.rm = TRUE))

# Création d'un nouveau DataFrame pour la visualisation
df_histo <- df %>%
  select("Country", "Continent", "Year",
         "Electricity.from.Fossil.Fuels",
         "Electricity.from.Nuclear",
         "Electricity.from.Renewables") %>%
  pivot_longer(cols = starts_with("Electricity.from."),
               names_to = "Electricity mode",
               values_to = "Electricity") %>%
  mutate(`Electricity mode` = gsub("Electricity.from.", "", `Electricity mode`),
         Year = as.character(Year))


# Créer un graphique à barres en faisant la somme pour chaque année
ggplot(df_histo, aes(x = Year, y= Electricity), show.legend=FALSE) +
  geom_bar(stat = "sum", aes(fill = `Electricity mode`), show.legend = TRUE) +
  labs(y = "Electricity (TWh)", )
  




color_map <- c("Fossil.Fuels" = rgb(223,95,73,200, maxColorValue = 255), "Nuclear" = rgb(74,147,255,200, maxColorValue = 255),
               "Renewables"= rgb(0,205,94,200,  maxColorValue = 255))




df_map <- subset(df, Year == 2020 & Continent == "Europe")
world <- ne_countries(scale = "medium", returnclass = "sf") %>%
  select("iso_a2", "geometry")
map_data <- left_join(world, df_map, by = c("iso_a2" = "ISO2"))



