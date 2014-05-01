Project: Prototype
==============================

| **Name**  | Ashley Cox  |
|----------:|:-------------|
| **Email** | amcox@dons.usfca.edu |

## Instructions ##

The following packages must be installed prior to running this code:

- `ggplot2`
- `shiny`

To run this code, please enter the following commands in R:
```
library(shiny)
library(ggplot2)
shiny::runGitHub('msan622', 'ashleycoxley', subdir = 'project-prototype')
```


## Discussion ##

For my project prototype, I'm showing a bar plot that shows the most frequent items listed on one day in the Bay Area craigslist Free section. The first plot shows the frequency for all regions:

![](overall.png)

The plot is interactive, so the user will select one or many regions to view. The x-axis will stay constant according to the order of the overall bar plot, but the bars will change. Below are two examples, of San Francisco and the East Bay.

![](sfc.png)

![](eby.png)