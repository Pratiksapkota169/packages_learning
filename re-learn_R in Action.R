# re-learn <R in Action,Second Edition>

### brief contents
#### PART 1   Getting Started
# - 1.Introduction to R
# - 2.Creating a dataset
# - 3.Getting started with graphs
# - 4.Basic data management
# - 5.Advanced data managent

#### PART 2 Basic Methods
# - 6.Basic graphs
# - 7.Basic statistics

#### PART 3 Intermediate Methods
# - 8.Regression
# - 9.Analysis of variance
# - 10.Power analysis
# - 11.Intermediate graphs
# - 12.Resampling statistics and boostrapping

#### PART 4 Advanced Methods
# - 13.Generalized linear models
# - 14.Principal components and factor analysis
# - 15.Time series
# - 16.Cluster analysis
# - 17.Classification
# - 18.Advanced methods for missing data

#### PART 5 Expanding Your Skills
# - 19.Advanced graphics with ggplot2
# - 20.Advanced programming
# - 21.Creating a package
# - 22.Creating dynamic reports
# - 23.Advanced graphics with the lattice package

#### Listing 1.1 A sample R session
age <- c(1, 3, 4, 2, 11, 9, 3, 9, 12, 3)
weight <- c(4.4, 5.3, 7.2, 5.2, 8.5, 7.3, 6.0, 10.4, 10.2, 6.1)
mean(weight)
sd(weight)
cor(age, weight)
plot(age, weight)

#### Listing 1.2 An example of commands used to manage the R workspace
getwd()
ls()
options()#Lets you view or set current options
history()#Displays your last commands (default=25)
savehistory("myfile")#saves the commands history to myfile (default=.Rhistory)
loadhistory("myfile")
save.image("myfile")#saves the workspace to myfile (default=.RData)
save(objectlist, file = "myfile")
load("myfile")#loads a workspace into the current session
q()


bmp("filename.bmp")
jpeg("filename.jpg")
pdf("filename.pdf")
png("filename.png")
postscript("filename.ps")
svg("filename.svg")
win.metafile("filename.wmf")


sink("myoutput", append = TRUE, split = TRUE)
pdf("mygraphs.pdf")
source("script2.R")

sink()
dev.off()
source("script3.R")

#### Listing 1.3 Working with a new package
help.start()


#Vecotrs:are one-dimensional arrays that can hold numeric data,
#character data,or logical data.
#The combine function c() is  used to form the vector
#Note that the data in a vector must be only one type or mode.You
#can't mix modes in the same vector.

#"Scalars" are one-element vectors
#You can refer to elements of a vector using a numeric vector of
#positions within brackets.
a <- c("k", "j", "h", "a", "c", "m")
a[3]
a[c(1, 3, 5)]
a[2:6]#contain two boundaries


#Matrices:is a two-dimensional array in which each element has the
#same mode.Matrices are created with the matrix() function.The general
#format is
#mymatrix<-matrix(vector,nrow=nm_of_rows,ncol=number_of_columns,
#                 byrow=logical_value,
#                 dimnames=list(char_vector_rownames,char_vector_colnames))


#### Listing 2.1 Creating matrices
y <- matrix(1:20, nrow = 5, ncol = 4)
y
cells <- c(1, 26, 24, 68)
rnames <- c("R1", "R2")
cnames <- c("C1", "C2")
mymatrix <- matrix(
  cells,
  nrow = 2,
  ncol = 2,
  byrow = TRUE,
  dimnames = list(rnames, cnames)
)
mymatrix

mymatrix <- matrix(
  cells,
  nrow = 2,
  ncol = 2,
  byrow = FALSE,
  dimnames = list(rnames, cnames)
)
mymatrix


#### Listing 2.2 Using matrix subscripts
x <- matrix(1:10, nrow = 2)
x
x[2,]
x[, 2]
x[1, 4]
x[1, c(4, 5)]


#Arrays:are similar to matrices but can have more than two dimensions.
#They're created with an array function of the following form
#myarray<-array(vector,dimensions,dimnames)


#### Listing 2.3 Creating an array
dim1 <- c("A1", "A2")
dim2 <- c("B1", "B2", "B3")
dim3 <- c("C1", "C2", "C3", "C4")
z <-
  array(1:24, c(2, 3, 4), dimnames = list(dim1, dim2, dim3))#2*3*4 dims
z

#Data frames:is more general than a matrix in that different columns
#can contain different modes of data.


#### 2.4 Creating a data frame
patientID <- c(1, 2, 3, 4)
age <- c(25, 34, 28, 52)
diabets <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")
patientdata <- data.frame(patientID, age, diabets, status)
patientdata


#### 2.5 Specifying elements of a data frame
patientdata[1:2]

patientdata[c("diabets", "status")]

patientdata$age

table(patientdata$diabets, patientdata$status)#row,col:pivot table

summary(mtcars$mpg)
plot(mtcars$mpg, mtcars$disp)

attach(mtcars)
summary(mpg)
plot(mpg, disp)
plot(mpg, wt)
detach(mtcars)

with(mtcars, {
  print(summary(mpg))
  plot(mpg, disp)
  plot(mpg, wt)
})


with(mtcars, {
  nokeepstats <- summary(mpg)
  keepstats <<- summary(mpg)
  #operator <<- saves the object to the global environment
  #outside of the with() call
})
nokeepstats
keepstats


#Factors:categorical and order categorical variables are called factors

status <- c("Poor", "Improved", "Excellent", "Poor")
status <- factor(status, ordered = TRUE)
#encode the vector as (3,2,1,3) and associate these values internally
#as 1=Excellent,2=Improved,and 3=Poor
status

#By default,factor levels for character are created in alphabetical order.

status <- factor(status,
                 order = TRUE,
                 levels = c("Poor", "Improved", "Excellent"))
status

#Any data values not in the list will be set to missing


