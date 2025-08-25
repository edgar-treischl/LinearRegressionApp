# alerts.R

register_alerts <- function(input, session) {
  observeEvent(input$reginfo, {
    show_alert(
      text = tags$span(
        tags$h3("Some help:", icon("lightbulb"), style = "color: #008080;"),
        "The intercept shows the predicted value when x is 0. ",
        "The slope tells how y changes with a 1-unit increase in x."
      ),
      btn_labels = "Sure thing!", btn_colors = "#008080", html = TRUE
    )
  })

  observeEvent(input$coefinfo, {
    show_alert(
      text = tags$span(
        tags$h3("Interpretation?", icon("lightbulb"), style = "color: #008080;"),
        "Always consider the scale. Check the summary statistics."
      ),
      btn_labels = "Got it!", btn_colors = "#008080", html = TRUE
    )
  })

  observeEvent(input$linearinfo, {
    show_alert(
      text = tags$span(
        tags$h3("Not linear?", icon("skull-crossbones"), style = "color: #008080;"),
        "OLS assumes linearity. But not all data follows this pattern."
      ),
      btn_labels = "Got it!", btn_colors = "#008080", html = TRUE
    )
  })
}
