#set data to iris data set
data <- iris

# Compute more values from x variable in a helper dataframe
data_helper <- NULL
data_helper$clust <- data[,-5]
data_helper$response <- data$Species


dataset <- read.csv("nfl_2018_v2.csv", stringsAsFactors = F)
nfl <- dataset[,c("week","season","game.id","name","Pos","Team","h.a","Opp_Team","fan_pts","DK.salary")]
nfl <- nfl[nfl$DK.salary > 0 & nfl$Pos != "",]
nfl[nfl$Pos == 'FB',"Pos"] <- 'RB'
names(nfl) <- c("Week",	"Year",	"GID"	,"Name",	"Pos"	,"Team",	"h.a",	"Oppt",	"DK.points"	,"DK.salary")
factor_levels <- c("QB", "WR", "RB", "TE", "Def", "")
nfl$Pos <- factor(nfl$Pos, levels = factor_levels)
nfl <- nfl[order(nfl$Week, nfl$Year, nfl$Team, nfl$Pos),]
