#Matrix-Data Structure
#A matrix is a collection of data elements arranged in a two-dimensional rectangular layout.

A=matrix(
  c(2,4,3,1,5,7), #the data elements
  nrow = 2, #number of rows
  ncol = 3, #number of columns
  byrow = TRUE #fill matrix by rows
)
A

#An element at the mth row,nth column of A can be accessed by the expression A[m,n]
A[2,3]
A[2,]
A[,3]
A[,c(1,3)]

dimnames(A)=list(
  c("row1","row2"), #row names
  c("col1","col2","col3") #column names
)
A

A["row2","col3"]


#Matrix Construction
B=matrix(
  c(2,4,3,1,5,7),
  nrow = 3,
  ncol = 2
)
B

#Transpose
t(B)

#Combining Matrices
C=matrix(
  c(7,4,2),
  nrow = 3,
  ncol = 1
)
C

cbind(B,C)
rbind(t(B),t(C))


#Deconstuction
#We can deconstruct a matrix by applying the c function,which
#combines all column vectors into one.
c(B) #matrix --> vector by rows

