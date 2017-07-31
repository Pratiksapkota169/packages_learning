#learning from:http://www.listendata.com/2016/10/r-data-table.html

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

#2.We would calculate the middle value i.e.10.  (3 5 7 [10] 13 20 26)

#3.We would check where 20=10? No.20<10

#4.Since is greater than 10,it should be somewhere after 10.
#So we can ingore all the values that are lower than or equal to 10.

#5.We are left with 13,20,26.The middle value is 20.

#6.We would again check whether 20=20.Yes.the match found.

#If we do not use this algorithm ,we would search 5 in the whole list of severnvalues.

#It is important to set key in your dataset which tells system that data is
#sorted by the key column.For example,you have employee's name,address,salary,
#designation,department,employee ID.We can use 'employee ID' as a key to search a particular employee.

#Set Key
setkey(mydata,origin)
#Note: It makes the data table sorted by the column "origin"

#How to filter when key is turned on
#don't need to refer the key column when apply filter
data12=mydata[c("JFK","LGA")]
data12

#Performance Comparison
system.time(mydata[origin %in% c("JFK","LGA")])
system.time(mydata[c("JFK","LGA")])

#Indexing Multiple Columns
setkey(mydata,origin,Destination)

#Filtering while setting keys on Multiple Columns
mydata[.("JFK","MIA")]
#It is equivalent to :
mydata[origin=="JFK" & Destination=="MIA"]

#To identify the column(s) indexed by
key(mydata)

#Sorting Data
#By default,it sorts data on ascending order
mydata01=setorder(mydata,origin)
mydata01

#Sorting Data on descending order
mydata02=setorder(mydata,-origin)
mydata02

#Sorting Data based on multiple variables
mydata03=setorder(mydata,origin,-carrier)
mydata03

#Adding Columns (Calculation on rows)
mydata[,dep_sch:=dep_time-dep_delay]
mydata

#Adding Multiple Columns
names(mydata)
mydata002=mydata[,c("dep_sch","arr_sch"):=list(dep_time-dep_delay,Arr_time-Arr_delay)]
mydata002

#IF THEN ELSE
#Method I:  mydata[,flag:=1*(min<50)]
#Method II: mydata[,flag:=ifelse(min<50,0)]
#It means to set flag=1 if min is less than 50.Otherwise, set flag=0

#How to write Sub Queries (like SQL)
#We can use this format-DT[][][] to build a chain in data.table.
#It is like sub-queries like SQL.
mydata[,dep_sch:=dep_time-dep_delay][,.(dep_time,dep_delay,dep_sch)]
#First,we are computing scheduled departure time and then selecting only relevant columns

#Summarize or Aggregate Columns
mydata[,.(mean=mean(arr_delay,na.rm = TRUE),
          median=median(arr_delay,na.rm = TRUE),
          min=min(arr_delay,na.rm = TRUE),
          max=max(arr_delay,na.rm = TRUE))]


#Summarize Multiple Columns
mydata[,.(mean(arr_delay),mean(dep_delay))]

#If you need to calculate summary statistics for a larger list of variables,
#you can use .SD and .SDcols operators.The .SD operator implies 'Subset of Data'
mydata[,lapply(.SD,mean),.SDcols=c("arr_delay","dep_delay")]

#Summarize all numeric Columns
#By default,.SD takes all continuous variables (excluding grouping variables)
mydata[,lapply(.SD,mean)]

#Summarize with multiple statistics
mydata[,sapply(.SD,function(x) c(mean=mean(x),median=median(x)))]


#GROUP BY (Within Group Calculation)
#Summarize by group 'origin'
mydata[,.(mean_arr_delay=mean(arr_delay,na.rm = TRUE)),by=origin]

#Use key column in a by operation
#Instead of 'by',you can use keyby= operator
mydata[,.(mean_arr_delay=mean(arr_delay,na.rm = TRUE)),keyby=origin]

#Summarize multiple variables by group 'origin'
mydata[,.(mean(arr_delay,na.rm = TRUE),mean(dep_delay,na.rm = TRUE)),by=origin]

