#Data Frame-Data Structure
#A data frame is used for sorting data tables.It is a list of vectors of equal length.
n=c(2,3,5)
s=c("aa","bb","cc")
b=c(TRUE,FALSE,TRUE)
df=data.frame(n,s,b)
df
mtcars

#The top line of the table,called the header,contains the column
#names.Each horizontal line afterward denotes a data row,which
#begins with the name of the row,and then followed by the actual data.
#Each data member of a row is called a cell.
mtcars[1,2]

mtcars["Mazda RX4","cyl"]
nrow(mtcars)
ncol(mtcars)

head(mtcars)

#Data Frame Column Vector
mtcars[9] #index + value
mtcars[[9]] #value
mtcars[["am"]] #value
mtcars["am"] #index + value
mtcars$am #value
mtcars[,"am"] #value


#Data Frame Column Slice
#Numeric Indexing

#Data Frame Row Slice
mtcars[24,] #colnames + value
mtcars[c(3,24),]

#Name Indexing
mtcars["Camaro Z28",]
mtcars[c("Datsun 710","Camaro Z28"),]


#Logical Indexing
L=mtcars$am==0
L
mtcars[L,]
mtcars[L,]$mpg

mtcars[L,][c(2,5)]

mtcars[L,][["cyl"]]


#Data Imoort

#Table File
mydata=read.table("E:/workspace_r/test.txt")
# Warning message:
# incomplete final line found by readTableHeader on:最后一行加空行
class(mydata) #data.frame

#CSV File
mydata=read.csv("mydata.csv")

#Working Directory
getwd() #get current working directory
set("<new path>") #set working directory
