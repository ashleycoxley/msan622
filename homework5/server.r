
data(Seatbelts)
times <- time(Seatbelts)
years <- floor(times)
months <- factor(month.abb[cycle(times)],levels = month.abb,ordered = TRUE)

belts <- transform(data.frame(Seatbelts), time = time(Seatbelts))
belts$time <- unclass(belts$time)
belts$year <- unclass(years)
belts$month <- months
melted_belts <- melt(belts, id=c('time', 'year', "month"))



plotOverview <- function(data, window) {
  xmin <- window[1]
  xmax <- window[2]
  
  ymin <- 0
  ymax <- 3000
  
  p <- ggplot(data, aes(x = time, y = drivers))
  
  p <- p + geom_rect(
    xmin = xmin, xmax = xmax,
    ymin = ymin, ymax = ymax,
    fill = grey)
  
  p <- p + geom_line()
  
  #p <- p + geom_vline(aes(x=1983))
  
  p <- p + scale_x_continuous(
    #limits = range(time),
    #expand = c(0, 0),
    #breaks = seq(1969, 1984, by = 1)
    )
  
  p <- p + scale_y_continuous(
    #limits = c(ymin, ymax),
    #expand = c(0, 0),
    #breaks = seq(ymin, ymax, length.out = 3)
    )
  
  p <- p + theme(panel.border = element_rect(
    fill = NA, colour = grey))
  
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(panel.grid = element_blank())
  p <- p + theme(panel.background = element_blank())
  p <- p + geom_vline(x = 1983, color =  "red", size = 1)
  
  return(p)
}

plotArea <- function(data, window) {
  xmin <- window[1]
  xmax <- window[2]
  
  ymin <- 0
  ymax <- 3000
  
  minor_breaks <- seq(
    floor(xmin), 
    ceiling(xmax), 
    by = 1/ 12)
  
  plot <- ggplot(
      subset(data, variable %in% c("DriversKilled", "drivers")), 
           aes(x=time, 
               y=value, 
               group = variable,
               fill = variable
               )
      ) + 
    geom_area() + 
    scale_x_continuous(
      limits = c(xmin, xmax),
      expand = c(0, 0),
      oob = rescale_none,
      breaks = seq(floor(xmin), ceiling(xmax), by = 1),
      minor_breaks = minor_breaks
      ) +
    scale_y_continuous(
      limits = c(ymin, ymax),
      expand = c(0, 0),
      breaks = seq(ymin, ymax, length.out = 5)
      ) +
    theme(axis.title = element_blank()) + 
    theme(legend.text = element_text(
                  face = "bold"),
          legend.title = element_blank(),
          legend.background = element_blank(),
          legend.position = c(.88, .8),
          legend.justification = c(0, 0),
          legend.key = element_rect(
            fill = NA,
            colour = "white",
            size = 1),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          #panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank()) +
    scale_fill_brewer(type="qual",
                      palette=6,
                      labels=c("Injury", "Death")
                      )
  if (xmin <= 1983 && 1983 <= xmax){
    plot <- plot + geom_vline(x = 1983, color = "black", size = 1)
  }

  return(plot)
}

plotStar <- function(data, vars){
  plot <- ggplot(subset(data, variable == vars), 
                   aes(x=month, 
                       y=value,
                       group=year,
                       color = variable
                   )
         ) +
    geom_line() +
    facet_wrap(~ year, ncol=4) +
    coord_fixed(ratio = 1 / 1000) +
    coord_polar() +
    theme(axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          legend.position = "None")
  
  return(plot)
}

shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
    
  output$mainPlot <- renderPlot({
    main <- plotArea(melted_belts,
                     input$window
                     )
    print(main)
  })
  
  output$overviewPlot <- renderPlot({
    overview <- plotOverview(belts,
                             input$window
                             )
    print(overview)
  })
  
  output$starPlot <- renderPlot({
    star <- plotStar(melted_belts,
                     input$vars
                     )
    print(star)
  })
})

