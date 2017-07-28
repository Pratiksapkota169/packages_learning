#List-Data Structure

#A list is a generic vector containing other objects
#For example,the following variable x is a list containing coples of three
#vectors n,s,b, and a numeric value 3.
n=c(2,3,5)
s=c("aa","bb","cc","dd","ee")
b=c(TRUE,FALSE,TRUE,FALSE,FALSE)

x=list(n,s,b,3)
x[[2]] #value
x[2] #index + value

#List Slicing
#We retrieve a list slice with the single square bracket "[]" operator.
#The following is a slice containing the second member of x,
#which is a copy of s.

x[2]

#With a index vector,we can retrieve a slice with multiple mumber.
#Here a slice containing the second and fourth members of x.
x[c(2,4)]


#Member Reference
#In order to reference a list member directly,we have to use the
#double square bracket "[[]]" operator.
#The following object x[[2]] is the second member of x.
#In other others,x[[2]] is a copy of s,but is not a slice
#containing s or its copy.

x[[2]][1]="ta"
x[[2]] #modify
x[2] #modify
s #is unaffected


#Named List Members
#We can assign names to list members,and reference them by names
#instead of numeric indexes.
#For example,in the following, v is a list of two members,
#named "bob" and "john".
v=list(bob=c(2,3,5),john=c("aa","bb"))


#List Slicing
#We retrieve a list slice with the square bracket "[]" operator.
#Here is a list slice containing a member of v named "bob".
v["bob"]


#With an index vector,we can retrieve a slice with multiple members.
#Here is a list slice with both members of v. Notice how they
#are reversed from their original positions in v.
v[c("john","bob")]
v #is unaffected

#Member Reference
v[["bob"]] #equal v[[1]]

#A named list member can also be referenced directly with the "$"
#operator in lieu of the double square bracker operator.
v$bob

#Search Path Attachment
#We can attach a list to the R search path and access its members
#without explicitly mentioning the list.
#It should to be detached for clean up.
attach(v)
bob
detach(v)