#Listing 2.6 Using factors
patientID <- c(1, 2, 3, 4)
age <- c(25, 34, 28, 52)
diabetes <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")
diabetes <- factor(diabetes)
status <- factor(status, ordered = TRUE)
patientdata <- data.frame(patientID, age, diabetes, status)
str(patientdata)
summary(patientdata)


#Lists:is an ordered collection of objects
#allows to gather a variety of objects under one name

#Listing 2.7 Creating a list
g <- "My First List"
h <- c(25, 26, 28, 39)
j <- matrix(1:10, nrow = 5)
k <- c("one", "two", "three")
mylist <- list(title = g, age = h, j, k)
mylist

mylist[[2]]
mylist[["age"]]#just values
mylist["age"]#concluding index:$age


#The file can be imported into a data frame:
grades <- read.table(
  "studentgrade.csv",
  header = TRUE,
  row.names = "StudentID",
  sep = ","
)

install.packages("xlsx")
library(xlsx)
mydataframe <- read.xlsx("filename.xlsx", 1)

library(RODBC)
odbcConnect(dsn, uid = "", pwd = "")
sqlFetch(channel, sqltable)
sqlQuery(channel, query)
sqlSave(channel, mydf, tablename = sqltable, append = FALSE)
sqlDrop(channel, sqltable)
close(channel)


#Useful function for working with data objects
length(object) #Gives the number of elements/components
dim(object) #Gives the dimensions of an object
str(object) #Give the structure of an object
class(object) #Gives the class of an object
mode(object) #Determines how an object is stored
names(object) #Gives the names of components in an object
c(object, object, ...)
cbind(object, object, ...)
rbind(object, object, ...)
object
head(object)
tail(object)
ls()
rm(object, object, ...)
newobject <- edit(object) #Edits object and saves it as newobject
fix(object) #Edits an object in place


pdf("mygraph.pdf")
attach(mtcars)
plot(wt, mpg)
abline(lm(mpg ~ wt))
title("Regression of MPG on Weight")
detach(mtcars)
dev.off()

dev.new()#create graph


dose <- c(20, 30, 40, 45, 60)
drugA <- c(16, 20, 27, 40, 60)
drugB <- c(15, 18, 25, 31, 40)

plot(dose, drugA, type = "b") #both points and lines should be plotted


#Graphical parameters
#customize many features of a graph (fonts,colors,axes,and labels)
#through options called graphical parameters.One way is to specify
#these options through the par() function.Values set in this manner
#will be in effect for the rest of the session or until they're
#changed.
#par(optionname=value,optionname=value,...)
#Adding the no readonly=TRUE option produces a list of current
#graphical settings that can be modified.

opar <- par(no.readonly = TRUE)
#makes a copy of the current settings
par(lty = 2, pch = 7)
#changes the default line type to dashed and the default symbol for
#plotting points to a solid triangle
plot(dose, drugB, type = "b")
par(opar)

plot(dose,
     drugA,
     type = "b",
     lty = 2,
     pch = 17)


#pch:Specifies the symbol to use when plotting points
#cex:Specifies the symbol size,cex is a number indicating the amount
#by which plotting symbols should be scaled relative to the default.
#1=default,1.5 is 50% larger,0.5 is 50% smaller,and so forth
#lty:Specifies the line type
#lwd:Specifies the line width,lwd is expressed relative to the default
#1=default,lwd=2 generate a line twice as wide as the default

#Colors
#Parameters for specifying colors

#col:Default plotting color.Some functions(such as lines and pie)
#accept a vector of value that are recycled.For example,if col=
#c("red","blue") and three lines are plotted,the first line will be
#read,the second blue,and the third red.

#col.axis:Color for axis text
#col.lab:Color for axis labels
#col.main:Color for titles
#col.sub:Color for subtitles
#fg:Color for the plot's foreground
#bg:Color for the plot's background

#col=1;col="white";col="#FFFFF";col=rgb(1,1,1);col=hsv(0,0,1)

#colors()
#create vectors of contiguous colors:
#rainbow(),heat.colors(),terrain.colors(),topo.colors(),cm.colors()


#The RColorBrewer package is particularly popular for creating
#attractive color palettes.
#install.packages("RColorBrewer")

library(RColorBrewer)
n <- 7
mycolors <- brewer.pal(n, "Set1")
barplot(rep(1, n), col = mycolors)
#return a vector of seven colors in hexadecimal format from the Set1 palette

#gray(1:10/10):produces 10 gray levels
n <- 10
mycolors <- rainbow(n)
pie(rep(1, n), labels = mycolors, col = mycolors)
mygrays <- gray(0:n / n)
pie(rep(1, n), labels = mygrays, col = mygrays)


#Text characteristics
#Parameters specifying text size
#cex:Number indicating the amount by which plotted text should be
#scaled relative to the default 1=default

#cex.axis:Magnification of axis text relative to cex
#cex.lab:Magnification of axis labels relative to cex
#cex.main:Magnification of titles relative to cex
#cex.sub:Magnification of subtitles relative to cex


par(
  font.lab = 3,
  cex.lab = 1.5,
  font.main = 4,
  cex.main = 2
)

#Parameters specifying font family,size,and style
#font:Integer specifying the font to use for plotted text.
#1=plain,2=bold,3=italic,4=bold italic,5=symbol(in Adobe symbol encoding)

#font.axis:Font for axis text
#font.lab:Font for axis labels
#font.main:Font for titles
#font.sub:Font for subtitles
#ps:Font point size(roughly 1/72 inch).The text size=ps*cex
#family:Font family for drawing text.Standard values are serif,sans,and mono.


#on Windows platforms:
#mono is mapped to TT Courier New (TT stands for TrueType)
#serif is mapped to TT Times New Roman
#sans is mapped to TT Arial

#On Windows,you can create this mapping via the windowsFont() function

windowsFonts(
  A = windowsFont("Arial Black"),
  B = windowsFont("Bookman Old Style"),
  C = windowsFont("Comic Sans MS")
)

