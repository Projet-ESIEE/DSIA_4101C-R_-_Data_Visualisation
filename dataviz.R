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



df <- read.csv("datasets/energy-cleaned-dataset.csv")
# Calcul du total d'électricité
df <- df %>%
  mutate("Total electricity" = rowSums(select(., c("Electricity.from.Fossil.Fuels",
                                                   "Electricity.from.Nuclear",
                                                   "Electricity.from.Renewables")), na.rm = TRUE))

df_test <- subset(df, Year==2020)

fig <- ggplot(df_test, aes(x = HDI, fill = Continent))+
  geom_histogram(binwidth = 0.05, alpha = 0.7)+
  facet_wrap(~Continent, scales = "free_y") +
  labs(title = "IDH repartition per continent",
       x = "HDI",
       y = "")
fig


world <- ne_countries(scale = "medium", returnclass = "sf")%>%
  select("iso_a2", "pop_est")
df_plot <- merge.data.frame(world,df,by.x = "iso_a2", by.y = "ISO2")%>%
  select("Country", "Year", "Total electricity", "pop_est", "HDI", "Continent")
  
df_plot$Electricity_per_capita <- df_plot$`Total electricity`/ df_plot$pop_est *1000000000
df_plot <- subset(df_plot, Year==2000 & Country != "Namibia")

fig <- ggplot(df_plot, aes(x = HDI, y = Electricity_per_capita, text= Country), fill=Continent) +
  geom_point(aes(color=Continent))+
  labs(title = "Electricity per capita vs IDH in 2020",
      x = "IDH",
      y = "Electricity per capita (Wh)")+
  scale_y_log10()
fig <- ggplotly(fig,  tooltip = c("text"))
fig

