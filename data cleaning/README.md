# Data Cleaning for NFL DFS Shiny App

The data that populates this DFS optimizer app comes from two separate sources. 

* [nfscrapR](https://github.com/maksimhorowitz/nflscrapR/) 
* [RotoGuru](http://rotoguru1.com/cgi-bin/fyday.pl?week=17&game=dk/)

- - -

#### `nflscrapR_data.R`

The first is the [nfscrapR](https://github.com/maksimhorowitz/nflscrapR/) package. This R package uses the NFL's API play-by-play data to aggregate all the individual player statistics of the 2018 season. This was used to then calculate the fantasy points for each player for each week of the season.

#### `draftkings_scrape.R`

The DraftKings player salaries are taken from a website: [RotoGuru](http://rotoguru1.com/cgi-bin/fyday.pl?week=17&game=dk/) which has an archive of all the player salaries for a variety of DFS sites. This R script uses the `rvest` package to scrape all the relevant data from the 2018 NFL season for DraftKings.

#### `nfl_merge_clean.R`

Once the two datasets are compiled they are joined together in this R script. There are some steps taken to further clean the data, filter out unneeded or errored data, and add extra clarification fields. The final version of this data is saved as a CSV: `nfl_dfs_2018.csv`. This is the raw data file that is fed into the Shiny app.
