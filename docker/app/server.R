##
## This ShinyApp runs a simple daily fantasy
## lineup optimzer for DraftKing's NFL scoring.
##

library(shiny)

shinyServer(function(input, output) {
  
  source("optimizer.r", local = TRUE)
  
  # Reactive value that triggers plot update and stores fitted values
  v <- reactiveValues(fitted_values = NULL, r2 = NULL)

  # When action button was triggered...
  observeEvent(input$Optimize, {
    # Add progress bar
    withProgress(message = 'Please wait',
                 detail = 'Running optimization...', value = 0.6,
    {
      selected_week <- {input$week}
      
      optim <- getSquad(nfl, 0, selected_week)
      
      # Increase progress bar to 0.8  
      incProgress(0.8, detail="Loading")
      
      # Increase progress bar to 1
      incProgress(1, detail="Finished")
      
      v$fan_pts <- sum(optim$fantasy_pts)
      v$salary <- sum(optim$salary)
      v$fmt_sal <- format(v$salary,big.mark=",",scientific=FALSE)
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
      paste("\u00A0",v$fan_pts), " total Fantasy Points", icon = icon("tachometer"),
      color = "light-blue"
      )	
    })
  
  # Total Salary Box
  output$salary_box <- renderValueBox({
    valueBox(
      paste0("$",v$fmt_sal), " total DraftKings salary", icon = icon("money"),
      color = "green"
    )	
  })

  # Show Data Table
  output$data_table <- renderDataTable({
    datatable(nfl, options = list(scrollX = TRUE))
  })
})