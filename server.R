library(shiny)
library(ggplot2)
library(randomForest)

activities <- read.csv(paste(getwd(),"/data/activities.csv",sep=""),sep=";", dec = ",")
activities$Date <- as.POSIXlt(strptime(activities$Date,"%d/%m/%Y"))


activities$Weekday <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", 
  "Friday", "Saturday")[as.POSIXlt(activities$Date)$wday + 1]
activities$Weekday <- factor(activities$Weekday, 
       levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", 
                  "Saturday", "Sunday"))
tmp <- activities[, -which(names(activities) %in% c("Date","Weekday"))]
fit <- randomForest(Steps ~ ., data=tmp, ntree=200)
means <- as.data.frame(t(colMeans(tmp)))

prednames <- names(activities)
prednames <- prednames[-which(prednames %in% c("Date","Weekday"))]


# Define server logic required to draw a histogram
shinyServer(function(input, output,clientData, session) {
    
    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should re-execute automatically
    #     when inputs change
    #  2) Its output type is a plot
    
    output$distPlot <- renderPlot({
        inputs <- as.POSIXlt(input$dates)
        acti_sl <- activities[as.Date(activities$Date) >= as.Date(inputs[1]),]
        acti_sl <- acti_sl[as.Date(acti_sl$Date) <= as.Date(inputs[2]),]
        boxplot(CaloriesBurned ~ Weekday, data = acti_sl)
        df.var<-data.frame(Weekday = acti_sl$Weekday, 
                           newvar=acti_sl[[as.character(input$ycol)]])
        boxplt <- ggplot(data = df.var, 
                         aes(x = Weekday, y = newvar)) +
            geom_boxplot(colour="#002776", fill="#81BC00", alpha = 1, 
                         outlier.colour = "red", outlier.size = 3,
                         axis.text.x = element_blank(), 
                         axis.title.x = element_blank())+
            theme_bw()
        boxplt

    })

    output$text1 <- renderText({ 
        tmp_means <- means
        tmp_means[[as.character(input$ycol2)]] <- input$inSlider2
        tmp_means$estimate_steps=predict(fit,tmp_means)
        
        paste("Predicted number of steps based on your input", 
              tmp_means$estimate_steps)

    })
    
    observe({
        selected <- as.character(input$ycol2)
        maxslideval <- as.numeric(max(activities[[selected]]))
            
        updateSliderInput(session, "inSlider2",
                          max = max(activities[[selected]]),
                          min = min(activities[[selected]]),
                          value = median(activities[[selected]]))
        
    })
})