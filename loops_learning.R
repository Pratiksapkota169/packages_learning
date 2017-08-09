#learn from:http://www.listendata.com/2015/09/loops-in-r.html

#What is Loop?
#Loop helps you to repeat the similar operation on different variables
#or on different columns or on different datasets.For example,you
#want to multiple each variable by 5. Instead of multiply each
#variable one by one,you can perform this task in loop.Its main
#benefit is to bring down the duplication in your code which helps
#to make changes later in the code.

#Ways to Write Loop in R
#1.For Loop
#2.While Loop
#3.Apply Family of Functions such as Apply,Lapply,Sapply etc

#Apply Family of Functions
#They are the hidden loops in R.They make loops easier to read
#and write.But these concepts are very new to the programming
#world as compared to For Loop and While Loop.

#1.Apply Function
#It is used when we want to apply a function to rows or columns
#of a matrix or data frame.It cannot be applied on lists or vectors.

dat<-data.frame(x=c(1:5,NA),
                z=c(1,1,0,0,NA,0),
                y=5*c(1:6))
dat
#Example 1:Find Maximum value of each row
apply(dat,1,max,na.rm=TRUE)

#Example 2:Find Maximum value of each column
apply(dat,2,max,na.rm=TRUE)


#2.Lapply Function
#When we apply a function to each element of a data structure
#and it returns a list.

#Example 1:Calculate Median of each of the variables
lapply(dat,function(x) median(x,na.rm = TRUE))


#Example 2:Apply a custom function
lapply(dat,function(x) x+1)


#3.Sapply Function
#Sapply is a user friendly version of Lapply as it returns a
#vector when we apply a function to each element of a data structure.

#Example 1:Number of Missing Values in each Variable
sapply(dat,function(x) sum(is.na(x)))

#Example 2:Extract names of all numeric variables in IRIS dataset
colnames(iris)[which(sapply(iris,is.numeric))]


#Lapply and Sapply Together

#Converting Factor Variables to Numeric
index<-sapply(dat,is.factor)
dat[index]<-lapply(dat[index],function(x) as.numeric(as.character(x)))
index


#4.For Loop

#Example 1:Maximum value of each column
x=NULL
for(i in 1:ncol(dat)){
  x[i]=max(dat[i],na.rm = TRUE)
}
x

#Prior to starting a loop,we need to make sure we create an empty
#vector.The empty vector is defined by x=NULL.Next step is to
#define the number of columns for which loop over would be executed.
#It is done with ncol function.The length function could also be
#used to know the number of column.


x=vector("double",ncol(dat))
for(i in seq_along(dat)){ #seq_along finds out what to loop over
  x[i]=max(dat[i],na.rm = TRUE)
}
x


#Example 2:Split IRIS data based on unique values in "species" variable
for(i in 1:length(unique(iris$Species))){
  require(dplyr)
  assign(paste("iris",i,sep = "."),
         filter(iris,Species==as.character(unique(iris$Species)[i])))
}


#Combine/Append Data within LOOP

#Method 1:Use do.call with rbind
#do.call() applies a given function to the list as a whole.
#When it is used with rbind,it would bind all the list arguments.
#In other words,converts list to matrix of multiple rows.

temp=list()
for(i in 1:length(unique(iris$Species))){
  series=data.frame(Species=as.character(unique(iris$Species)[i]))
  temp[i]=series
}
output=do.call(rbind,temp)
output


#Method 2:Use Standard Looping Technique
dummydt=data.frame(matrix(ncol = 0,nrow = 0))
for(i in 1:length(unique(iris$Species))){
  series=data.frame(Species=as.character(unique(iris$Species)[i]))
  
  if(i==1){
    output=rbind(dummydt,series)  
  }else{
    output=rbind(output,series)
  }
}

output


#If we need to wrap the above code in function,we need to make
#some changes in the code.For example,data$variable won't work
#inside the code.Instead we should use data[[variable]]

dummydt=data.frame(matrix(ncol = 0,nrow = 0))
temp=function(data,var){
  for(i in 1:length(unique(data[[var]]))){
    series=data.frame(Species=as.character(unique(data[[var]]))[i])
    
    if(i==1){
      output=rbind(dummydt,series)
    }else{
      output=rbind(output,series)
    }
  }
  return(output)
}
temp(iris,"Species")


#For Loop and Sapply Together
for(i in which(sapply(dat,is.numeric))){
  dat[is.na(dat[,i]),i]<-median(dat[,i],na.rm = TRUE)
}
dat


#Create new columns in Loop
mydata=data.frame(x1=sample(1:100,100),
                  x2=sample(letters,100,replace = TRUE),
                  x3=rnorm(100))
mydata

#Standardize Variables
lst=list()
for(i in which(sapply(mydata,is.numeric))){
  x.scaled=(mydata[,i]-mean(mydata[,i]))/sd(mydata[,i])
  lst[[i]]=x.scaled
}

names(lst)<-paste(names(sapply(mydata,is.numeric)),"_scaled",sep = "")
mydata.scaled=data.frame(do.call(cbind,lst))


#5.While Loop in R
i=1
while(i<7){
  if(i%%2==0){
    print(paste(i,"is an Even number"))
  }else if(i%%2>0){
    print(paste(i,"is an Odd number"))
  }
  i=i+1
}


#Loop Concepts:Break and Next
for(i in 1:3){
  for(j in 3:1){
    if((i+j)>4){
      break
    }else{
      print(paste("i=",i,"j=",j))
    }
  }
}

#Next Keyword
for(i in 1:3){
  for(j in 3:1){
    if((i+j)>4){
      next
    }else{
      print(paste("i=",i,"j=",j))
    }
  }
}



#Sample Data
data = read.table(text="
X Y Z
6 5 0
6 3 NA
6 1 5
8 5 3
1 NA 1
8 7 2
2 0 2", header=TRUE)

data

#Calculate maximum value across row
apply(data,1,max,na.rm=TRUE)

#Calculate number of 0s in each row
apply(data==0,1,sum,na.rm=TRUE)

#Calculate number of values greater than 5 in each row
apply(data>5,1,sum,na.rm=TRUE) #number not sum

#Select all rows having mean value greater than or equal to 4
df=data[apply(data,1,mean,na.rm=TRUE)>=4,]
df

#Remove rows having NAs
helper=apply(data,1,function(x){any(is.na(x))})
df2=data[!helper,]
df2
#equal to
df2=na.omit(data)
df2

#Count unique values across row
df3=apply(data,1,function(x) length(unique(na.omit(x))))
df3
data

