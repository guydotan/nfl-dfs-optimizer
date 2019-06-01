##
## Merge datasets and clean it to prepare for
## loading into the shiny app
##

# read in three datasets
nfl_stats <- read.csv("csvs/nfl_player_stats.csv" , stringsAsFactors = F)
dfs_data  <- read.csv("csvs/dfs_data.csv" , stringsAsFactors = F)
def_teams <- read.csv("csvs/def_teams.csv" , stringsAsFactors = F)

# add dfs salary data to dataframe
nfl_dfs <- left_join(nfl_stats,
                      dfs_data[,c("plyr.nm","DK.salary","Team_fmt","Week","Year","h.a")],
                      by = c("name" = "plyr.nm",
                             "week" = "Week",
                             "season" = "Year",
                             "Team" = "Team_fmt"))

# check which have no salary data
na_sal <- nfl_dfs[is.na(nfl_dfs$DK.salary),]
na_sal <- na_sal[na_sal$playerID != 1,]
na_sal %>%  group_by(name, Team) %>%
  summarise(tot_fp = sum(fan_pts)) %>%
  arrange(desc(tot_fp))

# only include data with salary info
nfl_dfs_no_nas <- nfl_dfs[!is.na(nfl_dfs$DK.salary),]

# keep only relevant columns
nfl_dfs_clean <- nfl_dfs_no_nas[,c(58,57,1,2,3,61,66,4,5,64,63,65,62,6:56)]
names(nfl_dfs_clean)[10] <- "full_name"
rownames(nfl_dfs_clean) <- NULL

# get every team game and date
sched <- nfl_stats[nfl_stats$Team != "",] %>%
          group_by(week, season, Team) %>%
          summarise(game_date = max(date))

# add date to def teams dataser
def_teams_date <- left_join(def_teams, 
                              sched,
                              by = c("Week" = "week",
                                     "Year" = "season",
                                     "Team_fmt" = "Team"))

# format def df into same columns as nfl player stats data
def_teams_date[,c(12:63)] <- NA
def_teams_clean <- def_teams_date[,c(1,2,3,11,4,5,6,12,7,7,8,10,9,13:63)]


# clean up column names
names(nfl_dfs_clean) <- tolower(names(nfl_dfs_clean))
names(def_teams_clean) <- tolower(names(nfl_dfs_clean))

# combine player stats with team stats into merged df
nfl_dfs_full <- rbind(nfl_dfs_clean, def_teams_clean)

# convert all FBs to RBs and remove blank positions
nfl_dfs_full[nfl_dfs_full$pos == 'FB', "pos"] <- 'RB' 
nfl_dfs_full <- nfl_dfs_full[nfl_dfs_full$pos != "",]

# add in day of week
nfl_dfs_full$dow <- strftime(nfl_dfs_full$date,'%a')
nfl_dfs_full <- nfl_dfs_full[,c(1:4,65,5:64)]

# save final dataset to csv
# write.csv(nfl_dfs_full, "csvs/nfl_dfs_2018.csv", row.names = F, na = "")
