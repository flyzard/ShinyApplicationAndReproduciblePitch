
#
# This is the user-interface definition of a Shiny web application to demonstrate
# wine quality prediction.
#

library(shiny)

# Define UI for application that draws a plot of the wine quality
shinyUI(fluidPage(

    # Application title
    titlePanel("Wine quality prediction based on their chemical properties"),

    p("You can play with the inputs below, representing the main chemical properties influencing the wine quality and predict the quality of the wine."),
    
    helpText("Please move the slider inputs and observe the changes in the prediction of red wine quality."),
    # Layout with side bar
    sidebarLayout(
        # Sidebar with various slider inputs
        sidebarPanel(
            sliderInput("alcohol",
                        "Quantity of alcohol:",
                        min = 8.0,
                        max = 15.0,
                        value = 14.3),
            
            sliderInput("volatile.acidity",
                        "Volatile Acidity:",
                        min = 0.12,
                        max = 1.2,
                        value = 0.62),
            
            sliderInput("sulphates",
                        "Quantity of sulphates:",
                        min = 0.25,
                        max = 1.30,
                        value = 0.65),
            
            sliderInput("citric.acid",
                        "Quantity of citric acid:",
                        min = 0.0,
                        max = 1.0,
                        value = 0.6)
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel(
                    title = "Graphic",
                    plotOutput("plot")
                ),
                tabPanel(
                    title = "Similar wines",
                    DT::dataTableOutput("table")
                )
            ),
            h3("This work only serves the completion of the Course Project, Developing Data Products in Coursera. Please don't rely on it to further conclusions"),
            h4("Here we use a general regression model. Not the best model, but Random Forest, which would give a more accurate prediction, would cause a time out cause the server would take too much time to build the model.")
        )
    )
))

