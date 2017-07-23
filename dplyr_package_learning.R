install.packages("dplyr")
library(dplyr)
# select()---select
# filter()---where
# group_by()---group by
# summarise()---
# arrange()---order by
# join()---join
# mutate()---column alias

#How to load Data
mydata=read.csv("E:/workspace_r/graphs_learning/tea_data.csv")

#Example 1:Selecting Random N Rows
#The sample_n function selects random rows from a data frame (or table).
#The second parameter of the function tells R the number of rows to select.
sample_n(mydata,3)

#Example 2:Selecting Random Fraction of Rows
#The sample_frac function returns randomly N% of rows.
#In the example below,it returns randomly 10% of rows.
sample_frac(mydata,0.1)

#Example 3:Remove Duplicate Rows based on all the variables (complete Row)
#The distinct function is used to eliminate duplicates.
x1=distinct(mydata)
##must the same all columns

#Example 4:Remove Duplicate Rows based on a variable
#The .keep_all function is used to retain all other variable in the output data frame.
x2=distinct(mydata,Yield,.keep_all = TRUE)

#Example 5:Remove Duplicates Rows based on multiple variables
#In the example below,we are using two variables to determine uniqueness.
x2=distinct(mydata,Yield,Ratio,.keep_all = TRUE)

#select() Function
#It is used to select only desired variables.
#data:Data Frame

#Example 6:Selecting Variable(or Columns)
#Suppose you are asked to select only a few variable.
#The code below selects variables "Index",columns from "State" to "Y2008".
mydata2=select(mydata,State,Ratio:Consum)

#Example 7:Dropping Variables
#The minus sign before a variable tells R to drop the variable.
mydata3=select(mydata,-Ratio,-Yield)
#The above code can also be written like:
mydata4=select(mydata,-c(Ratio,Yield))

#Example 4:Selecting or Dropping Variable starts with 'Y'(column name)
mydata5=select(mydata,starts_with("R"))
#Adding a negative sign before starts_with() implies dropping the variables starts with "Y"
mydata55=select(mydata,-starts_with("R"))

# starts_with()---Starts with a prefix
# ends_with()---Ends with a prefix
# contains()---Contains a literal string
# matches()---Matches a regular expression
# num_range()---Numerical range like x01,x02,x03
# one_of()---Variables in character vector
# everything()---All variables

#Example 9:Selecting Variables contain 'I' in their names
mydata6=select(mydata,contains("i"))

#Example 10:Reorder Variables
#The code below keeps variables 'State' in the front
#and the remaining variables follow that.
mydata7=select(mydata,Consum,everything())

#rename() Function
#It is used to change variable name.
#syntax:rename(data,new_name=old_name)
#data:Data Frame

#Example 11:Rename Variable
#The rename function can be used to rename variable.
#In the following code,we are renaming 'Index' variable to 'Index1'.
mydata8=rename(mydata,Consum1=Consum)
names(mydata8)#show columns's names

#filter() Function
#It is used to subset data with matching logical conditions.
#data:Data Frame

#Example 12:Filter Rows
#Suppose you need to subset data.
#You want to filter rows and retain only those values in which Index is equal to A.
mydata9=filter(mydata,State=="韩国")

#Example 13:Multiple Selection Criteria
#The %in% operator can be used to select multiple items.
#In the following program,we are telling R
#to select rows against 'A' and 'C' in column 'Index'
mydata10=filter(mydata,State %in% c("中国","韩国"))

#Example 14:'AND' Condition in Selection Criteria
#Suppose you need to apply 'AND' condition.
#In this case,we are picking data for 'A' and 'C' 
#in the column 'Index' and income greater than 1.3 million in Year 2002
mydata11=filter(mydata,State %in% c("中国","韩国","土耳其") & Consum>=200)

#Example 15:'OR' Condition in Selection Criteria
#The '|' denotes OR in the logical condition.
#It means any of the two conditions.
mydata12=filter(mydata,State %in% c("中国","韩国","土耳其") |Yield)

#Example 16:NOT Condition
#The "!" sign is used to reverse the logical condition.
mydata13=filter(mydata,!State %in% c("中国","韩国"))

#Example 17:Contains Condition
#The grepl function is used to search for pattern matching.
#In the following code,we are looking for records where in column state contains 'Ar' in their name.
mydata14=filter(mydata,grepl("国",State))


##summarise() Function
#data:Data Frame

#Example 18:Summarize selected variables
#In the example below,we are calculting mean and median for the variable Y2015.
summarise(mydata,Consum_mean=mean(Consum),Yield=median(Yield))

#Example 19:Summarize Multiple Variables
#In the following example,we are calculating number of records,
#mean and median for variables Y2005 and Y2006.
#The summarise_at function allow us to select multiplt variables by their names.
summarise_at(mydata,vars(Consum,Yield),funs(n(),mean,median))
#each var---each fun

#Example 20:Summarize with Custom Functions
#We can also use custom function in the summarise function.
#In this case,we are computing the number of records,number of missing values,
#mean and median for variables Y2011 and Y2012.
#The dot(.) denotes each variables specified in the second argument of the function.
summarise_at(mydata,vars(Consum,Yield),
             funs(n(),missing=sum(is.na(.)),
                      mean(.,na.rm = TRUE),
                      median(.,na.rm = TRUE)))

#How to apply Non-Standard Functions
#Suppose you want to subtract mean from its original value
#and then calculate variance of it.
set.seed(222)
mydata15<-data.frame(X1=sample(1:100,100),X2=runif(100))
summarise_at(mydata15,vars(X1,X2),function(x) var(x-mean(x)))

#Example 21: Summarize all Numeric Variables
#The summarise_if function allows you to summarise conditionally.
summarise_if(mydata,is.numeric,funs(n(),mean,median))
#===
numdata=mydata[sample(mydata,is.numeric)]
summarise_all(numdata,funs(n(),mean,median))

#Example 22:Summarize Factor Variable
#We are checking the number of levels/categories 
#and count of missing observations in a categorical(factor) variable.
summarise_all(mydata["Yield"],funs(nlevels(.),sum(is.na(.))))

#arrange() function:
#Use: Sort data
#Syntax:
#



















































