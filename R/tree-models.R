source("R/logistic-models.R")

suppressPackageStartupMessages({
  library(rpart)
  library(xgboost)
})

tree_formula <- loan_st ~ age + int + grade + log(l_amnt) + log(income) +
  emp_len + home + sex + region

xgb_formula <- ~ age + int + grade + log(l_amnt) + log(income) +
  emp_len + home + sex + region

actual_default_tree <- as.numeric(as.character(test$loan_st))

simple_tree <- rpart(
  tree_formula,
  data = train,
  method = "class",
  control = rpart.control(
    maxdepth = 4,
    minsplit = 100,
    cp = 0.001
  )
)

pred_tree_simple <- predict(simple_tree, newdata = test, type = "prob")[, "1"]

xgb_train_matrix <- model.matrix(xgb_formula, data = train)[, -1, drop = FALSE]
xgb_test_matrix <- model.matrix(xgb_formula, data = test)[, -1, drop = FALSE]
xgb_train_label <- as.numeric(as.character(train$loan_st))
xgb_test_label <- actual_default_tree

xgb_train <- xgb.DMatrix(data = xgb_train_matrix, label = xgb_train_label)
xgb_test <- xgb.DMatrix(data = xgb_test_matrix, label = xgb_test_label)

xgb_params <- list(
  objective = "binary:logistic",
  eval_metric = c("logloss", "auc"),
  max_depth = 3,
  eta = 0.05,
  subsample = 0.8,
  colsample_bytree = 0.8,
  min_child_weight = 20,
  lambda = 1
)

set.seed(567)
xgb_nrounds <- 160
xgb_model <- xgb.train(
  params = xgb_params,
  data = xgb_train,
  nrounds = xgb_nrounds,
  watchlist = list(train = xgb_train, test = xgb_test),
  verbose = 0
)

pred_xgb <- predict(xgb_model, newdata = xgb_test)

ROC_tree_simple <- roc(test$loan_st, pred_tree_simple, quiet = TRUE)
ROC_xgb <- roc(test$loan_st, pred_xgb, quiet = TRUE)

xgb_round_grid <- seq(20, xgb_nrounds, 20)
xgb_learning_curve <- do.call(
  rbind,
  lapply(xgb_round_grid, function(rounds) {
    set.seed(567)
    model_i <- xgb.train(
      params = xgb_params,
      data = xgb_train,
      nrounds = rounds,
      verbose = 0
    )

    pred_train_i <- predict(model_i, newdata = xgb_train)
    pred_test_i <- predict(model_i, newdata = xgb_test)

    data.frame(
      rounds = rounds,
      series = c("Train AUC", "Test AUC"),
      auc = c(
        as.numeric(auc(train$loan_st, pred_train_i, quiet = TRUE)),
        as.numeric(auc(test$loan_st, pred_test_i, quiet = TRUE))
      )
    )
  })
)

brier_score <- function(actual, predicted_probability) {
  mean((predicted_probability - actual)^2)
}

strategy_curve <- function(model_name, prob_of_default,
                           acceptance_grid = seq(0.50, 0.95, 0.05),
                           good_loan_payoff = 1,
                           bad_loan_cost = 5) {
  do.call(
    rbind,
    lapply(acceptance_grid, function(accept_rate) {
      cutoff <- unname(quantile(prob_of_default, accept_rate))
      accept <- prob_of_default <= cutoff
      accepted <- sum(accept)
      accepted_good <- sum(actual_default_tree[accept] == 0)
      accepted_defaults <- sum(actual_default_tree[accept] == 1)
      bad_rate <- accepted_defaults / accepted
      net_payoff <- accepted_good * good_loan_payoff -
        accepted_defaults * bad_loan_cost

      data.frame(
        model = model_name,
        accept_rate = accept_rate,
        cutoff = cutoff,
        accepted = accepted,
        accepted_good = accepted_good,
        accepted_defaults = accepted_defaults,
        bad_rate = bad_rate,
        net_payoff = net_payoff
      )
    })
  )
}

calibration_table <- function(model_name, prob_of_default, groups = 10) {
  data.frame(
    model = model_name,
    observed_default = actual_default_tree,
    predicted_pd = prob_of_default
  ) |>
    group_by(model) |>
    mutate(risk_decile = ntile(predicted_pd, groups)) |>
    group_by(model, risk_decile) |>
    summarize(
      applications = n(),
      average_predicted_pd = mean(predicted_pd),
      observed_default_rate = mean(observed_default),
      .groups = "drop"
    )
}

