library(rFdk)
ttConnect()
Sys.sleep(1)
GetPrecision <-function (symbol)
{
    ttConf.Symbol()[name==symbol, precision]
}
GetBars <- function( symbol, periodStr="M1" )
{
    bars<-as.data.table(ttFeed.BarHistory(symbol, priceTypeStr = "BidAsk", barPeriodStr = periodStr, 
                                          startTime = as.Date('2015-01-01'), endTime = as.Date('2016-01-01')))
    bars[,bidHigh:=bidHigh * 10^GetPrecision(symbol)]
    bars[,askLow:=askLow * 10^GetPrecision(symbol)]
    
    if( !complete.cases(bars))
        bars<-bars[complete.cases(bars),]
    
    bars
}

sapply( ttConf.Symbol()$name[1:10], function( symbolName)
    {
        symHistory<-GetBars(symbolName)
        symHistory$askFromString <- format(symHistory$askFrom)
        write.table(symHistory[,.(bidHigh, askLow, askFromString)], symbolName, row.names = F)
        fileName<-paste("data", symbolName, sep='\\')
        zip(fileName, symbolName)
        file.remove(symbolName)
    })
