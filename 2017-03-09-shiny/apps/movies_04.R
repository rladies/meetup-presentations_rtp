#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(dplyr)
library(shiny)
library(ggplot2)
load("movies.Rdata")

# Define UI for application that plots features of movies ---------------------
ui <- fluidPage(
  
  # Application title ---------------------------------------------------------
  titlePanel("Movie plotter"),
  
  # Sidebar layout with a input and output definitions ------------------------
  sidebarLayout(
    
    # Inputs: Select variables to plot ----------------------------------------
    sidebarPanel(
      
      # Select variable for x-axis --------------------------------------------
      selectInput("var_x", 
                  label = "x-axis variable", 
                  choices = names(movies), 
                  selected = "imdb_rating"),
      
      # Select variable for y-axis --------------------------------------------
      selectInput("var_y", 
                  label = "y-axis variable", 
                  choices = NA)
      
    ),
    
    # Output: -----------------------------------------------------------------
    mainPanel(
      
      # Show plot -------------------------------------------------------------
      h4("Plot of the movies data"),
      plotOutput("main_plot"),
      HTML("<br>"),        # a little bit of visual separation
      
      # Show summary statistics -----------------------------------------------
      h4("X Summary statistics:"),
      tableOutput("x_summary"),
      conditionalPanel(
        "input.var_y != 'None'",
        h4("Y Summary statistics:"),
        tableOutput("y_summary")
      )
    )
  )
)

# Define server function required to create the plot and summary statistics ---
server <- function(input, output, session) {
  
  # Define observer for determining which variables to display as y-choices ---
  observe({
    y_choices = c("None", names(movies))
    new_y_choices = setdiff(y_choices, input$var_x)
    # Don't allow the same variable as x to be selected for y
    updateSelectInput(session, inputId = "var_y", choices = new_y_choices)
  })
  
  # Create the plot object the plotOutput function is expecting ---------------
  output$main_plot = renderPlot({
    
    # Many if statements to determine which type of plot to make
    if (input$var_y == "None")
    { 
      base = ggplot(movies, aes_string(x=input$var_x))
      
      if (is.numeric(movies[[input$var_x]]))
      {
        base + geom_histogram()
      } else {
        base + geom_bar(aes_string(fill=input$var_x))
      }
    } else {
      if (is.numeric(movies[[input$var_x]]) & is.numeric(movies[[input$var_y]]))
      {
        ggplot(movies, aes_string(x=input$var_x, y=input$var_y)) +
          geom_point()
      } 
      else if (!is.numeric(movies[[input$var_x]]) & is.numeric(movies[[input$var_y]]))
      {
        ggplot(movies, aes_string(x=input$var_x, y=input$var_y)) +
          geom_boxplot()
      }
      else if (is.numeric(movies[[input$var_x]]) & !is.numeric(movies[[input$var_y]]))
      {
        ggplot(movies, aes_string(y=input$var_x, x=input$var_y)) +
          geom_boxplot() + 
          coord_flip()
      } else {
        ggplot(movies, aes_string(x=input$var_x, fill=input$var_y)) +
          geom_bar()
      }
    }
  })
  
  # Calculate the summary statistics for x the tableOutput function is expecting ----
  output$x_summary = renderTable({
    data.frame(
      mean = mean(movies[[input$var_x]], na.rm = TRUE),
      med = median(movies[[input$var_x]], na.rm = TRUE),
      iqr = IQR(movies[[input$var_x]], na.rm = TRUE),
      min = min(movies[[input$var_x]], na.rm = TRUE),
      max = max(movies[[input$var_x]], na.rm = TRUE)
    )
  })
  
  # Calculate the summary statistics for y the tableOutput function is expecting ----
  output$y_summary = renderTable({
    if (input$var_y != "None")
    {
      data.frame(
        mean = mean(movies[[input$var_y]], na.rm = TRUE),
        med = median(movies[[input$var_y]], na.rm = TRUE),
        iqr = IQR(movies[[input$var_y]], na.rm = TRUE),
        min = min(movies[[input$var_y]], na.rm = TRUE),
        max = max(movies[[input$var_y]], na.rm = TRUE)
      )
    }
  })
}

# Run the application ---------------------------------------------------------
shinyApp(ui = ui, server = server)
