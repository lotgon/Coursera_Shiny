
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
        selectInput("symbolInput", "Choose a symbol:", choices = c("EURUSD", "XAUUSD", "XAGUSD"))
        ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("BidChart")
#       ,h4("Estimated Trade History"),
#       ,tableOutput("tradeReportsTable")
    )
  )
))
