#learning from:http://www.listendata.com/2016/08/dplyr-tutorial.html

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
#arrange(data_frame,variable(s)_to_sort)
#or
#data_frame %>% arrange(variable(s)_to_sort)
#To sort a variable in descending order,use desc(x).


#Example 23: Sort Data by Multiple Variables
#The default sorting order of arrange() function is ascending.
#In this example,we are sorting data by multiple variables.
arrange(mydata,Yield,Consum)

#Suppose you need to sort one variable by descending order and other variable by ascending order.
arrange(mydata,desc(Consum),Yield)


#Pipe Operator %>%
#It is important to understand the pipe(%>%) operator before knowing
#the other function of dplyr package. dplyr utilizes pipe operator
#from another package (magrittr).
#It allows you to write sub-queries like we do it in sql.

#Note:All the function in dplyr package can be used without the pipe operator.
#The question arises "Why to use pipe operator %>%".
#The answer is it lets to wrap multiple together with the use of %>%.

#Syntax:
#filter(data_frame,variable==value)
#or
#data %>% filter(variable==value)

#The %>% is NOT restricted to filter function.
#It can be used with any function.

#Example:
#The code below demonstates the usage of pipe %>% operator.
#In this example,we are selecting 10 random observations of two variables
#"Index" "State" from the data frame "mydata".

dt=sample_n(select(mydata,Yield,Consum),10)
#or
dt=mydata %>% select(Yield,Consum) %>% sample_n(10)


#group_by() function
#Use:Group data by categorical variable
#Syntax:
#group_by(data,variables)
#or
#data %>%group_by(variabless)

#Example 24: Summarise Data by Categorical Variable
#We are calculating count and mean of variables Y2011 and Y2012 by variable Index.

t=summarise_at(group_by(mydata,State),
               vars(Yield,Consum),funs(n(),mean(.,na.rm = T)))

#or
t=mydata %>% group_by(State) %>% summarise_at(vars(Yield:Consum),funs(n(),mean(.,na.rm=TRUE)))


#do() function
#Use:Compute within groups
#Syntax:
#do(data_frame,expressions_to_apply_to_each_group)
#Note:The dot(.) is required to refer to a data frame.

#Example 25: Filter Data within a Categorical Variable
#Suppose you need to pull top 2 rows from "A","C"and "I" categories of variables Index.
t=mydata %>% filter(State %in% c("韩国","中国","美国")) %>% group_by(State) %>% do(head(.,2))

#Example 26: Selecting 3rd Maximum Value by Categorical Variable
#We are calculting third maximum value of variable Y2015 by variable Index.
#The following code first selects only two variables Index and Y2015.
#Then it filters the variable Index with "A","C" and "I" and then it groups
#the same variable and sorts the variable Y2015 in descending order.
#At last,it selects the third row.
t=mydata %>% select(State,Yield,Consum) %>%
  filter(State %in% c("中国","韩国","美国")) %>%
  group_by(State) %>%
  do(arrange(.,desc(Consum))) %>%
  slice(1)
#The slice() function is used to select rows by position.

#Using Window Functions
#Like SQL,dplyr uses window functions that are used to subset data within a group.
#It returns a vector of values.We could use min_rank() function that
#calculates rank in the preceding example.
t=mydata %>% select(State,Yield,Consum) %>%
  filter(State %in% c("中国","韩国","美国")) %>%
  group_by(State) %>%
  filter(min_rank(desc(Consum))==1)

#Example 27: Summarize,Group and Sort Together
#In this case,we are computing mean of variables Y2014 and Y2015 by variable Index.
#Then sort the result by calculated mean variable Y2015.
t=mydata %>% group_by(State) %>%
  summarise(Mean_Yield=mean(Yield,na.rm=TRUE),
            Mean_Consum=mean(Consum,na.rm=TRUE)) %>%
  arrange(desc(Mean_Consum))


#mutate() function
#Use: Creates new variables
#Syntax:
#mutate(data_frame,expression(s))
#or
#data_frame %>% mutate(expression(s))


#Example 28: Create a new variable
#The following code calculates division of Y2015 by Y2014 and name it "change".
mydata16=mutate(mydata,change=Yield/Consum)
#mutate mean change

