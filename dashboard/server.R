library(DT)
library(ggplot2)

function(input, output, session){
  output$plot_1 <- renderPlot({
    # cały okres
  })
  output$plot_2 <- renderPlot({
    # dzień tygodnia
  })
  output$plot_3 <- renderPlot({
    # godzina
  })
}
