# This script uses various data sources to compile the unemployment
# benefit base payment rate for a single adult

library(tidyverse)
library(tabulizer)
library(lubridate)
library(padr)

remove_linebreak <- function(string) gsub("\n", "", string)

pounds_to_dollars <- function(pounds, shillings, pence) {
  pounds * 2 +
    (shillings / 10) +
    (5/6) * pence/100
}

# Single UB to 1982 from PDF ----
# This data is loaded from a publication called: `Occasional Paper No. 12: A
# compendium of legislative changes in social security 1908-1982` by FaCSIA 2006
# Included in the pacakge in `inst/source`

op12 <- system.file("sources", "dss_op12.pdf",
                         package = "strayr")


pre_decimal <- extract_tables(op12, 133)[[1]][10:14,1:2]
pre_decimal <- as_tibble(pre_decimal) %>%
  rename(date = 1,
         rate = 2)

# Convert pounds, shillings, and pence to dollars
# 1 pound = $2; 10s = $1; 1s = 10c
pre_decimal <- pre_decimal %>%
  separate(rate, into = c("pounds", "shillings", "pence")) %>%
  mutate_at(vars(pounds, shillings, pence),
            as.numeric) %>%
  mutate(rate = pounds_to_dollars(pounds, shillings, pence)) %>%
  select(date, rate)

post_decimal <- extract_tables(op12, 133)[[1]][16:22,1:2] %>%
  as_tibble() %>%
  rename(date = 1,
         rate = 2)

post_decimal <- extract_tables(op12, 134)[[1]][6:17,c(1, 3)] %>%
  as_tibble() %>%
  rename(date = 1, rate = 2) %>%
  bind_rows(post_decimal)

post_decimal <- extract_tables(op12, 134)[[1]][25:33,c(1, 3)] %>%
  as_tibble() %>%
  rename(date = 1, rate = 2) %>%
  bind_rows(post_decimal)

post_decimal <- post_decimal %>%
  mutate(rate = parse_number(rate))

ub_op12 <- bind_rows(pre_decimal, post_decimal)

ub_op12 <- ub_op12 %>%
  separate(date, into = c("day", "month", "year"), fill = "left") %>%
  mutate(day = if_else(is.na(day), "1", day),
         year = paste0("19", year),
         date = paste(day, month, year, sep = "-"),
         date = lubridate::dmy(date)) %>%
  select(date, rate) %>%
  arrange(date)

ub_op12 <- ub_op12 %>%
  padr::pad("day") %>%
  fill(rate, .direction = "down")

# Single UB from 1969 scraped from web ----


