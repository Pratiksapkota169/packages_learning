#Vector-Data Structure
#A vector is a sequence of data elements of the same basic type.
#Members in a vector are officially called components.

c(2,3,5)

c(TRUE,FALSE,TRUE,FALSE,FALSE)

c("aa","bb","cc","dd","ee")

length(c("aa","bb","cc","dd","ee")) #5 members


#Combining Vectors

#Vectors can be combined via the function c. For examples,the 
#following two vectors n and s are combined into a new vector
#containing elements from both vectors.
n=c(2,3,5)
s=c("aa","bb","cc","dd","ee")
c(n,s)

#Value Coercion
#In the code snippet above,notice how the numeric values are
#being coerced into character strings when the two vectors are
#combined.This is necessary so as to maintain the same primitive
#data type for members in the same vector.

#Vector Arighmetics
#Arithmetic operations of vectors are performed member-by-member,i.e.,
#memberwise.For example,suppose we have two vectors a and b.
a=c(1,3,5,7)
b=c(1,2,4,8)

#Then,if we multiply a by 5,we should get a vector with each of
#its members multiplied by 5.
5*a

#And if we add a and b together,the sum would be a vector whose
#members are the sum of the corresponding members from a and b.
a+b

#Similarly for subtraction,multiplication and division,we get
#new vectors via memberwise operations.

a-b
a*b
a/b

#Recycling Rule
#If two vectors are of unequal length,the shorter one will be
#recycled in order to match the longer vector. For example,
#the following vectors u and v have different lengths,and
#their sum is computed by recycling values of the shorter vector u.

u=c(10,20,30)
v=c(1,2,3,4,5,6,7,8,9)
u+v


#Vector Index
s=c("aa","bb","cc","dd","ee")
s[3]

#Negative Index
s[-3]

#Out-of_Range Index
s[10]


#Numeric Index Vector
s=c("aa","bb","cc","dd","ee")
s[c(2,3)]
s[2:3]

#Duplicate Indexes
s[c(2,3,3)]

#Out-of-Order Indexes
s[c(2,1,3)]

#Range Index
s[2:4]

#Logical Index Vector
s=c("aa","bb","cc","dd","ee")
L=c(FALSE,TRUE,FALSE,TRUE,FALSE)
s[L]#return value of TRUE

s[c(FALSE,TRUE,FALSE,TRUE,FALSE)]


#Named Vector Members
v=c("Mary","Sue")
v
names(v)=c("First","Last")
v
v["First"]

v[c("Last","First")]

