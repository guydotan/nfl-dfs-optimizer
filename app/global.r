# read in nfl dfs dataset and prep it for use in the app

nfl <- read.csv("../data cleaning/csvs/nfl_dfs_2018.csv", stringsAsFactors = F)

# clean up some variable names
names(nfl)[13:14] <- c("salary","fantasy_pts")

# turn position field into a factor
factor_levels <- c("QB", "WR", "RB", "TE", "Def")
nfl$pos <- factor(nfl$pos, levels = factor_levels)

# reorder the table for display
nfl <- nfl[order(nfl$season, nfl$week, nfl$date, nfl$team, nfl$pos),]
row.names(nfl) <- NULL
