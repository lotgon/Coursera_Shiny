
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
 GetMaximumDropdown <- function (bars, tp )
 {
    N<-nrow(bars)
    result<-as.data.table(data.frame())
    askFrom<-bars$askFrom
    bidHigh<-bars$bidHigh
    askLow<-bars$askLow
    
    openSell <- bidHigh[1]
    maxPriceSell <-openSell
    openTimeSell <- 1
    
    openBuy <- askLow[1]
    minPriceBuy <-openBuy
    openTimeBuy <- 1   
    
    for(i in 1:N)
    {
        if( askLow[i] > maxPriceSell ) #better to use askHigh if you need more precise model
            maxPriceSell <- askLow[i]
        if( askLow[i] < maxPriceSell - tp) #not equal because we want to imitate not ideal execution 
        {
            result<-rbindlist(list(result, data.table(tp, 
                                                      side="sell",
                                                      openTimeIndex=openTimeSell,
                                                      drawdown=maxPriceSell - openSell,
                                                      age=i-openTimeSell,
                                                      openPrice=openSell,
                                                      openTime=askFrom[openTimeSell],
                                                      closeTime=askFrom[i])))
            if( i!= N)
            {
                openSell <- bidHigh[i+1] #open new order on next step... better to use bidClose instead of high
                maxPriceSell <- openSell
                openTimeSell <- i+1
            }
        }
        #the same logic for buy order
        if( bidHigh[i] < minPriceBuy) 
            minPriceBuy <- bidHigh[i]
        if( bidHigh[i] > minPriceBuy + tp ) #not equal because we want to imitate not ideal execution 
        {
            result<-rbindlist(list(result, data.table(tp, 
                                                      side="buy",
                                                      openTimeIndex=openTimeBuy,
                                                      drawdown=openBuy - minPriceBuy,
                                                      age=i-openTimeBuy,
                                                      openPrice=openBuy,
                                                      openTime=askFrom[openTimeBuy],
                                                      closeTime=askFrom[i])))
            if( i!= N)
            {
                openBuy <- askLow[i+1] #open new order on next step... better to use bidClose instead of high
                minPriceBuy <- openBuy
                openTimeBuy <- i+1
            }
        }
        
     }
    result<-rbindlist(list(result, data.table(tp, 
                                              "sell",
                                              openTimeSell,
                                              maxPriceSell - openSell,
                                              NA,
                                              openSell,
                                              askFrom[openTimeSell],
                                              askFrom[i])))
    
    result<-rbindlist(list(result, data.table(tp, 
                                              "buy",
                                              openTimeBuy,
                                              openBuy - minPriceBuy,
                                              NA,
                                              openBuy,
                                              askFrom[openTimeBuy],
                                              askFrom[i])))
    
    result
 }

shinyServer(function(input, output) {

    library(lubridate) 
    library(ggplot2)
    library(data.table)
    library(downloader)
    volumeLots<<-0.01
    
    symbolInput<- reactive({
        withProgress(message = 'Downloading data', value = 0, {
            
        symbolName<<-input$symbolInput
        sourceLink<-sprintf("https://github.com/lotgon/Coursera_Shiny/blob/master/PrepareData/data/%s.zip?raw=true", symbolName)
        file <- paste(tempdir(), symbolName, sep =  "\\")
        if(!file.exists(file))
            download(sourceLink, file, mode="wb") 
        incProgress(0.5)
        
         d<-fread(unzip(file))
         d[,askFrom:=ymd_hms(askFromString, tz="GMT")]
         d[,askFromString:=NULL]  
         d<-d[.N:1]
         incProgress(0.75)
        })
        d
    })
    calcInput<- reactive({
        data <- symbolInput()      
        r1<- GetMaximumDropdown(data, input$tp)
        r1[,DrawdownInTp:=drawdown/tp]
        r1[,index:=1:.N]
        r1[,usedMargin:=tp*volumeLots*10*2^(DrawdownInTp)]
        r1[,balanceGrowth:=tp*volumeLots*10*index]
        r1
    })

  output$BidChart <- renderPlot({
    data <- symbolInput()      
    ggplot(data, aes(x=data$askFrom, y=data$bidHigh*10^-5)) + geom_line() + ggtitle(symbolName) + xlab("Date") + ylab("Price")
  })
  output$MarginChart <- renderPlot({
      r1 <- calcInput()      
      ggplot(r1, aes(x=openTime, y=usedMargin)) + geom_line() + ylab("Required deposit, USD") + ggtitle("Margin requirement for account")
  })
  output$ProfitChart <- renderPlot({
      r1 <- calcInput()      
      ggplot(r1, aes(x=openTime, y=balanceGrowth+tp)) + geom_line() + ylab("Account Balance, USD") + ggtitle("Account Profit")
  })
  output$percentageIncome <- renderPrint({
      r1 <- calcInput()      
      round(input$tp*volumeLots*10*nrow(r1) *100 / max(r1$usedMargin))
      
  })
  output$ordersNumber <- renderPrint({
      r1 <- calcInput()      
      nrow(r1)
  })
#    output$tradeReportsTable <-renderTable({
#        data <- symbolInput()      
#        r[, .(openTime, closeTime, side, usedMargin, balanceGrowth)]
#    })

})
