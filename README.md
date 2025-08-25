
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LinearRegressionApp

<!-- badges: start -->

<!-- badges: end -->

An interactive Shiny app that teaches and visualizes the fundamentals of
**linear regression**.

## 🔍 Purpose

This app is designed as a **teaching tool** for students, instructors,
and data beginners to explore:

- The linear relationship between two variables.
- How regression works behind the scenes.
- Key concepts like variance decomposition and $R^2$.
- Interpretation of regression coefficients.

Whether you’re new to statistics or want to visualize the mechanics of
OLS, this app provides an accessible and intuitive learning environment.

## 🧠 Learning Goals

- Understand regression coefficients: intercept & slope  
- Visualize and decompose variance (SST = SSR + SSE)  
- Learn how model fit is assessed via $R^2$  
- Practice interpretation with hints and questions

## 🚀 Features

- 📁 Choose a data set from: `mtcars`, `iris`, `swiss`, `ChickWeight`,
  `catholic`
- 🧮 Interactive selection of dependent and independent variables
- 📊 Visualizations for:
  - Distributions
  - Scatterplots with regression lines
  - Total variance vs. explained error
  - Residual errors
  - Variance decomposition
- 🧠 Interpretation hints and guided questions
- 📥 Downloadable report (`.docx`) summarizing your selected model

## 🌐 Visit the App

You can view the app on my [my
website](http://edgar-treischl.de/projects) or run via:

``` r
library(shiny)
runGitHub("LinearRegressionApp", "edgar-treischl", ref="main")
```