#Or it can be written like below
mydata[,lapply(.SD,mean,na.rm=TRUE),.SDcols=c("arr_delay","dep_delay"),by=origin]

#Remove Duplicates
#You can remove non-unique/duplicate cases with unique() function.
setkey(mydata,"carrier")
unique(mydata)
setkey(mydata,NULL)
unique(mydata)
#Setting key to NULL is not required if no key is already set.

#Extrat values within a group
#select first and second values from a categorical variable carrier
mydata[,.SD[1:2],by=carrier]
#Select LAST value from a group
mydata[,.SD[.N],by=carrier]

#SQL's RANK OVER PARTITION
#In SQL,Window functions are very useful for solving complex data problem.
#Rank Over Partition is the most popular window function.
#It can be easily translated in data.table with the help of frank() function
#frank() is similar to base R's rank() function but much faster.
dt=mydata[,rank:=frank(-distance,ties.method = "min"),by=carrier]
#calculating rank of variable 'distance' by 'carrier'
#assign rank 1 to the highest value of 'distance' within unique values of 'carrier'

#Cumulative SUM by GROUP
dat=mydata[,cum:=cumsum(distance),by=carrier]
head(dat)

#Lag and Lead
#The lag and lead of a variable can be calculated with shift() function.
#The syntax of shift() function is as follows-
#shift(variable_name,number_of_lag,type=c("lag","lead"))
DT<-data.table(A=1:5)
DT[,X:=shift(A,1,type="lag")] #first:NA
DT[,Y:=shift(A,1,type = "lead")] #last:NA
DT

#Between and LIKE Operator
DT=data.table(x=6:10)
DT[x %between% c(7,9)]

DT=data.table(Name=c("dep_time","dep_delay","arrival"),
              ID=c(2,3,4))
DT
DT[Name %like% "dep"]

#Merging/Joins
#The merging in data.table is very similar to base R merge() function.
#The only difference is data.table by default takes common key variable
#as a primary key to merge two datasets.Whereas,data.frame takes
#common variable name as a primary key to merge the datasets.
#Sample Data
(dt1<-data.table(A=letters[rep(1:3,2)],X=1:6,key= "A"))
(dt2<-data.table(A=letters[rep(2:4,2)],Y=6:1,key = "A"))

#Inner Join
merge(dt1,dt2,by="A")

#Left Join
merge(dt1,dt2,by="A",all.x = TRUE)

#Right Join
merge(dt1,dt2,by="A",all.y = TRUE)

#Full Join
merge(dt1,dt2,all = TRUE)

#Convert a data.table to data.frame
class(mydata)
setDF(mydata)

set.seed(123)
X=data.frame(A=sample(3,10,TRUE),
             B=sample(letters[1:3],10,TRUE))
class(X)#[1] "data.frame"
setDT(X,key="A")
class(X)#[1] "data.table" "data.frame"

#Examples for Practise
#Q1.Calculate total number of rows by month and then sort on descending order
mydata[,.N,by=month][order(-N)]
#The .N operator is used to find count

#Q2.Find top3 months with high mean arrival delay
mydata[,.(mean_arr_delay=mean(arr_delay,na.rm=TRUE)),by=month][order(-mean_arr_delay)][1:3]

#Q3.Find origin of flights having average total delay is greater than 20 minutes
mydata[,lapply(.SD,mean,na.rm=TRUE),.SDcols=c("arr_delay","dep_delay"),by=origin][(arr_delay+dep_delay)>20]

#Q4.Extract average of arrival and departure delays for 
#carrier =="DL" by "origin" and "dest" variables
mydata[carrier=="DL",
       lapply(.SD,mean,na.rm=TRUE),
       by=.(origin,dest),
       .SDcols=c("arr_delay","dep_delay")]

#Q5.Pull first value of "air_time" by "origin" and then sum
#the returned values when it is greater than 300
mydata[,.SD[1],.SDcols="air_time",by=origin][air_time>300,sum(air_time)]

##########################END##############################