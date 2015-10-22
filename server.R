# Load libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(grid)

# Define function to calculate standard measurements for BMI
sBMI <- function(ft, inc, lbs){
    Ht = (ft*12)+inc
    sCal = (lbs/(Ht)^2)*703
    ifelse(!is.na(sCal), sCal, 0)
}

# Define fiunction to calculate metric measurements for BMI
mBMI <- function(cm, kg){
    ht = cm/100
    mCal = kg/(ht)^2
    ifelse(!is.na(mCal), mCal, 0)
}

# Define Reference Table Parameters
BMI <- c("Below 18.5", "18.5 - 24.9", "25.0 - 29.9", "30.0 and Above")
wStatus <- c("Underweight", "Normal or Healthy Weight", "Overweight", "Obese")
refTable <- cbind.data.frame(BMI, wStatus)
names(refTable) <- c("BMI", "Weight Status")

# Create Function for Reference Plot
myplot <- function(bm){
    BMI <- c(18.49, 6.5, 5, 20)
    Status <- c("Underweight", "Normal or Healthy Weight", "Overweight", "Obese")
    refTable <- cbind.data.frame(BMI, Status)
    refTable <- refTable %>% mutate(Category = "Status", pos = cumsum(BMI)-(0.5*BMI))
    ggplot(refTable, aes(x=Category, y=BMI, fill=Status)) + 
        geom_bar(stat="identity", width = 0.8) + 
        geom_hline(yintercept=bm, colour="red", size=0.85) +
        geom_text(aes(label=Status, y=pos), size = 4.5, angle = 90, colour="white") +
        theme(legend.position="none") + xlab("") + coord_flip()
}

# Define the various outputs in shinyServer
shinyServer(
    function(input, output, session){
        # Output BMI if the inputs for standard measurements are correctly entered
        output$yoursBMI <- renderPrint({ifelse(
            is.finite(sBMI(input$ft, input$inc, input$lbs)), 
            sBMI(input$ft, input$inc, input$lbs), 
            "please click Reset and specify your Height first")})
        
        # Output BMI if the inputs for metric measurements are correctly entered
        output$yourmBMI <- renderPrint({ifelse(
            is.finite(mBMI(input$cm, input$kg)),
            mBMI(input$cm, input$kg),
            "please click Reset and specify your Height first")})
        
        # Output the Reference Table for Standard tab input fields
        output$refTablea <- renderTable(refTable, include.rownames=FALSE)
        
        # Output the Reference Table for Metric tab input fields
        output$refTableb <- renderTable(refTable, include.rownames=FALSE)
        
        # Output Reference Plot for Standard tab input fields
        output$plotsa <- renderPlot({
            myplot(ifelse(
                is.infinite(sBMI(input$ft, input$inc, input$lbs)), 0, 
                ifelse(sBMI(input$ft, input$inc, input$lbs) > 50, 50, 
                       sBMI(input$ft, input$inc, input$lbs))))
        }, height = 260, width = 500)
        
        # Output Reference Plot for Metric tab input fields
        output$plotsb <- renderPlot({
            myplot(ifelse(
                is.infinite(mBMI(input$cm, input$kg)), 0,
                ifelse(mBMI(input$cm, input$kg) > 50, 50,
                       mBMI(input$cm, input$kg))))
        },height = 260, width = 500)
        
        # Define Reset parameters for Standard tab input fields
        observe({
            input$reset_input1
            updateNumericInput(session, "ft", value = 0)
            updateNumericInput(session, "inc", value = 0)
            updateNumericInput(session, "lbs", value = 0)
        })
        
        # Define Reset parameters for Metric tab input fields
        observe({
            input$reset_input2
            updateNumericInput(session, "cm", value = 0)
            updateNumericInput(session, "kg", value = 0)
        })
    }
)


# library(shinyapps)
# shinyapps::deployApp('C:/Users/user/datasciencecoursera/Developing Data Products/courseProject/appBMI')