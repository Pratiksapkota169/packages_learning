#learn from R vs. Python

#1.字符串格式化输出
myword <- sample(LETTERS, 10, replace = FALSE)#不允许重复
myword

#paste:sep参数默认间隔为空格
#paste0:sep默认无间隔


#拼接单个向量时，通过设置collapse参数来控制字符之间的间隔符，最终输出一个单值字符串
paste(myword, collapse = "-")
paste0(myword, collapse = "-")

#paste0把paste的sep参数简化了，直接强制设定为无间隔，如果做向量间匹配，
#paste0函数就可以不用设置sep参数
mydate <- paste(2001:2005, "06", sep = "-")
mydate
mydate <- paste0(2001:2005, "06", collapse = "-")
mydate


#library(stringr)
str_c(myword, collapse = "")

library(sca)
library(dplyr)
percent(seq(0, 0.1, 0.01), d = 2, sep = "")#d:小数点后保留几位

library(scales)
runif(10, 0, 1)
percent(runif(10, 0, 1))


#%d整数 %02d d代表整数；2代表长度；0代表不足长度用0补齐
#%f浮点数 %4.2f 第一个数字代表总位数；第二个数字代表小数点位数
#%s字符串
#%% 百分比


sprintf("%d%%", 1:10)
sprintf("%d-%d-%02d", 2001, 12, 1:30)
sprintf("有%.1f%%的人评价变形金刚5较差", 30.7)
sprintf("%s是阿里巴巴的%s", "马云", "老板")


# print("I'm %s.I'm %d year old." % ("黄", 25))
# 使用字典进行字符传递：可以不用考虑字典内的键值对顺序
# print("I'm %(name)s.I'm %(age)d year old. " % {"age": 25, "name": "黄"})

# format函数
# print("{2},{1},{0}".format("小伟", "大伟", "小三"))
# 位置参数，即在要输出的主句中插入提供的对应字符串位置，即可完成格式化过程
# 如果不想在主句对应的花括号内写位置参数，必须保证提供的字符串顺序与主句对应要插入的位置保持一致
# print("{}和{}是一对好{}".format("大伟", "小伟", "基友"))

# 也可以在format括号中对字符串进行命名，然后将对应名字传入主句对应花括号内部
# "I'm {name}.I'm {age} year old.".format(age=25, name="黄")

# url = "http://study.163.com/category/400000000146050#/?p="
# myurl1 = []
# for i in range(1, 23):
#   urlm = url + "%d" % i
# myurl1.append(urlm)
# print(urlm)
#
# myurl2 = []
# for i in range(1, 23):
#   urlm = url + "{}".format(i)
# myurl2.append(urlm)
# print(urlm)


# 2.数据合并与追加
df1 <- data.frame(
  A = c('A0', 'A1', 'A2', 'A3'),
  B = c('B0', 'B1', 'B2', 'B3'),
  C = c('C0', 'C1', 'C2', 'C3'),
  D = c('D0', 'D1', 'D2', 'D3')
)
df2 <- data.frame(
  E = c('A4', 'A5', 'A6', 'A7'),
  F = c('B4', 'B5', 'B6', 'B7'),
  G = c('C4', 'C5', 'C6', 'C7'),
  H = c('D4', 'D5', 'D6', 'D7')
)
df3 <- data.frame(
  I = c('A8', 'A9', 'A10', 'A11'),
  J = c('B8', 'B9', 'B10', 'B11'),
  K = c('C8', 'C9', 'C10', 'C11'),
  L = c('D8', 'D9', 'D10', 'D11')
)
df1
df2
df3

mydata1 <- cbind(df1, df2, df3)
mydata1
mydata2 <- dplyr::bind_cols(df1, df2, df3)
mydata2


df3 <- data.frame(
  id = c(1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008),
  gender = c(
    'male',
    'female',
    'male',
    'female',
    'male',
    'female',
    'male',
    'female'
  ),
  pay = c('Y', 'N', 'Y', 'Y', 'N', 'Y', 'N', 'Y'),
  m_point = c(10, 12, 20, 40, 40, 40, 30, 20)
)
df4 <- data.frame(
  id = c(1001, 1002, 1003, 1004, 1005, 1006),
  city = c(
    'Beijing ',
    'Shenzhen',
    'Guangzhou',
    'Shenzhen',
    'Shanghai',
    'Beijing'
  ),
  age = c(23, 44, 54, 32, 34, 32),
  category = c('100-A', '100-B', '110-A', '110-C', '210-A', '130-F'),
  price = c(1200, 2900, 2133, 5433, 1346, 4432)
)
print(df3)
print(df4)

