library(DT)
library(shiny)
library(hexbin)
library(googleVis)
library(ggplot2)

data(NHANES)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        datasetInput <- reactive({
                
                
        })
        bmiTable <- reactive({
                data.frame(
                        Name = c("Your Weight (lbs)", 
                                 "Your Height(in)",
                                 "Your BMI",
                                 "Suggested Weight Loss"),
                        Value = as.character(c(input$weight, 
                                               input$height,
                                               round(input$weight/(input$height^2)*703,2),
                                               ceiling(max(0,input$weight - (25 *(input$height^2)/703 ))))), 
                        stringsAsFactors=FALSE)
        })
        output$view <- renderGvis({
                gvisScatterChart(datasetInput(), options=list(width=400, height=450))
        })
        output$hsecPlot <- renderPlot({
                bin = (hexbin(NHANES$Weight* 2.2,NHANES$BMI, xbins=5,xlab="Weight (lbs)",ylab ="BMI"))
                plot(bin)
                abline(lm(NHANES$BMI ~ NHANES$Weight ))})
        output$secPlot <- renderPlot({
                myDs <- data.frame(NHANES$Weight *2.2,NHANES$BMI)
                colnames(myDs)<-c("Weight","BMI")
                myBMI <-round(input$weight/(input$height^2)*703,2)
                maxBMI = 50
                d <- ggplot(myDs, aes(Weight, BMI)) 
                if(input$rangeOverlays){
                        d <- d + geom_point(aes(colour=BMI),na.rm=TRUE)+ scale_colour_gradient(low= "#00FF00", high= "#FF0000") 
                } else {
                        d <- d + stat_binhex(bins = 20,na.rm=TRUE,color="yellow")+scale_fill_gradientn(colours=c("#A0A0FF","#000060")) 
                }
                if(input$rangeOverlays){
                        d<- d +annotate("rect", xmin = 100, xmax = 300, ymin =18.5, ymax =25,
                                        alpha = .2,fill="green")
                        d<- d +annotate("rect", xmin = 100, xmax = 300, ymin =25, ymax =30,
                                        alpha = .2,fill="yellow")  
                        d<- d +annotate("rect", xmin = 100, xmax = 300, ymin =30, ymax =50,
                                        alpha = .2,fill="red")
                        d <- d + annotate("text", x = 300, y = 40, label = "Obese",colour = "#FF0000",hjust=1)
                        d <- d + annotate("text", x = 300, y = 27, label = "Overweight",colour = "#AFAF00",hjust=1)
                        d <- d + annotate("text", x = 300, y = 22, label = "Healthy",colour = "#00FF00",hjust=1)
                        d <- d + annotate("text", x = 300, y = 15, label = "Underweight",colour = "#000000",hjust=1)
                        
                }
                d<-d + annotate("rect", xmin = input$weight-15, xmax = input$weight+15, ymin =min(myBMI,maxBMI)-2, ymax =min(myBMI,maxBMI)+2,
                                alpha = .8,fill="#ffffff")
                if (myBMI >= 30){
                        d <- d + annotate("text", x = input$weight, y = min(myBMI,maxBMI), label = as.character(myBMI),colour = "#FF0000")
                }
                if (myBMI <=25){
                        d <- d + annotate("text", x = input$weight, y = min(myBMI,maxBMI), label = as.character(myBMI),colour = "#00A000")
                }
                if (myBMI >=25 && myBMI < 30){
                        d <- d + annotate("text", x = input$weight, y = min(myBMI,maxBMI), label = as.character(myBMI),colour = "#BFBF00",fill="black")
                }
                d <- d +theme_bw()
                d <- d +xlim(100,300)+ylim(10,maxBMI+2)
                d })
        output$bmi <- renderPrint({input$weight/(input$height^2)*703})
        output$bmitable <- renderTable(bmiTable())
        
})