# Simple Random Based Research
# UMD - MoEF - LAPAN - WRI
# April, 18 2018

# Analysed by: Diana Parker
# Visualized by: Rizky Firmansyah

# Load global variables
source("global.R")

# Load your server script
source("server.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  

  # Application title
  h1("Forest Change during 1990 - 2016"),
  h5("10.000 Simple Random Sampling of Landsat Pixels"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y",
                  label = "Y-axis:",
                  choices = c("First Year Degradation" = "DEG_YR_FIRST",
                              "First Year Clearing" = "CLEAR_YR_FIRST"),
                  selected = "CLEAR_YR_FIRST"
                  
      ),
      
      # Select variable for x-axis
      selectInput(inputId = "x",
                  label = "X-axis:",
                  choices = c("Final Land Use UMD" = "FINAL_LU_UMD",
                              "1990 Land Cover" = "X1990_LC",
                              "2016 KLHK Land Use" = "KLHK_LU"),
                  selected = "X1990_LC"
      ),
      
      # Select variable for z, changing dynamic colors within your plots
      selectInput(inputId = "z",
                  label = "Color by:",
                  choices = c("Island" = "ISLAND",
                              "First Year Degraded" = "DEG_YR_FIRST",
                              "First Year Clearing" = "CLEAR_YR_FIRST",
                              "First Change Year" = "CH1_YR",
                              "Second Change Year" = "CH2_YR",
                              "Third Change Year" = "CH3_YR",
                              "Fourth Change Year" = "CH4_YR",
                              "Fifth Change Year" = "CH5_YR",
                              "Sixth Change Year" = "CH6_YR",
                              "Trajectory" = "TRAJECTORY"),
                  selected = "ISLAND"
      ),
      
    # making a boolean checkbox if you would like to show the table
      checkboxInput(inputId = "show_table",
                    label = "Show data table",
                    value = TRUE
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(id = "tabspanel", type = "tabs",
                tabPanel(title = "Plot",
                    plotOutput(outputId = "barplot", brush = "plot_brush"),
                    hr(),
                    DT::dataTableOutput(outputId = "nusantable")
                ),
                tabPanel(title = "Map",
                    plotOutput(outputId = "mapplot")
                )
      )
    )
  )
)

# Run the application 
shinyApp(ui = ui, server = server)