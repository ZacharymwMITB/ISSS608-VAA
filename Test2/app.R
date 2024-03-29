library(shiny)

pacman::p_load(shiny, shinydashboard, shinycssloaders, 
               tidyverse, dplyr, leaflet, plotly, 
               ggthemes, fresh, sf, sfdep, tmap, tm, 
               ggraph, igraph, tidytext, DT, spatstat,
               lubridate,viridis, ggplot2, readr, purrr, ggstatsplot, 
               vcd, ggmosaic, forcats)


ACLED_MMR <- read_csv("data/MMR.csv")

final <- readRDS("data/final.rds")
mapping_rates <- readRDS("data/mapping_rates.rds")

Events_2 <- read_csv("data/df_complete.csv")
Space_2 <- read_csv("data/df1_complete.csv")

event_type <- unique(final$event_type)
admin1 <- unique(final$admin1)



mmr_shp_mimu_1 <- sf::st_read(dsn = "data/geospatial3", layer = "mmr_polbnda2_adm1_250k_mimu_1")
mmr_shp_mimu_2 <- sf::st_read(dsn = "data/geospatial3", layer = "mmr_polbnda_adm2_250k_mimu")

ACLED_MMR <- read_csv("data/MMR.csv")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "YearMosaic2",
                  label = "Year:",
                  choices = seq(2020, 2023),
                  selected = 2023),
      selectInput(inputId = "Option1Mosaic2",
                  label = "Option 1:",
                  choices = unique(ACLED_MMR$admin1),
                  selected = "admin1"),
      selectInput(inputId = "Option2Mosaic2",
                  label = "Option 2:",
                  choices = unique(ACLED_MMR$event_type),
                  selected = "event_type")
    ),
    mainPanel(
      plotOutput("Mosaicplot2", height = "700px")
    )
  )
)

server <- function(input, output) {
  MosaicResults2 <- reactive({
    req(input$YearMosaic2, input$Option1Mosaic2, input$Option2Mosaic2)
    
    # Filter the data based on the user's selection
    filteredData <- ACLED_MMR %>%
      filter(year == input$YearMosaic2)
    
    if (nrow(filteredData) == 0) {
      return(NULL)  # Exit if no data
    }
    
    return(filteredData)  
  })        
  
  output$Mosaicplot2 <- renderPlot({
    dataForMosaic2 <- MosaicResults2()  
    
    if (is.null(dataForMosaic2)) return()  # Check if the data is NULL and exit if it is
    
    Mosaic2 <- vcd::mosaic(as.formula(paste0(~input$Option1Mosaic2 + input$Option2Mosaic2)), 
                           data = dataForMosaic2, gp = shading_max, 
                           labeling = labeling_border(labels = TRUE, varnames = FALSE, 
                                                      rot_labels = c(90, 0, 0, 0), 
                                                      just_labels = c("left", "center", "center", "right")))
    Mosaic2
  })
}

shinyApp(ui = ui, server = server)
