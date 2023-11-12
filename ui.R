library(shiny)
library(plotly)
library(leaflet)

df <- read.csv("datasets/energy-cleaned-dataset.csv")
# Define UI for application that draws a choropleth map
shinyUI(fluidPage(
  
  # Application title
  titlePanel(
    textOutput(outputId = "title")
  ),
  
  # Main panel
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "years",
                  label = "Year",
                  min = 2000,
                  max = 2020,
                  step = 1,
                  value = 2000,
                  animate = FALSE),
      selectInput(inputId = "continent",
                  label = "Continent",
                  selected = "Europe",
                  choices = unique(df$Continent)),
      plotOutput("pie"),
    ),
    mainPanel(
    leafletOutput(outputId = "map",),
    plotOutput(outputId="histo", height = 300)
    )
  )
))
