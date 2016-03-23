
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
# GetMaximumDropdown <- function (bars, tp )
# {
#     N<-nrow(bars)
#     result<-as.data.table(data.frame(row.names=c("tp", "openTime", "tralOpen", "UpDown")))
#     askFrom<-bars$askFrom
#     bidFrom<-bars$bidFrom
#     bidSpeed<-bars$bidSpeed
#     askSpeed<-bars$askSpeed
#     bidClose<-bars$bidClose
#     askClose<-bars$askClose
# }

shinyServer(function(input, output) {

    library(lubridate) 
    library(ggplot2)
    library(data.table)

    symbolInput<- reactive({
        symbolName<<-input$symbolInput
        sourceLink<-sprintf("https://github.com/lotgon/Coursera_Shiny/blob/master/MartinGale/data/%s.zip?raw=true", symbolName)
        file <- paste(tempdir(), symbolName, sep =  "")
        if(!file.exists(file))
            download.file(sourceLink, file, mode="wb") 
        
        d<-fread(unzip(file))
        d[,askFrom:=ymd_hms(askFromString, tz="GMT")]
        d[,askFromString:=NULL]  
        d
    })

  output$BidChart <- renderPlot({
    data <- symbolInput()      
    ggplot(data, aes(x=data$askFrom, y=data$bidHigh)) + geom_line() + ggtitle(symbolName) + xlab("Date") + ylab("Price")
  })
  
#   output$tradeReportsTable <-renderTable({
#       data <- symbolInput()      
#   })

})
