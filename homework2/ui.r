library(shiny)

shinyUI(
  pageWithSidebar(
    headerPanel("IMDB Ratings"),
    sidebarPanel(
      radioButtons(
        "showRating",
        "MPAA Rating:",
        choices = c("All", "PG", "PG-13", "R", "NC-17")
      ),
      checkboxGroupInput(
        inputId = "showGenres", 
        label = "Genre", 
        choices = c('Action', 'Animation', 'Comedy', 'Documentary', 'Drama', 'Romance', 'Short', "Mixed", 'None')
      ),
      selectInput(
        "colorChoice",
        "Color Scheme",
        choices = c("Default","Accent", "Set 1", "Set 2", "Set 3", "Dark 2", "Pastel 1","Pastel 2")
      ),
      sliderInput(
        inputId = 'alphaChoice',
        label = 'Point Opacity:',
        min = 0.1, 
        max = 1.0, 
        step = .1, 
        value = .5, 
      ), 
      sliderInput(
        inputId = 'sizeChoice', 
        label = 'Point Size:', 
        min = 1, 
        max = 10, 
        value = 3, 
      ),
      sliderInput(
        inputId = 'yearChoice',
        label = "Release Date Range:",
        min = 1938,
        max = 2005,
        value = c(1938, 2005),
        step = 1,
        format = '####'
      )
    ),
    mainPanel(
      tabsetPanel(
        #plotOutput("scatterPlot")
        tabPanel("Scatterplot", plotOutput("scatterPlot")),
        tabPanel("Table", tableOutput("table"))
      )
    )
  )
)
