# Copied from the remakeGenerator package under GPL>=3:
# \url{https://github.com/wlandau/remakeGenerator}
wildcards <- function(df, rules = NULL, expand = TRUE,
  include = NULL, exclude = NULL) {
  if (!length(rules))
    return(nofactors(df))
  check_rules(rules)
  stopifnot(is.list(rules))
  stopifnot(is.logical(expand))
  expand <- rep(expand, length.out = length(rules))
  for (index in seq_len(length(rules)))
    df <- wildcard(
      df,
      wildcard = names(rules)[index], values = rules[[index]],
      expand = expand[index],
      include = include,
      exclude = exclude)
  df
}

check_df <- function(df){
  dm <- dim(df)
  good <- length(dm) == 2 & all(dm > 0)
  if (!good){
    stop("df must have two dimensions and must be nonempty.")
  }
}

check_rules <- function(rules){
  wildcards <- names(rules)
  values <- unlist(rules) %>%
    unique %>%
    unname
  if (length(intersect(wildcards, values)))
    warning(
      "In `rules`, some wildcards are also replacement values.\n",
      "The returned data frame may be different than you expect,\n",
      "and it may depend on the order of the wildcards in `rules`.")
}

factor2character <- function(x) {
  if (is.factor(x))
    x <- as.character(x)
  x
}

get_matches <- function(df, wildcard, include) {
  lapply(df[, include, drop = FALSE], matches_col, wildcard = wildcard) %>%
    Reduce(f = "|")
}

gsub_multiple <- function(pattern, replacement, x) {
  i <- grepl(pattern, x)
  if (!sum(i))
    return(x)
  replacement <- rep(replacement, length.out = sum(i))
  x[i] <- Vectorize(function(pattern, replacement, x) {
    gsub(pattern = pattern, replacement = replacement,
      x = x, fixed = TRUE)
  },
  c("x", "replacement"))(pattern, replacement, x[i])
  x
}

matches_col <- function(x, wildcard) {
  grepl(wildcard, x, fixed = TRUE)
}

process_include <- function(df, include, exclude){
  i <- !is.null(include)
  e <- !is.null(exclude)
  columns <- colnames(df)
  if (i & e){
    stop("You may specify include or exclude, but not both.")
  } else if (!i & !e){
    colnames(df)
  } else if (e){
    setdiff(columns, exclude)
  } else {
    intersect(columns, include)
  }
}

unique_random_string <- function(exclude = NULL, n = 30) {
  while ((out <- stri_rand_strings(1, n)) %in% exclude) # nolint
    next
  out
}
