source("R/logistic-packages.R")

dat <- readRDS("loan_data_ARF.rds")
colnames(dat) <- c(
  "loan_st",
  "l_amnt",
  "int",
  "grade",
  "emp_len",
  "home",
  "income",
  "age",
  "sex",
  "region"
)

high_income <- dat[dat$income > 1000000, ]
if (nrow(high_income) > 0) {
  high_income_index <- data.frame(value = as.integer(rownames(high_income)))
  dat <- dat[-high_income_index$value, ]
}
