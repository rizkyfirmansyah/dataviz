# Define server logic required to draw a histogram

server <- function(input, output) {
  
  ## Create a bar chart
  output$barplot <- renderPlot({
    ggplot(data = nusan, aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_bar(stat = "identity", fill = "deeppink") +
      theme_classic()
  })
  
  ## Create a data table
  output$nusantable <- DT::renderDataTable({
    if(input$show_table) {
      brushedPoints(nusan, brush = input$plot_brush) %>%
        select(ISLAND, X1990_LC, FINAL_LU_UMD, KLHK_LU, TRAJECTORY)
    }         
  })

  output$mapplot <- renderPlot({
    #plot(st_geometry(nusan_shp))
    ggplot(data = nusan_shp, aes(x = x, y = y)) +
      geom_point()
  })
  
}