#If graphs will be output in PDF or PostScript format,changing the
#font family is relatively straightforward.For PDFs,use names(pdfFonts())
#to find out which fonts are available on your system and pdf(file=
#"myplot.pdf",family="fontname") to generate the plots.


#Graph and margin dimensions
#pin:Plot dimensions(width,height) in inches
#mai:Numerical vector indicating margin size,where c(bottom,left,
#top,right) is expressed in inches
#mar:Numerical vector indicating margin size,where c(bottom,left,
#top,right) is expressed in lines.The default is c(5,4,4,2)+0.1


#Listing 3.1 Using graphical parameters to control graph appearance
dose <- c(20, 30, 40, 45, 60)
drugA <- c(16, 20, 27, 40, 60)
drugB <- c(15, 18, 25, 31, 40)

opar <- par(no.readonly = TRUE)
par(pin = c(2, 3))
par(lwd = 2, cex = 1.5)
par(cex.axis = .75, font.axis = 3)
plot(
  dose,
  drugA,
  type = "b",
  pch = 19,
  lty = 2,
  col = "red",
  ann = FALSE
)
plot(
  dose,
  drugB,
  type = "b",
  pch = 23,
  lty = 6,
  col = "blue",
  bg = "green"
)

#Error in plot.new() : plot region too large
par("mar")#default setting
opar <- par(no.readonly = TRUE)
par(mar = rep(4, 4))


#Adding text,customized axes,and legends
plot(
  dose,
  drugA,
  type = "b",
  col = "red",
  lty = 2,
  pch = 2,
  lwd = 2,
  main = "Clinical Trials for Drug A",
  sub = "This is hypothetical data",
  xlab = "Dosage",
  ylab = "Drug Response",
  xlim = c(0, 60),
  ylim = c(0, 70)
)

#not all functions allow you to add these options
#Some high-level plotting functions include default titles
#and labels.You can remove them by adding ann=FALSE in the
#plot() statement or in a separate par() statement.

#Titles
title(
  main = "main title",
  sub = "subtitle",
  xlab = "x-axis label",
  ylab = "y-axis label"
)

title(
  main = "My Title",
  col.main = "red",
  sub = "My Subtitle",
  col.sub = "blue",
  xlab = "My X label",
  ylab = "My Y label",
  col.lab = "green",
  cex.lab = 0.75
)


#Axes
#axis(side,at=,labels=,pos=,lty=,col=,las=,tck=,...)
#side:integer indicating the side of the graph on which to draw
#the axis(1=bottom,2=left,3=top,4=right)
#at:Numeric vector indicating where tick marks should be drawn
#labels:Operacter vector of labels to be placed at the tick
#marks(if null,the at values are used)
#pos:Coordinate at which the axis line is to be drawn
#lty:Line type
#col:Line and tick mark color
#las:Specifies that labels are parallel(=0) or perpendicular
#(=2) to the axis
#tck:Length of each tick mark as a fraction of the plotting
#region (a negative number is outside the graph,a positive
#number is inside, 0 suppresses ticks, and 1 creates gridlines)
#The default is -0.01

#When creating a custom axis,you should suppress the axis that's
#automatically generated by the high-level plotting function.
#The option axes=FALSE suppresses all axes (including all axis
#frame lines,unless you add the option frame.plot=TRUE).The
#options xaxt="n"  and yaxt="n" suppress the x-axis and y-axis,
#respectively (leaving the frame lines,without ticks).


#Listing 3.2 An example of custom axes
x <- c(1:10)
y <- x
z <- 10 / x
opar <- par(no.readonly = TRUE)

par(mar = c(5, 4, 4, 8) + 0.1)

plot(
  x,
  y,
  type = "b",
  pch = 21,
  col = "red",
  yaxt = "n",
  lty = 3,
  ann = FALSE
)

lines(
  x,
  z,
  type = "b",
  pch = 22,
  col = "blue",
  lty = 2
)

axis(
  2,
  at = x,
  labels = x,
  col.axis = "red",
  las = 2
)

axis(
  4,
  at = z,
  labels = round(z, digits = 2),
  col.axis = "blue",
  las = 2,
  cex.axis = 0.7,
  tck = -.01
)

mtext(
  "y=1/x",
  side = 4,
  line = 3,
  cex.lab = 1,
  las = 2,
  col = "blue"
)

title("An Example of Creative Axes",
      xlab = "X Values",
      ylab = "Y=X")

par(opar)


#Reference lines

#The abline() function is used to add reference lines to a graph.
#The format is abline(h=yvalues,v=xvalues)
#Other graphical parameters (such as line type,color,and width)
#can also be specified in the abline() function.For example,
#abline(h=c(1,5,7)) adds solid horizontal lines at y=1,5,7,
#whereas the code abline(v=seq(1,10,2),lty=2,col="blue") add
#dashed blue vertical lines at x=1,3,5,7 and 9.

#Legend
legend(location, title, legend, ...)

#location:There are several ways to indicate the location of the
#legend.You can give an x,y coordinate for its upper-left corner.
#You can use location(1),in which case you use the mouse to
#indicate the legned's.You can also use the keyword bottom,
#bottomleft,left,topleft,top,topright,right,bottomright,or center
#to place the legend in the graph.If you use one of these keywords,
#you can also use inset=to sepecify an amount to move the legend
#into the graph.

#Listing 3.3 Comparing drug A and drug B reponse by dose
dose <- c(20, 30, 40, 45, 60)
drugA <- c(16, 20, 27, 40, 60)
drugB <- c(15, 18, 25, 31, 40)

#modify settings:lwd,cex,font.lab
opar <- par(no.readonly = TRUE)
par(lwd = 2,
    cex = 1.5,
    font.lab = 2)

