library(DT)
library(plotly)

navbarPage("Nasze dane pomocy studenta",
           tabPanel("Porównanie użytkowników/domen",
  sidebarPanel(
    selectInput("domain_select",
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
    )
  ),
  mainPanel(
    plotOutput("plot_1"),
    radioButtons(
      "spiky_smooth",
      label = "",
      choices = list("Smooth" = T, "Spiky"= F),
      selected = T
    ),
    plotOutput("plot_3"),
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    )
  )
),
tabPanel("Średnia aktywność w tygodniu",
         sidebarPanel(
           selectInput("user_select1",
                       label = "Wybierz użytkownika:",
                       choices = c("Kacper" = "kacper",
                                   "Jakub" = "jakub",
                                   "Janek" = "jan"),
                       multiple = FALSE,
                       selected = "Kacper"),
           selectInput("domain_select1",
                       label = "Wybierz domenę:",
                       choices = c("stackoverflow.com",
                                   "wikipedia.org",
                                   "github.com",
                                   "pw.edu.pl",
                                   "youtube.com",
                                   "google.com",
                                   "facebook.com",
                                   "instagram.com"),
                       selected = "stackoverflow.com")),
         mainPanel(
           plotOutput("plot_weekdays", click = "plot_click"),
           plotOutput("plot_weekhours"),
           uiOutput("missing_plot")
         )),
tabPanel("str3"))
