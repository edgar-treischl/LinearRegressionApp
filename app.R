library(shiny)
library(GGally)
library(ggplot2)
library(rmarkdown)
library(shinyWidgets)
library(thematic)

catholic <- read.csv(here::here("data", "catholic.csv"))

ui <- fixedPage(
  theme = bslib::bs_theme(bootswatch = "simplex", primary = "#2a9d8f"),
  titlePanel("Linear Regression App"),

  sidebarLayout(
    sidebarPanel(width = 3,
                 h4("Pick data and variables:"),
                 selectInput("dataset", label = "", choices = c("Cars", "ChickenWeight", "Iris", "Catholic", "Swiss")),
                 uiOutput('iv'),
                 uiOutput('dv'),
                 downloadButton("report", "Download Summary"),
                 br(), br(),
                 actionButton("code", "Source Code", icon = icon("github"),
                              onclick ="window.open('https://github.com/edgar-treischl/LinearRegressionApp', '_blank')")
    ),

    mainPanel(width = 9,
              tabsetPanel(type = "tabs",
                          tabPanel("Start", icon = icon("play"),
                                   includeMarkdown("markdown/start.md"),
                                   includeMarkdown("markdown/summary1.md"),
                                   verbatimTextOutput("summary"),
                                   includeMarkdown("markdown/summary2.md"),
                                   plotOutput("distPlot_dv"),
                                   h6("And the independent variable:"),
                                   plotOutput("distPlot_iv")
                          ),
                          tabPanel("Linearity", icon = icon("ruler"),
                                   includeMarkdown("markdown/linear1.md"),
                                   plotOutput("scatter"),
                                   h5("What would you say? Is there a linear association between X and Y?"),
                                   actionButton("linearinfo", "Not linear?", icon = icon("chart-line"))
                          ),
                          tabPanel("Regression", icon = icon("rocket"),
                                   includeMarkdown("markdown/regression.md"),
                                   verbatimTextOutput("model"),
                                   h5("Can you interpret the results? Can you calculate the predicted value if X increases by 1 unit?"),
                                   withMathJax(helpText("Hint: $$y_i=\\beta_1+\\beta_2*x_i$$")),
                                   actionButton("reginfo", "More help?", icon = icon("lightbulb")),
                                   includeMarkdown("markdown/plot.md"),
                                   plotOutput("plot"),
                                   actionButton("coefinfo", "A hint?", icon = icon("lightbulb"))
                          ),
                          tabPanel("Fit", icon = icon("hand-point-right"),
                                   includeMarkdown("markdown/datafit.md"),
                                   plotOutput("error"),
                                   includeMarkdown("markdown/datafit2.md")
                          ),
                          tabPanel("Variance", icon = icon("times"),
                                   includeMarkdown("markdown/variance.md"),
                                   plotOutput("total"),
                                   includeMarkdown("markdown/variance2.md"),
                                   includeMarkdown("markdown/variance3.md"),
                                   plotOutput("regression")
                          ),
                          tabPanel("R squared", icon = icon("hand-peace"),
                                   includeMarkdown("markdown/variance4.md"),
                                   plotOutput("variance"),
                                   includeMarkdown("markdown/variance5.md")
                          )
              )
    )
  )
)

# Server function
server <- function(input, output, session) {
  thematic::thematic_shiny()

  # Reactive dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "Cars" = mtcars,
           "ChickenWeight" = ChickWeight,
           "Iris" = iris,
           "Catholic" = catholic,
           "Swiss" = swiss)
  })

  # Independent variable selector with default
  output$iv <- renderUI({
    req(datasetInput())
    choices <- names(datasetInput())
    selectInput('iv', 'Independent variable', choices = choices, selected = choices[1])
  })

  # Dependent variable selector with default
  output$dv <- renderUI({
    req(datasetInput())
    choices <- names(datasetInput())
    default_dv <- if(length(choices) >= 2) choices[2] else choices[1]
    selectInput('dv', 'Outcome', choices = choices, selected = default_dv)
  })


  datasetInput <- reactive({
    get_dataset(input$dataset, catholic)
  })

  Rawdata <- reactive({
    prepare_raw_data(datasetInput(), input$iv, input$dv)
  })

  SSdata <- reactive({
    calculate_ss_data(Rawdata())
  })

  regFormula <- reactive({
    make_formula(input$dv, input$iv)
  })

  model <- reactive({
    lm(regFormula(), data = datasetInput())
  })

  # All renderPlots
  output$distPlot_dv <- renderPlot({
    req(input$dv, datasetInput())
    hist_plot(datasetInput(), input$dv)
  })

  output$distPlot_iv <- renderPlot({
    req(input$iv, datasetInput())
    hist_plot(datasetInput(), input$iv)
  })

  output$scatter <- renderPlot({
    req(input$iv, input$dv, Rawdata())
    scatter_plot(Rawdata(), input$iv, input$dv)
  })

  output$total <- renderPlot({
    req(input$iv, input$dv, Rawdata())
    total_variance_plot(Rawdata(), input$iv, input$dv)
  })

  output$regression <- renderPlot({
    req(input$iv, input$dv, Rawdata())
    explained_variance_plot(Rawdata(), input$iv, input$dv)
  })

  output$error <- renderPlot({
    req(input$iv, input$dv, Rawdata())
    error_plot(Rawdata(), input$iv, input$dv)
  })

  output$variance <- renderPlot({
    req(SSdata())
    variance_bar_plot(SSdata())
  })

  output$plot <- renderPlot({
    req(model())
    ggcoef(model(), vline_color = "red") +
      ylab("Coefficient") + xlab("Point estimate") +
      theme_minimal(base_size = 16)
  })

  # Summary + model output
  output$summary <- renderPrint({
    req(input$iv, input$dv, datasetInput())
    summary(cbind(datasetInput()[[input$dv]], datasetInput()[[input$iv]]))
  })


  output$model <- renderPrint({ summary(model()) })

  # Alerts
  register_alerts(input, session)

  # Report download handler (same)
  output$report <- downloadHandler(
    filename = "report.docx",
    content = function(file) {
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      params <- list(
        dataname = input$dataset,
        data = datasetInput(),
        dv = datasetInput()[[input$dv]],
        iv = datasetInput()[[input$iv]],
        namedv = input$dv,
        nameiv = input$iv
      )
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv()))
    }
  )
}

# Launch app
shinyApp(ui, server)

