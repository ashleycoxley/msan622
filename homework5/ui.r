shinyUI(
  pageWithSidebar(
  headerPanel("UK Driver Injuries"),
  sidebarPanel(
    conditionalPanel(condition="input.conditionedPanels==1",
                     sliderInput(
                        "window", 
                        "Begin and End Dates: ",
                        min = 1969, 
                        max = 1984,
                        value = c(1974, 1980),
                        step = 1,
                        ticks = TRUE,
                        format = "####"
                        )
                      ),
    conditionalPanel(condition="input.conditionedPanels==2"
                     ),
    
    width = 3
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Area Plot", 
               value=1,
               plotOutput(
                 outputId = "mainPlot", 
                 width = "100%", 
                 height = "400px"
               ),
               
               plotOutput(
                 outputId = "overviewPlot",
                 width = "100%",
                 height = "200px"
               )
      ), 
      tabPanel("Plot 2", 
               value=2
      ),
      id = "conditionedPanels"
    ),
  
    width = 9
)))