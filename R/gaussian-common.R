source("R/gaussian-packages.R")
source("R/format-helpers.R")

x <- seq(-4, 4, 0.001)
D <- dnorm(x)
P <- pnorm(x)

credit_horizons <- 1:5
pd_cum <- c(0.01, 0.03, 0.06, 0.1, 0.15)
pd_incremental <- c(pd_cum[1], diff(pd_cum))
default_threshold <- qnorm(pd_cum)
threshold_check <- pnorm(default_threshold)
hull_example_247_rho <- 0.2

# Legacy names kept while the chapter is being refactored.
pd <- pd_cum
x.y <- default_threshold

n.year <- c("year 1", "year 2", "year 3", "year 4", "year 5")
n.pd <- c("pd.y1", "pd.y2", "pd.y3", "pd.y4", "pd.y5")

L <- c(-4, 4)
colors2 <- c("blue", "red", "purple", "pink", "green")
legend2 <- c(
  paste0("pd(1year)=", fmt_pct(pd_cum[1], 2), ": x<=", fmt_num(default_threshold[1], 6)),
  paste0("pd(2years)=", fmt_pct(pd_cum[2], 2), ": x<=", fmt_num(default_threshold[2], 6)),
  paste0("pd(3years)=", fmt_pct(pd_cum[3], 2), ": x<=", fmt_num(default_threshold[3], 6)),
  paste0("pd(4years)=", fmt_pct(pd_cum[4], 2), ": x<=", fmt_num(default_threshold[4], 6)),
  paste0("pd(5years)=", fmt_pct(pd_cum[5], 1), ": x<=", fmt_num(default_threshold[5], 6))
)

make_correlation_matrix <- function(n_firms, rho) {
  sigma <- matrix(rho, nrow = n_firms, ncol = n_firms)
  diag(sigma) <- 1
  sigma
}

simulate_latent_credit <- function(n_sims, n_firms, rho, seed = 130575) {
  set.seed(seed)
  MASS::mvrnorm(
    n = n_sims,
    mu = rep(0, n_firms),
    Sigma = make_correlation_matrix(n_firms, rho)
  )
}

simulate_t_copula_credit <- function(n_sims, n_firms, rho, df, seed = 130575) {
  set.seed(seed)
  gaussian_latent <- MASS::mvrnorm(
    n = n_sims,
    mu = rep(0, n_firms),
    Sigma = make_correlation_matrix(n_firms, rho)
  )
  scale_shock <- sqrt(rchisq(n_sims, df = df) / df)
  gaussian_latent / scale_shock
}

make_default_matrix <- function(latent_credit, threshold) {
  latent_credit <= threshold
}

summarize_default_counts <- function(default_matrix) {
  default_count <- rowSums(default_matrix)
  count_table <- as.data.frame(table(default_count))
  names(count_table) <- c("defaults", "frequency")
  count_table$defaults <- as.integer(as.character(count_table$defaults))
  count_table$probability <- count_table$frequency / nrow(default_matrix)
  count_table
}

summarize_default_events <- function(default_matrix) {
  default_count <- rowSums(default_matrix)
  n_firms <- ncol(default_matrix)
  c(
    expected_defaults = mean(default_count),
    no_default = mean(default_count == 0),
    at_least_one = mean(default_count >= 1),
    three_or_more = mean(default_count >= 3),
    five_or_more = mean(default_count >= 5),
    all_default = mean(default_count == n_firms)
  )
}

portfolio_losses <- function(default_matrix, ead, recovery) {
  lgd_amount <- ead * (1 - recovery)
  as.numeric(default_matrix %*% lgd_amount)
}

loss_risk_summary <- function(losses) {
  var_95 <- unname(quantile(losses, 0.95, type = 1))
  var_99 <- unname(quantile(losses, 0.99, type = 1))
  var_999 <- unname(quantile(losses, 0.999, type = 1))
  c(
    expected_loss = mean(losses),
    median_loss = unname(quantile(losses, 0.50, type = 1)),
    var_95 = var_95,
    var_99 = var_99,
    var_999 = var_999,
    es_99 = mean(losses[losses >= var_99]),
    es_999 = mean(losses[losses >= var_999]),
    economic_capital_999 = var_999 - mean(losses)
  )
}
