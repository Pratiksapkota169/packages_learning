library(shiny)

#Define UI ----

#Shiny uses the function fluidPage to create a display that
#automatically adjusts to the dimensions of your user's browser
#window.You lay out the user interface of your app by placing 
#elements in the fluidPage function.

#For example,the ui function below creates a user interface that
#has a title panel and a sidebar layout,which includes a sidebar
#panel and a main panel.Note that these elements are placed within
#the fluidPage function.

#titlePanel and sidebarLayout are the two most popular elements
#to add to fluidPage.They create a basic Shiny app with a sidebar.
#sidebarLayout always takes two arguments:
#1.sidebarPanel function output
#2.mainPanel function output
#These functions place content in either the sidebar or the main panels.
#The sidebar panel will appear on the left side of your app by default.
#You can move it to the right by giving sidebarLayout the optional
#argument position="right".

#titlePanel and sidebarLayout create a basic layout for your Shiny
#app,but you can also create more advanced layouts.You can use 
#navbarPage to give you app a multi-page user interface that includes
#a navigation bar.Or you can use fluidPage and column to build your
#layout up from a grid system.
#https://shiny.rstudio.com/articles/layout-guide.html

#Formatted text
#Shiny offers many tag functions for formatting text.The easier way
#to describe them is by running through an example.


ui<-fluidPage(
  titlePanel("My Shiny App"),
  
  sidebarLayout(
    sidebarPanel (),
    mainPanel (
      h6("Episode IV",align="center"),
      h6("A NEW HOPE",align="center"),
      h2("It is a period of civil war.",align="center"),
      h3("Rebel spaceships, striking",align="center"),
      h4("from a hidden base, have won",align="center"),
      h5("their first victory against the",align="center"),
      h6("evil Galactic Empire.")
    )
  )
)

#Define server logic ----
server<-function(input,output){
  
}

#Run the app ----
shinyApp(ui = ui,server = server)







