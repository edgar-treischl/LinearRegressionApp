# #
# # This is the user-interface definition of a Shiny web application. You can
# # run the application by clicking 'Run App' above.
# #
# # Find out more about building applications with Shiny here:
# #
# #    http://shiny.rstudio.com/
# #
#
# library(shiny)
# library(GGally)
# library(ggplot2)
# library(rmarkdown)
# library(waiter)
# library(shinyWidgets)
#
# #library(shinyjs)
#
# # Define UI for application that draws a histogram
# shinyUI(fixedPage(
#   theme = bslib::bs_theme(bootswatch = "simplex", primary = "#2a9d8f"), #for theming
#   use_waiter(),
#   waiter_show_on_load(html = spin_flower()),
#   #useShinyjs(),  # Include shinyjs
#   # Sidebar with a slider input for number of bins
#   titlePanel("Linear Regression in a Nutshell"),
#   sidebarLayout(
#     sidebarPanel(width = 3,
#                 h4("Pick data and variables:"),
#                 selectInput("dataset", label = "",
#                             choices = c("Cars", "ChickenWeight", "Iris", "Catholic", "Swiss")),
#                 uiOutput('iv'),
#                 uiOutput('dv'),
#                 downloadButton("report", "Download Summary"),
#                 br(),
#                 br(),
#                 actionButton("code", "Source Code", onclick ="window.open('https://github.com/edgar-treischl/OLSinaNutshell.git', '_blank')", icon = icon("github"))
#                 ),
#
#
#     # Show a plot of the generated distribution
#     mainPanel(width = 9,
#       tabsetPanel(type = "tabs",
#                   tabPanel("Start", icon = icon("play"),
#                            includeMarkdown("R/start.md"),
#                            includeMarkdown("R/txt/summary1.md"),
#                            verbatimTextOutput("summary"),
#                            includeMarkdown("R/txt/summary2.md"),
#                            plotOutput("distPlot_dv"),
#                            h6("And the independent variable:"),
#                            plotOutput("distPlot_iv")
#
#                   ),
#                   tabPanel("Linearity ", icon = icon("ruler"),
#                            includeMarkdown("R/txt/linear1.md"),
#                            plotOutput("scatter"),
#                            h5("What would you say? Is there a linear association between X and Y?"),
#                            actionButton(
#                              inputId = "linearinfo",
#                              label = "Not linear?",
#                              icon = icon("chart-line"))
#                            ),
#                   tabPanel("Regression", icon = icon("rocket"),
#                            includeMarkdown("R/txt/regression.md"),
#                            verbatimTextOutput("model"),
#                            h5("Can you interpret the results? Can you calculate
#                               the predicted value if X increases by 1 unit?"),
#                            withMathJax(helpText("Hint: $$y_i=\\beta_1+\\beta_2*x_i$$")),
#                            actionButton(
#                              inputId = "reginfo",
#                              icon = icon("lightbulb"),
#                              label = "More help?"),
#                            includeMarkdown("R/txt/plot.md"),
#                            plotOutput("plot"),
#                            actionButton(
#                              inputId = "coefinfo",
#                              icon = icon("lightbulb"),
#                              label = "A hint?")
#                            ),
#                   tabPanel("Fit", icon = icon("hand-point-right"),
#                            includeMarkdown("R/txt/datafit.md"),
#                            plotOutput("error"),
#                            includeMarkdown("R/txt/datafit2.md"),
#                            ),
#                   tabPanel("Variance", icon = icon("times"),
#                            includeMarkdown("R/txt/variance.md"),
#                            plotOutput("total"),
#                            includeMarkdown("R/txt/variance2.md"),
#                            includeMarkdown("R/txt/variance3.md"),
#                            plotOutput("regression")
#                            ),
#                   tabPanel("R squared", icon = icon("hand-peace"),
#                            includeMarkdown("R/txt/variance4.md"),
#                            plotOutput("variance"),
#                            includeMarkdown("R/txt/variance5.md")
#                            )
#
#       )
#     )
#   )
# ))
