#' @export

strayr <- function(x, to = "state_abbr"){

  dat <- gsub("[^[:alpha:] ]", "", x)

  dat <- tolower(dat)

  matched_abbr <- names(state_dict[match(dat, tolower(state_dict))])

  return <- state_table[[to]][match(matched_abbr, state_table$state_abbr)]

  return
}

