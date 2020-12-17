extract_timestamp_date <- function(val) {
  as.POSIXct(val/1000000, origin = "1970-01-01")
}
extract_domain2 <- function(val, name = "domain") {
  urltools::domain(val) %>%
    urltools::suffix_extract() %>%
    mutate(domsuf = if_else(is.na(domain), "", paste(domain, suffix, sep ="."))) %>%
    select(domsuf) %>%
    pull()

}

# tidyjson jest powolny i długo to ładuje, ale RJSONIO nie chciał współpracować
tidyjson::read_json("raw_data/BrowserHistory.json") %>%
  tidyjson::gather_object() %>%
  tidyjson::gather_array() %>%
  tidyjson::spread_all() %>%
  as_tibble() %>%
  select(time_usec, url, title, page_transition) ->
  raw_data

raw_data %>%
  mutate_at("time_usec", extract_timestamp_date) %>%
  mutate(across("url", extract_domain2)) %>%
  rename(domain = "url") -> ooo

ooo %>% group_by(domain) %>% summarise(count = n()) %>% View()

ooo %>%
  filter(domain %in% c("stackoverflow.com", "wikipedia.org", "github.com")) %>%
  mutate(hour = lubridate::hour(time_usec)) %>%
  group_by(domain, hour) %>%
  summarise(count = n()) %>% View
  ggplot(aes(x = hour, color = domain, y = count)) +
  geom_line()

ooo %>%
  filter(domain %in% c("google.com", "youtube.com", "facebook.com")) %>%
  mutate(hour = lubridate::hour(time_usec)) %>%
  group_by(domain, hour) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = hour, color = domain, y = count)) +
  geom_line()
