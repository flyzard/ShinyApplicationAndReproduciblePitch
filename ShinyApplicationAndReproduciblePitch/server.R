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

# Download data
df = read.csv("https://raw.githubusercontent.com/flyzard/ShinyApplicationAndReproduciblePitch/master/winequality-red.csv")

# Build model
model <- train(quality~., df, method ="glm",  
               trControl=trainControl(method = "cv", number = 5, verboseIter = TRUE), na.action = na.exclude)

#model <- train(quality~., df, method ="ranger",  
 #               trControl=trainControl(method = "cv", number = 5, verboseIter = TRUE), na.action = na.exclude)

newdata <- data.frame(
    "alcohol" = NA, 
    "volatile.acidity" = NA, 
    "sulphates" = NA, 
    "citric.acid" = NA, 
    "fixed.acidity" = mean(df$fixed.acidity),
    "residual.sugar" = mean(df$residual.sugar),
    "chlorides" = mean(df$chlorides),
    "free.sulfur.dioxide" = mean(df$free.sulfur.dioxide),
    "total.sulfur.dioxide" = mean(df$total.sulfur.dioxide),
    "density" = mean(df$density),
    "pH" = mean(df$pH))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    prediction <- reactive({
        newdata$alcohol = input$alcohol
        newdata$volatile.acidity = input$volatile.acidity
        newdata$sulphates = input$sulphates
        newdata$citric.acid = input$citric.acid
        
        pred <- predict(model, newdata = newdata)
        pred
    })
    
    similars <- reactive({
        alcohol = input$alcohol
        v.acidity = input$volatile.acidity
        sulphates = input$sulphates
        c.acid = input$citric.acid
        
        sim <- df[(between(df$alcohol, alcohol-1, alcohol+1) 
                   & between(df$volatile.acidity, v.acidity -0.5, v.acidity +0.5)
                   & between(df$sulphates, sulphates -0.5, sulphates +0.5)
                   & between(df$citric.acid, c.acid -0.5, c.acid +0.5)),]
        
        sim
    })

    output$table <- DT::renderDataTable({
        similars()
    })


    output$plot <- renderPlot({
        data <- similars()
        predi <- prediction()
        
        plot <- ggplot(df, aes(x=alcohol, y = quality))+
            geom_point(aes(color = volatile.acidity), alpha = 0.3)+
            geom_smooth(method = "glm")+
            geom_vline(xintercept = input$alcohol, color = "red")+
            geom_hline(yintercept = predi, color = "green")
        
        plot
    })
})
