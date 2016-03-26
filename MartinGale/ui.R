
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Martingale trade strategy analyse"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        selectInput("symbolInput", "Choose a symbol:", choices = c("EURUSD", "AUDUSD", "GBPUSD", "LTCUSD", "NZDUSD"))
        ,   sliderInput("tp", "Take Profit:", min = 100,  max = 1000, value = 500, step=50)
        ,p('Detail information about take profit can be found http://www.investopedia.com/terms/t/take-profitorder.asp')
        ),

    # Show a plot of the generated distribution
    mainPanel(
        p('
        This website helps to analyse the simplest and one of the most popular trade strategy called "Martingale". 
        Detail information about the idea of this strategy can be found on the Wikipedia page: https://en.wikipedia.org/wiki/Martingale_(betting_system).
        ')
        ,p('This chart shows the rates for chosen symbol, all data downloaded from from https://github.com/lotgon/Coursera_Shiny/tree/master/PrepareData/data')
      ,plotOutput("BidChart"),
      plotOutput("MarginChart"),
      plotOutput("ProfitChart"),
      helpText('Income per period, in percent:'),
      verbatimTextOutput('percentageIncome'),
      helpText('Orders number:'),
      verbatimTextOutput('ordersNumber')
      ,p('Number of orders tell us about analyse variability.')

#       ,h4("Estimated Trade History"),
#       ,tableOutput("tradeReportsTable")
    )
  )
))
