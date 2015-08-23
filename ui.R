library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    navbarPage("My Fitbit virtualizer", 
               tabPanel("Explore the Data",
                        sidebarPanel(
                            dateRangeInput("dates", label = h3("Date range"),
                                           start = as.Date("2015-04-01"), 
                                           end = as.Date("2015-07-31"), 
                                           min = as.Date("2015-04-01"), 
                                           max = as.Date("2015-07-31")
                            ),
                            selectInput('ycol', 'Y Variable', 
                                        names(activities), 
                                        selected = names(activities)[2])
                        ),
                        mainPanel(
                            plotOutput("distPlot")
                        )
                        
               ),
               tabPanel("Predict number of steps",
                        sidebarPanel(
                            selectInput('ycol2', 'Predict from', 
                                        prednames, 
                                        selected = prednames[1]),
                            sliderInput("inSlider2", "Slider input 2:",
                                        min = 0, max = 2000, value = c(1500))
                        ),
                        mainPanel(
                            textOutput("text1")
                        )
                        
               ),
               tabPanel("About",
                        mainPanel(
                            includeMarkdown("about.md"))
               )
    ) 
    
))