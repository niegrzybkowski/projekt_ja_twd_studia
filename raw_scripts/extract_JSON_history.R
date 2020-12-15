extract_timestamp_date <- function(val) {
  as.Date(as.POSIXct(val/1000000, origin = "1970-01-01"))
}
extract_domain <- function(val) {
  stringr::str_match(val, "(?<=http[s]?:\\/\\/)(\\w+[.])*\\w+")[1,1]
}

RJSONIO::fromJSON("raw_data/BrowserHistory.json")[["Browser History"]] -> raw_data

raw_data %>%
  purrr::transpose() ->
  transposed

