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
age<-c(1,3,4,2,11,9,3,9,12,3)
weight<-c(4.4,5.3,7.2,5.2,8.5,7.3,6.0,10.4,10.2,6.1)
mean(weight)
sd(weight)
cor(age,weight)
plot(age,weight)

#### Listing 1.2 An example of commands used to manage the R workspace
getwd()
ls()
options()#Lets you view or set current options
history()#Displays your last commands (default=25)
savehistory("myfile")#saves the commands history to myfile (default=.Rhistory)
loadhistory("myfile")
save.image("myfile")#saves the workspace to myfile (default=.RData)
save(objectlist,file="myfile")
load("myfile")#loads a workspace into the current session
q()


bmp("filename.bmp")
jpeg("filename.jpg")
pdf("filename.pdf")
png("filename.png")
postscript("filename.ps")
svg("filename.svg")
win.metafile("filename.wmf")


sink("myoutput",append = TRUE,split = TRUE)
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
a<-c("k","j","h","a","c","m")
a[3]
a[c(1,3,5)]
a[2:6]#contain two boundaries


#Matrices:is a two-dimensional array in which each element has the
#same mode.Matrices are created with the matrix() function.The general
#format is
#mymatrix<-matrix(vector,nrow=nm_of_rows,ncol=number_of_columns,
#                 byrow=logical_value,
#                 dimnames=list(char_vector_rownames,char_vector_colnames))


#### Listing 2.1 Creating matrices
y<-matrix(1:20,nrow=5,ncol=4)
y
cells<-c(1,26,24,68)
rnames<-c("R1","R2")
cnames<-c("C1","C2")
mymatrix<-matrix(cells,nrow = 2,ncol = 2,byrow = TRUE,
                 dimnames = list(rnames,cnames))
mymatrix

mymatrix<-matrix(cells,nrow = 2,ncol = 2,byrow = FALSE,
                 dimnames = list(rnames,cnames))
mymatrix


#### Listing 2.2 Using matrix subscripts
x<-matrix(1:10,nrow = 2)
x
x[2,]
x[,2]
x[1,4]
x[1,c(4,5)]


#Arrays:are similar to matrices but can have more than two dimensions.
#They're created with an array function of the following form
#myarray<-array(vector,dimensions,dimnames)


#### Listing 2.3 Creating an array
dim1<-c("A1","A2")
dim2<-c("B1","B2","B3")
dim3<-c("C1","C2","C3","C4")
z<-array(1:24,c(2,3,4),dimnames = list(dim1,dim2,dim3))#2*3*4 dims
z

#Data frames:is more general than a matrix in that different columns
#can contain different modes of data.


#### 2.4 Creating a data frame
patientID<-c(1,2,3,4)
age<-c(25,34,28,52)
diabets<-c("Type1","Type2","Type1","Type1")
status<-c("Poor","Improved","Excellent","Poor")
patientdata<-data.frame(patientID,age,diabets,status)
patientdata


#### 2.5 Specifying elements of a data frame
patientdata[1:2]

patientdata[c("diabets","status")]

patientdata$age

table(patientdata$diabets,patientdata$status)#row,col:pivot table

summary(mtcars$mpg)
plot(mtcars$mpg,mtcars$disp)

attach(mtcars)
summary(mpg)
plot(mpg,disp)
plot(mpg,wt)
detach(mtcars)

with(mtcars,{
  print(summary(mpg))
  plot(mpg,disp)
  plot(mpg,wt)
})


with(mtcars,{
  nokeepstats<-summary(mpg)
  keepstats<<-summary(mpg)
  #operator <<- saves the object to the global environment
  #outside of the with() call
})
nokeepstats
keepstats


#Factors:categorical and order categorical variables are called factors

status<-c("Poor","Improved","Excellent","Poor")
status<-factor(status,ordered = TRUE)
#encode the vector as (3,2,1,3) and associate these values internally
#as 1=Excellent,2=Improved,and 3=Poor
status

#By default,factor levels for character are created in alphabetical order.

status<-factor(status,order=TRUE,
               levels = c("Poor","Improved","Excellent"))
status

#Any data values not in the list will be set to missing


#Listing 2.6 Using factors
patientID<-c(1,2,3,4)
age<-c(25,34,28,52)
diabetes<-c("Type1","Type2","Type1","Type1")
status<-c("Poor","Improved","Excellent","Poor")
diabetes<-factor(diabetes)
status<-factor(status,ordered = TRUE)
patientdata<-data.frame(patientID,age,diabetes,status)
str(patientdata)
summary(patientdata)


#Lists:is an ordered collection of objects
#allows to gather a variety of objects under one name

#Listing 2.7 Creating a list
g<-"My First List"
h<-c(25,26,28,39)
j<-matrix(1:10,nrow = 5)
k<-c("one","two","three")
mylist<-list(title=g,age=h,j,k)
mylist

mylist[[2]]
mylist[["age"]]#just values
mylist["age"]#concluding index:$age


#The file can be imported into a data frame:
grades<-read.table("studentgrade.csv",header = TRUE,
                   row.names = "StudentID",sep = ",")

install.packages("xlsx")
library(xlsx)
mydataframe<-read.xlsx("filename.xlsx",1)

library(RODBC)
odbcConnect(dsn,uid = "",pwd="")
sqlFetch(channel,sqltable)
sqlQuery(channel,query)
sqlSave(channel,mydf,tablename=sqltable,append = FALSE)
sqlDrop(channel,sqltable)
close(channel)


#Useful function for working with data objects
length(object) #Gives the number of elements/components
dim(object) #Gives the dimensions of an object
str(object) #Give the structure of an object
class(object) #Gives the class of an object
mode(object) #Determines how an object is stored
names(object) #Gives the names of components in an object
c(object,object,...) 
cbind(object,object,...)
rbind(object,object,...)
object
head(object)
tail(object)
ls()
rm(object,object,...)
newobject<-edit(object) #Edits object and saves it as newobject
fix(object) #Edits an object in place


pdf("mygraph.pdf")
attach(mtcars)
plot(wt,mpg)
abline(lm(mpg~wt))
title("Regression of MPG on Weight")
detach(mtcars)
dev.off()











