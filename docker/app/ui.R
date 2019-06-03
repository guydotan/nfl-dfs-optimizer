#
# This ShinyApp shows how to evaluate and compare
# the quality of linear models.
#

# Use ShinyDashboard
library(shinydashboard)
library(DT)
library(ggvis)

# define dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

ui <- dashboardPage(
    
  # Define Header and Sidebar
  dashboardHeader(title = "Daily Fantasy Optimizer"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Optimizer", tabName = "optimizer", icon = icon("cog")),
      menuItem("Explore", tabName = "explore", icon = icon("eye")),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    
    # Define CSS style for the estimation button
    tags$head(tags$style(HTML('
                              .optimize_button {background-color: #89400f; color:white; width: 100%}
                              .optimize_button:hover {background-color: #542a0e; color:white}
                              .optimize_button:focus {background-color: #542a0e; color:white}
                              '))),
    
    
    # Define content for each page
    tabItems(
      # Optimizer Page
      tabItem(tabName = "optimizer",
              fluidRow(
                # Add box for app parameters
                box(
                  width = 3,
                  title = "NFL 2018 Season",
                  status = "primary",
                  solidHeader = TRUE,

                  radioButtons("week_optim",
                               label = "Choose NFL Week Number:",
                               choices = c("1" = 1,
                                           "2" = 2,
                                           "3" = 3,
                                           "4" = 4,
                                           "5" = 5,
                                           "6" = 6,
                                           "7" = 7,
                                           "8" = 8,
                                           "9" = 9,
                                           "10" = 10,
                                           "11" = 11,
                                           "12" = 12,
                                           "13" = 13,
                                           "14" = 14,
                                           "15" = 15,
                                           "16" = 16,
                                           "17" = 17),
                               selected = 1),
                  
                  actionButton("Optimize","Optimize",
                               icon("cog"),
                               class="optimize_button"
                  )
                ),                
                                
                # Add box for graph 
                box(
                  title = "Optimized Lineup",
                  solidHeader = TRUE,
                  status = "primary",
                  width = 9,
                  tableOutput("view")
                  ),
                
                # Add box for salary
                valueBoxOutput("salary_box", width = 3),
                
                # Add box for fan pts
                valueBoxOutput("fan_pts_box", width = 3)
                )
      ),

      # Data Page
      tabItem(tabName = "data",
              h2("Data"),
              DT::dataTableOutput("data_table")
      ),
      
      # Explorer Page
      tabItem(tabName = "explore",
              fluidPage(
                titlePanel("2018 NFL Stats Explorer"),
                fluidRow(
                  column(3,
                         wellPanel(
                           h4("Filter"),
                           sliderInput("week", "Week Number",
                                       1, 17, value = c(1,17),
                                       sep = ""),
                           sliderInput("salary", "DraftKings Salary",
                                       0, 10000, value = c(0, 10000),
                                       step = 250),
                           selectInput("pos", "Select Opponent",
                                       c("All Positions", pos_levels)),
                           selectInput("team", "Select Teams",
                                       c("All Teams", all_teams)
                           ),
                           selectInput("opp", "Select Opponent",
                                       c("All Opponents", all_teams)),
                           textInput("full_name", "Enter any part of player name (e.g. Tom Brady)")
                         ),
                         wellPanel(
                           selectInput("xvar", "X-axis variable", axis_vars, selected = "week"),
                           selectInput("yvar", "Y-axis variable", axis_vars, selected = "fantasy_pts")
                         )
                  ),
                  column(9,
                         ggvisOutput("plot1")
                  )
                )
              )
           ),
      
      # About Page
      tabItem(tabName = "about",
              includeHTML("about.html")
      )
    )
  )
)
