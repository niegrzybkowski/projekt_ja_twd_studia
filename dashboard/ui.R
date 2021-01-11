library(DT)
library(plotly)

pageWithSidebar(
  headerPanel("Iris data"),
  sidebarPanel(
    selectInput("user_select",
                label = "Wybierz użytkownika:",
                choices = c("Jakub" = "jakub",
                            "Kacper" = "kacper",
                            "Janek" = "jan"),
                multiple = TRUE,
                selected = 1),
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
                selected = "stackoverflow.com")
  ),
  mainPanel(
    plotOutput("plot_1"),
    radioButtons(
      "spiky_smooth",
      label = "",
      choices = list("Smooth" = T, "Spiky"= F),
      selected = T
    ),
    plotOutput("plot_2"),
    plotOutput("plot_3")
  )
)
