library(lubridate)
all_data <- read.csv("data/allCount.csv")
all_data$date <- as.Date(all_data$date)
all_dataweek <- all_data %>% mutate("weekdat" = wday(all_data$date))

head(all_data1)
all_data2 <- all_dataweek %>% group_by("user" = all_dataweek$user,
                                    "weekday" =  all_dataweek$weekdat,"domain" = all_data1$domain) %>%
                                    dplyr::summarise(average = mean(count))



write.csv(all_data2,"data\\avgweekdays.csv")
