source("R/gaussian-packages.R")

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
  "pd(1year)=1.02%: x<=-2.326348",
  "pd(2years)=3.07%: x<=-1.880794",
  "pd(3years)=6.29%: x<=-1.554774",
  "pd(4years)=10.08%: x<=-1.281552",
  "pd(5years)=14.8%: x<=-1.036433"
)
