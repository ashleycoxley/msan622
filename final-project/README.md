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

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To get items frequencies, I stemmed the "item" column of my dataset and counted frequencies for each region and overall. The user can choose any number of regions to view on the histogram at a time. I thought it was important for comparison that the order of items on the x-axis of my plot stay constant, even while different regions were selected, so I ordered item frequency according to the overall frequency. The histogram quickly and easily shows the user what sorts of items are most commonly seen on craigslist Free, so I think it is quite effective as a first visualization for this project.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;I believe this plot has a good data-to-ink ratio, because, as is the case with most of my plots, I tend to prefer simple, clean plots with only a few ways to interact. The data density is somewhat lower as it visualizes only a few numbers (one for each item). However, the data that was cleaned to obtain those numbers was considerably dense. The lie factor on this plot is low, but could be improved by collecting scraped data over a longer period of time (at this point, it only visualizes one day's worth of posts).


### Item Density Map ###
![](map.png)

### Item Ratios ###
![](ratios.png)

### Posting Habits ###
![](habits.png)

## Interactivity ##

## Prototype Feedback ##

## Challenges ##