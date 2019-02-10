# Create lookup tables of state names and abbreviations
library(tidyverse)

state_table <- tibble::tribble(
                                    ~state_name, ~state_abbr,     ~iso, ~postal,
                              "New South Wales",       "NSW", "AU-NSW",   "NSW",
                                   "Queensland",       "Qld", "AU-QLD",   "QLD",
                              "South Australia",        "SA",  "AU-SA",    "SA",
                                     "Tasmania",       "Tas", "AU-TAS",   "TAS",
                                     "Victoria",       "Vic", "AU-VIC",   "VIC",
                            "Western Australia",        "WA",  "AU-WA",    "WA",
                 "Australian Capital Territory",       "ACT", "AU-ACT",   "ACT",
                           "Northern Territory",        "NT",  "AU-NT",    "NT"
                 )


state_dict_df <- state_table %>%
  gather(key = "type", value = "alias", -state_abbr)

state_dict_df <- state_table %>%
  select(state_abbr) %>%
  mutate(alias = state_abbr,
         type = "state_abbr") %>%
  bind_rows(state_dict_df)

state_dict <- state_dict_df$alias
names(state_dict) <- state_dict_df$state_abbr

state_dict <- c(state_dict,
     "SA" = "south oz",
     "WA" = "west oz",
     "Tas" = "tassie",
     "Tas" = "tazzie",
     "Tas" = "tazzy")

state_dict <- state_dict[!duplicated(state_dict)]

usethis::use_data(state_dict, state_table, overwrite = TRUE)

