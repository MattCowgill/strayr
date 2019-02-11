#' Convert Australian state names and abbreviations into a consistent format
#'
#' @param string a character vector containing Australian state names or abbreviations
#'
#' @param to what form should the state names be converted to? Options are
#' "state_name", "state_abbr" (the default), "iso", and "postal".
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
