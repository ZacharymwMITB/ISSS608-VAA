#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)
library(vcd)
library(ggplot2)
library(ggmosaic)

Myanmar <- read_csv("data/ACLED_MMR_1.csv")

ui <- fluidPage(
    titlePanel("Mosaic Plots"),
    sidebarLayout(
      varSelectInput(inputId = "VarSelect1",
                     "Select Variable 1: ",
                     data = Myanmar),
      varSelectInput(inputId ="varselect2",
                     "Select Variable 2: ",
                     data = Myanmar)),
      mainPanel(
        plotOutput("Mosaic")
      )
)


server <- function(input, output) { 
  output$Mosaic <-renderPlot({
    vcd::mosaic(~input$VarSelect1 + input$varselect2, data = Myanmar)
  })

}



# Run the application 
shinyApp(ui = ui, server = server)
