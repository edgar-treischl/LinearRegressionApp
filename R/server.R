# #
# # This is the server logic of a Shiny web application. You can run the
# # application by clicking 'Run App' above.
# #
# # Find out more about building applications with Shiny here:
# #
# #    http://shiny.rstudio.com/
#
# library(shiny)
# library(ggplot2)
# library(readr)
# library(waiter)
# library(shinyWidgets)
#
#
#
# catholic <- read.csv(here::here("data", "catholic.csv"))
#
# #setwd("/srv/shiny-server/ols/")
# #catholic <- read.csv("catholic.csv")
#
#
# # Define server logic required to draw a histogram
# shinyServer(function(input, output, session) {
#
#   thematic::thematic_shiny()
#   Sys.sleep(3) # do something that takes time
#   waiter_hide()
#
#
# #Select data
#   datasetInput <- reactive({
#     switch(input$dataset,
#            "Cars" = mtcars,
#            "ChickenWeight" = ChickWeight,
#            "Iris" = iris,
#            "Catholic" = catholic,
#            "Swiss" = swiss)
#   })
#
#   #Select dependent variable
#   output$dv = renderUI({
#     selectInput('dv', h5('Outcome'), choices = names(datasetInput()))
#   })
#
#   #Select independent variable
#   output$iv = renderUI({
#     selectInput('iv', h5('Independent variable'), choices = names(datasetInput()))
#   })
#
#   ###Creating the raw data data:
#   Rawdata <- reactive({
#     x <- datasetInput()[,input$iv]
#     y <- datasetInput()[,input$dv]
#     Rawdata <- data.frame(y, x)
#     mod <- lm(y ~ x, Rawdata)
#     ypred <- predict(mod)
#     Rawdata <- data.frame(y, x, ypred)
#   })
#
#   SSdata <- reactive({
#     dat <- Rawdata()
#     Y <- mean(dat$y)
#     mod <- lm(y ~ x, dat)
#     ypred <- predict(mod)
#     dat$ypred <- ypred
#     SST <- sum((dat$y - Y)^2)
#     SSE <- round(sum((dat$y - ypred)^2), digits = 5)
#     SSA <- SST - SSE
#
#     SSQ <- data.frame(SS = c("Total","Regression","Error"),
#                       value = as.numeric(c(SST, SSA, SSE)/SST)*100)
#     SSQ$SS <- factor(SSQ$SS, as.character(SSQ$SS))
#     SSdata <- data.frame(SS = factor(SSQ$SS, as.character(SSQ$SS)),
#                          value = as.numeric(c(SST, SSA, SSE)/SST)*100)
#
#   })
#
#   # regression formula
#   regFormula <- reactive({
#     as.formula(paste(input$dv, '~', input$iv))
#   })
#
#   # bivariate model
#   model <- reactive({
#     lm(regFormula(), data = datasetInput())
#   })
#
#
#   # data view
#   #output$view <- renderTable({
#   #head(datasetInput(), n = input$obs)
#   #})
#
#
#   # summary statistics
#   output$summary <- renderPrint({
#     summary(cbind(datasetInput()[input$dv], datasetInput()[input$iv]))
#   })
#
#   # histograms1
#   output$distPlot_dv <- renderPlot({
#     z    <- datasetInput()[,input$dv]
#     hist(z, col = 'darkgray', border = 'white', main = input$dv, xlab = input$dv)
#   })
#
#   # histograms2
#   output$distPlot_iv <- renderPlot({
#     f    <- datasetInput()[,input$iv]
#     hist(f, col = 'darkgray', border = 'white', main = input$iv, xlab = input$iv)
#   })
#
#   ### Scatter
#   output$scatter <- renderPlot({
#     ggplot(Rawdata(), aes(x=x, y=y)) +
#       geom_point()+
#       geom_smooth()+
#       theme(axis.title = element_text(size = 18),
#             title = element_text(size = 20),
#             axis.text  = element_text(size = 18),
#             panel.background=element_rect(fill="white",colour="black"))+
#       xlab(input$iv)+
#       ylab(input$dv)+
#       ggtitle("Scatter plot")
#   })
#
#   # bivariate model
#   output$model <- renderPrint({
#     summary(model())
#   })
#
#   #Total variance####
#   output$total <- renderPlot({
#     cols <- c("#619CFF", "#00BA38", "#F8766D")
#     ggplot(Rawdata(), aes(x=x,y=y))+
#       geom_point(size=3) +
#       geom_segment(xend = Rawdata()[,2], yend = mean(Rawdata()[,1]),
#                    colour = "#0571b0")+
#       geom_hline(yintercept = mean(Rawdata()[,1]))+
#       theme(axis.title = element_text(size = 18),
#             title = element_text(size = 20),
#             axis.text  = element_text(size = 18),
#             panel.background=element_rect(fill="white",colour="black"))+
#       xlab(input$iv)+
#       ylab(input$dv)+
#       ggtitle("Total Variance")
#   })
#
#
#   ###Explained Variance####
#   output$regression <- renderPlot({
#     cols <- c("#619CFF", "#00BA38", "#F8766D")
#     ggplot(Rawdata(), aes(x=x,y=y))+
#       geom_point(alpha=0)+
#       geom_smooth(method= "lm", se = F, colour = "black")+
#       geom_hline(yintercept = mean(Rawdata()[,1]))+
#       geom_segment(aes(x=x,y=ypred), xend = Rawdata()[,2],
#                    yend = mean(Rawdata()[,1]),
#                    colour = "#008837")+
#       theme(axis.title = element_text(size = 18),
#             axis.text  = element_text(size = 18),
#             title = element_text(size = 20),
#             panel.background=element_rect(fill="white",colour="black"))+
#       xlab(input$iv)+
#       ylab(input$dv)+
#       ggtitle("Variance explained by X")
#
#   })
#
#
#   ### Error
#   output$error <- renderPlot({
#     cols <- c("#619CFF", "#00BA38", "#F8766D")
#     ggplot(Rawdata(), aes(x = x, y = y))+
#       geom_point(size=3) + geom_smooth(method= "lm", se = F,
#                                        colour = "black")+
#       geom_segment(xend = Rawdata()[,2], yend = Rawdata()[,3],
#                    colour = "#ca0020")+
#       theme(axis.title = element_text(size = 18),
#             axis.text  = element_text(size = 18),
#             title = element_text(size = 20),
#             panel.background=element_rect(fill="white",colour="black"))+
#       xlab(input$iv)+
#       ylab(input$dv)+
#       ggtitle("Total error")
#
#   })
#
#   ### Explained variance
#   output$variance <- renderPlot({
#     cols <- c("#0571b0", "#008837", "#ca0020")
#     ggplot(SSdata(), aes(y = value, x = SS, fill = SS))+
#       geom_bar(stat = "identity")+
#       scale_fill_manual(values = cols)+
#       theme(axis.title = element_text(size = 18),
#             title = element_text(size = 20),
#             axis.text.x  = element_text(size = 10),
#             axis.text.y  = element_text(size = 18),
#             panel.background=element_rect(fill="white",colour="black")) +
#       ylab("% of explained variance")+
#       xlab("")+
#       ggtitle("Variance components")+
#       theme(legend.position = "bottom")+
#       theme(legend.text = element_text(colour="black", size=16,
#                                        face="bold"))+
#       labs(fill = "Variance")
#
#
#   })
#
# #t <- reactiveValues(data = NULL)
#
# #observeEvent(input$go, {
#   #t$data <- model
#   #})
#
#
#   observeEvent(input$reginfo, {
#     show_alert(
#       title = NULL,
#       btn_labels = "Sure thing!",
#       btn_colors = "#008080",
#       text = tags$span(
#         tags$h3("Some help:", icon("lightbulb"),
#                 style = "color: #008080;"),
#         "The intercept tells you the predicted value of y in case x is 0.",
#         "The beta-coefficient tells you how much y is increased (decreased)
#         if x goes up by 1 unit. Use both to calculate the predicted value."
#       ),
#       html = TRUE
#     )
#   })
#
#
#
#
# observeEvent(input$coefinfo, {
#   show_alert(
#     title = NULL,
#     btn_labels = "Got it!",
#     btn_colors = "#008080",
#     text = tags$span(
#       tags$h3("Interpretation?", icon("lightbulb"),
#               style = "color: #008080;"),
#       "Don't let you fool by point estimates. The estimates depend on the scale
#       of the variables. We have to look at the summary statistics to get an idea
#       about the effect size."
#     ),
#     html = TRUE
#   )
# })
#
#
#
#
#
#
# #shinywidgets##########
# observeEvent(input$linearinfo, {
#   show_alert(
#     title = NULL,
#     btn_labels = "Got it!",
#     btn_colors = "#008080",
#     text = tags$span(
#       tags$h3("Not linear?", icon("skull-crossbones"),
#               style = "color: #008080;"),
#       "We assume that there is a linear association between X and Y. Certainly,
#       this must not be the case and the OLS assumption(s) would be violated."
#     ),
#     html = TRUE
#   )
# })
#
#
#
#
# ### Plot Model
#   output$plot <- renderPlot({
#     #if (is.null(t$data)) return()
#     ggcoef(model(), vline_color="red")+
#       ylab("Coefficient")+
#       xlab("Point estimate")+
#       theme(axis.title = element_text(size = 20),
#             axis.text.x  = element_text(size = 10),
#             axis.text.y  = element_text(size = 16),
#             panel.background=element_rect(fill="white",colour="black"))
#
#   })
#
#   output$report <- downloadHandler(
#     # For PDF output, change this to "report.pdf"
#     filename = "report.docx",
#     content = function(file) {
#       # Copy the report file to a temporary directory before processing it, in
#       # case we don't have write permissions to the current working dir (which
#       # can happen when deployed).
#       tempReport <- file.path(tempdir(), "report.Rmd")
#       file.copy("report.Rmd", tempReport, overwrite = TRUE)
#
#       # Set up parameters to pass to Rmd document
#       params <- list(dataname = input$dataset, data = datasetInput(), dv = datasetInput()[input$dv], iv = datasetInput()[input$iv],
#                      namedv = input$dv, nameiv = input$iv )
#
#       # Knit the document, passing in the `params` list, and eval it in a
#       # child of the global environment (this isolates the code in the document
#       # from the code in this app).
#       rmarkdown::render(tempReport, output_file = file,
#                         params = params,
#                         envir = new.env(parent = globalenv())
#       )
#     }
#   )
#
# })
