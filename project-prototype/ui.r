library(shiny)

shinyUI(
  pageWithSidebar(    
    headerPanel('Craigslist Free in the Bay Area'),
    sidebarPanel(
    conditionalPanel(condition = 'input.conditionedPanels == 1',
                     sidebarPanel(
                       checkboxGroupInput(
                         inputId = 'showRegion', 
                         label = "Region", 
                         choices = c('San Francisco' = 'sfc', 'Peninsula' = 'pen', 'East Bay' = 'eby', 'North Bay' = 'nby', 'South Bay' = 'sby')
                         )
                     )
                     ),
    
    conditionalPanel(condition = 'input.conditionedPanels == 2',
                     sidebarPanel()
                     )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Items",
                 value = 1,
                 plotOutput('barPlot')
                 ),
        tabPanel("Posting Habits",
                 value = 2,
                 plotOutput('bubblePlot')
                 ),
        id = "conditionedPanels"
      )
    )
  )
)

