library(shiny)

library(maps)
library(mapproj)
source("helpers.R")
counties<-readRDS("data/counties.rds")
# percent_map(counties$white,"darkgreen","% White")

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


# ui<-fluidPage(
#   titlePanel("My Shiny App"),
#   
#   sidebarLayout(
#     sidebarPanel (),
#     mainPanel (
#       p("p creates a paragraph of text."),
#       p("A new p() command starts a new paragraph.Supply a style
#         attribute to change the format of the entire paragraph.",style=
#           "font-family:'times';font-sil6pt"),
#       strong("strong() makes bold text."),
#       em("em() creates italicized (i.e,emphasized) text."),
#       br(),
#       code("code displays your text similar to computer code"),
#       div("div creates segments of text with a similar style.This 
#           division of text is all blue because I passed the argument 
#           'style=color:blue' to div",style="color:blue"),
#       br(),
#       p("span does the same thing as div ,but it works with",
#         span("groups of words",style="color:blue"),
#         "that appear inside a paragraph.")
#     )
#   )
# )


#Images
#Images can enhance the appearance of you app and help your users
#understand the content.Shiny looks for the img function to place
#image files in your app.

#To insert an image,give the img function the name of your image
#file as the src argument(e.g.,img(src="my_image.png")).You must
#spell out this argument since img passes your input to an HTML
#tag,and src is what the tag expects.

#You can also include other HTML friendly parameters such as height
#and width.Note that height and width numbers will refer to pixels.
#img(src="my_image.png",height=72,width=72)

#The img function looks for your image file in a speciic place.Your
#file must be in a folder named www in the same directory as the
#app.R script.Shiny treats this directory in a special way.Shiny will
#share any file placed here with your user's web browser,which makes
#www a great place to put image,style sheets,and other things the
#browser will need to build the wep components of your Shiny app.

# ui<-fluidPage(
#   titlePanel("My Shiny App"),
#   sidebarLayout(
#     sidebarPanel(
#       strong(h2("Installation")),
#       p("Shiny is available on CRAN,so you can install it in the
#         usual way from your R console:"),
#       p('install.package("shiny")',style="color:red",align="center"),
#       br(),
#       div(img(src="rstudio.png",height=70,width=200),align="right"),
#       p("Shiny is a product of",span("RStudio",style="color:blue"))
#     ),
#     mainPanel(
#       h1("Introducing Shiny"),
#       p("Shiny is a new package from RStudio that incredibly easy
#         to build interactive web applications with R."),
#       br(),
#       p("For an introduction and live examples,visit the",a("Shiny homepage",
#                                                             href="http://shiny.rstudio.com")),
#       br(),
#       h1("Features"),
#       em("-Build useful web applications with only a few lines of
#          codes-no JavaScript required."),
#       p("-Shiny applications are automatically 'live' in the
#            same way that,",strong("spreadsheets"),
#         "are live. Outputs change instantity as users modify inputs,
#         without requiring a reload of the browser.")
#     )
#   )
# )


#Lesson 3
#Add control widgets
#Basic widgets:Buttons,Date range,Radio buttons,Single checkbox,
#File input,Select box,Checkbox group,Help text,Sliders,Date input,
#Numeric input,Text input
#https://shiny.rstudio.com/articles/layout-guide.html

# ui<-fluidPage(
#   titlePanel("Basic widgets"),
#   
#   fluidRow(
#     column(3,
#            h3("Buttons"),
#            actionButton("action","Action"),
#            br(),
#            br(),
#            submitButton("Submit")),
#     column(3,
#            h3("Single checkbox"),
#            checkboxInput("checkbox","Choice A",value=TRUE)),
#     column(3,
#            checkboxGroupInput("checkGroup",
#                               h3("Checkbox group"),
#                               choices = list("Choice 1"=1,
#                                              "Choice 2"=2,
#                                              "Choice 3"=3),
#                               selected = 1)),
#     column(3,
#            dateInput("date",
#                      h3("Date input"),
#                      value = "2017-09-05"))
#   ),
#   
#   fluidRow(
#     column(3,
#            dateRangeInput("date",h3("Date range"))),
#     column(3,
#            fileInput("file",h3("File input"))),
#     column(3,
#            h3("Help text"),
#            helpText("Note: help text isn't a true widget,",
#                     "but it provides an easy way to add text to",
#                     "accompany other widgets.")),
#     column(3,
#            numericInput("num",
#                         h3("Numeric input"),
#                         value = 1))
#   ),
#   
#   fluidRow(
#     column(3,
#            radioButtons("radio",h3("Radio buttons"),
#                         choices = list("Choice 1"=1,"Choice 2"=2,
#                                        "Choice 3"=3),selected = 1)),
#     column(3,
#            sliderInput("slider1",h3("Sliders"),
#                        min=0,max=100,value = 50),
#            sliderInput("slider2","",
#                        min=0,max=100,value = c(25,75))
#            ),
#     column(3,
#            textInput("text",h3("Text input"),
#                      value = "Enter text..."))
#   )
# 
# )


