library(shiny)
shinyUI(
    pageWithSidebar(
        headerPanel("Body Mass Index (BMI) Calculator","BMI Calculator"),
        sidebarPanel(position = "right",
                     p(em(strong("Select Standard or Metric Measurements"))),
                     tabsetPanel(
                         tabPanel("Standard",
                                  h4('Specify your Height (in feet and inches)'),
                                  p(em('To specify your height, type in the value or use the arrow buttons')),
                                  div(style="display:inline-block", numericInput('ft', 'feet', value = 0, min = 0, max = 15)),
                                  div(style="display:inline-block", numericInput('inc', 'inches', value = 0, min = 0, max = 12)),
                                  h4('Specify your Weight (in pounds)'),
                                  p(em('To specify your weight, click on the slider and drag or use the arrow keys to move it slowly')),
                                  sliderInput('lbs', 'pounds', value = 0, min = 0, max = 450),
                                  tags$hr(),
                                  actionButton("reset_input1", "Reset")
                         ),
                         tabPanel("Metric",
                                  h4('Specify your Height (in centimeters)'),
                                  p(em('To specify your height, type in the value or use the arrow buttons')),
                                  numericInput('cm', 'centimeters', value = 0, min = 0, max = 500),
                                  h4('Specify your Weight (in kilograms)'),
                                  p(em('To specify your weight, click on the slider and drag or use the arrow keys to move it slowly')),
                                  sliderInput('kg', 'kilograms', value = 0, min = 0, max = 200),
                                  tags$hr(),
                                  actionButton("reset_input2", "Reset")
                         ),
                         id = "calculatePanels"
                     )
        ),
        mainPanel(
            h3('What is BMI?'),
            p("BMI means" , em(strong("Body Mass Index. ")), "This is a person's weight in kilograms divided by the square of the person's height in meters. For measurements in feet/inches and pounds, the result is multiplied by a factor of 703."),
            conditionalPanel(condition="input.calculatePanels == 'Standard'",       
                             helpText("Standard Calculation Selected"),
                             h4('Your BMI is:'),
                             verbatimTextOutput("yoursBMI"),
                             p("For adults older than 20 years, BMI can be intepreted using the weight status categories shown in the Table and Chart below."),
                             fluidRow(column(5, p(strong('Table Showing Weight Categories by BMI')), tableOutput('refTablea'), p('For children and teenagers however, BMI weight status depends upon age and sex. More information is available at the ', tags$a("Centre for Disease Control Website", href="http://www.cdc.gov/healthyweight/assessing/bmi/adult_bmi/index.html", target="_blank"))),
                                      column(6, plotOutput('plotsa', width = "100%")))
            ),    
            conditionalPanel(condition="input.calculatePanels == 'Metric'", 
                             helpText("Metric Calculation Selected"),
                             h4('Your BMI is:'),
                             verbatimTextOutput("yourmBMI"),
                             p("For adults older than 20 years, BMI can be intepreted using the weight status categories shown in the Table and Chart below."),
                             fluidRow(column(5, p(strong('Table Showing Weight Categories by BMI')), tableOutput('refTableb'), p('For children and teenagers however, BMI weight status depends upon age and sex. More information is available at the ', tags$a("Centre for Disease Control Website", href="http://www.cdc.gov/healthyweight/assessing/bmi/adult_bmi/index.html", target="_blank"))),
                                      column(6, plotOutput('plotsb', width = "100%")))
                             
                             
            )
        )
    )
)