#drwa a line
plot(
  dose,
  drugA,
  type = "b",
  pch = 15,
  lty = 1,
  col = "red",
  ylim = c(0, 60),
  main = "Drug A vs. Drug B",
  xlab = "Drug Dosage",
  ylab = "Drug Response"
)

#draw another line
lines(
  dose,
  drugB,
  type = "b",
  pch = 17,
  lty = 2,
  col = "blue"
)

#drwa a subline
abline(
  h = c(30),
  lwd = 1.5,
  lty = 2,
  col = "gray"
)

library(Hmisc)
#add minor ticks
minor.tick(nx = 3,
           ny = 3,
           tick.ratio = 0.5)#3等分，长度一半

#add legend
legend(
  "topleft",
  inset = .05,
  title = "Drug Type",
  c("A", "B"),
  lty = c(1, 2),
  pch = c(15, 17),
  col = c("red", "blue")
)

par(opar)


#Text annotations
#text(location,pos,side),mtext()
#location:Location can be an x,y coordinate.Alternatively,
#you can place the text interactively via mouse by specifying
#location as locator(1)

attach(mtcars)
plot(
  wt,
  mpg,
  main = "Mileage vs. Car Weight",
  xlab = "Weight",
  ylab = "Mileage",
  pch = 18,
  col = "blue"
)
text(
  wt,
  mpg,
  row.names(mtcars),
  cex = 0.6,
  pos = 4,
  col = "red"
)
detach(mtcars)

#The text() function is usedd to add the car make to the
#right of each data point.The point labels are shrunk by
#40% and presented in red.


opar <- par(no.readonly = TRUE)
par(cex = 1.5)
plot(1:7, 1:7, type = "n")
text(3, 3, "Example of default text")
text(4, 4, "Example of mono-spaced text")
text(5, 5, family = "serif", "Example of serif text")
par(opar)


#The resulting plot will differ from platform to platform,
#because plain,mono,and serif text are mapped to different
#font families on different systems


#Math annotations
#x+y:x+y
#x-y:x-y
#x*y:xy
#x/y:x/y
#x%+-%y:x±y
#x%/%y:x÷y
#x%*%y:x×y
#x%.%y:xy
#sqrt(x,y)
#x%~~%y
#x%=~%y
#x%==%y
#x%prop%y
#underline(x)

#Combining graphs
#With the par() function,you can include the graphical parameter
#mfrow=c(nrows,ncols) to create a matrix of nrows x ncols plots
#that are filled in by row.Alternatively,you can use mfool=c(nrows,
#ncols) to fill the matrix by columns.

attach(mtcars)
opar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
plot(wt, mpg, main = "Scatterplot of wt vs. mpg")
plot(wt, disp, main = "Scatterplot of wt vs. disp")
hist(wt, main = "Histogram of wt")
boxplot(wt, main = "Boxplot of wt")
par(opar)
detach(mtcars)


attach(mtcars)
opar <- par(no.readonly = TRUE)
par(mfrow = c(3, 1))
hist(wt)
hist(mpg)
hist(disp)
par(opar)
detach(mtcars)


attach(mtcars)
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE))
hist(wt)
hist(mpg)
hist(disp)
detach(mtcars)


attach(mtcars)
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE),
       widths = c(3, 1),
       heights = c(1, 2))
hist(wt)
hist(mpg)
hist(disp)
detach(mtcars)


#Listing 3.4 Fine placement of figures in a graph
opar <- par(no.readonly = TRUE)
par(fig = c(0, 0.8, 0, 0.8))
plot(mtcars$wt, mtcars$mpg,
     xlab = "Miles Per Gallon",
     ylab = "Car weight")

#c(x1,x2,y1,y2)
par(fig = c(0, 0.8, 0.55, 1), new = TRUE)
boxplot(mtcars$wt, horizontal = TRUE, axes = FALSE)

par(fig = c(0.65, 1, 0, 0.8), new = TRUE)
boxplot(mtcars$mpg, axes = FALSE)

mtext(
  "Enhanced Scatterplot",
  side = 3,
  outer = TRUE,
  line = -3
)

par(opar)


#Listing 4.1 Creating the leadership data frame
manager <- c(1, 2, 3, 4, 5)
date <- c("10/24/08", "10/28/08", "10/1/08", "10/12/08", "5/1/09")
country <- c("US", "US", "UK", "UK", "UK")
gender <- c("M", "F", "F", "M", "F")
age <- c(32, 45, 25, 39, 99)
q1 <- c(5, 3, 3, 3, 2)
q2 <- c(4, 5, 5, 3, 2)
q3 <- c(5, 2, 5, 4, 1)
q4 <- c(5, 5, 5, NA, 2)
q5 <- c(5, 5, 2, NA, 1)
leadership <- data.frame(manager,
                         date,
                         country,
                         gender,
                         age,
                         q1,
                         q2,
                         q3,
                         q4,
                         q5,
                         stringsAsFactors = FALSE)
leadership


#Listing 4.2 Creating new variables
mydata <- data.frame(x1 = c(2, 2, 6, 4),
                     x2 = c(3, 4, 2, 8))
mydata$sumx <- mydata$x1 + mydata$x2
mydata$meanx <- (mydata$x1 + mydata$x2) / 2

#or
attach(mydata)
mydata$sumx <- x1 + x2
mydata$meanx <- (x1 + x2) / 2

#or:prefer
mydata <- transform(mydata,
                    sumx = x1 + x2,
                    means = (x1 + x2) / 2)

#isTRUE(x):Tests whether x is TRUE

names(leadership)[2] <- "testDate"
names(leadership)
names(leadership)[6:10] <- c("item1", "item2", "item3", "item4", "item5")

library(plyr)
leadership <- rename(leadership,
                     c(manager = "managerID", testDate = "Date"))
names(leadership)


#Listing 4.3 Applying the is.na() function
is.na(leadership[, 6:10])

#First,missing values are considered noncomparable,even to themselves
#This means you can't use comparison operators to test for the
#presence of missing values.
#Second,R doesn't represent infinite or impossible values as
#missing values as missing values.

