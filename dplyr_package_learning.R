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

















