#Example 29: Multiply all the variables by 1000
#It creates new variables and name them with suffix "_new"
mydata177<-select(mydata,-State)
mydata17=mutate_all(mydata177,funs("new"=.*1000))

#Note-The above code returns the following error messages.
#Warning messages:
#1: In Ops.factor(c(1L, 1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 4L, 5L, 6L,  :
#‘*’ not meaningful for factors
#2: In Ops.factor(1:51, 1000) : ‘*’ not meaningful for factors

#Solution : See Example 45 - Apply multiplication on only numeric variables

#Example 30: Calculate Rank for Variables
#Suppose you need to calculate rank for variables Y2008 to Y2010
mydata18=mutate_at(mydata,vars(Yield:Consum),
                   funs(Rank=min_rank(.)))

#By default, min_rank() assigns 1 to the smallest value and high number
#to the largest value.In case, you need to assign rank 1 to the largest
#value of a variable, use min_rank(desc(.))
mydata19=mutate_at(mydata,vars(Yield,Consum),
                   funs(Rank=min_rank(desc(.))))

#Example 31: Select State that generated highest income among the variable "Index"
out=mydata %>% group_by(State) %>%
  filter(min_rank(desc(Consum))==1) %>%
  select(State,Yield)

#Example 32:Cumulative Income of "Index" variable
#The cumsum function calculates cumulative sum of a variable.
#With mutate function, we insert a new variable called "Total" which contains 
#which contains values of cumulative income of variable Index.
out=mydata %>% group_by(State) %>%
  mutate(Total=cumsum(Consum)) %>%
  select(State,Consum,Total)

#join() function
#Use:Join two datasets
#Syntax:
# inner_join(x,y,by=)
# left_join(x,y,by=)
# right_join(x,y,by=)
# full_join(x,y,by=)
# semi_join(x,y,by=)
# anti_join(x,y,by=)


#Example 33: Common rows in both the tables
#Let's create two data frames say df1 and df2
df1<-data.frame(ID=c(1,2,3,4,5),
                w=c("a","b","c","d","e"),
                x=c(1,1,0,0,1),
                y=rnorm(5),
                z=letters[1:5])
df2<-data.frame(ID=c(1,7,3,6,8),
                w=c("z","b","k","d","l"),
                x=c(1,2,3,0,4),
                y=rnorm(5),
                z=letters[2:6])
#INNER JOIN return rows when there is a match in both tables.
#In this example, we are merging df1 and df2 with ID as common variable(primary key).
df3<-inner_join(df1,df2,by="ID")

#If the primary key does not have same name in both the tables,
#try the following way
inner_join(df1,df2,by=c("ID"="ID1"))


#Example 34:Applying LEFT JOIN
#LEFT JOIN :It returns all rows from the left table,even if there are 
#no matches in the right table.
left_join(df1,df2,by="ID")

#Combine Data Vertically
#insersect(x,y)
#Rows that appear in both x and y

#union(x,y)
#Rows that appear in either or both x and y

#setdiff(x,y)
#Rows that appear in x but not y

#Example 35: Applying INTERSECT
#Prepare Sample Data for Demonstration
mtcars$model<-rownames(mtcars)
first<-mtcars[1:20,]
second<-mtcars[10:32,]

#INTERSECT selects unique rows that are common to both the data frames.
intersect(first,second)


#Example 36: Applying UNION

#UNION displays all rows from both the tables and removes duplicate records
#from the combined dataset.By using union_all function,it allows duplicate
#rows in the combined dataset.
x=data.frame(ID=1:6,ID1=1:6)
y=data.frame(ID=1:6,ID1=1:6)
union(x,y) #unique
union_all(x,y) #allow duplicate


#Example 37: Rows appear in one table but not in other table
setdiff(first,second) #in first but not in second

#Example 38: IF ELSE Statement
#Syntax:
#if_else(condition,true,false,missing=NULL)
df<-c(-10,2,NA)
if_else(df<0,"negative","positive",missing = "missing value")