x <- c(1, 2, NA, 3)
y <- x[1] + x[2] + x[3] + x[4]
z <- sum(x)
z#return NA

y <- sum(x, na.rm = TRUE)
y#return 6

#na.omit():delete any rows with missing data


#Listing 4.4 Using na.omit() to delete incomplete observation
leadership
newdata <- na.omit(leadership)
newdata


#Date values
#as.Date(x,"input_format")
#%d:Day as a number 01-31
#%a:Abbreviated weekday Mon
#%A:Unabbreviated weekday Monday
#%m:Month 00-12
#%b:Abbreviated month Jan
#%B:Unabbreviated month January
#%y:Two-digit year 07
#%Y:Four-digit year 2007


strDates <- c("01/05/1965", "08/16/1975")
dates <- as.Date(strDates, "%m/%d/%Y")#指明原格式是啥,然后转成标准的年月日格式
dates

myformat <- "%m/%d/%y"
leadership
leadership$Date <- as.Date(leadership$Date, myformat)

Sys.Date()
date()

today <- Sys.Date()
format(today, format = "%B %d %Y")#转成指定格式
format(today, format = "%A")#星期二
format(today, format = "%a")#周二


startdate <- as.Date("2004-02-13")
enddate <- as.Date("2011-01-22")
days <- enddate - startdate
days


today <- Sys.Date()
dob <- as.Date("1956-10-12")
difftime(today, dob, units = "weeks")#return difference of weeks


strDates <- as.character(dates)
strDates


#Test:is.numeric(),is.character(),is.vector(),is.matrix(),
#is.data.frame(),is.factor(),is.logical()
#Convert:as.numeric(),as.character(),as.vector(),as.matrix(),
#as.data.frame(),as.factor(),as.logical()


#Sorting data
newdata <- leadership[order(leadership$age), ]#按age升序
newdata

attach(leadership)
newdata <- leadership[order(gender, age), ]
newdata
detach(leadership)


attach(leadership)
newdata <- leadership[order(gender, -age), ]#按age降序排列
newdata
detach(leadership)


#Merging datasets
#Adding columns to a data frame

total <- merge(dataframeA, dataframeB, by = c("ID", "Country"))

total <- cbind(A, B)
#must have the same number of rows and be sorted in the same order


#Adding rows to a data frame
total <- rbind(dataframeA, dataframeB)

#two data frames must have the same variables,but don't have to be
#in the same order.
#Delete the extra variables in dataframeA
#Create the additional variables in dataframeB,and set them to NA


#Selecting variables
newdata <- leadership[, c(6:10)]
newdata

myvars <- c("item1", "item2", "item3", "item4", "item5")
newdata <- leadership[myvars]
newdata


myvars <- paste("item", 1:5, sep = "")
newdata <- leadership[myvars]
newdata


#Excluding variables
myvars <- names(leadership) %in% c("item3", "item4")
newdata <- leadership[!myvars]
newdata

newdata <- leadership[c(-3, -4)]
newdata

leadership$item1 <- leadership$item2 <- NULL
leadership


#Listing 4.6 Selecting observations
newdata <- leadership[1:3, ]
newdata <- leadership[leadership$gender == "M" & leadership$age > 30, ]
newdata


#The subset() function
newdata <- subset(leadership, age >= 35 | age < 24,
                  select = c(item3, item5))
newdata <- subset(leadership, gender == "M" & age > 25,
                  select = gender:item4)


#Random samples
mysample <- leadership[sample(1:nrow(leadership), 3, replace = FALSE), ]
mysample

#Listing SQL statement to manipulate data frames
#install.packages("sqldf")
library(sqldf)
newdf <- sqldf("select * from mtcars where carb=1 order by mpg",
               row.names = TRUE)
newdf

sqldf(
  "select avg(mpg) as avg_mpg,avg(disp) as avg_disp,gear
  from mtcars where cyl in (4,6) group by gear"
)


#Statistical functions
#mean(x),median(x),sd(x),var(x),mad(x)#绝对中位差
#quantile(x,probs),range(x),sum(x),diff(x,lag=n)#滞后差分项
#min(x),max(x),scale(x,center=TRUE,scale=TRUE)#


#Listing 5.1 Calculting the mean and standard deviation
x<-c(1,2,3,4,5,6,7,8)
mean(x)
sd(x)


#Listing 5.2 Generating pseudo-random numbers from a uniform distribution
#runif():generate pseudo-random numbers from a nuiform distribution
#on the interval 0 to 1
#set.seed()

runif(5)
set.seed(1234)
runif(3)


#Listing 5.3 Generating data from a multivariate normal distribution
library(MASS)
options(digits=3)#保留
set.seed(1234)

mean<-c(230.7,146.7,3.6)
sigma <- matrix(c(15360.8, 6721.2, -47.1,
                  6721.2, 4700.9, -16.5,
                  -47.1, -16.5, 0.3), nrow=3, ncol=3)

mydata <- mvrnorm(500, mean, sigma)
mydata <- as.data.frame(mydata)
names(mydata) <- c("y","x1","x2")

dim(mydata)
head(mydata,n=10)


#Character functions
#nchar(x):Counts the number of characters of x
#substr(x,start,stop):Extracts or replaces substrings in a character vector

#grep(pattern,x,ignore.case=FALSE,fixed=FALSE):Search for pattern
#in x.If fixed=FALSE,then pattern is a regular expression.If fixed
#=TRUE,then pattern is a text string.Return the matching indices.

#sub(pattern,replacement,x,ignore.case=FALSE,fixed=FALSE)
#strsplit(x,split,fixed=FALSE)
#paste(...,sep="")
#toupper(x)
#tolower(x)

#length(x)
#seq(from,to,by)
#rep(x,n)
#cut(x,n):divides the continuous variable x into a factor with n levels
#pretty(x,n)
#cat(...,file="myfile",append=FALSE)


