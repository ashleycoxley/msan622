library(ggplot2)
library(shiny)

# Objects defined outside of shinyServer() are visible to
# all sessions. Objects defined instead of shinyServer()
# are created per session. Place large shared data outside
# and modify (filter/sort) local copies inside shinyServer().

# See plot.r for more comments.

# Note: Formatting is such that code can easily be shown
# on the projector.

# Loads global data to be shared by all sessions.
loadData <- function() {
  data("movies", package = "ggplot2")
  
  filtered <- movies[which(movies$budget != 0 & movies$budget != 'NA' & movies$mpaa != ""),]
  genre <- rep(NA, nrow(filtered))
  count <- rowSums(filtered[, 18:24])
  genre[which(count > 1)] = "Mixed"
  genre[which(count < 1)] = "None"
  genre[which(count == 1 & filtered$Action == 1)] = "Action"
  genre[which(count == 1 & filtered$Animation == 1)] = "Animation"
  genre[which(count == 1 & filtered$Comedy == 1)] = "Comedy"
  genre[which(count == 1 & filtered$Drama == 1)] = "Drama"
  genre[which(count == 1 & filtered$Documentary == 1)] = "Documentary"
  genre[which(count == 1 & filtered$Romance == 1)] = "Romance"
  genre[which(count == 1 & filtered$Short == 1)] = "Short"
  filtered$genre <- as.factor(genre)
  return(filtered)
}

# Label formatter for numbers in thousands.
thousand_formatter <- function(x) {
  return(sprintf("%dk", round(x / 1000)))
}

# Create plotting function.
getPlot <- function(localFrame, showRating, showGenres, colorChoice, alphaChoice, sizeChoice) {
  print(head(localFrame))
  if (showRating != 'All'){
    localFrame <- localFrame[which(localFrame$mpaa==showRating), ]
    print(head(localFrame))
  }
  
  if (length(showGenres) > 0) {
    localFrame <- localFrame[which(localFrame$genre %in% showGenres),]
    print(head(localFrame))
  }
  
  localPlot <- ggplot(localFrame, aes(x=budget, y=rating, color=mpaa)) +
    ggtitle("Movie Budgets vs. Ratings") +
    xlab("Budget") +
    ylab("Rating") +
    geom_point(size=sizeChoice, alpha=alphaChoice)
  
  mpaas <- levels(localFrame$mpaa)[2:5]
  
  if (colorChoice == "Pastel 1") {
    paletteChoice <- brewer_pal(type = "qual", palette = 'Pastel1')(length(mpaas))
  }
  else if (colorChoice == "Accent") {
    paletteChoice <- brewer_pal(type = "qual", palette = 'Accent')(length(mpaas))
  }
  else if (colorChoice == "Set 1") {
    paletteChoice <- brewer_pal(type = "qual", palette = 'Set1')(length(mpaas))
  }
  else if (colorChoice == "Set 2") {
    paletteChoice <- brewer_pal(type = "qual", palette = 'Set2')(length(mpaas))
  }
  else if (colorChoice == "Set 3") {
    paletteChoice <- brewer_pal(type = "qual", palette = 'Set3')(length(mpaas))
  }
  else if (colorChoice == "Dark 2") {
    paletteChoice <- brewer_pal(type = "qual", palette = 'Dark2')(length(mpaas))
  }
  else if (colorChoice == "Pastel 2") {
    paletteChoice <- brewer_pal(type = "qual", palette = 'Pastel2')(length(mpaas))
  }
  else if (colorChoice == 'Default'){
    #my_palette <- brewer_pal(type = "qual", palette = 'Set3')(length(mpaas))
    return(localPlot + scale_color_discrete(name = 'MPAA Rating'))
  }
  
  all_mpaas <- levels(localFrame$mpaa)[which(levels(localFrame$mpaa)!='')]
  localPlot <- localPlot + scale_color_manual(values = paletteChoice, name = 'MPAA Rating')
  return(localPlot)
}

##### GLOBAL OBJECTS #####

globalData <- loadData()

##### SHINY SERVER #####
shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  localFrame <- globalData
  
  sortOrder <- reactive(
    {
        if (input$sortColumn == "Genre") {
          return(
            order(
              localFrame$Genres,
              decreasing = input$sortDecreasing
            )
          )
        }
        else {
          return(
            order(
              localFrame$Counts,
              decreasing = input$sortDecreasing
            )
          )
        }
    }
  )
  
  output$table <- renderTable(
      {
        return(localFrame[sortOrder(), ])
      },
      include.rownames = FALSE
  )
  
  output$scatterPlot <- renderPlot(
    {
      scatterPlot <- getPlot(
        localFrame,
        input$showRating,
        input$showGenres,
        input$colorChoice,
        input$alphaChoice,
        input$sizeChoice
      )
    print(scatterPlot)
    }
  )
  }
)

# Two ways to run this application. Locally, use:
# runApp()

# To run this remotely, use:
# runGitHub("lectures", "msan622", subdir = "ShinyDemo/demo1")
