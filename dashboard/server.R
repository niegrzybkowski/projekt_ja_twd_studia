library(DT)
library(ggplot2)

function(input, output, session){
  output$plot_1 <- renderPlot({
    # cały okres
    read.csv("../data/allCount.csv") %>%
      dplyr::as_tibble() %>%
      mutate(date = as.Date(date)) %>%
      group_by(date, user, domain) %>%
      summarise(count = sum(count)) %>%
      filter(domain == input$domain_select) %>%
      ggplot(aes(x = date, y = count, color = user)) +
      geom_smooth(se = F) +
      theme_bw() +
      scale_x_date(limits = as.Date(c("2020-01-01", "2021-02-01"))) +
      scale_y_continuous(limits = c(0, NA))
  })
  output$plot_2 <- renderPlot({
    read.csv("../data/avgweekdays.csv") %>%
      filter(user == input$user_select, domain == input$domain_select) %>%
    ggplot(aes(x = weekday, y = average)) +
      geom_col() + theme_bw()

  })
  output$plot_3 <- renderPlot({
    # godzina
  })
}
