source("R/gaussian-packages.R")
source("R/format-helpers.R")

x <- seq(-4, 4, 0.001)
D <- dnorm(x)
P <- pnorm(x)

pd <- c(0.01, 0.03, 0.06, 0.1, 0.15)
x.y <- qnorm(pd)

n.year <- c("year 1", "year 2", "year 3", "year 4", "year 5")
n.pd <- c("pd.y1", "pd.y2", "pd.y3", "pd.y4", "pd.y5")

L <- c(-4, 4)
colors2 <- c("blue", "red", "purple", "pink", "green")
legend2 <- c(
  paste0("pd(1year)=", fmt_pct(pd[1], 2), ": x<=", fmt_num(x.y[1], 6)),
  paste0("pd(2years)=", fmt_pct(pd[2], 2), ": x<=", fmt_num(x.y[2], 6)),
  paste0("pd(3years)=", fmt_pct(pd[3], 2), ": x<=", fmt_num(x.y[3], 6)),
  paste0("pd(4years)=", fmt_pct(pd[4], 2), ": x<=", fmt_num(x.y[4], 6)),
  paste0("pd(5years)=", fmt_pct(pd[5], 1), ": x<=", fmt_num(x.y[5], 6))
)