#Applying functions to matrices and data frames
#Listing 5.4 Applying functions to data objects
a<-250
sqrt(a)
options(digits = 5)#一共显示的位数，重启失效

b<-c(1.243, 5.654, 2.99)
round(b)

c<-matrix(runif(12),nrow = 3)
c
log(c)

mean(c)#takes the average of all 12 elements in the matrix

#Listing 5.5 Applying a function to the rows of a matrix
mydata<-matrix(rnorm(30),nrow=6)
mydata
apply(mydata,1,mean)#calculates the row means
apply(mydata,2,mean)#calculates the column means
apply(mydata,2,mean,trim=0.2)
#means based on the middle 60% of the data,with the bottom 20% and
#top 20% of the values discarded


#Listing 5.6 A solution to the learning example
options(digits = 2)
Student <- c("John Davis", "Angela Williams", "Bullwinkle Moose",
               "David Jones", "Janice Markhammer", "Cheryl Cushing",
               "Reuven Ytzrhak", "Greg Knox", "Joel England",
               "Mary Rayburn")
Math <- c(502, 600, 412, 358, 495, 512, 410, 625, 573, 522)
Science <- c(95, 99, 80, 82, 75, 85, 80, 95, 89, 86)
English <- c(25, 22, 18, 15, 20, 28, 15, 30, 27, 18)
roster <- data.frame(Student, Math, Science, English,
                       stringsAsFactors=FALSE)
roster
z<-scale(roster[,2:4])
score<-apply(z,1,mean)
score
roster<-cbind(roster,score)
roster

y<-quantile(score,c(.8,.6,.4,.2))
roster$grade[score>=y[1]]<-"A"
roster$grade[score<y[1] & score>=y[2]]<-"B"
roster$grade[score<y[2] & score>=y[3]]<-"C"
roster$grade[score<y[3] & score>=y[4]]<-"D"
roster$grade[score<y[4]]<-"F"
roster


name<-strsplit(roster$Student," ")
name

#"["is a function that extracts part of an object---here the first
#or second component of the list name
Lastname<-sapply(name,"[",2)
Lastname

Firstname<-sapply(name,"[",1)
Firstname

roster<-cbind(Firstname,Lastname,roster[,-1])
roster


roster<-roster[order(Lastname,Firstname),]
roster


#Listing 5.7 A switch example
feelings<-c("sad","afraid")
for(i in feelings){
  print(
    switch(i,
           happy="I am glad you are happy",
           afraid="There is nothing to fear",
           sad="Cheer up",
           angry="Calm down now"
    )
  )
}


#Listing 5.8 mystats():a user-written function for summary statistics
mystats<-function(x,parametric=TRUE,print=FALSE){
  if(parametric){
    cneter<-mean(x);spread<-sd(x)
  }else{
    center<-median(x);spread<-mad(x)
  }
  
  if(print & parametric){
    cat("Mean=",center,"\n","SD=",spread,"\n")
  }else if(print & !paremetric){
    cat("Median=",center,"\n","MAD=",spread,"\n")
  }
  
  result<-list(center=center,spread=spread)
  return(result)
}


#Listing 5.9 Transposing a dataset
cars<-mtcars[1:5,1:4]
cars
t(cars)


#Listing 5.10 Aggregating data
options(digits = 3)
attach(mtcars)
aggdata<-aggregate(mtcars,by=list(cyl,gear),FUN=mean,na.rm=TRUE)
aggdata


#install.packages("reshape2")
library(reshape2)


#Bar plots
install.packages("vcd")
library(vcd)

counts<-table(Arthritis$Improved)
counts

barplot(counts,main="Simple Bar Plot",
        xlab="Improvement",ylab="Frequency")
barplot(counts,main = "Horizontal Bar Plot",
        xlab = "Frequency",ylab = "Improvement",
        horiz = TRUE)

#If the categorical variable to be plotted is a factor or ordered factor
plot(Arthritis$Improved, main="Simple Bar Plot",
     xlab="Improved", ylab="Frequency")
plot(Arthritis$Improved, horiz=TRUE, main="Horizontal Bar Plot",
     xlab="Frequency", ylab="Improved")


counts<-table(Arthritis$Improved,Arthritis$Treatment)
counts
names(Arthritis)

#Listing 6.2 Stacked and grouped bar plots
barplot(counts,main = "Stacked Bar Plot",
        xlab = "Treatment",ylab = "Frequency",
        col = c("red","yellow","green"),
        legend=rownames(counts))
barplot(counts,main="Grouped Bar Plot",
        xlab = "Treatment",ylab = "Frequency",
        col = c("red","yellow","green"),
        legend=rownames(counts),beside = TRUE)


#Listing 6.3 Bar Plot for sorted mean values
states<-data.frame(state.region,state.x77)
View(states)
means<-aggregate(states$Illiteracy,by=list(state.region),FUN=mean)
means
means<-means[order(means$x),]
means
barplot(means$x,names.arg = means$Group.1)
title("Mean Illiteracy Rate")


#Listing 6.4 Fitting labels In a bar plot
par(mar=c(5,8,4,2))#increases the size of the y margin

par(las=2)#rotates the FL bar labels

counts<-table(Arthritis$Improved)
barplot(counts,main = "Treatment Outcome",
        horiz = TRUE,
        cex.names = 0.8,
        names.arg = c("No Improvement","Some Improvement","Marked Improvement"))

#Spinograms:脊髓造影图
library(vcd)
attach(Arthritis)
counts<-table(Treatment,Improved)
spine(counts,main = "Spinogram Example")
detach(Arthritis)


#Listing 6.5 Pie charts
par(mfrow=c(2,2))
slices<-c(10,12,4,16,8)
lbls<-c("US","UK","Australia","Germany","France")
pie(slices,labels = lbls,main="Simple Pie Chart")