mydata3 <- merge(df3, df4, by = "id", all = TRUE)
print(mydata3)
mydata3 <- merge(df3, df4, by = "id", all = FALSE)
print(mydata3)
mydata3 <- merge(df3, df4, by = "id", all.x = TRUE)
print(mydata3)
mydata3 <- merge(df3, df4, by = "id", all.y = TRUE)
print(mydata3)


mydata3 <- rbind(df1, df2, df3)
mydata3
mydata4 <- dplyr::bind_rows(df1, df2, df3)
mydata4


# library(reshape2):melt/dcast
# library(tidyr):gather/spread

mydata<-data.frame(
  Name = c("苹果","谷歌","脸书","亚马逊","腾讯"),
  Conpany = c("Apple","Google","Facebook","Amozon","Tencent"),
  Sale2013 = c(5000,3500,2300,2100,3100),
  Sale2014 = c(5050,3800,2900,2500,3300),
  Sale2015 = c(5050,3800,2900,2500,3300),
  Sale2016 = c(5050,3800,2900,2500,3300)
)
mydata

#melt函数是reshape2包中的数据宽转长的函数
mydata<-melt(mydata,id.vars = c("Conpany","Name"),
             variable.name = "Year",
             value.name = "Sale")
mydata

#转换之后，长数据结构保留了原始宽数据中的Name、Company字段，同时将剩余的
#年度指标进行堆栈，转换为一个代表年度的类别维度和对应年度的指标，即年度字段被降维

data1<-gather(data = mydata,key = "Year",value = "Sale",Sale2013:Sale2016)
data1

#相对于数据宽转长而言，数据长转宽就显得不是很常用，因为长转宽是数据透视，这种透视
#过程可以通过汇总函数或者类数据透视表函数来完成

data2<-dcast(data = data1,Name+Conpany~Year)
data2

data3<-spread(data = data1,key = Year,value = Sale)
data3


#通常使用factor直接生成因子变量，仅需一个向量（原则上可以是文本型，也可以是数字型，
#但是通常从实际意义上来说，被转换的应该是一个含有多类别的类别型文本变量）
#factor(x,levels,labels=levels,ordered=)
#x:要转换的变量
#levels:要设定的因子水平(省略则自动以向量中的不重复对象为因子水平)
#labels:因子标签(与因子水平对应，打印时显示对应的因子标签)
#ordered:设定是否对因子水平排序
vector<-rep(LETTERS[1:5],6)
print(vector)
plyr::count(vector)
myfactor<-factor(vector,levels = c("E","D","C","B","A"),
                  labels = c("EEE","DDD","CCC","BBB","AAA"),ordered=TRUE)
myfactor

#通常，factor函数中，levels一般不用设置，函数会自动判断向量内有几个水平，但是倘若
#要生成有序因子的话，默认会根据字母顺序排列，如果自然顺序与目标有序因子顺序不一致，
#则一定要指定levels，labels则视具体需求而定，如果本身就是文本类别的话，一般无需设定标签

#因子变量与文本变量数值变量之间的互转则通过as.character()或者as.number()来实现

library(dplyr)
as.character(as.factor(1:10)) %>% str()
as.numeric(as.factor(1:10)) %>% str()


#因子变量重编码
#将一个度量指标，转换为分段的因子变量，则可以通过cut函数来实现
scale<-runif(100,0,100)
#cut(x,breaks,labels = NULL,include.lowest = FALSE,right = TRUE,ordered=)
#接受一个数值型向量，breaks接受一个数值向量(标识分割点)或者单个数值(分割数目)
#right:设定分割带是左开右闭或者左闭右开(默认左开右闭)
#include.lowest则根据right的设定，决定是否应该包含端点值(如果right为TRUE,左开右闭区间，
#则包含最小值，如果right为FALSE，左闭右开区间则包含最大值)，默认为FALSE
factor1<-cut(scale,br)
















