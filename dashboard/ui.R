library(DT)
library(plotly)

navbarPage(
  "Nasze dane pomocy studenta",
  tabPanel(
    "Porównanie użytkowników/domen",
    sidebarLayout(
      sidebarPanel(
        selectInput(
        "domain_select",
        label = "Wybierz domenę lub kliknij na słupek poniżej:",
        choices = c("stackoverflow.com",
                    "wikipedia.org",
                    "github.com",
                    "pw.edu.pl",
                    "youtube.com",
                    "google.com",
                    "facebook.com",
                    "instagram.com"),
        selected = "stackoverflow.com"),
        plotOutput("plot_comp", click = "plot_comp_click", height = "300px")
      ),
      mainPanel(plotOutput("plot_1", height = "500px"))
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
           selectInput("day_select1",
                       label = "Wybierz dzień tygodnia:",
                       choices = c("poniedziałek" = "pon",
                                   "wtorek" = "wt",
                                   "środa" = "sr",
                                   "czwartek" = "czw",
                                   "piątek" = "pia",
                                   "sobota" = "sob",
                                   "niedziela" = "niedz"),

                       multiple = FALSE,
                       selected = "Poniedziałek"),
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
           plotOutput("plot_weekhours")
         )),
tabPanel(
  "Balans rozrywka/edukacja",
  sliderInput(
    "balans",
    label = "Wybierz miesiąc",
    min = as.Date("2019-12-01"),
    max = as.Date("2021-01-01"),
    value = as.Date("2020-04-01"),
    timeFormat = "%Y-%m",
    ticks = F,
    animate = animationOptions(
      interval = 30, loop = F
    )
  ),
  #plotOutput("plot_balans")
))
