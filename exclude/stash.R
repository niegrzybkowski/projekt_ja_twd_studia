all_c %>%
  mutate(month = paste0(lubridate::year(date), "-", lubridate::month(date)))

  ggplot(aes(x = date, y = count, color = user)) +
  geom_line()



  ggplotly()
  output$table_1 <- DT::renderDataTable({
    DT::datatable(iris)
  })

  output$plot_1 <- renderPlot({
    sample_row <- sample(1:nrow(iris), input$plot_1_sample)
    sampled_iris <- iris[sample_row, ]

    if (input$plot_1_colors) {
      ggplot(sampled_iris, aes_string(x = input$plot_1_x, y = input$plot_1_y, color = "Species")) +
        geom_point()
    } else {
      ggplot(sampled_iris, aes_string(x = input$plot_1_x, y = input$plot_1_y)) +
        geom_point()
    }

  })

  output$plotly_1 <- renderPlotly({
    sample_row <- sample(1:nrow(iris), input$plot_1_sample)
    sampled_iris <- iris[sample_row, ]

    if (input$plot_1_colors) {
      p <- ggplot(sampled_iris, aes_string(x = input$plot_1_x, y = input$plot_1_y, color = "Species")) +
        geom_point()
    } else {
      p <- ggplot(sampled_iris, aes_string(x = input$plot_1_x, y = input$plot_1_y)) +
        geom_point()
    }
    ggplotly(p)

  })




  all_c %>%
    group_by(domain) %>%
    summarise(total = sum(count)) %>%
    mutate(domain = factor(
      domain, levels = c(
      "stackoverflow.com",
      "wikipedia.org",
      "github.com",
      "pw.edu.pl",
      "youtube.com",
      "google.com",
      "facebook.com",
      "instagram.com")
      )) %>%
    ggplot(aes(x = domain, y = total)) +
    geom_col(fill = "slateblue") +
    ggtitle("Ogólne użycie stron") +
    labs(x = "Domena", y = "Łączna ilość wejść") +
    theme_bw()+
    theme(axis.text.x = element_text(angle = 20, hjust = 1))

read.csv("data/allCount.csv", stringsAsFactors = F) %>%
  mutate(category = ifelse(domain %in% c("stackoverflow.com", "wikipedia.org", "github.com","pw.edu.pl"), "edu", "ent")) %>%
  mutate(date = as.Date(paste0(lubridate::year(date), "-", lubridate::month(date), "-01"))) %>%
  group_by(user, date, category) %>%
  summarise(avg = mean(count)) %>%
  tidyr::pivot_wider(names_from = category, values_from = avg) %>%
  filter(date >= as.Date("2020-01-01")) %>%
  write.csv("data/balance.csv", row.names = F)

read.csv("data/balance.csv") %>%
  plot_ly(
    x = ~ent,
    y = ~edu,
    color = ~user,
    type = "scatter",
    mode = "markers",
    frame = ~date,
    size = 10
  ) %>%
  layout(
    title = "Balans Rozrywka/Edukacja",
    xaxis = list(title = "Rozrywka", zeroline = F),
    yaxis = list(title = "Edukacja", zeroline = F)
  )

  filter(date)
  ggplot(aes(x = edu, y = ent, color = user)) +
  geom_point(size = 5)

transition_reveal(date) -> bouncy

anim_save("boing.gif", bouncy)


div(
  selectInput(
    "user_select",
    label = "Wybierz użytkownika:",
    choices = c("Kacper" = "kacper",
                "Jakub" = "jakub",
                "Janek" = "jan"),
    multiple = FALSE,
    selected = "Kacper"
  ),
  style="display: inline-block;vertical-align:top; width: 150px;"
),
div(
  selectInput(
    "domain_select3",
    label = "Wybierz domenę:",
    choices = c("stackoverflow.com",
                "wikipedia.org",
                "github.com",
                "pw.edu.pl",
                "youtube.com",
                "google.com",
                "facebook.com",
                "instagram.com"),
    selected = "stackoverflow.com"),
  style="display: inline-block;vertical-align:top; width: 200px;"
),
div(
  dateRangeInput( "Date_range_select",
                  label = "Wybierz okres:",
                  start = "2019-12-16",
                  end = "2019-12-30",
                  min = "2019-12-16",
                  max = "2020-12-15",
                  format = "yyyy-mm-dd",
                  startview = "month",
                  weekstart = 1,
                  language = "en",
                  width = NULL,
                  autoclose = TRUE
  ),
  style="display: inline-block;vertical-align:top; width: 250px;"
),
dateInput( "Date_select",
           label = "Wybierz dzień:",
           value = "2019-12-16",
           min = "2019-12-16",
           max = "2020-12-15",
           format = "yyyy-mm-dd",
           startview = "month",
           weekstart = 1,
           language = "en",
           width = NULL,
           autoclose = TRUE
),
plotOutput("plot_3"),
tags$style(type="text/css",
           ".shiny-output-error { visibility: hidden; }",
           ".shiny-output-error:before { visibility: hidden; }"
)


sliderInput(
  "balans",
  label = "Wybierz miesiąc",
  min = as.Date("2019-12-01"),
  max = as.Date("2021-01-01"),
  value = as.Date("2020-04-01"),
  timeFormat = "%Y-%m",
  ticks = F,
  animate = animationOptions(
    interval = 1000, loop = F
  ),
  step = 30
),


ooo %>% group_by(domain) %>% summarise(count = n()) %>% View()

ooo %>% View()

ooo %>%
  filter(domain %in% c("stackoverflow.com", "wikipedia.org", "github.com")) %>%
  mutate(hour = lubridate::hour(time_usec)) %>%
  group_by(domain, hour) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = hour, color = domain, y = count)) +
  geom_line()

ooo %>%
  filter(domain %in% c("stackoverflow.com")) %>%
  mutate(date = lubridate::month(time_usec)) %>%
  group_by(domain, date) %>%
  ggplot(aes(x = date, color = domain)) +
  geom_bar()

ooo %>%
  filter(domain %in% c("google.com", "youtube.com", "facebook.com")) %>%
  mutate(hour = lubridate::hour(time_usec)) %>%
  group_by(domain, hour) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = hour, color = domain, y = count)) +
  geom_line()