pct<-round(slices/sum(slices)*100)
lbls2<-paste(lbls," ",pct,"%",sep = "")
pie(slices,labels = lbls,col = rainbow(length(lbls2)),
    main = "Pie Chart with Percentages")

#install.packages("plotrix")
library(plotrix)
pie3D(slices,labels = lbls,explode = 0.1,
      main="3D Pie Chart")
mytable<-table(state.region)
lbls3<-paste(names(mytable),"\n",mytable,sep = "")
pie(mytable,labels = lbls3,
    main = "Pie Chart from a Table\n (with sample sizes)")


library(plotrix)
slices<-c(10,12,4,16,8)
lbls<-c("US","UK","Australia","Germany","France")
fan.plot(slices,labels = lbls,main = "Fan Plot")


#Listing 6.6 Histograms
par(mfrow=c(2,2))

#default plot,five bins 
hist(mtcars$mpg)

#12 bins,red fill for the bars
hist(mtcars$mpg,breaks = 2,col = "red",
     xlab = "Miles Per Gallon",
     main = "Colored histogram with 12 bins")

#a density curve and rug-plot overlay
#the density curve is a kernel density estimate
#a rug plot is a one-dimensional representation of the actual data values
#if there are many tied values:
#rug(jitter(mtcars$mpg,amount=0.01))
hist(mtcars$mpg,freq = FALSE,
     breaks = 12,col = "red",
     xlab = "Miles Per Gallon",
     main = "Histogram,rug plot,density curve")

rug(jitter(mtcars$mpg))#加上x轴子坐标须

lines(density(mtcars$mpg),col="blue",lwd=2)

#a superimposed normal curve and a box around the figure
x<-mtcars$mpg
h<-hist(x,
        breaks = 12,col = "red",
        xlab = "Miles Per Gallon",
        main = "Histogram with normal curve and box")
xfit<-seq(min(x),max(x),length=40)
yfit<-dnorm(xfit,mean = mean(x),sd=sd(x))
yfit<-yfit*diff(h$mids[1:2])*length(x)
lines(xfit,yfit,col="blue",lwd=2)
box()


#Listing 6.7 Kernael density plots
par(mfrow=c(2,1))
d<-density(mtcars$mpg)
plot(d)

d<-density(mtcars$mpg)
plot(d,main = "Kernel Density of Miles Per Gallon")
polygon(d,col="red",border="blue")
rug(mtcars$mpg,col = "brown")#polygon多边形


#Listing 6.8 Comparative kernel density plots
# install.packages("sm")
library(sm)
attach(mtcars)
cyl.f<-factor(cyl,levels = c(4,6,8),
              labels = c("4 cylinder","6 cylinder","8 cylinder"))
sm.density.compare(mpg,cyl,xlab="Miles Per Gallon")
title(main = "MPG Distribution by Car Cylinders")

colfill<-c(2:(1+length(levels(cyl.f))))
legend(locator(1),levels(cyl.f),fill = colfill)
#locator(1) option:click in the graph where you want to appear

detach(mtcars)

boxplot(mtcars$mpg,main="Box plot",ylab="Miles per Gallon")

boxplot(mpg~cyl,data = mtcars,
        main="Car Mileage Data",
        xlab="Number of Cylinders",
        ylab="Miles Per Gallon")

#notched box:缺口箱图
boxplot(mpg~cyl,data = mtcars,
        notch=TRUE,
        varwidth=TRUE,
        col="red",
        main="Car Mileage Data",
        xlab="Number of Cylinders",
        ylab="Miles Per Gallon")

#varwidth

#Listing 6.9 Box plots for two crossed factors
mtcars$cyl.f<-factor(mtcars$cyl,levels = c(4,6,8),
                     labels = c("4","6","8"))
mtcars$am.f<-factor(mtcars$am,levels = c(0,1),
                    labels = c("auto","standard"))
boxplot(mpg~am.f*cyl.f,
        data = mtcars,
        varwidth=TRUE,
        col=c("gold","darkgreen"),
        main="MPG Distribution by Auto Type",
        xlab="Auto Type",ylab="Miles Per Gallon")


#Listing 6.10 Violin plots
install.packages("vioplot")
library(vioplot)

x1<-mtcars$mpg[mtcars$cyl==4]
x2<-mtcars$mpg[mtcars$cyl==6]
x3<-mtcars$mpg[mtcars$cyl==8]
vioplot(x1,x2,x3,
        names = c("4 cyl","6 cyl","8 cyl"),
        col = "gold")

#Dot plots
dotchart(mtcars$mpg,labels = row.names(mtcars),cex = .7,
         main = "Gas Mileage for Car Models",
         xlab = "Miles Per Gallon")

#Listing 6.11 Dot plot grouped,sorted,and colored
x<-mtcars[order(mtcars$mpg),]
x$cyl<-factor(x$cyl)

x$color[x$cyl==4]<-"red"
x$color[x$cyl==6]<-"blue"
x$color[x$cyl==8]<-"darkgreen"

dotchart(x$mpg,
         labels = row.names(x),
         cex = .7,
         groups = x$cyl,
         gcolor = "black",
         color = x$color,
         pch = 19,
         main = "Gas Mileage for Car Models\ngrouped by cylinder",
         xlab = "Miles Per Gallon")


#Listing 7.1 Descriptive statistics via summary()
myvars<-c("mpg","hp","wt")
head(mtcars[myvars])
summary(mtcars[myvars])

#Listing 7.2 Description statistics via sapply()
mystats<-function(x,na.omit=FALSE){
  if(na.omit)
    x<-x[!is.na(x)]
  m<-mean(x)
  n<-length(x)
  s<-sd(x)
  skew<-sum((x-m)^3/s^3)/n
  kurt<-sum((x--m)^4/s^4)/n - 3
  return(c(n=n,mean=m,stdev=s,skew=skew,kurtosis=kurt))
}

