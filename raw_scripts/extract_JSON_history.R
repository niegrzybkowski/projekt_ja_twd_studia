extract_timestamp_date <- function(val) {
  as.POSIXct(val/1000000, origin = "1970-01-01")
}
extract_domain <- function(val) {
  stringr::str_match(val, "(?<=http[s]?:\\/\\/)(\\w+[.])*\\w+")[,1]
}
#RJSONIO::fromJSON("raw_data/BrowserHistory.json")[["Browser History"]] -> raw_data

#raw_data %>%
#  purrr::transpose() ->
#  transposed

tidyjson::read_json("raw_data/BrowserHistory.json") %>% tidyjson::gather_object() %>% tidyjson::gather_array() -> japierdole

japierdole %>% tidyjson::spread_all() -> dsaadsaf

dsaadsaf %>% select(time_usec, url, title) -> dafr

dafr %>% as_tibble() %>% mutate_at("time_usec", extract_timestamp_date) %>% mutate(across("url", extract_domain)) -> ooo

ooo %>%
  filter(url %in% c("stackoverflow.com", "pl.wikipedia.org")) %>%
  group_by(url, time_usec) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = time_usec, color = url, y = count)) +
  geom_line()
