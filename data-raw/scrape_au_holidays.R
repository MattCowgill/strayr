library(ckanr)
library(tidyverse)
library(stringr)

ckanr_setup(url = "https://data.gov.au")

package <- package_show("australian-holidays-machine-readable-dataset")

raw.data <- package$resources %>%
  map(function(x) {
    x[["url"]]
  }) %>%
  unlist() %>%
  map_dfr(read_csv)

auholidays <- raw.data %>%
  transmute(
    Date = ymd(Date),
    Name = coalesce(`Holiday Name`, `Holiday_Name`),
    Jurisdiction = coalesce(`Applicable To`, Jurisdiction),
    Jurisdiction = str_to_upper(Jurisdiction)
  )


usethis::use_data(auholidays, overwrite = TRUE)
