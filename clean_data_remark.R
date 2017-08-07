#learning from:http://blog.fens.me/r-apply/

#R的循环操作for和while，都是基于R语言本身实现的，而向量操作是基于底层的C语言函数实现的

#1.apply的家族函数

#2.apply函数
#apply函数是最常用的代替for循环的函数。
#apply函数可以对矩阵、数据框、数组（二维、多维），按行或列进行循环计算，
#对子元素进行迭代，并把子元素以参数传递的形式给自定义的FUN函数中，并以返回计算结果

#apply(X,MARGIN,FUN,...)
#X:数组、矩阵、数据框
#MARGIN:按行计算或按列计算，1表示按行，2表示按列
#FUN:自定义的调用函数

#对一个矩阵的每一行求和
x<-matrix(1:12,ncol = 3)
x
apply(x,1,sum)

#让数据框的x1列加1，并计算x1，x2列的均值
#生成data.frame
x<-cbind(x1=3,x2=c(4:1,2:5))
x

#自定义函数myFUN
myFUN<-function(x,c1,c2){
  c(sum(x[c1],1),mean(x[c2]))
}

#把数据框按行做循环,每行分别传递给myFUN函数
apply(x,1,myFUN,c1="x1",c2=c("x1","x2"))


#如果直接用for循环来实现
#定义一个结果的数据框
df<-data.frame()

#定义for循环
for(i in 1:nrow(x)){
  row<-x[i,] #每行的值
  df<-rbind(df,rbind(c(sum(row[1],1),mean(row))))#计算，并赋值到结果数据框中
}

df

#通过向量化计算来完成
data.frame(x1=x[,1]+1,x2=rowMeans(x))

#比较3种操作上面性能上的消耗
#清空环境变量
rm(list=ls())

#封装fun1
fun1<-function(x){
  myFUN<-function(x,c1,c2){
    c(sum(x[c1],1),mean(x[c2]))
  }
  apply(x,myFUN,c1="x1",c2=c("x1","x2"))
}

#封装fun2
fun2<-function(x){
  df<-data.frame()
  for(i in 1:nrow(x)){
    row<-x[i,]
    df<-rbind(df,rbind(sum(row[1],1),mean(row)))
  }
}

#封装fun3
fun3<-function(x){
  data.frame(x1=x[,1]+1,x2=rowMeans(x))
}

#生成数据集
x<-cbind(x1=3,x2=c(400:1,2:500))

#分别统计3中方法的CPU消耗
system.time(fun1(x))#for循环耗时最长
system.time(fun2(x))#apply耗时很短
system.time(fun3(x))#内置向量计算几乎不耗时

#3.lapply函数
#对list、data.frame数据集进行循环，并返回和X长度同样的list结构作为结果集

#lapply(X,FUN,...)
#计算list中每个KEY对应的数据的分位数
#构建一个list数据集x,分别包括a,b,c三个KEY值
x<-list(a=1:10,b=rnorm(6,10,5),c=c(TRUE,FALSE,FALSE,TRUE))
x

lapply(x,fivenum)

#lapply可以很方便地把list数据集进行循环操作，还可以用data.frame数据集按列进行循环，
#但如果传入的数据集是一个向量或矩阵对象，那么直接使用lapply就不能达到想要的效果了

#生成一个矩阵
x<-cbind(x1=3,x2=c(2:1,4:5))

class(x)
x
lapply(x,sum)#lapply会分别循环矩阵中的每个值，而不是按行或按列进行分组计算

#如果对数据框的列求和:按列进行分组，再进行计算
lapply(data.frame(x),sum)


#4.sapply函数
#sapply函数是一个简化版的lapply,sapply增加了2个参数simplify和USE.NAMES,
#主要是让输出看起来更友好，返回值为向量，而不是list对象

#sapply(X,FUN,...,simplify=TRUE,USE.NAMES=TRUE)
#X:数组、矩阵、数据框
#FUN:自定义的调用函数
#simplify:是否数组化，当值为array时，输出结果按数组进行分组
#USE.NAMES:如果X为字符串，TRUE设置字符串为数据名，FALSE不设置

x<-cbind(x1=3,x2=c(2:1,4:5))

#对矩阵计算，计算过程同lapply函数
sapply(x,sum)

#对数据框计算
sapply(data.frame(x),sum) #等价于apply(x,2,sum)
class(lapply(x,sum)) #list
class(sapply(x,sum)) #numeric


#如果simplify=FALSE和USE.NAMES=FALSE,那么完全sapply函数就等于lapply函数了
lapply(data.frame(x),sum)
sapply(data.frame(x),sum,simplify = FALSE,USE.NAMES = FALSE)

#对于simplify为array时，构建一个三维数组，其中二个维度为方阵
a<-1:2
#按数组分组
sapply(a,function(x) matrix(x,2,2),simplify = "array")

#默认情况，则自动合并分组
sapply(a,function(x) matrix(x,2,2))


val<-head(letters)
#默认设置数据名
sapply(val,paste,USE.NAMES = TRUE)
#USE.NAMES=FALSE,则不设置数据名
sapply(val,paste,USE.NAMES = FALSE)


