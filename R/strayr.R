#' @export

strayr <- function(string, to = "state_abbr", fuzzy_match = TRUE, max_dist = 0.4, method = "jw"){
  if(!is.logical(fuzzy_match)){
    stop("`fuzzy_match` argument must be either `TRUE` or `FALSE`")
  }

  if(!is.character(string)){
    stop("`string` argument to `strayr()` must be a character vector.")
  }

  dat <- state_string_tidy(string)

  if(fuzzy_match){
    matched_abbr <- names(state_dict[stringdist::amatch(dat, tolower(state_dict),
                                               method = method,
                                               maxDist = max_dist)])
  } else {
    matched_abbr <- names(state_dict[match(dat, tolower(state_dict))])
  }

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
