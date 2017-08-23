#' @title Function \code{wildcard}
#' @description Main function of the package. Evaluate a wildcard
#' to fill in or expand a data frame.
#' Copied and modified from \code{remakeGenerator::evaluate()} package under GPL-3:
#' \url{https://github.com/wlandau/remakeGenerator}
#' @export
#' @param df data frame 
#' @param rules list with names a wildcards and elements as vectors of values
#' to substitute in place of the wildcards.
#' @param wildcard character scalar, a wildcard found in a data frame
#' @param values vector of values to substitute in place of a wildcard
#' @param expand logical, whether to expand the rows of the data frame to substitute
#' each value for each wildcard in turn. If \code{FALSE}, no new rows
#' will be added to \code{df} when the values are substituted in place
#' of wildcards. Can be a vector of length \code{length(rules)} if using the \code{rules}
#' argument.
#' @examples 
#' myths <- data.frame(
#'   myth = c('Bigfoot', 'UFO', 'Loch Ness Monster'), 
#'   claim = c('various', 'day', 'day'), 
#'  note = c('various', 'pictures', 'reported day'))
#' wildcard(myths, wildcard = 'day', values = c('today', 'yesterday'))
#' wildcard(myths, wildcard = 'day', values = c('today', 'yesterday'), expand = FALSE)
#' locations <- data.frame(
#'   myth = c('Bigfoot', 'UFO', 'Loch Ness Monster'),
#'   origin = 'where')
#' rules <- list(
#'   where = c('North America', 'various', 'Scotland'),
#'   UFO = c('spaceship', 'saucer'))
#' wildcard(locations, rules = rules, expand = c(FALSE, TRUE))
#' numbers <- data.frame(x = 4, y = 3, z = 4444, w = 4.434)
#' wildcard(numbers, wildcard = 4, values = 7)
#' # Wildcards should not also be replacement values.
#' # Otherwise, the output will be strange
#' # and will depend on the order of the wildcards.
#' \dontrun{
#' df <- data.frame(x = "a", y = "b")
#' rules <- list(a = letters[1:3], b = LETTERS[1:3])
#' wildcard(df, rules = rules)
#' }
wildcard <- function(df, rules = NULL, wildcard = NULL,
  values = NULL, expand = TRUE) {
  stopifnot(is.logical(expand))
  if (!is.null(rules))
    return(wildcards(df = df, rules = rules, expand = expand))
  df <- nofactors(df)
  if (is.null(wildcard) | is.null(values))
    return(df)
  matches <- get_matches(df, wildcard)
  if (!any(matches))
    return(df)
  major <- unique_random_string(colnames(df))
  minor <- unique_random_string(c(colnames(df), major))
  df[[major]] <- df[[minor]] <- seq_len(nrow(df))
  matching <- df[matches, ]
  if (expand)
    matching <- expandrows(matching, n = length(values))
  true_cols <- setdiff(colnames(matching), c(major, minor))
  matching[, true_cols] <- lapply(matching[, true_cols,
    drop = FALSE], gsub_multiple, pattern = wildcard,
    replacement = values) %>% as.data.frame(stringsAsFactors = FALSE)
  rownames(df) <- rownames(matching) <- NULL
  matching[[minor]] <- seq_len(nrow(matching))
  out <- rbind(matching, df[!matches, ])
  out <- out[order(out[[major]], out[[minor]]), ]
  out[[major]] <- out[[minor]] <- NULL
  rownames(out) <- NULL
  out
}

#' @title Function \code{expand}
#' @description Expand the rows of a data frame
#' Copied and modified from \code{remakeGenerator::expand()} under GPL>=3:
#' \url{https://github.com/wlandau/remakeGenerator}
#' @export
#' @seealso \code{\link{wildcard}}]
#' @param df data frame
#' @param n number of duplicates per row
#' @param type character scalar. If \code{'each'}, rows will be duplicated in place.
#' If \code{'times'}, the data frame itself will be repeated \code{n} times
#' @examples
#' df <- data.frame(
#'   ID = c('24601', 'Javert', 'Fantine'), 
#'   fate = c('fulfillment', 'confusion', 'misfortune'))
#' expandrows(df, n = 2, type = 'each')
#' expandrows(df, n = 2, type = 'times')
expandrows <- function(df, n = 2, type = c("each", "times")) {
  if (n < 2)
    return(df)
  nrows <- nrow(df)
  type <- match.arg(type)
  if (type == "each")
    i <- rep(seq_len(nrows), each = n)
  else
    i <- rep(seq_len(nrows), times = n)
  df <- df[i, ]
  rownames(df) <- NULL
  df
}

#' @title Function \code{nofactors}
#' @description Turn all the factors of a data frame into characters.
#' @export
#' @seealso \code{\link{wildcard}}
#' @param df data frame
#' @examples
#' class(iris$Species)
#' str(iris)
#' out <- nofactors(iris)
#' class(out$Species)
#' str(out)
nofactors <- function(df) {
  lapply(df, factor2character) %>%
    as.data.frame(stringsAsFactors = FALSE)
}