#Create a new variable with IF_ELSE
#If a value is less than 5,add it to 1 and if it is greater than or equal to 5,
#add it to 2. Otherwise 0.
df=data.frame(x=c(1,5,6,NA))
df %>% mutate(newvar=if_else(x<5,x+1,x+2,0))

#Nested IF ELSE
#Multiple IF ELSE statement can be written using if_else() function.
mydf=data.frame(x=c(1:5,NA))
mydf %>% mutate(newvar=if_else(is.na(x),"I am missing",
                               if_else(x==1,"I am one",
                                if_else(x==2,"I am two",
                                  if_else(x==3,"I am three","Others")))))


#SQL-Style Case When Statement
#We can use case_when() function to write nested if-else queries.
#In case_when(), you cannot use variables directly within case_when()
#wrapper so it should be writen like .$x which is equvalent to mydf$x.
#TRUE refers to ELSE statement.
mydf %>% mutate(flag=case_when(is.na(.$x) ~ "I am missing",
                               .$x == 1 ~"I am one",
                               .$x == 2 ~"I am two",
                               .$x == 3 ~"I am three",
                               TRUE ~ "Others"))

#Important Point
#Make sure you set is.na() condition at the beginning in nested ifelse.
#Otherwise,it would not be executed.

#Example 39: Apply Row Wise Operation
#Suppose you want to find maxmum value in each row of variables
#2012,2013,2014,2015.The rowwise() function allows you to apply functions to rows.
df=mydata %>% rowwise() %>% mutate(Max=max(Y2012:Y2015)) %>%
  select(Y2012:2015,Max)


#Example 40: Combine Data Frames
#Suppose you are asked to combine two data frames.
#Let's first create two sample datasets.
df1=data.frame(ID=1:6,x=letters[1:6])
df2<-data.frame(ID=7:12,x=letters[7:12])

#The bind_rows() function combine two datasets with rows.
#So combined dataset would contain 12 rows(6+6) and 2 columns.
xy=bind_rows(df1,df2)
#It is equivalent to base R function rbind.
xy=rbind(df1,df2)

#The bind_cols() function combine two datasets with columns.
#So combined dataset would contain 4 columns and 6 rows.
xy=bind_cols(df1,df2)
#or
xy=cbind(df1,df2)


#Example 41: Calculate Percentile Values
#The quantile() function is used to determine Nth percentile value.
mydata %>% group_by(State) %>%
  summarise(Pecentile_25=quantile(Consum,probs=0.25),
            Pecentile_50=quantile(Consum,probs=0.5),
            Pecentile_75=quantile(Consum,probs=0.75),
            Pecentile_99=quantile(Consum,prob=0.99))

#The ntile() function is used to divide the data into N bins.
x=data.frame(N=1:15)
x=mutate(x,pos=ntile(x$N,3))


#Example 42: Automate Model Building
#This example explains the advanced usage of do() function.
#In this example,we are building linear regression model for each
#level of a categorical variable.There are 3 levels in variable cyl of dataset mtcars.
length(unique(mtcars$cyl))#3:6/4/8

by_cyl<-group_by(mtcars,cyl)
models<-by_cyl %>% do(mod=lm(mpg~disp,data=.))
summarise(models,rsq=summary(mod)$r.squared)
models %>% do(data.frame(
  var=names(coef(.$mod)),
  coef(summary(.$mod))
))

#if() Family of Function
#It includes functions like select_if,mutate_if,summarise_if.
#They come into action only when logical condition meets.

#Example 43: Select only numeric columns
#The select_if() function returns only those columns where logical condition is TRUE.
#The is.numeric refers to retain only numeric variables.
mydata20<-select_if(mydata,is.numeric)
#Similarly,you can use the following code for selecting factor columns
mydata21<-select_if(mydata,is.factor)


#Example 44: Number of levels in factor variables
#Like select_if() function,summarise_if() function lets you to 
#summarise only for variables where logical condition holds.
summarise_if(mydata,is.factor,funs(nlevels(.)))


#Example 45: Multiply by 1000 to numeric variables
mydata22<-mutate_if(mydata,is.numeric,funs("new"=.*1000))

#Example 46: Convert value to NA
#In this example,we are converting "" to NA using na_if() function.
k<-c("a","b","","d")
na_if(k,"")

########################END############################