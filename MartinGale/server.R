
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

    library(lubridate)    
    
    symbolInput<- reactive({
        sourceLink<-sprintf("https://github.com/lotgon/Coursera_Shiny/blob/master/MartinGale/data/%s.zip?raw=true", input$symbolInput)
        file <- paste(tempdir(), "_ptempdownload.zip", sep =  "")
        download.file(sourceLink, file, mode="wb") 
        
        d<-fread(unzip(file))
        d[,askFrom:=ymd_hms(askFromString, tz="GMT")]
        d[,askFromString:=NULL]  
        d
    })

  output$BidChart <- renderPlot({
    data <- symbolInput()      
    plot(data$askFrom, data$bidHigh)
  })

})
