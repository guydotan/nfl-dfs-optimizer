##
## This ShinyApp runs a simple daily fantasy
## lineup optimzer for DraftKing's NFL scoring.
##

library("shiny")
library("dplyr")
library("stringr")
library("rsconnect")

shinyServer(function(input, output, session){
  
  source("optimizer.R", local = TRUE)
  
  # Reactive value that triggers plot update and stores fitted values
  v <- reactiveValues(data = NULL)

  # When action button was triggered...
  observeEvent(input$Optimize, {
    # Add progress bar
    withProgress(message = 'Please wait',
                 detail = 'Running optimization...', value = 0.6,
    {
      selected_week <- {input$week_optim}
      
      optim <- getSquad(nfl, 0, selected_week)
      
      # Increase progress bar to 0.8  
      incProgress(0.8, detail="Loading")
      
      v$fan_pts <- sum(optim$fantasy_pts)
      v$fmt_fan_pts <- format(round(v$fan_pts, 2), nsmall = 2)
      v$salary <- sum(optim$salary)
      v$fmt_sal <- format(v$salary,big.mark=",",scientific=FALSE)
      
      # Increase progress bar to 1
      incProgress(1, detail="Finished")
       
   })
    
    output$view <- renderTable({
      factor_levels <- c("QB", "WR", "RB", "TE", "Def", "")
      optim$pos <- factor(optim$pos, levels = factor_levels)
      optim <- optim[order(optim$pos),]
      names(optim) <- c("Week","DOW","Player","Pos","Team","Opp","Salary","Fantasy Pts")
      optim
      
    })
  })
  
  # Fantasy Points Box
  output$fan_pts_box <- renderValueBox({
    valueBox(
      paste("\u00A0",v$fmt_fan_pts),
      " total Fantasy Points",
      icon = icon("tachometer"),
      color = "light-blue"
      )	
    })
  
  # Total Salary Box
  output$salary_box <- renderValueBox({
    valueBox(
      paste0("$",v$fmt_sal),
      " total DraftKings salary",
      icon = icon("money"),
      color = "green"
    )	
  })

  # Show Data Table
  output$data_table <- renderDataTable({
    datatable(nfl, options = list(scrollX = TRUE))
  })
  
  plyrs <- reactive({
    
    # Due to dplyr issue #318, we need temp variables for input values
    fanpts <- input$fantasy_pts
    week <- input$week
    team <- input$team
    opp <- input$opp
    salary <- input$salary
    minweek <- input$week[1]
    maxweek <- input$week[2]
    minsal <-  input$salary[1]
    maxsal <- input$salary[2]
    
    p <- nfl %>%
      filter(
        week >= minweek,
        week <= maxweek,
        salary >= minsal,
        salary <= maxsal
      ) %>%
      arrange(fantasy_pts)
    
    # filter by team
    if (input$team != "All Teams") {
      Team <- paste0("", input$team, "")
      p <- p %>% filter(team == Team)
    }
    # filter by opponent
    if (input$opp != "All Opponents") {
      Opp <- paste0("", input$opp, "")
      p <- p %>% filter(opp == Opp)
    }
    # filter by position
    if (input$pos != "All Positions") {
      Pos <- paste0("", input$pos, "")
      p <- p %>% filter(pos == Pos)
    }
    # filter by player
    if (!is.null(input$full_name) && input$full_name != "") {
      Plyr_nm <- paste0("", input$full_name, "")
      p <- p %>% filter(str_detect(tolower(full_name),tolower(Plyr_nm)))
    }
    p <- as.data.frame(p)
  })
  
  # reactive again to add in ID for hover action in graph
  plyrs_with_ids <- reactive({
    dat_ids <- as.data.frame(plyrs())
    dat_ids$ID <- 111111:(nrow(dat_ids)+111110)
    dat_ids
  })
  
  # Function for generating tooltip text
  plyr_tooltip <- function(x) {
    #if (is.null(x)) return(NULL)
    if (is.null(x$ID)) return(NULL)
    
    # Pick out the player-game with this ID
    all_plyrs <- isolate(plyrs_with_ids())
    plyr <- all_plyrs[all_plyrs$ID == x$ID, ]
    
    paste0("<b>", plyr$full_name, "</b>, ", plyr$team, "<br>",
           ifelse(plyr$h.a == 'h',
                  paste0("Week ", plyr$week, " - vs ", plyr$opp, "<br>"),
                  paste0("Week ", plyr$week, " - at ", plyr$opp, "<br>")),
           "Salary: $", format(plyr$salary, big.mark = ",", scientific = FALSE), "<br>",
           paste0("Fantasy Pts: ", format(round(plyr$fantasy_pts, 2), nsmall = 2))
    )
  }
  
  # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
    
    plyrs_with_ids %>%
      ggvis(x = xvar, y = yvar) %>%
      layer_points(size := 50,
                   size.hover := 200,
                   fillOpacity := 0.2,
                   fillOpacity.hover := 0.5,
                   fill = ~pos,
                   key := ~ID) %>%
      add_tooltip(plyr_tooltip, "hover") %>%
      add_axis("x", title = xvar_name) %>%
      add_axis("y", title = yvar_name,title_offset = 50) %>%
      set_options(width = 750, height = 500)
  })

    vis %>% bind_shiny("plot1")
})