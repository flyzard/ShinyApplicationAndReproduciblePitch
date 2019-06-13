
#
# This is the user-interface definition of a Shiny web application to demonstrate
# wine quality prediction.
#

library(shiny)

# Define UI for application that draws a plot of the wine quality
shinyUI(fluidPage(

    # Application title
    titlePanel("Wine quality perdiction"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("alcohol",
                        "Quantity of alcohol:",
                        min = 8,
                        max = 15,
                        value = 12),
            
            sliderInput("volatile.acidity",
                        "Acidity:",
                        min = 0.12,
                        max = 1.6,
                        value = 0.8),
            
            sliderInput("sulphates",
                        "Quantity of sulphates:",
                        min = 0,
                        max = 2,
                        value = 1),
            
            sliderInput("citric.acid",
                        "Quantity of citric acid:",
                        min = 0,
                        max = 1,
                        value = 0.5)
            
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
            )
        )
    )
))

