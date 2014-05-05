
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
  
  return(ordered)
}

getFreq <- function() {
  file <- 'posting_freqs.csv'
  post_freq <- read.csv(file, header=T)
  
  return(post_freq)
}

plotFreq <- function(localFrame, showRegion) {
  if (length(showRegion) == 0){
    localFrame$showRegion <- localFrame$overall
  }
  
  else if (length(showRegion) == 1){
    localFrame$showRegion <- localFrame[,showRegion]
  }
  
  else {
    localFrame$showRegion <- rowSums(localFrame[,c(showRegion)])
  }
  
  barPlot <- ggplot(subset(localFrame, overall > 10 & word != "NA"), 
                    aes(x=word, y=showRegion)) +
    geom_bar(stat='identity') +
    scale_y_continuous(limits = c(0, 74)) +
    theme(axis.text.x = element_text(angle=35, hjust=1, vjust=1)) +
    theme(axis.title.x = element_blank()) +
    theme(axis.title.y = element_blank()) +
    theme(panel.grid.major.x = element_blank())
  
  return(barPlot)
}

plotBubble <- function(freqTable) {
  
  bubble <- ggplot(freqTable, aes(
    x = lens,
    y = normed,
    color = region,
    size = pops)) +
    geom_point() +
    scale_x_continuous(limits = c(130, 190)) +
    scale_y_continuous(limits = c(1.5, 4)) +
    geom_text(aes(label=labels,
                  hjust = 1,
                  vjust = .8),
              color = "grey40",
              size = 4) +
    guides(size=FALSE) +
    theme(legend.position="none") +
    scale_size_area(max_size=14) +
    xlab('Posts per 10K Population') +
    ylab('Median Posting Length (Characters)') +
    theme(axis.ticks.x = element_blank()) +
    theme(axis.ticks.y = element_blank())
    
  return(bubble)
}

globalData <- getData()
freq <- getFreq()

shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  localFrame <- globalData
  freqData <- freq
  
  output$barPlot <- renderPlot({
  barPlot <- plotFreq(
    localFrame,
    input$showRegion
  )
  print(barPlot)
  })
  
  output$bubblePlot <- renderPlot({
    bubblePlot <- plotBubble(
      freqData
      )
    print(bubblePlot)
  })
})