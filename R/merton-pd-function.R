source("R/merton-common.R")

pd <- function(E0, se, rf, TT, D) {
  eq24.3 <- function(V0, sv) {
    V0 * pnorm((log(V0 / D) + (rf + sv^2 / 2) * TT) / (sv * sqrt(TT))) -
      D * exp(-rf * TT) * pnorm(
        ((log(V0 / D) + (rf + sv^2 / 2) * TT) / (sv * sqrt(TT))) -
          sv * sqrt(TT)
      ) -
      E0
  }

  eq24.4 <- function(V0, sv) {
    pnorm((log(V0 / D) + (rf + sv^2 / 2) * TT) / (sv * sqrt(TT))) *
      sv * V0 -
      se * E0
  }

  min.footnote10 <- function(x) {
    (eq24.3(x[1], x[2]))^2 + (eq24.4(x[1], x[2]))^2
  }

  V0_sv <- optim(c(1, 1), min.footnote10)
  V0 <- V0_sv$par[1]
  sv <- V0_sv$par[2]

  pnorm(-(((log(V0 / D) + (rf + sv^2 / 2) * TT) /
    (sv * sqrt(TT))) - sv * sqrt(TT)))
}

pd1 <- pd(E0, se, rf, TT, D)
