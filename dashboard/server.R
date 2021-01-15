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
      "#8d8da5",
      "#e88cd3",
      "#5fd9cd",
      "#ff5c5c",
      "#0000dd",
      "#91c8ff",
      "#b130ba"),
    medium_color = c(
      "#f48024",
      "#63639e",
      "#a526b8",
      "#0095af",
      "#f00000",
      "#ffc30b",
      "#1877f2",
      "#4d5eca"),
    dark_color = c(
      "#b24e15",
      "#2d2d39",
      "#381567",
      "#1c475a",
      "#8f0000",
      "#dd0000",
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
      geom_smooth(se = F, formula = y ~ x, method = "loess", size = 2.5) + # , span = 0.5, size = 1.5
      theme_bw() +
      scale_x_date(limits = as.Date(c("2019-12-01", "2021-02-01"))) +
      scale_y_continuous(limits = c(0, NA)) +
      scale_color_manual(
        values = colors_df %>%
          filter(domain == input$domain_select) %>%
          select(-domain) %>%
          unlist(use.names = F),
        labels = c("Jakub", "Jan", "Kacper")
      ) +
      labs(x = "Data", y = "Średnia liczba wejść", color = "Użytkownik") +
      theme(axis.title = element_text(size = 16),
            axis.text = element_text(size = 13),
            title = element_text(size = 20),
            legend.text = element_text(size = 13))
  })
  output$plot_comp <- renderPlot({
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
      theme(axis.text.x = element_text(angle = 30, hjust = 1),
            plot.background = element_rect(fill = "#f5f5f5", color = "#f5f5f5"),
            axis.title = element_text(size = 16),
            axis.text = element_text(size = 12), title = element_text(size = 20))
  })

  wdt <- read.csv("../data/avgweekdays.csv")
  wdh <- read.csv("../data/avgweekdaysandhours.csv")

  observeEvent(input$plot_comp_click, {
    decision <- NULL
    x_coord <- input$plot_comp_click$x
    if(x_coord <= 1.5){
      decision <- "stackoverflow.com"
    }
    else if(x_coord > 1.5 & x_coord <= 2.5){
      decision <- "wikipedia.org"
    }
    else if(x_coord > 2.5 & x_coord <= 3.5){
      decision <- "github.com"
    }
    else if(x_coord > 3.5 & x_coord <= 4.5){
      decision <- "pw.edu.pl"
    }
    else if(x_coord > 4.5 & x_coord <= 5.5){
      decision <- "youtube.com"
    }
    else if(x_coord > 5.5 & x_coord <= 6.5){
      decision <- "google.com"
    }
    else if(x_coord > 6.5 & x_coord <= 7.5){
      decision <- "facebook.com"
    }
    else if(x_coord > 7.5 & x_coord <= 8.5){
      decision <- "instagram.com"
    }
    print(decision)
    if (!is.null(decision)) {
      updateSelectInput(session, "domain_select", selected = decision)
    }
  })

  observeEvent(input$plot_click,{
    day <- NULL
    x_coord <- input$plot_click$x
    if(x_coord <= 1.5){
      day <- "pon"
    }
    else if(x_coord > 1.5 & x_coord <= 2.5){
      day <- "wt"
    }
    else if(x_coord > 2.5 & x_coord <= 3.5){
      day <- "sr"
    }
    else if(x_coord > 3.5 & x_coord <= 4.5){
      day <- "czw"
    }
    else if(x_coord > 4.5 & x_coord <= 5.5){
      day <- "pia"
    }
    else if(x_coord > 5.5 & x_coord <= 6.5){
      day <- "sob"
    }
    else if(x_coord > 6.5 & x_coord <= 7.5){
      day <- "niedz"
    }

    if (!is.null(day)) {
      updateSelectInput(session, "day_select1", selected = day)
    }})


  output$plot_weekhours <- renderPlot({

     wdh <- wdh %>%
      filter(user == input$user_select1, domain == input$domain_select1, weekday == input$day_select1)
    minval = min(wdh$hour)
    maxval = max(wdh$hour)
      ggplot(wdh, aes(x = hour, y = average)) +
      geom_bar(stat = "identity", fill = colors_df %>%
                 filter(domain == input$domain_select1) %>%
                 select(medium_color) %>%
                 unlist(use.names = FALSE)) +
      theme_bw() + ggtitle(paste("Średnia liczba wejść a godzina- ", input$day_select1)) +
      theme(axis.title = element_text(size = 16),
            axis.text = element_text(size = 13), title = element_text(size = 20)) +
      labs(x = "Godzina", y = "Średnia liczba wejść") + scale_x_discrete(limits = c(minval:maxval))
  })


  output$plot_weekdays <- renderPlot({
    cos <- wdt
    cos <- cos %>%
      filter(user == input$user_select1, domain == input$domain_select1)
    cos$weekday <- c("niedz","pon", "wt", "sr", "czw", "pia", "sob")
    cos$weekday <- factor(cos$weekday, levels = c("pon", "wt", "sr", "czw", "pia", "sob", "niedz"))
    cos %>% ggplot(aes(x = weekday, y = average)) +
      geom_bar(stat = "identity", fill = colors_df %>%
                 filter(domain == input$domain_select1) %>%
                 select(medium_color) %>%
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
    jaka_strona <- as.character(input$domain_select3)

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
