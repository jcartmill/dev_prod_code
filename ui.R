library(shiny)
# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(
        headerPanel("BMI Calculator"),
        sidebarPanel(
                helpText("Move the sliders to your height and weight.
                         The table will update to your values and suggest 
                         a weight loss goal to get you into the Healthy range.
                         Your BMI will also be overlayed on the NHANES data set
                         to show how you compare."),
                
                sliderInput("height", 
                            label = "Height in inches:",
                            min = 40, max = 85, value = 70),
                sliderInput("weight", 
                            label = "Weight in pounds:",
                            min = 100, max = 300, value = 150),
                helpText("Click the check box to overlay the BMI Ranges"),
                
                checkboxInput("rangeOverlays", label = "Show BMI Ranges ", value = FALSE),
                
                helpText("Powered by Shiny from"),
                tags$img(src = "http://www.rstudio.com/wp-content/uploads/2014/03/blue-125.png")
        ),
        mainPanel(
                
                tableOutput("bmitable"),
               # htmlOutput("view"),
                plotOutput("secPlot")
        )
))