#' @importFrom dplyr pull "%>%"
#' @export

strayr <- function(x, to = "state_abbr"){

  x <- gsub("[^[:alpha:]]", "", x)

  x <- tolower(x)

  matches_x <- names(state_dict[tolower(state_dict) %in% x])

  state_table[,"state_abbr"] %in% matches_x
  which(state_table[,"state_abbr"] %in% matches_x)

  return <- subset(state_table,
                   state_abbr %in% matches_x)

  # rewrite without dplyr dependency
  return <- return %>% dplyr::pull(to)

  return
}
