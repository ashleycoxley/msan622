loadData <- function() {
  state <- data.frame(state.x77,
                      State = state.name,
                      Abbrev = state.abb,
                      Region = state.region,
                      Division = state.division
  )
  state$PopDensity <- state$Population / state$Area
  state$Region <- as.factor(state$Region)
  state$Illiteracy <- state$Illiteracy/100
  
  return(state)
}

getBubble <- function(localFrame, showLabels, chooseY){
  
  localFrame$condLabels <- localFrame$Abbrev
  
  if (length(showLabels > 0)){
    localFrame$condLabels[!localFrame$Region %in% showLabels] <- NA
  }
  
  localFrame$chooseY <- localFrame[, chooseY]
  
  bubblePlot <- ggplot(localFrame, aes(
    x = Illiteracy,
    y = chooseY,
    color = Region,
    size = Population)) +
    geom_point() +
    guides(size=FALSE) +
    theme(legend.position=c(.9, .52)) +
    xlab("Illiteracy rate, 1970") +
    scale_color_manual(labels = c("Northeast", "South", "Midwest", "West"),
                       values = brewer_pal(type = "qual", palette = 'Set1')(4)) +
    scale_x_continuous(labels=percent) +
    theme(axis.ticks.x = element_blank()) +
    theme(axis.text.x = element_text(size=12)) +
    theme(axis.ticks.y = element_blank()) +
    theme(axis.text.y = element_text(size=12)) +
    theme(panel.grid.minor.y = element_blank()) +
    theme(panel.grid.minor.x = element_blank()) +
    scale_size_area(max_size=12)
  
  if (as.character(chooseY) == "Life.Exp"){
    bubblePlot <- bubblePlot +
      ylab("Life expectancy, 1969-71")
  }
  
  if (as.character(chooseY) == "Murder"){
    bubblePlot <- bubblePlot +
      ylab("Murders per 100,000 population, 1976")
  }
  
  if (length(showLabels > 0)){
    bubblePlot <- bubblePlot +
    geom_text(aes(label=condLabels,
                  hjust = 0,
                  vjust = 0),
              color = "grey25",
              size = 5)
  }
  
  print(bubblePlot)  
}

getMultiples <- function(localFrame, toggleLabels, chooseY2){
  
  localFrame$chooseY2 <- localFrame[, chooseY2]

  multiplesPlot <- ggplot(localFrame, aes(
    x = Illiteracy,
    y = chooseY2,
    color = Region,
    size = Population)) +
    geom_point() +
    facet_wrap(~Region) +  
    scale_color_manual(labels = c("Northeast", "South", "Midwest", "West"),
                       values = brewer_pal(type = "qual", palette = 'Set1')(4)) +
    scale_x_continuous(labels=percent) +
    theme(legend.position="None") +
    theme(axis.ticks.x = element_blank()) +
    theme(axis.text.x = element_text(size=12)) +
    theme(axis.ticks.y = element_blank()) +
    theme(axis.text.y = element_text(size=12)) +
    theme(panel.grid.minor.y = element_blank()) +
    theme(panel.grid.minor.x = element_blank())
    
  if (as.character(chooseY2) == "Life.Exp"){
    multiplesPlot <- multiplesPlot +
      ylab("Life expectancy, 1969-71")
  }
  
  if (as.character(chooseY2) == "Murder"){
    multiplesPlot <- multiplesPlot +
      ylab("Murders per 100,000 population, 1976")
  }
    
  if (toggleLabels == "On"){
    multiplesPlot <- multiplesPlot +
      geom_text(aes(label=Abbrev,
           hjust = 0,
           vjust = 0),
       color = "grey25",
       size = 3)
  }
  
  print(multiplesPlot)
}

getParallelCoord <- function(localFrame, chooseRegion){

  palette <- brewer_pal(type = "qual", palette = "Set1")(4)
  
  if (length(chooseRegion > 0)){
    regions <- levels(localFrame$Region)
    palette[which(!regions %in% chooseRegion)] <- "grey85"
  }

  parallelPlot <- ggparcoord(data = localFrame,
                     columns = c(1, 4, 5, 6),
                     groupColumn = 11, 
                     order = c(1, 4, 5, 6),
                     showPoints = FALSE,
                     alphaLines = 0.6,
                     shadeBox = NULL,
                     scale = "uniminmax"
                             ) + 
    theme_grey() +
    scale_color_manual(labels = c("Northeast", "South", "Midwest", "West"),
                       values = palette) +
    scale_x_discrete(labels = c("Population", "Life Expectancy", "Murder Rate", "HS Graduation Rate"))
    theme(axis.ticks.x = element_blank()) +
    theme(axis.text.x = element_text(size=12)) +
    theme(axis.title.x = element_blank()) +
    theme(axis.ticks.y = element_blank()) +
    theme(axis.text.y = element_text(size=12)) +
    theme(axis.title.y = element_blank()) +
    theme(panel.grid.minor.y = element_blank()) +
    theme(panel.grid.minor.x = element_blank())
    
  print(parallelPlot)
}

globalData <- loadData()

shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  localFrame <- globalData

  output$bubblePlot <- renderPlot({
      bubblePlot <- getBubble(
        localFrame,
        input$showLabels,
        input$chooseY
        )
      print(bubblePlot)
    })
  
  output$multiplesPlot <- renderPlot({
      multiplesPlot <- getMultiples(
        localFrame,
        input$toggleLabels,
        input$chooseY2
        )
      print(multiplesPlot)
    })
  
  output$parallelPlot <- renderPlot({
      parallelPlot <- getParallelCoord(
        localFrame,
        input$chooseRegion
        )
      print(parallelPlot)
    })
}
)
            
