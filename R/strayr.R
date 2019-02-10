#' @export

strayr <- function(x, to = "state_abbr"){

  dat <- state_string_tidy(x)

  matched_abbr <- names(state_dict[match(dat, tolower(state_dict))])

  ret <- state_table[[to]][match(matched_abbr, state_table$state_abbr)]

  ret
}

#' @importFrom stringdist amatch
#' @export
fuzzy_strayr <- function(x, to = "state_abbr", max_dist = 0.4, method = "jw"){

  dat <- state_string_tidy(x)

  matched_abbr <- names(state_dict[stringdist::amatch(dat, tolower(state_dict), method = method, maxDist = max_dist)])

  ret <- state_table[[to]][match(matched_abbr, state_table$state_abbr)]

  ret

}


state_string_tidy <- function(string){

  strings_to_remove <- paste(c("[^[:alpha:] ]",
                         "the",
                         "great",
                         "state",
                         "of"),
                         collapse = "|")

  string <- tolower(string)

  string <- gsub(strings_to_remove, "", string)

  string <- trimws(string, "both")

  string
}
