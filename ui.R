library(shiny)

shinyUI(fluidPage(
  headerPanel("Interactive Shiny App to plot reggresion for EPL"),
  sidebarPanel(
    sliderInput("slider1", label = h3("number of players in reggresion"), min = 1, max = 695, value = 350, step = 5),
    h4("your choosen number of players is:"),
    verbatimTextOutput("inputValue"),
    sliderInput("num", label = h3("select number of players to display data table for"), min = 1, max = 25, value = 1, step = 1)
  ),
  mainPanel(
    h3('Fantasy Premier league linear regression'),
    
    plotOutput('newHist'),
    tableOutput('data'),
    helpText(   a("See more on premier league fantasy side", href="http://fantasy.premierleague.com/") )
    
  )
  
))