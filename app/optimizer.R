##
## Optimizer code to select the best 9 player fantasy footballl lineup
## 1 QB, 3 WR, 2 RB, 1 TE, 1 FLEX, 1 DEF
##

# code taken from following github source:
# https://github.com/sdeep27/linear-optimization-fantasy-football

library(lpSolve)
# library(lpSolveAPI)

getSquad = function(csvfile, minSalary, week){

  # filter to selected week
  rawTable <- csvfile[csvfile$week == week,]
  rawTable <- rawTable[ , c("week","dow","name","pos","team","opp","salary","fantasy_pts")]
  
  # creating binary variables
  nfl <- cbind(rawTable, model.matrix(~ pos + 0, rawTable))
  # creating flex binary column
  nfl$posFlex <- 0
  for (row in 1:length(nfl$posRB)) {
    if (nfl$posRB[row] > 0 || nfl$posWR[row] > 0 || nfl$posTE[row] > 0){
      nfl$posFlex[row] <- 1
    }
  }
  
  # set any player we don't want to include in analysis points to 0. 
  # for (player in delPlayer){
  #  index = which(nfl$Name == player)
  #  nfl[index, 9] <- 0
  # }
  
  # create constraints
  cons<- c(nfl$posQB, nfl$posRB, nfl$posWR, nfl$posTE, nfl$posFlex, nfl$posDef, nfl$salary)
  #create matrix and double it for both sides of constraints
  con <- matrix(cons, nrow=7, byrow=TRUE)
  allcons <- rbind(con, con)
  # set right hand side coefficients for both max and min
  maxrhs <- c(1,3,4,2,7,1,"50000") #max salary,qb,rb,wr,te,flex,def
  minrhs <- c(1,2,3,1,7,1, minSalary) #minsalary, #qb, rb, wr, te, flex, def
  maxrel <- c("<=","<=","<=","<=","<=","<=","<=")
  minrel <- c(">=", ">=",">=",">=",">=",">=",">=")
  # all final variables
  obj <- nfl$fantasy_pts
  rel <- c(maxrel,minrel)
  rhs <- c(maxrhs, minrhs)
  mylp<- lp("max",obj,allcons,rel,rhs,all.bin=TRUE)
  # creating table just for the players that are in optimal solution
  solindex <- which(mylp$solution==1)
  optsolution <- nfl[solindex,]
  # cleaning up table and adding sums
  optsolution <- optsolution[,c(-9:-14)]
  
  return(optsolution)
}

#View(optsolution)