# read in nfl dfs dataset and prep it for use in the app

nfl <- read.csv("data/nfl_dfs_2018.csv", stringsAsFactors = F)

# clean up some variable names
names(nfl)[13:14] <- c("salary","fantasy_pts")

# turn position field into a factor
pos_levels <- c("QB", "WR", "RB", "TE", "Def")
nfl$pos <- factor(nfl$pos, levels = pos_levels)

# remove unneeded columns
nfl <- nfl[,-c(3,9)]

# reorder the table for display
nfl <- nfl[order(nfl$season, nfl$week, nfl$date, nfl$team, nfl$pos),]
row.names(nfl) <- NULL

axis_vars <- c(
  "Salary (DK)" = "salary",
  "Fantasy Points" = "fantasy_pts",
  "Week" = "week"
)

all_teams <- sort(unique(nfl$team))
