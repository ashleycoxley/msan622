
getData <- function() {
  file <- 'craigs_parsed_w_item.csv'
  craigs <- read.csv(file, header=F)
  colnames(craigs) <- c('url', 'region', 'neighborhood', 'title', 'text', 'item')
  
  craigs_minus <- subset(craigs, region != 'scz')
  craigs_minus$region <- factor(craigs_minus$region)
  
  # stem titles
  craigs_minus[,6] <- as.character(craigs_minus[,6])
  stemmed_items <- lapply(craigs_minus[,6], stemDocument)
  craigs_minus$item <- unlist(stemmed_items)
  
  # get frequencies
  region_freq <- as.data.frame(table(craigs_minus$item, craigs_minus$region))
  colnames(region_freq) <- c('word', 'region', 'regionfreq')
  freqs <- cast(region_freq, word~region, value='regionfreq')
  freqs$overall <- rowSums(freqs)
  
  # order words by overall frequency
  ordered <- freqs[order(freqs$overall, decreasing=TRUE), ]
  ordered$word <- factor(ordered$word, levels = ordered$word)
}

plotFreq <- function(localFrame, showRegion) {
  if (length(showRegion == 0)){
    showRegion <- overall
  }
  
  localFrame$showRegion <- localFrame[, c(showRegion)]
  
  barPlot <- ggplot(subset(localFrame, overall > 10 & word != "NA"), aes(x=word, y=showRegion)) +
    geom_bar(stat='identity') +
    theme(axis.text.x = element_text(angle=35, hjust=1, vjust=1)) +
    theme(axis.title.x = element_blank()) +
    theme(axis.title.y = element_blank()) +
    theme(panel.grid.major.x = element_blank())
  
  return(barPlot)
}

globalData <- getData()

shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  localFrame <- globalData
  
  output$scatterPlot <- renderPlot({
  barPlot <- barPlot(
    localFrame,
    input$showRegion,
  )
  print(barPlot)
}
  )
}
)