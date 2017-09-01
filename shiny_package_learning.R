#Leaern Shiny

#Lesson 1

# install.packages("shiny")
library(shiny)

runExample("01_hello") #a histogram
runExample("02_text") #tables and data frames
runExample("03_reactivity") #a reactive expression
runExample("04_mpg") #global variables
runExample("05_sliders") #slider bars
runExample("06_tabsets") #tabbed panels
runExample("07_widgets") #help text and submit buttons
runExample("08_html") #shiny app build from html
runExample("09_upload") #file upload wizard
runExample("10_download") #file download wizard
runExample("11_text")

#new directory named my_app
#app.R contains ui and server two parts
runApp("my_app")

runApp("my_app",display.mode = "showcase")