#5.vapply函数
#vapply类似于sapply，提供了FUN.VALUE参数，用来控制返回值的行名，可以让程序更健壮
#vapply(X,FUN,FUN.VALUE,...,USE.NAMES=TRUE)
#FUN.VALUE:定义返回值的行名row.names

x<-data.frame(cbind(x1=3,x2=c(2:1,4:5)))

#设置行名，4行分别为a,b,c,d
vapply(x,cumsum,FUN.VALUE = c("a"=0,"b"=0,"c"=0,"d"=0))
#当不设置时，为默认的索引值
a<-sapply(x,cumsum)
a

#手动的方式设置行名
row.names(a)<-c("a","b","c","d")
a


#6.mapply函数
#mapply也是sapply的变形函数，类似多变量的sapply，但是参数定义有些变化。
#第一参数为自定义的FUN函数，第二个参数'...'可以接收多个数据，作为FUN函数的参数调用
#mapply(FUN,...,MoreArgs=NULL,SIMPLIFY=TRUE,USE.NAMES=TRUE)
#...:接收多个数据
#MoreArgs:参数列表
#SIMPLIFY:是否数组化，当值为array时，输出结果按数组进行分组

set.seed(1)
x<-1:10
y<-5:-4
z<-round(runif(10,-5,5))#runif(n,min,max)不包括边界

x;y;z
mapply(max,x,y,z)#按索引顺序取较大的值
mapply(min,x,y,z)#按索引顺序取较小的值


#生成4个符合正态分布的数据集，分别对应的均值和方差为c(1,10,100,1000)
set.seed(1)
n<-rep(4,4)
m<-v<-c(1,10,100,1000)
#生成4组数据，按列分组
mapply(rnorm,n,m,v)

#由于mapply是可以接收多个参数的，所以在做数据操作时，
#就不需要把数据先合并为data.frame了，直接一次操作就能计算出结果


#7.tapply函数
#tapply用于分组的循环计算，通过INDEX参数可以把数据集X进行分组，相当于group by的操作
#tapply(X,INDEX,FUN=NULL,...,simplify=TRUE)
#INDEX:用于分组的索引

#通过iris$Species品种进行分组
tapply(iris$Petal.Length,iris$Species,mean)
head(iris)

set.seed(1)
x<-y<-1:10
x;y

#设置分组索引t
t<-round(runif(10,1,100)%%2)
t

#对x进行分组求和
tapply(x,t,sum)

#由于tapply只接收一个向量参数，通过'...'可以再传给FUN其他参数，
#那么把y作为tapply的第四个参数进行计算
tapply(x,t,sum,y)

#得到的结果并不符合预期，结果不是把x和y对应的t分组后求和，
#第四个参数y传入sum时，并不是按照循环一个一个传进去的，而是每次传了完整的向量数据，
#那么再执行sum时，sum(y)=55
#在使用'...'去传入其他的参数时，一定要看清楚传递过程的描述


#8.rapply函数
#rapply是一个递归版本的lapply，它只处理list类型的数据
#对list的每个元素进行递归遍历，如果list包括子元素则继续遍历
#rapply(object,f,classes="ANY",deflt=NULL,how=c("unlist","replace","list"),...)
#object:list数据
#f:自定义的调用函数
#classes:匹配类型，ANY为所有类型
#deflt:非匹配类型的默认值
#how:3种操作方式，当为replace时，则用调用f后的结果替换原list中原来的元素；
#当为list时，新建一个list，类型匹配调用f函数，不匹配赋值为deflt；
#当为unlist时，会执行一次unlist(recursive=TRUE)的操作

#对一个list的数据进行过滤，把所有数字型numeric的数据进行从小到大的排序
x<-list(a=12,b=1:4,c=c("b","a"))
y=pi
z=data.frame(a=rnorm(10),b=1:10)
a<-list(x=x,y=y,z=z)

#进行排序，并替换原list的值
rapply(a,sort,classes = "numeric",how = "replace")

#integer<>numeric,不进行排序

rapply(a,function(x) paste(x,"++++"),classes = "character",deflt = NA,how = "list")

#解释：把character类型的拼接上+++，非character类型的为NA，新建一个list


#9.eapply函数
#对一个环境空间中的所有变量进行遍历
#eapply(env,FUN,...,all.names=FALSE,USE.NAMES=TRUE)
#env:环境空间
#all.names:匹配类型，ANY为所有类型


library(pryr)
#定义一个环境空间
env<-new.env()
env

#向这个环境空间中存入3个变量
env$a<-1:10
env$beta<-exp(-3:3)
env$logic<-c(TRUE,FALSE,FALSE,TRUE)

#查看env
ls(env)


#查看env空间中的变量字符串结构
ls.str(env)

#计算env环境空间中所有变量的均值
eapply(env,mean)

#查看当前环境空间中的变量
ls()

#查看所有变量的占用内存大小
eapply(environment(),object.size)


#eapply函数平时很难被用到，但对于R包开发来说，环境空间的使用是必须要掌握的
#特别是当R要作为工业化的工具时，对变量的精准控制和管理是非常必要的
