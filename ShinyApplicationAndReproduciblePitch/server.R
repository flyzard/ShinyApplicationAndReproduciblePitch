#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(dplyr)
library(shiny)
library(caret)
library(ggplot2)

df = read.csv("ShinyApplicationAndReproduciblePitch/winequality-red.csv")
model <- train(quality ~ ., data = df, method = "ranger", trControl = trainControl(method = "cv", number = 5, verboseIter = TRUE))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    prediction <- reactive({
        pred <- predict(model, newdata = data.frame(input$alcohol, input$volatile.acidity, input$sulphates, input$citric.acid))
        pred
    })
    
    similars <- reactive({
        sim <- filter(df, 
            (alcohol < input$alcohol + 0.5 | alcohol > input$alcohol - 0.5),
            (volatile.acidity < input$volatile.acidity + 0.05 | volatile.acidity > input$volatile.acidity - 0.05), 
            (sulphates < input$sulphates + 0.08 | sulphates > input$sulphates - 0.08), 
            (citric.acid < input$citric.acid + 0.05 | citric.acid > input$citric.acid - 0.05)
        )
        sim
    })

    output$table <- DT::renderDataTable({
        similars()
    })


    output$plot <- renderPlot({
        data <- similars()
        plot <- ggplot(data, aes(x=alcohol, y = volatile.acidity))+
            geom_point(aes(color = sulphates), alpha = 0.3)+
            geom_smooth(method = "glm")+
            geom_vline(xintercept = input$car, color = "red")+
            geom_hline(yintercept = pred, color = "green")
        ggplot(data, aes(gdpPercap, lifeExp)) +
            geom_point() +
            scale_x_log10()
    })

})
