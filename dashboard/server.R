library(DT)
library(ggplot2)
library(data.table)
library(lubridate)
library(dplyr)

function(input, output, session){
  output$plot_1 <- renderPlot({
    # cały okres
    read.csv("../data/allCount.csv") %>%
      dplyr::as_tibble() %>%
      mutate(date = as.Date(date)) %>%
      group_by(date, user, domain) %>%
      summarise(count = sum(count)) %>%
      filter(domain == input$domain_select) %>%
      ggplot(aes(x = date, y = count, color = user)) +
      geom_smooth(se = F) +
      theme_bw() +
      scale_x_date(limits = as.Date(c("2020-01-01", "2021-02-01"))) +
      scale_y_continuous(limits = c(0, NA))
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
