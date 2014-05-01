library(shiny)

shinyUI(
  pageWithSidebar(
    headerPanel("Craigslist Free in the Bay Area"),
    sidebarPanel(
      checkboxGroupInput(
        inputId = "showRegion", 
        label = "Region", 
        choices = c('San Francisco' = 'sfc', 'Peninsula' = 'pen', 'East Bay' = 'eby', 'North Bay' = 'nby', 'South Bay' = 'sby')
      )
    ),
    mainPanel(
      tabsetPanel(
        plotOutput("barPlot")
      )
    )
  )
)
