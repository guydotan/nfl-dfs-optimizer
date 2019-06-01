##
## scraping rotoguru for daily fantasy data ##
##

library("rvest")
library("stringr")

# rotoguru base url
url <- 'http://rotoguru1.com/cgi-bin/fyday.pl'

# DF to hold all DFS data
dfs_data <- c()

# pull just 2018 nfl data
year <- 2018

# loop through all 17 weeks of NFL season to scrape dfs data
for (i in 1:17){
  # scrape webpage and text values 
  rotoguru <- read_html(paste0(url,"?week=",i,"&year=",year,"&game=dk&scsv=1"))
  dfs <-rotoguru %>%
      html_node("pre") %>%
      html_text()
  
  # convert to CSV
  dfs_df <- read.csv(textConnection(dfs),sep = ";", stringsAsFactors = F)
  dfs_data <- rbind(dfs_data, dfs_df)
}

# extract first name and last name columns
dfs_data$first_name <- str_split_fixed(dfs_data$Name, ", ", 2)[,2]
dfs_data$last_name <- str_split_fixed(dfs_data$Name, ", ", 2)[,1]

# convert to name format to match nflscrapR
dfs_data$plyr.nm <- ifelse(dfs_data$first_name == "",
                           dfs_data$last_name,
                           paste0(substr(dfs_data$first_name,0,1),".",dfs_data$last_name))

# clean up certain player names to match nflscrapR
dfs_data[dfs_data$Name == 'Mahomes II, Patrick',]$plyr.nm <- 'P.Mahomes'
dfs_data[dfs_data$Name == 'Beckham Jr., Odell',]$plyr.nm <- 'O.Beckham'
dfs_data[dfs_data$Name == 'Robinson, Allen',]$plyr.nm <- 'A.Robinson II'
dfs_data[dfs_data$Name == 'Williams, Tyrell',]$plyr.nm <- 'Ty.Williams'
dfs_data[dfs_data$Name == 'Snead, Willie',]$plyr.nm <- 'W.Snead IV'
dfs_data[dfs_data$Name == 'Williams, Damien',]$plyr.nm <- 'Dam. Williams'
dfs_data[dfs_data$Name == 'Thomas, Demaryius',]$plyr.nm <- 'De.Thomas'
dfs_data[dfs_data$Name == 'Thomas, Demaryius',]$plyr.nm <- 'De.Thomas'
dfs_data[dfs_data$Name == 'Ginn Jr., Ted',]$plyr.nm <- 'T.Ginn'
dfs_data[dfs_data$Name == 'Wilson Jr., Jeff',]$plyr.nm <- 'J.Wilson'
dfs_data[dfs_data$Name == 'Williams, Darrel',]$plyr.nm <- 'Dar.Williams'

# clean up team abbreviations to match nflscrapR
dfs_data$Team_fmt <- toupper(dfs_data$Team)
dfs_data[dfs_data$Team_fmt == 'GNB',]$Team_fmt <- 'GB'
dfs_data[dfs_data$Team_fmt == 'JAC',]$Team_fmt <- 'JAX'
dfs_data[dfs_data$Team_fmt == 'KAN',]$Team_fmt <- 'KC'
dfs_data[dfs_data$Team_fmt == 'LAR',]$Team_fmt <- 'LA'
dfs_data[dfs_data$Team_fmt == 'NOR',]$Team_fmt <- 'NO'
dfs_data[dfs_data$Team_fmt == 'NWE',]$Team_fmt <- 'NE'
dfs_data[dfs_data$Team_fmt == 'SFO',]$Team_fmt <- 'SF'
dfs_data[dfs_data$Team_fmt == 'TAM',]$Team_fmt <- 'TB'

# clean up opponent team abbreviations to match nflscrapR
dfs_data$Opp_fmt <- toupper(dfs_data$Oppt)
dfs_data[dfs_data$Opp_fmt == 'GNB',]$Opp_fmt <- 'GB'
dfs_data[dfs_data$Opp_fmt == 'JAC',]$Opp_fmt <- 'JAX'
dfs_data[dfs_data$Opp_fmt == 'KAN',]$Opp_fmt <- 'KC'
dfs_data[dfs_data$Opp_fmt == 'LAR',]$Opp_fmt <- 'LA'
dfs_data[dfs_data$Opp_fmt == 'NOR',]$Opp_fmt <- 'NO'
dfs_data[dfs_data$Opp_fmt == 'NWE',]$Opp_fmt <- 'NE'
dfs_data[dfs_data$Opp_fmt == 'SFO',]$Opp_fmt <- 'SF'
dfs_data[dfs_data$Opp_fmt == 'TAM',]$Opp_fmt <- 'TB'

def_teams <- dfs_data[dfs_data$Pos == 'Def',]
def_teams <- def_teams[,c("Year","Week","GID","Team_fmt","Opp_fmt","h.a","Name","Pos","DK.points","DK.salary")]

# save two datasets
# write.csv(dfs_data , file = "csvs/dfs_data.csv", row.names = F)
# write.csv(def_teams , file = "csvs/def_teams.csv", row.names = F)