myvars<-c("mpg","hp","wt")
sapply(mtcars[myvars],mystats)


#Listing 7.3 Description statisticcs via describe() in the Hmisc package
library(Hmisc)
myvars<-c("mpg","hp","wt")
describe(mtcars[myvars])


#Listing 7.4 Descriptive statistics via stat.desc() in the pastecs package
install.packages("pastecs")
library(pastecs)
myvars<-c("mpg","hp","wt")
stat.desc(mtcars[myvars])


#Listing 7.5 Descriptive statistics via describe() in the psych package
install.packages("psych")
library(psych)
myvars<-c("mpg","hp","wt")
describe(mtcars[myvars])


#Listing 7.6 Descriptive statistics by group using aggregate()
myvars<-c("mpg","hp","wt")
aggregate(mtcars[myvars],by=list(am=mtcars$am),mean)
aggregate(mtcars[myvars],by=list(mtcars$am),mean)#label=Group.1

aggregate(mtcars[myvars],by=list(am=mtcars$am),sd)


#Listing 7.7 Descriptive statistics by group using by()
dstats<-function(x) sapply(x,mystats)
myvars<-c("mpg","hp","wt")
by(mtcars[myvars],mtcars$am,dstats)


#Listing7.8 Summary statistics by group using summaryBy() in the doBy package
#install.packages("doBy")
library(doBy)
summaryBy(mpg+hp+wt~am,data = mtcars,FUN = mystats)


#Listing 7.9 Summary statistics by group using describee.by() in the psych package
library(psych)
myvars<-c("mpg","hp","wt")
describeBy(mtcars[myvars],list(am=mtcars$am))


library(vcd)

#one-way tables
mytable<-with(Arthritis,table(Improved))
mytable
prop.table(mytable)*100

#two-way tables
mytable<-xtabs(~Treatment+Improved,data=Arthritis)
mytable
margin.table(mytable,1)#marginal frequencies

prop.table(mytable,2)#marginal proportions

#index(1) refer to the first variable in the table() statement


#add marginal sums to the table
addmargins(mytable)
addmargins(prop.table(mytable))
addmargins(prop.table(mytable,1),2)#sum column alone,2:加列
addmargins(prop.table(mytable,2),1)#sum row alone,1:加行


#Listing 7.10 Two-way table using CrossTable
#install.packages("gmodels")
library(gmodels)

CrossTable(Arthritis$Treatment,Arthritis$Improved)

#Listing 7.11 Three-way contingency table
mytable<-xtabs(~Treatment+Sex+Improved,data=Arthritis)
mytable
ftable(mytable)

margin.table(mytable,1)
margin.table(mytable,2)
margin.table(mytable,c(1,3))

ftable(prop.table(mytable,c(1,2)))

ftable(addmargins(prop.table(mytable,c(1,2)),3))

#Listing 7.12 Chi-sequare test of Independence
library(vcd)
mytable<-xtabs(~Treatment+Improved,data = Arthritis)
chisq.test(mytable)#Treatment and Improved aren't Independent


#Listing 7.13 Measures of association for a two-way table
mytable<-xtabs(~Treatment+Improved,data = Arthritis)
assocstats(mytable)


#Listing 7.14 Covariances and correlations
states<-state.x77[,1:6]
cov(states)#协方差
cor(states)#相关系数
cor(states,method = "spearman")


#install.packages("ggm")
library(ggm)

colnames(states)
#partial correlations
pcor(c(1,5,2,3,6),cov(states))
#0.346 is the correlation between population(variable 1) and murder
#rate(variable 5),controllin for the influence of income,illiteracy
#rate,and high school graduation rate(variablee 2,3 and 6)


#Listing 7.15 Testing a correlation 
cor.test(states[,3],states[,5])

#Listing 7.16 Correlation matrix and tests of significance via corr.test()
library(psych)
corr.test(states,use = "complete")


library(MASS)
t.test(Prob~So,data = UScrime)
#can reject the hypothesis that Southern states and non-Southern
#states have equal probabilities of imprisonment (p<.001)


sapply(UScrime[c("U1","U2")],function(x)(c(mean=mean(x),sd=sd(x))))

with(UScrime,t.test(U1,U2,paired = TRUE))


with(UScrime,by(Prob,So,median))

wilcox.test(Prob~So,data = UScrime)
#can reject the hypothesis that incarceration rates are the same
#in Southern and non-Southern states (p<.001)


#The Wilcoxon(秩和检验) signed rank test provides a nonparametric alternative
#to the dependent sample t-test.


sapply(UScrime[c("U1","U2")],median)

with(UScrime,wilcox.test(U1,U2,paired = TRUE))


#Listing 7.17 Nonparametric multiple comparisons
source("http://www.statmethods.net/RiA/wmc.txt")
states<-data.frame(state.region,state.x77)
wmc(Illiteracy~state.region,data = states,method = "holm")


#Listing 8.1 Simple Linear regression
fit<-lm(weight~height,data = women)
summary(fit)

women$weight
fitted(fit)
residuals(fit)#残差

plot(women$height,women$weight,
     xlab = "Height (in inches)",
     ylab = "Weight (in pounds)")
abline(fit)
#Weight=-87.52+3.45xHeight


#Listing 8.2 Polynomial regression
fit2<-lm(weight~height+I(height^2),data = women)
summary(fit2)

#Weight=261.88-7.35xHeight+0.083xHeight^2

fit3<-lm(weight~height+I(height^2)+I(height^3),data = women)
summary(fit3)

plot(women$height,women$weight)
lines(women$height,fitted(fit3))#lines(x,y)


#install.packages("car")
library(car)
scatterplot(weight~height,data = women,
            spread=FALSE,smoother.args=list(lty=2),pch=19,
            main="Women Age 30-39",
            xlab = "Height (inches)",
            ylab = "Weight (lbs.)")#散点图

#Listing 8.3 Examining bivariate relationships
states<-

















