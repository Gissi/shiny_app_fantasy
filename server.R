#######
#Hér má skilgreina t.d nýtt gagnasett sem er sótt dæmi væri fantasy football data
library(shiny)
library(ggplot2)

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

fantasy <- function ()
  
{
  
  #Load libraries
  rm(list=ls())
  library("XML")  
  all_fantasy_data_frame <- data.frame()
  #loop through all sites to get the data 25 is enough 
  for (i in 1:25) {
    
    #read in string
    statistics_string <- paste("http://fantasy.premierleague.com/stats/elements/?stat_filter=total_points&element_filter=0&page=",i,sep="")  
    
    #read data
    fantasy_data <- readHTMLTable(statistics_string, stringsAsFactors = FALSE)
    
    #Turn data into data frame the data is stored in the first elemnt of the table as a list
    
    fantasy_data_frame <- data.frame(fantasy_data[1])
    
    #The first 2 columns are blank. fix that only if the vector is not empty.
    if (length(fantasy_data_frame) > 0 )
    {
      fantasy_data_frame <- fantasy_data_frame[,3:9]
    }
    
    
    #lets name the columns withou the null
    
    names(fantasy_data_frame) <- sub("NULL.","",names(fantasy_data_frame))  
    all_fantasy_data_frame <- rbind(all_fantasy_data_frame,fantasy_data_frame)   
    all_fantasy_data_frame$Price<-gsub("£","",all_fantasy_data_frame$Price)   
    all_fantasy_data_frame$Total<-as.numeric(all_fantasy_data_frame$Total)
    all_fantasy_data_frame$Price<-as.numeric(all_fantasy_data_frame$Price)
    
    
  }
  
  return(all_fantasy_data_frame)
  
}

points <- fantasy()

shinyServer(
  
  function(input, output){
    
    output$inputValue <- renderPrint({input$slider1})  
    output$newHist <- renderPlot({p1 <- ggplot(points[1:input$slider1,], aes(x = Price, y = Total))
                                  p1+geom_point()+geom_smooth(method = "lm")+labs(title = "EPL fantasy points vs price", x = "EPL fantasy plaer Price", y="EPL total point today")
                                  #+theme_bw()+theme(plot.title= element_text(size = 20, colour = "red"))         
                               
                                  })
    output$data <- renderTable({
      points[1:input$num,]
    })
    
      
    
  }
)