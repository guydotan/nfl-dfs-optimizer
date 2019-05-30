#
# This ShinyApp shows how to evaluate and compare
# the quality of linear models.
#

# Use ShinyDashboard
library(shinydashboard)

ui <- dashboardPage(
  
  # Define Header and Sidebar
  dashboardHeader(title = "Daily Fantasy Optimizer"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Optimizer", tabName = "optimizer", icon = icon("cog")),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  

  dashboardBody(
    
    # Define CSS style for the estimation button
    tags$head(tags$style(HTML('
                              .estimation_button {background-color: #89400f; color:white; width: 100%}
                              .estimation_button:hover {background-color: #542a0e; color:white}
                              .estimation_button:focus {background-color: #542a0e; color:white}
                              '))),
    
    # Define content for each page
    tabItems(
      
      # Estimation Page
      tabItem(tabName = "optimizer",
              fluidRow(
                # Add box for estimation parameters
                box(
                  width = 3,
                  title = "NFL 2018 Season",
                  status = "primary",
                  solidHeader = TRUE,
                  
                  radioButtons("week",
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
                               selected = 1)
                  ),                
                                
                # Add box for graph 
                box(
                  title = "Optimized Lineup",
                  solidHeader = TRUE,
                  status = "primary",
                  width = 9,
                  tableOutput("view")
                  ),
                
                # Add box for fan pts
                valueBoxOutput("fan_pts_box", width = 3),
                
                # Add box for salary
                valueBoxOutput("salary_box", width = 3),
                
                actionButton("Optimize","Optimize",
                               icon("cog"),
                               class="estimation_button"
                               )
                )
      ),

      # Data Page
      tabItem(tabName = "data",
              h2("Data"),
              dataTableOutput("data_table")
      ),
      
      # About Page
      tabItem(tabName = "about",
              includeHTML("about.html")
      )
    )
  )
)
