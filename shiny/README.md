# Shiny App - NFL DFS Optimizer 

### Link to the app: [NFL DFS](https://guydotan.shinyapps.io/nfl_dfs/)


## App Overview

This app runs an optimizer for the 2018 NFL season stats to determine the best possible daily fantasy lineup for each of the 17 weeks of the regular season. The app contains four sections or tabs.

## The Four Tabs

### Optimize

This page runs the weekly lineup optimizer. Simply select the week number you wish to look at then click the "Optimize" button. The green box reflects the total salary of the 9-man lineup while the blue box shows total fantasy points from those players.

### Explore

This tab has an interactive visualization of all the indivdual performances throughout the 2018 season. Each dot is color coded by position and you can filter based on position, team, opponent and narrow down by salary or week number.

At the bottom you can change the X and Y axis to one of three variables: **salary**, **fantasy points**, and **week number**.

### Data

The data tab has the entire dataset for this app taken from the [nfscrapR](https://github.com/maksimhorowitz/nflscrapR/) package and merged with the website: [RotoGuru](http://rotoguru1.com/cgi-bin/fyday.pl?week=17&game=dk/) which was scraped for DFS salary data. Scroll right to view all the columns and use the pagination to search through all the data.

### About

This page just has a brief explanation of the rules of daily fantasy sports, how the scoring system is calculated, and how the app was created. 