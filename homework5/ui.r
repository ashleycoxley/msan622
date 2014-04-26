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
                        ),
                     h5("Vertical line denotes seatbelt law going into effect")
                      ),
    conditionalPanel(condition="input.conditionedPanels==2",
                     radioButtons(
                       "vars",
                       "Variables: ",
                       choices = c("Driver Injuries" = "drivers", "Driver Deaths" = "DriversKilled"))
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
      tabPanel("Star Plot", 
               value=2,
               plotOutput(
                 outputId = "starPlot",
                 width = "90%",
                 height = "600px"
                 )
      ),
      id = "conditionedPanels"
    ),
  
    width = 9
)))