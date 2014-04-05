library(shiny)

shinyUI(
  pageWithSidebar(
    headerPanel("IMDB Ratings"),
    sidebarPanel(
      selectInput(
        "sortColumn",
        "Sort By:",
        choices = c("Genre", "Count")
      ),
      checkboxInput(
        "sortDecreasing",
        "Decreasing",
        FALSE
      ),
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
        choices = c("Default","Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1","Pastel2")
      ),
      sliderInput(
        inputId = 'alpha',
        label = 'Point Weight:',
        min = 0.1, 
        max = 1.0, 
        step = .1, 
        value = .5, 
      ), 
      sliderInput(
        inputId = 'size', 
        label = 'Point Size:', 
        min = 1, 
        max = 10, 
        value = 5, 
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