constant_default_rate <- rep(mean(actual_default_tree), length(actual_default_tree))

model_metrics <- data.frame(
  model = c("logi_full", "single_tree", "xgboost", "constant default rate"),
  auc = c(
    as.numeric(auc(ROC_logi_full)),
    as.numeric(auc(ROC_tree_simple)),
    as.numeric(auc(ROC_xgb)),
    NA_real_
  ),
  brier_score = c(
    brier_score(actual_default_tree, pred_logi_full),
    brier_score(actual_default_tree, pred_tree_simple),
    brier_score(actual_default_tree, pred_xgb),
    brier_score(actual_default_tree, constant_default_rate)
  )
)

baseline_brier <- model_metrics$brier_score[
  model_metrics$model == "constant default rate"
]
model_metrics$brier_skill <- 1 - model_metrics$brier_score / baseline_brier

strategy_comparison <- bind_rows(
  strategy_curve("logi_full", pred_logi_full),
  strategy_curve("single_tree", pred_tree_simple),
  strategy_curve("xgboost", pred_xgb)
)

calibration_comparison <- bind_rows(
  calibration_table("logi_full", pred_logi_full),
  calibration_table("xgboost", pred_xgb)
)

xgb_importance <- xgb.importance(
  feature_names = colnames(xgb_train_matrix),
  model = xgb_model
)

xgb_shap <- predict(xgb_model, newdata = xgb_test, predcontrib = TRUE)
xgb_shap_df <- as.data.frame(xgb_shap)
xgb_baseline_name <- intersect(c("BIAS", "(Intercept)"), names(xgb_shap_df))[1]
xgb_shap_no_bias <- xgb_shap_df[
  ,
  names(xgb_shap_df) != xgb_baseline_name,
  drop = FALSE
]

xgb_shap_importance <- data.frame(
  feature = names(xgb_shap_no_bias),
  mean_abs_shap = colMeans(abs(xgb_shap_no_bias))
) |>
  arrange(desc(mean_abs_shap))

john_doe_index <- 1
john_doe_prediction_summary <- data.frame(
  model = c("logi_full", "single_tree", "xgboost"),
  predicted_pd = c(
    pred_logi_full[john_doe_index],
    pred_tree_simple[john_doe_index],
    pred_xgb[john_doe_index]
  ),
  observed_default = actual_default_tree[john_doe_index]
)

john_xgb_contrib_raw <- as.numeric(xgb_shap_df[john_doe_index, ])
names(john_xgb_contrib_raw) <- names(xgb_shap_df)
john_xgb_baseline <- unname(john_xgb_contrib_raw[xgb_baseline_name])
john_xgb_feature_contrib <- john_xgb_contrib_raw[
  names(john_xgb_contrib_raw) != xgb_baseline_name
]
john_xgb_feature_sum <- sum(john_xgb_feature_contrib)
john_xgb_score <- sum(john_xgb_contrib_raw)
john_xgb_pd_from_score <- plogis(john_xgb_score)

john_xgb_score_summary <- data.frame(
  component = c(
    "baseline score",
    "sum of feature contributions",
    "total score F_i",
    "logistic transformation of F_i",
    "direct XGBoost prediction"
  ),
  value = c(
    john_xgb_baseline,
    john_xgb_feature_sum,
    john_xgb_score,
    john_xgb_pd_from_score,
    pred_xgb[john_doe_index]
  )
)

john_xgb_contribution_table <- data.frame(
  feature = names(john_xgb_feature_contrib),
  contribution = as.numeric(john_xgb_feature_contrib)
) |>
  arrange(desc(abs(contribution))) |>
  slice_head(n = 8)

partial_dependence <- function(variable, grid_values) {
  data.frame(
    variable = variable,
    value = grid_values,
    average_predicted_pd = sapply(grid_values, function(value) {
      new_data <- test
      new_data[[variable]] <- value
      new_matrix <- model.matrix(xgb_formula, data = new_data)[, -1, drop = FALSE]
      mean(predict(xgb_model, newdata = new_matrix))
    })
  )
}

partial_dependence_data <- bind_rows(
  partial_dependence("int", seq(
    quantile(test$int, 0.05),
    quantile(test$int, 0.95),
    length.out = 40
  )),
  partial_dependence("income", seq(
    quantile(test$income, 0.05),
    quantile(test$income, 0.95),
    length.out = 40
  )),
  partial_dependence("age", seq(
    quantile(test$age, 0.05),
    quantile(test$age, 0.95),
    length.out = 40
  ))
)