# ui <- fluidPage(
#   titlePanel("censusVis"),
#   
#   sidebarLayout(
#     sidebarPanel(
#       helpText("Create demographic maps with 
#                information from the 2010 US Census."),
#       
#       selectInput("select1",h3("Choose a variable to display"),
#                   choices = list("Percent White"=1, 
#                                  "Percent Black"=2,
#                                  "Percent Hispanic"=3, 
#                                  "Percent Asian"=4),
#                   selected = 1),
#       
#       sliderInput("slider1", h3("Range of interest:"),
#                   min = 0, max = 100, value = c(0, 100))
#       ),
#     
#     mainPanel()
#   )
# )

#http://shiny.rstudio.com/gallery/widget-gallery.html


#Lesson 4
#Display reactive output

#Two steps
#1.Add an R object to your user interface.
#2.Tell Shiny how to build the object in the server function.The
#object will be reactive if the coe that builds it calls a widget value.

#Step 1:Add an R object to the UI
#dataTableOutput:DataTable
#htmlOutput:raw HTML
#imageOutput:image
#plotOutput:plot
#tableOutput:table
#textOutput:text
#uiOutput:raw HTML
#verbatimTextOutput:text

ui<-fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from
               the 2010 US Census."),
      selectInput("var","Choose a variable to display",
                  choices = c("Percent White",
                              "Percent Black",
                              "Percent Hispanic",
                              "Percent Asian"),
                  selected = "Percent Black"),
      sliderInput("range","Range of interest:",
                  min=0,max=100,value = c(0,100))
      ),
    
    mainPanel(
      # textOutput("selected_var"),
      # textOutput("min_max"),
      plotOutput("map")
    )
)
)

#Notice that textOutput takes an argument,the character string
#"selected_var".Each of the *Output functions require a single
#argument:a character string that Shiny will use as the name of
#your reactive element.Your users will not see this name,but you
#will use it later.


#Step2:Provide R code to build the object.
#Placing a function in ui tells Shiny where to display your object.
#Next,you need to tell Shiny how to build the object.

#We do this by providing the R code that builds the object in the
#server function.

#The server function plays a special role in the Shiny process;
#it builds a list-like object named output that contains all of
#the code needed to update the R objects in your app.Each R object
#needs to have its own entry in the list.

#In the server function below,output$selected_var matches
#textOutput("selected_var") in your ui.


# #Define server logic ----
# server<-function(input,output){
#   output$selected_var<-renderText({
#     "You have selected this"
#   })
# }

#You do not need to explicitly state in the server function to 
#return output in its last line of code.R will automatically
#update output through reference class semantics.

#Each entry to output should contain the output of one of Shiny's
#render* functions.These functions capture an R expression and
#do some light pre-processing on the expression.Use the render*
#function that corresponds to the type of reactive object you
#are making.

#renderDataTable:DataTable
#renderImage:images(saved as a link to a source file)
#renderPlot:plots
#renderPrint:any printed output
#renderTable:data frame,matrix,outher table like structures
#renderText:character strings
#renderUI:a Shiny tag object or HTML

#Each render* function takes a single argument:an R expression 
#surrounded by braces,{}.The expression can be one simple line 
#of text,or it can involve many lines of code,as if it were a
#complicated function call.

