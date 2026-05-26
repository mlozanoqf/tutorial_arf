source("R/merton-packages.R")

E0 <- 3
se <- 0.8
rf <- 0.05
TT <- 1
D <- 10

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

PD <- function(V0, sv) {
  # Merton risk-neutral/implied probability: P_Q(V_T < D) = N(-d2).
  pnorm(-(((log(V0 / D) + (rf + sv^2 / 2) * TT) /
    (sv * sqrt(TT))) - sv * sqrt(TT)))
}

pd_merton <- PD(V0, sv)
