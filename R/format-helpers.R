fmt_num <- function(x, digits = 4) {
  formatC(x, format = "f", digits = digits)
}

fmt_pct <- function(x, digits = 2) {
  paste0(fmt_num(100 * x, digits), "%")
}

fmt_bps <- function(x, digits = 1) {
  fmt_num(10000 * x, digits)
}

fmt_int <- function(x) {
  format(round(x), big.mark = ",", scientific = FALSE, trim = TRUE)
}

fmt_musd <- function(x, digits = 2) {
  paste0("$", fmt_num(x / 1e6, digits), "m")
}