#Think of this R expression as a set of instructions that you 
#give Shiny to store for later.Shiny will run the instructions
#when you first launch your app,and then Shiny will rerun the
#instructions every time it needs to update your object.

#For this to work,your expression should return the object you
#have in mind.You will get an error if the expression does not 
#return an object,or if it returns the wrong type of object.


#Use widget values
#Take a look at the first line of code in the server function.
#Do you notice that the server function mentions two arguments,
#input and output? You already saw that output is a list-like
#object that stores instructions for building the R object in
#your app.

#input is a second list-like object.It stores the current values
#of all of the widgets in your app.These values will be saved
#under the names that you gave the widgets in you ui.

#So for example,our app has two widgets,one named "var" and one
#named "range".The values of "var" and "range" will be saved in
#input as input$var and input$range.Since the slider widget has
#two values,input$range will contain a vector of length two.

#Shiny will automatically make an object reactive if the object 
#uses an input value.For example, the server function below
#function creates a reactive line of text by calling the value
#of the select box widget to build the text.


# server<-function(input,output){
#   output$selected_var<-renderText({
#     paste("You have selected",input$var)
#   })
#   
#   output$min_max<-renderText({
#     paste("You have chosen a range that goes from",
#           input$range[1],"to",input$range[2])
#   })
#   
#   output$map<-renderPlot({
#     percent_map(counties$white,"darkgreen","% white")
#   })
# }

#Shiny tracks which outputs depend on which widgets.When a user
#changes a widget,Shiny will rebuild all of the outputs that
#depend on the widget,using the new value of the widget as it goes.
#As a result,the rebuild objects will be completely up-to-date.

#runApp("census-app",display.mode=""showcase)
#When the server portion of the script.When Shiny rebuilds an output,
#it highlights the code it is running.


#Lesson 5
#Use R scripts and data

#The dataset in counties.rds contains
#the name of each county in the United States
#the total population of the county
#the percent of residents in the county who are White,Black,Hispanic,or Asian

#counties<-readRDS("my_app/data/counties.rds")
#head(counties)

#helps.R is an R script that can help you make choroleth maps.
#A choropleth map is a map that uses color to display the regional
#variation of variable.In our case,helpers.R will create percent_map,
#a function designed to map the data in counties.rds.

#helpers.R uses the maps and mapproj packages in R.
#install.packages(c("maps","mapproj"))

#The percent_map function helpers.R takes five arguments:
#var:a column vector from the counties.rds dataset
#color:any character string you see in the output of colors()
#legend.title:A character stiring to use as the title of the plot's legend
#max:A parameter for controlling shade range(defaults to 100)
#min:A parameter for controlling shade range(defaults to 0)

# library(maps)
# library(mapproj)
# source("my_app/helpers.R")
# counties<-readRDS("my_app/data/counties.rds")
# percent_map(counties$white,"darkgreen","% White")

#When Shiny runs the commands in server.R,it will treat all file paths
#as if they begin in the same directory as server.R.In other words,the
#directory that you save server.R in will become the working directory
#of your Shiny app.


#Execution
#Shiny will run the whole script the first time you call runApp.
#Run once when app is launched

#Shiny saves the server function until a new user arrives.Each time 
#a new user visits your app,Shiny runs the server function again,one
#time.The function helps Shiny build a distinct set of reactive objects
#for each user.
#Run once each time a user visits the app

#As users interact with the widgets and change their values,Shiny will
#re-run the R expression assigned to each reactive object that depend
#on a widget whole value was changed.If you r user is very active,these
#expression may be re-run many,many times a second.
#Run once each time a user changes a widget that output$map depends on

#The ShinyApp function is run once,when you launch your app
#The server function is run once each time a user visits your app
#The R expressions inside render* functions are run many times.

#Source scripts,load libraries,and read data sets at the beginning of
#app.R outside of the server function.Shiny will only run this code once,
#which is all you need to set your server up to run the R expressions
#contained in server.

#Define user specific objects inside server function,but outside of any
#render* calls.These would be objects that you think each user will need
#their own personal copy of. For example,an object that records the user's
#session information.This code will be run once per user.

#Only place code that Shiny must return to build an object inside of a 
#render* function.Shiny will return all of the code in a render* chunk
#each time a user changes a widget mentioned in the chunk.This can be
#quite often.

