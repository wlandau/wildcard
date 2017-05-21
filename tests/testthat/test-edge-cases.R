# library(testthat); devtools::load_all()

context("edge cases")

test_that("null cases", {
  df = data.frame(x = c(1, 2, "x", "x", 3), y = c("a", "b", "c", "x_y", "x_x"), stringsAsFactors = TRUE)
  out = wildcard(df, wildcard = "not_found", values = c(1111, 2222), expand = TRUE)
  expect_equal(nofactors(df), out)
  out = wildcard(df, rules = list(not_found = c(1111, 2222)), expand = FALSE)
  expect_equal(nofactors(df), out)
  out = wildcard(df, rules = list(), expand = FALSE)
  expect_equal(nofactors(df), out)
  out = wildcard(df, wildcard = NULL, values = NULL, expand = FALSE)
  expect_equal(nofactors(df), out)
  expect_error(wildcard(df, rules = c(a = 1), expand = FALSE))
})

test_that("expanded df works with blank col", {
  df = data.frame(x = c(1, 2, "x", 3), y = c("a", "b", "c", "x_x"), z = 1:4, stringsAsFactors = TRUE)
  out = wildcard(df, wildcard = "x", values = c(1111, 2222), expand = TRUE)
  truth = data.frame(
    x = as.character(c(1, 2, 1111, 2222, 3, 3)),
    y = as.character(c("a", "b", "c", "c", "1111_1111", "2222_2222")),
    z = c(1, 2, 3, 3, 4, 4),
    stringsAsFactors = FALSE)
  expect_equal(out, truth)
})
