# utils.R

get_dataset <- function(selection, catholic_data) {
  switch(selection,
         "Cars" = mtcars,
         "ChickenWeight" = ChickWeight,
         "Iris" = iris,
         "Catholic" = catholic_data,
         "Swiss" = swiss)
}

prepare_raw_data <- function(df, iv, dv) {
  y <- df[[dv]]
  x <- df[[iv]]
  mod <- lm(y ~ x)
  ypred <- predict(mod)
  data.frame(y = y, x = x, ypred = ypred)
}

calculate_ss_data <- function(data) {
  Y <- mean(data$y)
  ypred <- data$ypred
  SST <- sum((data$y - Y)^2)
  SSE <- sum((data$y - ypred)^2)
  SSA <- SST - SSE

  data.frame(
    SS = factor(c("Total", "Regression", "Error")),
    value = round(c(SST, SSA, SSE) / SST * 100, 2)
  )
}

make_formula <- function(dv, iv) {
  as.formula(paste(dv, "~", iv))
}
