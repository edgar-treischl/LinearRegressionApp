# Helper function for histogram
hist_plot <- function(data, var_name) {
  hist(data[[var_name]], col = 'darkgray', border = 'white',
       main = var_name, xlab = var_name)
}

# Scatter plot
scatter_plot <- function(data, xlab, ylab) {
  ggplot(data, aes(x = x, y = y)) +
    geom_point() +
    geom_smooth() +
    theme_minimal(base_size = 16) +
    xlab(xlab) + ylab(ylab) +
    ggtitle("Scatter plot")
}

# Total variance plot
total_variance_plot <- function(data, xlab, ylab) {
  ggplot(data, aes(x = x, y = y)) +
    geom_point(size = 3) +
    geom_segment(aes(xend = x, yend = mean(y)), colour = "#0571b0") +
    geom_hline(yintercept = mean(data$y)) +
    theme_minimal(base_size = 16) +
    xlab(xlab) + ylab(ylab) +
    ggtitle("Total Variance")
}

# Regression (explained variance)
explained_variance_plot <- function(data, xlab, ylab) {
  ggplot(data, aes(x = x, y = y)) +
    geom_point(alpha = 0) +
    geom_smooth(method = "lm", se = FALSE, colour = "black") +
    geom_segment(aes(x = x, y = ypred, xend = x, yend = mean(y)),
                 colour = "#008837") +
    geom_hline(yintercept = mean(data$y)) +
    theme_minimal(base_size = 16) +
    xlab(xlab) + ylab(ylab) +
    ggtitle("Variance explained by X")
}

# Error plot
error_plot <- function(data, xlab, ylab) {
  ggplot(data, aes(x = x, y = y)) +
    geom_point(size = 3) +
    geom_smooth(method = "lm", se = FALSE, colour = "black") +
    geom_segment(aes(xend = x, yend = ypred), colour = "#ca0020") +
    theme_minimal(base_size = 16) +
    xlab(xlab) + ylab(ylab) +
    ggtitle("Total error")
}

# Variance bar plot
variance_bar_plot <- function(ssdata) {
  ggplot(ssdata, aes(y = value, x = SS, fill = SS)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = c("#0571b0", "#008837", "#ca0020")) +
    theme_minimal(base_size = 16) +
    ylab("% of explained variance") + xlab("") +
    ggtitle("Variance components") +
    theme(legend.position = "bottom")
}
