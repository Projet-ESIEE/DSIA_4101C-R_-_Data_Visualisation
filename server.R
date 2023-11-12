#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(leaflet)
library(rnaturalearth)


df <- read.csv("datasets/energy-cleaned-dataset.csv")

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



function(input, output, session) {
  
  output$title <- renderText(
   paste("Electricity production in ",input$continent," in ",input$years," (TWh)")
  )
  
  output$map <- renderLeaflet({
  
    df_map <- subset(df, Year == input$years & Continent == input$continent)
    world <- ne_countries(scale = "medium", returnclass = "sf")%>%
      select("iso_a2", "geometry")
    map_data <- left_join(world, df_map, by = c("iso_a2" = "ISO2"))
    
    continent_pos <- list(
      "Europe" = c(3,50,14),
      "Asia" = c(3,25,100),
      "Africa" = c(3,8,20),
      "Americas" = c(2,13,-74),
      "Oceania" = c(3,-19,144)
    )
     pos <- continent_pos[[input$continent]]
    # Define color palette
    colorPal <- colorNumeric(palette = "Reds", domain = map_data$`Total electricity`, na.color = "#808080")
    
    leaflet(map_data) %>%
      setView(lat=pos[2], lng=pos[3], zoom=pos[1]) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~colorPal(`Total electricity`),
        fillOpacity = 0.7,
        color = "#ffffff",
        weight = 0.3,
        smoothFactor = 0.5,
        opacity = 1,
        highlight = highlightOptions(weight = 2, bringToFront = TRUE)
      ) %>%
      addLegend(
        pal = colorPal,
        values = ~`Total electricity`,
        title = "",
        position = "bottomright"
      )
  })
  
  
  output$pie <- renderPlot({
    color_map <- c("Fossil.Fuels" = rgb(223,95,73,200, maxColorValue = 255), "Nuclear" = rgb(74,147,255,200, maxColorValue = 255),
                   "Renewables"= rgb(0,205,94,200,  maxColorValue = 255))
    
    df_pie <- subset(df_histo, Continent == input$continent & Year== input$years)
    
    fig <- ggplot(df_pie)+
      geom_bar(aes(x="", y=Electricity , fill=`Electricity mode`), stat = "identity")+
      coord_polar("y")+
      theme_void()+
      scale_fill_manual(values = color_map)  # Couleurs personnalisées
    
    fig
    
  })
  
  
  output$histo <- renderPlot({
  
    df_histogram <- subset(df_histo, Continent == input$continent)
    # Créer un graphique à barres en faisant la somme pour chaque année
    ggplot(df_histogram, aes(x = Year, y= Electricity), show.legend=FALSE) +
      geom_bar(stat = "sum", aes(fill = `Electricity mode`), show.legend = TRUE) +
      labs(y = "" )
  })
}

