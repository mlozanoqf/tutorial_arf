source("R/merton-packages.R")
source("R/format-helpers.R")

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

start_V0 <- E0 + D * exp(-rf * TT)
start_sv <- se * E0 / start_V0

V0_sv <- optim(
  par = c(V0 = start_V0, sv = start_sv),
  fn = min.footnote10,
  method = "L-BFGS-B",
  lower = c(V0 = 1e-6, sv = 1e-6),
  control = list(
    parscale = c(V0 = 10, sv = 0.2),
    ndeps = c(V0 = 1e-6, sv = 1e-8)
  )
)
V0 <- unname(V0_sv$par["V0"])
sv <- unname(V0_sv$par["sv"])

PD <- function(V0, sv) {
  # Merton risk-neutral/implied probability: P_Q(V_T < D) = N(-d2).
  pnorm(-(((log(V0 / D) + (rf + sv^2 / 2) * TT) /
    (sv * sqrt(TT))) - sv * sqrt(TT)))
}

pd_merton <- PD(V0, sv)
