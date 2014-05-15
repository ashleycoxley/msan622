Final Project
==============================

| **Name**  | Ashley Cox |
|----------:|:-------------|
| **Email** | amcox@dons.usfca.edu |


## Dataset ##
For my final project, I scraped craigslist Free postings in an attempt to find some regional differences in the San Francisco Bay Area. In addition to the scraped text, I used population from the U.S. Census Bureau and open source shapefiles (for the map visualization).

## Techniques ##

### Item Histogram ###
![](histogram.png)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This visualization is the most basic and meant to give a good overall picture of craigslist Free postings and the items they contain. I extracted "items" from the posting titles by using a part-of-speech tagger in Python and determining that, typically, the item was the last-occurring noun. The resulting items list is thus imperfect but arguably the most accurate one to result from automated extraction. 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To get items frequencies, I stemmed the "item" column of my dataset and counted frequencies for each region and overall. The user can choose any number of regions to view on the histogram at a time. I thought it was important for comparison that the order of items on the x-axis of my plot stay constant, even while different regions were selected, so I ordered item frequency according to the overall frequency. The histogram quickly and easily shows the user what sorts of items are most commonly seen on craigslist Free, so I think it is quite effective as a first visualization for this project. Because the frequencies are not scaled by number of posts per region, it shows the location of items that a user might be interested in, rather than showing a relative density (which is shown in the choropleth map).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;I believe this plot has a good data-to-ink ratio, because, as is the case with most of my plots, I tend to prefer simple, clean plots with only a few ways to interact. The data density is somewhat lower as it visualizes only a few numbers (one for each item). However, the data that was cleaned to obtain those numbers was considerably dense. The lie factor on this plot is low, but could be improved by collecting scraped data over a longer period of time (at this point, it only visualizes one day's worth of posts).


### Item Density Map ###
![](map.png)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The Item Density map is probably the most visually interesting of my plots. To create this choropleth map, I used open-source Bay Area county shapefiles and merged some counties to create the regions used by craigslist: North Bay, East Bay, San Francisco, Peninsula, and South Bay. I hard-coded columns in a new dataset for the top 7 most frequent items, where the value reflected the relative frequency of that item versus all other items in a particular region. As a result, the plot shows density within each region (as opposed to density among all regions), which I believe is the best and most accurate representation of item density. 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This plot's strength is in comparison. Rather than showing the overall number of certain items in different regions, it displays something more of a trend. Coupled with the fact that the information is in map format, the focus is shifted from being about items (as it is in the histogram) to being about regions. The item, in this plot, is a device used to show some differences among regions. For example, we can see that there is no free dirt in San Francisco, whereas there is plenty in the more rural craigslist regions. 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The data density and data-to-ink ratio are similar in this plot to the histogram. While the data frame used to produce the plot is very simple, with few rows and columns, the data that was reduced to create it was quite large. The data-to-ink ratio is quite high, as the plot shows little other than the map areas, colored by frequency. The lie factor is low, especially with the inclusion of the annotation regarding the density calculation.

### Item Ratios ###
![](ratios.png)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

### Posting Habits ###
![](habits.png)

## Interactivity ##

## Prototype Feedback ##

## Challenges ##