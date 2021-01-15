library(DT)
library(plotly)

navbarPage(
  "Nasze dane pomocy studenta",
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

  ),
  mainPanel(
    plotOutput("plot_1"),


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
tabPanel("str3",
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
         ))
