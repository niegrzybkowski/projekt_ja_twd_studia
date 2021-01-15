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
      "#0000dd",
      "#91c8ff",
      "#b130ba"),
    medium_color = c(
      "#f48024",
      "#8888bb",
      "#a526b8",
      "#0095af",
      "#dd3333",
      "#dd0000",
      "#1877f2",
      "#4d5eca"),
    dark_color = c(
      "#b24e15",
      "#000000",
      "#381567",
      "#1c475a",
      "#990000",
      "#00dd00",
      "#0b5ab1",
      "#e8c04a")
  )
  all_c <- read.csv("../data/allCount.csv", stringsAsFactors = F) %>%
    mutate(date = as.Date(date))
  output$plot_1 <- renderPlot({
    # cały okres
    all_c %>%
      filter(domain == input$domain_select) %>%
    ggplot(aes(x = date, y = count, color = user)) +
      geom_smooth(se = F, formula = y ~ x, method = "loess") + # , span = 0.5, size = 1.5
      theme_bw() +
      scale_x_date(limits = as.Date(c("2019-12-01", "2021-02-01"))) +
      scale_y_continuous(limits = c(0, NA)) +
      scale_color_manual(
        values = colors_df %>%
          filter(domain == input$domain_select) %>%
          select(-domain) %>%
          unlist(use.names = F)
      ) +
      labs(x = "Data", y = "Średnia liczba wejść", color = "Użytkownik")
  })
  output$plot_comp <- renderPlot({

  })

  observeEvent(input$plot_click,{
  output$missing_plot <- renderUI({
    day <- input$plot_click$x
    if(day <= 1.5){
      drawPlot("pon")
    }
    else if(day > 1.5 & day <= 2.5){
     drawPlot("wt")
    }
    else if(day > 2.5 & day <= 3.5){
      drawPlot("sr")
    }
    else if(day > 3.5 & day <= 4.5){
      drawPlot("czw")
    }
    else if(day > 4.5 & day <= 5.5){
      drawPlot("pia")
    }
    else if(day > 5.5 & day <= 6.5){
      drawPlot("sob")
    }
    else if(day > 6.5 & day <= 7.5){
      drawPlot("niedz")
    }
    else {
      NULL
    }
  })})
  drawPlot <- function(day){
    output$plot_weekhours <- renderPlot({
      wdh1 <- wdh
      wdh1 <- wdh1 %>% filter(user == input$user_select1, domain == input$domain_select1, weekday == day)
       ggplot(wdh1, aes(x = hour, y = average)) +
        geom_bar(stat = "identity", fill = colors_df %>%
                   filter(domain == input$domain_select1) %>%
                   select(dark_color) %>%
                   unlist(use.names = FALSE)) +
        theme_bw() + ggtitle(paste("Średnia liczba wejść a godzina- ", day)) +
        theme(axis.title = element_text(size = 16),
              axis.text = element_text(size = 13), title = element_text(size = 20)) +
        labs(x = "Godzina", y = "Średnia liczba wejść") + scale_x_discrete(limits = c(0:23))
    })

  }

  wdt <- read.csv("../data/avgweekdays.csv")
  wdh <- read.csv("../data/avgweekdaysandhours.csv")

  output$plot_weekdays <- renderPlot({
    cos <- wdt
    cos <- cos %>%
      filter(user == input$user_select1, domain == input$domain_select1)
    cos$weekday <- c("niedz","pon", "wt", "sr", "czw", "pia", "sob")
    cos$weekday <- factor(cos$weekday, levels = c("pon", "wt", "sr", "czw", "pia", "sob", "niedz"))
    cos %>% ggplot(aes(x = weekday, y = average)) +
      geom_bar(stat = "identity", fill = colors_df %>%
                 filter(domain == input$domain_select1) %>%
                 select(dark_color) %>%
                 unlist(use.names = FALSE)) +
      theme_bw() + ggtitle("Średnia liczba wejść a dzień tygodnia") +
      theme(axis.title = element_text(size = 16),
            axis.text = element_text(size = 13), title = element_text(size = 20)) +
      labs(x = "Dzień tygodnia", y = "Średnia liczba wejść")

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
