library(ggplot2)
library(scales)
library(reshape)
library(stringr)
data(movies)
data(EuStockMarkets)


# Data transformations
filtered <- movies[which(movies$budget != 0 & movies$budget != 'NA'),]

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

genre_levels <- names(sort(table(genre), decreasing=T))
filtered$genre <- genre
filtered$genre <- factor(filtered$genre, levels=genre_levels)
                         
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))
eu$time <- unclass(eu$time)
melted_eu <- melt(eu, id=c('time'), measured=c('DAX', 'SMI', 'CAC', 'FTSE'))

# Get euro-sign format for EU price graph, taken from Stack Overflow:
# http://stackoverflow.com/questions/11935797/euro-sign-in-ggplot-scales-package
euro_format <- function(largest_with_cents = 100000) {
  function(x) {
    x <- round_any(x, 0.01)
    if (max(x, na.rm = TRUE) < largest_with_cents &
          !all(x == floor(x), na.rm = TRUE)) {
      nsmall <- 2L
    } else {
      x <- round_any(x, 1)
      nsmall <- 0L
    }
    str_c("€", format(x, nsmall = nsmall, trim = TRUE, big.mark = ",", scientific = FALSE, digits=1L))
  }
}

# Plot 1
plot1 <- ggplot(filtered, aes(x=budget, y=rating, group=genre, color=genre)) + 
  plotgeom_jitter() +
  ggtitle("Movie Ratings by Budget") +
  xlab("Budget") +
  ylab("Movie Rating") +
  scale_x_continuous(labels = dollar_format()) +
  scale_colour_brewer(name = "Genre", type='qual', palette=3) +
  ggsave(file='hw1-scatter.png', height=6, width=9)
  

# Plot 2
plot2 <- ggplot(filtered, aes(genre, fill=genre)) +
  geom_bar() +
  ggtitle("Genre Frequency in Movies Dataset") +
  xlab("Genre") +
  ylab("Number of Movies") +
  scale_fill_brewer(name = "Genre", type='qual', palette=3) +
  theme(legend.position="none") +
  ggsave(file='hw1-bar.png', height=6, width=9)

# Plot 3
plot3 <- ggplot(filtered, aes(x=budget, y=rating, color=genre)) + 
  geom_jitter() +
  ggtitle("Movie Ratings by Genre") +
  xlab("Budget") +
  ylab("Movie Rating") +
  scale_x_continuous(labels = dollar_format()) +
  scale_colour_brewer(name = "Genre", type='qual', palette=3) +
  theme(axis.text.x = element_text(angle=35, hjust=1, vjust=1)) +
  theme(legend.position="none") +
  facet_wrap(~genre) +
  ggsave(file='hw1-multiples.png', height=6, width=9)

# Plot 4
plot4 <- ggplot(melted_eu, aes(x=time, y=value, group=variable, color=variable)) + 
  geom_line() +
  ggtitle("EU Stock Prices") +
  xlab("Year") +
  ylab("Price") +
  scale_y_continuous(labels = euro_format()) +
  scale_colour_brewer(name='Symbol', type='div', palette=1) +
  ggsave(file='hw1-multiline.png', height=6, width=9)


