book <- read.csv(file.choose())

book_source <- DirSource(
  directory = file.path("/Users/ashley/Desktop/Data_Visualization/"),
  encoding = "UTF-8",     # encoding
  pattern = "*.txt",      # filename pattern
  recursive = FALSE,      # visit subdirectories?
  ignore.case = FALSE)    # ignore case in pattern?

book_corpus <- Corpus(
  book_source, 
  readerControl = list(
    reader = readPlain, # read as plain text
    language = "en"))   # language is english

book_corpus <- tm_map(book_corpus, tolower)

book_corpus <- tm_map(
  book_corpus, 
  removePunctuation,
  preserve_intra_word_dashes = TRUE)

book_corpus <- tm_map(
  book_corpus, 
  removeWords, 
  stopwords("english"))

book_corpus <- tm_map(
  book_corpus, 
  removeWords, 
  c("dont"))

book_corpus <- tm_map(
  book_corpus, 
  stemDocument,
  lang = "porter") # try porter or english

book_corpus <- tm_map(
  book_corpus, 
  stripWhitespace)

book_tdm <- TermDocumentMatrix(book_corpus)

book_matrix <- as.matrix(book_tdm)

freq_df <- data.frame(
  book1 = book_matrix[, "pg13577.txt"],
  book2 = book_matrix[, "pg17099.txt"],
  stringsAsFactors = FALSE)

freq_df <- freq_df[order(
  rowSums(freq_df), 
  decreasing = TRUE),]

freq_df <- head(freq_df, 20)

freq_plot <- ggplot(freq_df, aes(book1, book2)) +
  geom_text(
    label = rownames(freq_df),
    position = position_jitter(
    width = 2,
    height = 1)
    ) +
  ggtitle("Common Word Frequencies in the Janet Aldridge \"Meadow-Brook Girls\" Series") +
  xlab("\"The Meadow-Brook Girls Afloat\"") +
  ylab("\"The Meadow-Brook Girls by the Sea\"") +
  theme(axis.ticks.x = element_blank()) +
  theme(axis.ticks.y = element_blank()) +
  ggsave("relative_freq.png", height=6, width=9)

book_df <- data.frame(
  word = rownames(book_matrix), 
  # necessary to call rowSums if have more than 1 document
  freq = rowSums(book_matrix),
  stringsAsFactors = FALSE) 

book_df <- book_df[with(
  book_df, 
  order(freq, decreasing = TRUE)), ]

rownames(book_df) <- NULL

wordcloud(
  book_df$word,
  book_df$freq,
  scale = c(0.5, 6),      # size of words
  min.freq = 8,          # drop infrequent
  max.words = 50,         # max words in plot
  random.order = FALSE,   # plot by frequency
  rot.per = 0.3,          # percent rotated
  # set colors
  # colors = brewer.pal(9, "GnBu")
  colors = brewer.pal(12, "Paired"),
  # color random or by frequency
  random.color = TRUE,
  # use r or c++ layout
  use.r.layout = FALSE   
)

png(filename = "wordcloud.png", width=9, height=6)
bar_df <- book_df[0:20,]

barplot <- ggplot(bar_df, aes(x=word, y=freq)) +
  geom_bar(stat="identity", fill="slateblue3") +
  ggtitle("Word Frequencies in in the Janet Aldridge \"Meadow-Brook Girls\" Series") +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  theme(axis.text.x = element_text(angle=35, hjust=1, vjust=1)) + 
  theme(axis.ticks.x = element_blank()) +
  theme(panel.grid.major.x = element_blank()) +
  theme(panel.grid.minor.x = element_blank()) +
  ggsave("barplot.png", height=6, width=9)
