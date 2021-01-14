library(lubridate)
library(dplyr)

kacper <- read.csv("data/kacper.csv")
jan <- read.csv("data/jan.csv")
jakub <- read.csv("data/jakub.csv")

combined <- bind_rows(kacper %>% mutate("user" = "kacper"),
                      jakub %>% mutate("user" = "jakub"),
                      jan %>% mutate("user"= "jan")
                      ) %>% rename("date" = "time_usec")
combined <- combined %>% select(-X) %>% mutate("weekdat" = wday(combined$date), "hours" = hour(combined$date))

comb1 <- combined %>% group_by("user" = combined$user,
                             "weekday" =  combined$weekdat,
                               "hour" = combined$hours,
                               "domain" = combined$domain) %>%
                          dplyr::count(name = "average")

ndkac <- length(unique(as.Date(kacper$time_usec)))
ndjan <- length(unique(as.Date(jan$time_usec)))
ndjak <- length(unique(as.Date(jakub$time_usec)))

nkac <- nrow(comb1 %>% filter(user == "kacper"))
njan <- nrow(comb1 %>% filter(user == "jan"))
njak <- nrow(comb1 %>% filter(user == "jakub"))

comb1$average[1:njak] <- comb1$average[1:njak]/ndjak
comb1$average[(njak+1):(njak+njan)] <- comb1$average[(njak+1):(njak+njan)]/ndjan
comb1$average[(njak+njan+1):(njak+njan+nkac)] <- comb1$average[(njak+njan+1):(njak+njan+nkac)]/ndkac

#Tworzenie tablicy ze średnią liczbą wejść na dzień tygodnia

all_data <- read.csv("data/allCount.csv")
all_dataweek <- all_data %>% mutate("weekdat" = wday(all_data$date))

all_data2 <- all_dataweek %>% group_by("user" = all_dataweek$user,
                                       "weekday" =  all_dataweek$weekdat,"domain" = all_dataweek$domain) %>%
dplyr::summarise(average = mean(count))

write.csv(all_data2,"data\\avgweekdays.csv")

#Tworzenie tablicy ze średnią liczbą na dzień tygodnia i godziny
kacper <- read.csv("data/kacper.csv")
jan <- read.csv("data/jan.csv")
jakub <- read.csv("data/jakub.csv")

combined <- bind_rows(kacper %>% mutate("user" = "kacper"),
                      jakub %>% mutate("user" = "jakub"),
                      jan %>% mutate("user"= "jan")
) %>% rename("date" = "time_usec")
combined <- combined %>% select(-X) %>% mutate("weekdat" = wday(combined$date), "hours" = hour(combined$date))

comb1 <- combined %>% group_by("user" = combined$user,
                               "weekday" =  combined$weekdat,
                               "hour" = combined$hours,
                               "domain" = combined$domain) %>%
  dplyr::count(name = "average")

ndkac <- length(unique(as.Date(kacper$time_usec)))
ndjan <- length(unique(as.Date(jan$time_usec)))
ndjak <- length(unique(as.Date(jakub$time_usec)))

nkac <- nrow(comb1 %>% filter(user == "kacper"))
njan <- nrow(comb1 %>% filter(user == "jan"))
njak <- nrow(comb1 %>% filter(user == "jakub"))

comb1$average[1:njak] <- comb1$average[1:njak]/ndjak
comb1$average[(njak+1):(njak+njan)] <- comb1$average[(njak+1):(njak+njan)]/ndjan
comb1$average[(njak+njan+1):(njak+njan+nkac)] <- comb1$average[(njak+njan+1):(njak+njan+nkac)]/ndkac
domain <- rep(c( "stackoverflow.com",
   "wikipedia.org",
   "github.com",
   "pw.edu.pl",
   "youtube.com",
   "google.com",
   "facebook.com",
   "instagram.com"), times = 7*24*3)
hour <- rep(1:24, each = 8, times = 7*3)
weekday <- rep(1:7, each = 8*24, times = 3)
user <- rep(c("jakub", "jan", "kacper"), each = 7*8*24, times = 3)
comb2 <- data.frame(user,weekday, hour, domain)

combination <- left_join(comb2,comb1, by = c("user", "weekday", "hour", "domain"))
combination$average[is.na(combination$average)] <- 0
combination$weekday <- rep(c("niedz","pon", "wt", "sr", "czw", "pia", "sob"), each = 8*24, times = 3)
write.csv(combination,"data\\avgweekdaysandhours.csv")