#You should generally avoid placing code inside a render function that
#does not need to be there.Doing so will slow down the entire app.

# server<-function(input,output){
#   output$map<-renderPlot({
#     percent_map(counties$white,"darkgreen","% white")
#   })
# }

#The census visualization app has one reactive object,a plot named
#"map".The plot is built with the percent_map function,which takes
#five arguments.
#The first three arguments,var,color,and legend.title,depend on the
#the value of the select box widget.
#The last two arguments,max and min,should be the max and min values
#of the slider bar widget.

#The server function below show one way to craft reactive arguments
#for percent_map.R's switch function can transform the output of a
#select box widget to whatever you like.However,the script is incomplete.
#It does not provide values for color,legend.title,max,or min.


# server<-function(input,output){
#   output$map<-renderPlot({
#     data<-switch(input$var,
#                  "Percent White"=counties$white,
#                  "Percent Black"=counties$black,
#                  "Percent Hispanic"=counties$hispanic,
#                  "Percent Asian"=counties$asian)
#     color<-switch(input$var,
#                   "Percent White"="darkgreen",
#                   "Percent Black"="black",
#                   "Percent Hispanic"="darkorange",
#                   "Percent Asian"="darkviolet")
#     legend<-switch(input$var,
#                    "Percent White"="% White",
#                    "Percent Black"="% Black",
#                    "Percent Hispanic"="% Hispanic",
#                    "Percent Asian"="% Asian")
#     percent_map(data,color,legend,input$range[1],input$range[2])
#   })
# }


#A more concise version of the server function
# server<-function(input,output){
#   output$map<-renderPlot({
#     args<-switch(input$var,
#                  "Percent White"=list(counties$white,"darkgreen","% White"),
#                  "Percent Black"=list(counties$black,"black","% Black"),
#                  "Percent Hispanic"=list(counties$hispanic,"darkorange","% Hispanic"),
#                  "Percent Asian"=list(counties$asian,"darkviolet","% Asian"))
#     args$min<-input$range[1]
#     args$max<-input$range[2]
#     
#     do.call(percent_map,args)
#   })
# }


#Lesson 6
#Use reactive expressions
#install.packages("quantmod")

#1.It uses getSymbols to download financial data straight into R from
#websites like Google finance.
#2.It uses chartSeries to display prices in an attractive chart.

#Check boxes and date ranges
#a date range selector,created with dateRangeInput
#a couple of check boxes made with checkboxInput.return TRUE or FALSE

#The check boxes are named log and adjust in the ui object,which means
#you can look them up as input$log and input$adjust in the server function.


#Streamline compution

#A reactive expression saves its result the first time you run it.
#The next time the reactive expression is called,it checks if the saved
#value has become out of date
#If the value is out of date,the reactive object will recalculate it
#If the value is up-to-date,the reactive expression will return the saved
#value without doing any computation.


# server <- function(input, output) {
#   
#   dataInput <- reactive({
#     getSymbols(input$symb, src = "google", 
#                from = input$dates[1],
#                to = input$dates[2],
#                auto.assign = FALSE)
#   })
#   
#   output$plot <- renderPlot({
#     
#     chartSeries(dataInput(), theme = chartTheme("white"), 
#                 type = "line", log.scale = input$log, TA = NULL)
#   })
#   
# }

#1.renderPlot will call dataInput()
#2.dataInput will check that the dates and symb widgets have not changed
#3.dataInput will return its saved data set of stock prices without re-fetching
#data from Google.
#4.renderPlot will re-draw the chart with the correct axis.

# server<-function(input,output){
#   dataInput<-reactive({
#     getSymbols(input$symb,src="google",
#                from=input$dates[1],
#                to=input$dates[2],
#                auto.assign = FALSE)
#   })
#   
#   output$plot<-renderPlot({
#     data<-dataInput()
#     
#     if(input$adjust)data<-adjust(dataInput())
#     
#     chartSeries(data,theme = chartTheme("white"),
#                 type = "line",log.scale = input$log,TA=NULL)
#   })
# }


#adjust is called inside renderPlot.If the adjust box is checked,
#the app will readjust all of the prices each time you switch
#from a normal y scale to a logged y scale.This readjustment is
#unnessary work.

