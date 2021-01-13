library(DT)
library(ggplot2)
library(data.table)
library(lubridate)
library(dplyr)

function(input, output, session){
  colors_df <- tibble(
    domain = c(
      "stackoverflow.com",
      "wikipedia.org",
      "github.com",
      "pw.edu.pl",
      "youtube.com",
      "google.com",
      "facebook.com",
      "instagram.com"),
    light_color = c(
      "#ffc43b",
      "#cccccc",
      "#e88cd3",
      "#5fd9cd",
      "#ff7777",
      "#cbdeef",
      "#91c8ff",
      "#b130ba"),
    medium_color = c(
      "#f48024",
      "#777777",
      "#a526b8",
      "#0095af",
      "#dd3333",
      "#8cb9e0",
      "#1877f2",
      "#4d5eca"),
    dark_color = c(
      "#b24e15",
      "#222222",
      "#381567",
      "#1c475a",
      "#990000",
      "#5d87af",
      "#0b5ac1",
      "#e8c04a")
  )
  output$plot_1 <- renderPlot({
    # cały okres
    read.csv("../data/allCount.csv") %>%
      dplyr::as_tibble() %>%
      mutate(date = as.Date(date)) %>%
      group_by(date, user, domain) %>%
      summarise(count = sum(count)) %>%
      filter(domain == input$domain_select) %>%
    ggplot(aes(x = date, y = count, color = user)) +
      geom_smooth(se = F, formula = y ~ x, method = "loess", family = "quasipoisson") +
      theme_bw() +
      scale_x_date(limits = as.Date(c("2020-01-01", "2021-02-01"))) +
      scale_y_continuous(limits = c(0, NA)) +
      scale_color_manual(
        values = colors_df %>% filter(domain == input$domain_select) %>% select(-domain) %>% unlist(use.names = F)
      )
  })
  output$plot_2 <- renderPlot({
    read.csv("../data/avgweekdays.csv") %>%
      filter(user == input$user_select, domain == input$domain_select) %>%
    ggplot(aes(x = weekday, y = average)) +
      geom_col() + theme_bw()

  })
  output$plot_3 <- renderPlot({
    # dany dzien
    kto = as.character(input$user_select)
    dane = paste("../data/",kto,".csv", sep="")
    tabelka <- read.table(dane,sep = ",", stringsAsFactors = T,header = T)
    tabelka <- as.data.frame(tabelka)
    dany_dzien <- as.character(input$Date_select)
    dany_dzien <- format(as.POSIXct(dany_dzien,format='%Y-%m-%d'),format='%Y/%m/%d')
    jaka_strona <- as.character(input$domain_select)

    dzien_data <- tabelka[format(as.POSIXct(tabelka$time_usec,format='%Y-%m-%d %H:%M:%S'),format='%Y/%m/%d') == dany_dzien,]
    dzien_data <- dzien_data[dzien_data$domain == jaka_strona,]
    godziny <- dzien_data$time_usec
    godziny <- round_date(strptime(godziny,"%Y-%m-%d %H:%M:%S" ),"1 hour")
    godziny <- format(as.POSIXct(godziny,format='%Y-%m-%d %H:%M:%S'),format='%H:%M')

    godziny1 <- format( seq.POSIXt(as.POSIXct(Sys.Date()), as.POSIXct(Sys.Date()+1), by = "1 hour"),
                        "%H%M", tz="GMT")
    godziny1 <- godziny1[1:(length(godziny1)-1)]
    godziny1 <- as.POSIXct(godziny1, format="%H%M")
    godziny1 <- format(godziny1,"%H:%M")

    a <- as.data.frame(table(c(godziny,godziny1,godziny)))

    ggplot(a,aes(x = Var1 ,y = Freq-1)) +
      geom_bar(stat="identity")+
      theme_bw() + xlab("Godzina") + ylab("Liczba wejsc")
  })
}
