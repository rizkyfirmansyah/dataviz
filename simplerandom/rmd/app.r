library(shiny)
library(tidyverse)
library(forcats)
library(knitr)

ui <- fluidPage(
		uiOutput('markdown')
)

server <- function(input, output) {
	output$markdown <- renderUI({
		HTML(markdown::markdownToHTML(knit('Sample_data_processing.Rmd', quiet = TRUE)))
	})
}

shinyApp(ui, server)