#Fix this problem by adding a new reactive expression to the app.
#The reactive expression should take the value of dataInput and
#return an adjusted copy of the data.

# server<-function(input,output){
#   dataInput<-reactive({
#     getSymbols(input$symb,src="google",
#                from=input$dates[1],
#                to=input$dates[2],
#                auto.assign=FALSE)
#   })
#   
#   finalInput<-reactive({
#     if(!input$adjust) return (dataInput())
#     adjust(dataInput())
#   })
#   
#   output$plot<-renderPlot({
#     chartSeries(finalInput(),theme=chartTheme("white"),
#                 type="line",log.scale=input$log,TA=NULL)
#   })
# }


#Now you have isolated each input in its own reactive expression
#or render* function.If an input changes,only out of date expression
#will re-run.

#A user clicks "Plot y axis on the log scale."
#renderPlot re-runs.
#renderPlot calls finalInput.
#finalInput checks with dataInput and input$adjust.
#If neither has changed,finalInput returns its saved value
#If either has changed,finalInput calculateds a new value
#with the current inputs.It will pass the new value to renderPlot
#and store the new value for future queries.


#Lesson 7
#Share your apps

#When it comes to sharing Shiny apps,you have two basic options:
#1.Share your Shiny app as R scripts.This is the simplest way to
#share an app,but it works only if your users have R on their
#own computer.Users can use these scripts to launch the app from
#their own R session.

#2.Share your Shiny app as a web page.This is definitely the
#most user friendly way to share a Shiny app.Your users can
#navigate to your app through the internet with a web browser.
#They will find your app fully rendered,up to date,and ready to go.


#Share as R scripts
#runUrl:will download and launch a Shiny app straight from a weblink
#To use runURL:
#-Save your Shiny app's directory as a zip file
#-Host that zip file at its own link on a web page.Anyone with
#access to the link can launch the app from inside R by running.

# runUrl("<the weblink>")


#runGitHub
# runGitHub("<your repository name>","<your user name>")


#runGist
#To share your app as gist:
#-Copy and paste your app.R files to the gist web page.
#-Note the URL that GitHub gives the gist.

#Once you've made a gist,your users can launch the app with
#runGist("<gist number>") where "<gist number>" is the number
#that appears at the end of your Gist's web address.

# runGist("eb3470beb1c0252bd0289cbc89bcf36f")


#Share as a web page
#All of the above methods share the same limitation.They require
#your user to have R and Shiny installed on their computer.

#However,Shiny creates the perfect opportunity to share output
#with people who do not have R.If you host the app as its own
#URL,users can visit the app and not need to worry about the code
#that generates it.

#RStudio offers four ways to host Shiny app as a web page:
#1.shinyapps.io
#2.Shiny Server
#3.Shiny Server Pro
#4.Rstudion Connect

#Shinyapps.io
#The easiest way to turn your Shiny app into a web page is to use
#shinyapps.io,RStudio's hosting service for Shiny apps.

#shinyapps.io lets you upload your app straight from your R session
#to a server hosted by RStudio.You have complete control over your
#app including server administration tools.
#http://www.shinyapps.io/


#Shiny Server
#Shiny Server is a companion program to Shiny that builds a web
#server designed to host Shiny apps.

#Shiny Server is a server program that Linux servers can run to 
#host a Shiny app as a web page.

#You can host multiple Shiny application on multiple web pages 
#with the same Shiny Server,and you can deploy the apps from
#behind a firewall.

#Shiny Server Pro
#Shiny Server will get your app to the web and take care of all
#of your Shiny publishing needs.However,if you use Shiny in a 
#forprofit setting,you may want to give yourself the server tools
#that come with most paid server program,such as
#-Password authentification
#-SSL support
#-Administrator tools
#-Priority support
#-and more


#RStudio Connect
#RStudio Connect is a new publishing platform for the work your
#team cerate in R.Share Shiny applications,R markdown reports,
#dashboards,plots and more in one convenient place.With RStudio
#Connect,you can publish from the RStudio IDE wiht the push of 
#a button and schedule execution of reports and flexible security policies.


#Run the app ----
shinyApp(ui = ui,server = server)
