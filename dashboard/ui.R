library(DT)
library(plotly)

pageWithSidebar(
  headerPanel("Iris data"),
  sidebarPanel(
    selectInput("user_select",
                label = "Wybierz użytkownika:",
                choices = c("Jakub" = 1,
                            "Kacper" = 2,
                            "Janek" = 3),
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
    plotlyOutput("plotly_1"),
    plotOutput("plot_1"),
    DT::dataTableOutput("table_1")
    # verbatimTextOutput("verbatim_1")
  )
)
