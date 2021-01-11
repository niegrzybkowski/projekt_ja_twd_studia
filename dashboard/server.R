library(DT)
library(ggplot2)

function(input, output, session){
  output$plot_1 <- renderPlot({
    # cały okres

    if (input$spiky_smooth) {
      read.csv("../data/allCount.csv", stringsAsFactors = F) %>%
        as_tibble() %>%
        mutate(date = as.Date(date)) %>%
        group_by(date, user, domain) %>%
        filter(domain == input$domain_select) %>%
        ggplot(aes(x = date, y = count, color = user)) +
        geom_smooth(se = F) +
        theme_bw() +
        scale_x_date(limits = as.Date(c("2020-01-01", "2021-02-01"))) +
        scale_y_continuous(limits = c(0, NA))
    } else {
      bin_dates7  <- function(date) {
        paste0(
          lubridate::year(date) , "-", lubridate::month(date), "-",
          ifelse(
            lubridate::day(date) <= 15,
            ifelse(lubridate::day(date) <= 7, "1", "7"),
            ifelse(lubridate::day(date) <= 21, "16", "23")
          )
        ) %>%
          as.Date()
      }
      read.csv("../data/allCount.csv", stringsAsFactors = F) %>%
        as_tibble() %>%
        mutate(date = bin_dates7(date)) %>%
        group_by(date, user, domain) %>%
        summarise(count = mean(count)) %>%
        filter(domain == input$domain_select) %>%
        ggplot(aes(x = date, y = count, color = user)) +
        geom_line() +
        theme_bw() +
        scale_x_date(limits = as.Date(c("2020-01-01", "2021-02-01"))) +
        scale_y_continuous(limits = c(0, NA))

    }

  })
  output$plot_2 <- renderPlot({
    # dzień tygodnia
  })
  output$plot_3 <- renderPlot({
    # godzina
  })
}
