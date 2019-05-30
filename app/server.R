#
# This ShinyApp shows how to evaluate and compare
# the quality of linear models.
#

library(shiny)

shinyServer(function(input, output) {
  
  source("optimizer.r", local = TRUE)
  
  # Reactive value that triggers plot update and stores fitted values
  v <- reactiveValues(fitted_values = NULL,
                      r2 = NULL)

  # When action button was triggered...
  observeEvent(input$Optimize, {
    # Add progress bar
    withProgress(message = 'Please wait',
                 detail = 'Run estimation...', value = 0.6,
    {
      selected_week <- {input$week}
      
      estimation <- getSquad(nfl, 0, selected_week)
      # Increase progress bar to 0.8  
      incProgress(0.8, detail="Store results")
      
      # Increase progress bar to 1
      incProgress(1, detail="Finish")
      
      v$fan_pts <- sum(estimation$DK.points)
      v$salary <- sum(estimation$DK.salary)
      v$fmt_sal <- format(v$salary,big.mark=",",scientific=FALSE)
    })
    
    output$view <- renderTable({
      factor_levels <- c("QB", "WR", "RB", "TE", "Def", "")
      estimation[-10,]$Pos <- factor(estimation[-10,]$Pos, levels = factor_levels)
      estimation <- estimation[order(estimation$Pos),]
      estimation
    })
  })
  
  # Estimation Results
  #output$estimation_results <- renderText(
  #  v$var
  #)
  
  # Show the first "n" observations ----
  # The use of isolate() is necessary because we don't want the table
  # to update whenever input$obs changes (only when the user clicks
  # the action button)

  
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
  
  # Overview Plot
  output$plot <- renderPlot({
      plot(data_helper$clust[,c("Sepal.Length", "Sepal.Width")], col = v$clusters,
           main = "Iris plot of Sepal Length and Width Colored by Cluster",
           xlab = "Sepal Length",
           ylab = "Sepal Width")
      points(v$centers[,c("Sepal.Length", "Sepal.Width")],
            col = 1:5,
            pch = 20,
            cex = 2
            )
    
  })
  #could add screeplot right here

  # Show Data Table
  output$data_table <- renderDataTable(nfl)

})
