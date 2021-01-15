flat_date <- function(date) {
  paste0(lubridate::year(date) , "-", lubridate::month(date), "-01") %>% as.Date()
}

bin_dates15<- function(date) {
  ifelse(
    lubridate::day(date) <= 15,
    paste0(
      lubridate::year(date), "-",
      lubridate::month(date), "-1"
    ),
    paste0(
      lubridate::year(date), "-",
      lubridate::month(date), "-15")
    ) %>%
    as.Date()
}

bin_dates7  <- function(date) {
  paste0(
    lubridate::year(date) , "-", lubridate::month(date), "-",
    ifelse(
      lubridate::day(date) <= 15,
      ifelse(lubridate::day(date) <= 7, "1", "7"),
      ifelse(lubridate::day(date) <= 21, "16", "23")
    )
  ) %>%
    as.Date()
}



read.csv("allCount.csv", stringsAsFactors = F) %>%
  as_tibble() %>%
  mutate(yearmonth = paste0(lubridate::year(date), "-", lubridate::month(date), "-01")) %>%
  group_by(yearmonth, user, domain) %>%
  summarise(count = sum(count)) %>%
  mutate(date = as.Date(yearmonth)) %>%
  filter(domain == "stackoverflow.com") %>%
  ggplot(aes(x = date, y = count, color = user)) +
  geom_smooth()


read.csv("allCount.csv", stringsAsFactors = F) %>%
  as_tibble() %>%
  mutate(date = bin_dates7(date)) %>%
  group_by(date, user, domain) %>%
  summarise(count = sum(count)) %>%
  filter(domain == "pw.edu.pl") %>%
  ggplot(aes(x = date, y = count, color = user)) +
  geom_line()

library(scales)

read.csv("data/allCount.csv", stringsAsFactors = F) %>%
  as_tibble() %>%
  mutate(date = bin_dates7(date)) %>%
  group_by(date, user, domain) %>%
  summarise(count = mean(count)) %>%
  filter(domain == "facebook.com") %>%
  ggplot(aes(x = date, y = count, color = user)) +
  geom_line() +
  theme_bw() +
  scale_x_date(limits = as.Date(c("2020-01-01", "2021-02-01"))) +
  scale_y_continuous(limits = c(0, NA))


tibble(
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
