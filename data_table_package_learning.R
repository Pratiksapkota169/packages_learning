#This data.table R package is considered as the fastest package for data manipulation.
#Analysts generally call R programming not compatible with big datasets(>10GB)
#as it is not memory efficient and loads everything into RAM.
#To change their perception,'data.table' package comes into play.
#This package was designed to be consise and painless.
#There are many benchmarks done in the past to compare dplyr vs data.table.
#In every benchmark,data.table wins.
#The effciency of this package was also compared with python's package(panda).
#And data.table wins.
#In CRAN, there are more than 200 packages that are dependent on data.table
#which makes it listed in the top5 R's package.

#data.table Syntax
#DT[i,j,by] 
#i:Subset Rows
#j:subset Columns
#Within GROUP

#1.The first parameter of data.table i refers to rows.
#It implies subsetting rows.It is equivalent to WHERE clause in SQL

#2.The second parameter of data.table j refers to columns.
#It implies subsetting columns(dropping/keeping).
#It is equivalent to SELECT clause in SQL.

#3.The third parameter of data.table by refers to adding a group so
#that all calculations would be done within a group.
#Equivalent to SQL's GROUP BY clause.


#The data.table syntax is NOT RESTRICTED to only 3 parameters.
#1.with,which
#2.allow.cartesian
#3.roll,rollends
#4..SD,.SDcols
#5.on,mult,nomatch

#install.packages("data.table")
library(data.table)

#Read Data
#In data.table package,fread() function is available to read or get data
#from your computer or from a web page.It is equivalent to read.csv() function of base R.
#install.packages("curl")
mydata=fread("https://github.com/arunsrinivasan/satrdays-workshop/raw/master/flights_2014.csv")

#Describe Data
#This dataset contains 253K observations and 17 columns.
#It constitutes information about flights' arrival or departure time,delays,
#flight cancellation and destination in year 2014.

nrow(mydata)
ncol(mydata)
names(mydata)
head(mydata)

#Selecting or Keeping Columns
#Suppose you need to select only 'origin' column.
dat1=mydata[,origin]
dat1
#return a vector NOT data.table

#To get result in data.table format
dat1=mydata[,.(origin)]
dat1
#return a data.table

#It can also be written like data.frame way
dat1=mydata[,c("origin"),with=FALSE]
dat1

#Keeping a column based on column position
dat2=mydata[,2,with=FALSE] #column 2 is "month"
dat2

#Keeping Multiple Columns
dat3=mydata[,.(origin,year,month,hour)]
dat3

#Keeping multiple columns based on column position
dat3=mydata[,c(2:4),with=FALSE]
dat3

#Dropping a Column
dat5=mydata[,!c("origin"),with=FALSE]
dat5

#Dropping Multiple Columns
dat6=mydata[,!c("origin","year","month"),with=FALSE]
dat6

#Keeping variables that contain 'dep'
#You can use %like% operator to find pattern.It is same as base R's
#grepl() function,SQL's LIKE operator
dat7=mydata[,names(mydata) %like% "dep",with=FALSE]
dat7

#Rename Variables
#rename a variable "dest" to "destination"
setnames(mydata,c("dest"),c("Destination"))
names(mydata)
setnames(mydata,c("arr_time","arr_delay"),c("Arr_time","Arr_delay"))

#Subsetting Rows/Filtering
dat8=mydata[origin=="JFK"]
dat8

#Select Multiple Values
dat9=mydata[origin %in% c("JFK","LGA")]
dat9

#Apply Logical Operator:NOT
dat10=mydata[!origin %in% c("JFK","LGA")]
dat10

#Filter based on Multiple variables
dat11=mydata[origin=="JFK" & carrier=="AA"]
dat11

#Faster Data Manipulation with Indexing
#data.table uses binary search algorithm that make data manipulation faster.

#Binary Search Algorithm
#Binary Search is an efficient algorithm for finding a value from a sorted
#list of values.It involves repeatedly spiltting in half the portion of 
#the list that contains values,until you found the value that you were searching for.

#5,10,7,20,3,13,26
#You are searching the value 20 in the above list.
#1.First,we sort the values.

#2.We would calculate the middle value i.e.10.

#3.We would check where 20=10? No.20<10

#4.Since is greater than 10,it should be somewhere after 10.
#So we can ingore all the values that are lower than or equal to 10.

#5.We are left with 13,20,26.The middle value is 20.

#6.We would again check whether 20=20.Yes.the match found.

















