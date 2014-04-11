shinyUI(pageWithSidebar(
  headerPanel("State of the States in the 1970s"),
  sidebarPanel(
    conditionalPanel(condition="input.conditionedPanels==1",
                     helpText(),
                     checkboxGroupInput(
                       "showLabels",
                       "Show Labels for Region",
                       choices = c("Northeast", "South", "Midwest" = "North Central", "West")
                     ),
                     radioButtons(
                       "chooseY",
                       "Outcomes",
                       choices = c("Life Expectancy" = "Life.Exp", "Murder Rate" = "Murder")
                       )
    ),
    
    conditionalPanel(condition="input.conditionedPanels==2",
                     helpText(),
                     radioButtons(
                       "toggleLabels",
                       "Labels",
                       choices = c("Off", "On")
                       ),
                     radioButtons(
                       "chooseY2",
                       "Outcomes",
                       choices = c("Life Expectancy" = "Life.Exp", "Murder Rate" = "Murder")
                     )
    ),
    
    conditionalPanel(condition="input.conditionedPanels==3",
                     helpText(),
                              checkboxGroupInput(
                                "chooseRegion",
                                "Region",
                                choices = c("Northeast", "South", "North Central", "West")
                                )
    )
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Bubble Plot", 
               value=1,
               plotOutput("bubblePlot")
               ), 
      tabPanel("Small Multiples", 
               value=2,
               plotOutput("multiplesPlot")
               ),
      tabPanel("Parallel Coordinates", 
               value=3,
               plotOutput("parallelPlot")
               ), 
      id = "conditionedPanels"
    )
  )
))