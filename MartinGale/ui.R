
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Martin Gale Analyses"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        selectInput("symbolInput", "Choose a symbol:", choices = c("EURUSD", "AUDUSD", "GBPUSD", "LTCUSD", "NZDUSD"))
        ,   sliderInput("tp", "Take Profit:", min = 100,  max = 1000, value = 500, step=50)
        ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("BidChart"),
      plotOutput("MarginChart"),
      plotOutput("ProfitChart"),
      helpText('Income in % per period:'),
      verbatimTextOutput('percentageIncome'),
      helpText('Orders number:'),
      verbatimTextOutput('ordersNumber')
      
#       ,h4("Estimated Trade History"),
#       ,tableOutput("tradeReportsTable")
    )
  )
))
