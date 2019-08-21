#' Convert Australian state names and abbreviations into a consistent format
#'
#' @param x a (character) vector containing Australian state names or abbreviations or
#' a (numeric) vector containing state codes (see [the ABS website](https://www.abs.gov.au/ausstats/abs@.nsf/Lookup/by%20Subject/1270.0.55.001~July%202016~Main%20Features~Australia%20(AUS)%20and%20State%20%7C%20Territory%20(S%7CT)~10017)).
#' Note that strayr always returns a character vector.
#'
#' @param to what form should the state names be converted to? Options are
#' "state_name", "state_abbr" (the default), "iso", "postal", and "code".
#'
#' @param fuzzy_match logical; either TRUE (the default) which indicates that
#' approximate/fuzzy string matching should be used, or FALSE which indicates that
#' only exact matches should be used.
#'
#' @param max_dist numeric, sets the maximum acceptable distance between your
#' string and the matched string. Default is 0.4. Only relevant when fuzzy_match is TRUE.
#'
#' @param method the method used for approximate/fuzzy string matching. Default
#' is "jw", the Jaro-Winker distance; see `??stringdist-metrics` for more options.
#'
#' @return a character vector
#'
#' @examples
#'
#' x <- c("western Straya", "w. A ", "new soth wailes", "SA", "tazz")
#'
#' # Convert the above to state abbreviations
#' strayr(x)
#'
#' # Convert the elements of `x` to state names
#'
#' strayr(x, to = "state_name")
#'
#' # Disable fuzzy matching; you'll get NAs unless exact matches can be found
#'
#' strayr(x, fuzzy_match = FALSE)
#'
#' # You can use strayr in a dplyr mutate call
#'
#' x_df <- data.frame(state = x, stringsAsFactors = FALSE)
#'
#' \dontrun{x_df %>% mutate(state_abbr = strayr(state))}
#'
#' @importFrom stringdist amatch
#' @export

strayr <- function(x, to = "state_abbr", fuzzy_match = TRUE, max_dist = 0.4, method = "jw"){


  if(!is.logical(fuzzy_match)){
    stop("`fuzzy_match` argument must be either `TRUE` or `FALSE`")
  }

  if(!is.numeric(x)) {
    x <- state_string_tidy(x)
  }

  if(fuzzy_match){
    matched_abbr <- names(state_dict[stringdist::amatch(x, tolower(state_dict),
                                               method = method,
                                               maxDist = max_dist)])
  } else {
    matched_abbr <- names(state_dict[match(x, tolower(state_dict))])
  }

  ret <- state_table[[to]][match(matched_abbr, state_table$state_abbr)]

  ret <- as.character(ret)

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
