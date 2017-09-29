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












