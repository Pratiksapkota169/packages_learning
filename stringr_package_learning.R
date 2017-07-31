#learning from:http://blog.fens.me/r-stringr/

library(stringr)

#字符串拼接函数
#1.str_c():字符串拼接
#与str_join完全相同，与paste()行为不完全一致
#str_c(...,sep="",collapse=NULL)
str_c("a","b")
str_c("a","b",sep="-")
str_c(c("a","a1"),c("b","b1"),sep = "-")

str_c(head(letters),collapse = "")
str_c(head(letters),collapse = ",")

#collapse对多个字符串无效
str_c("a","b",collapse = "-")
str_c(c("a","a1"),c("b","b1"),collapse = "-")

#拼接有NA值的字符串向量时，NA还是NA
str_c(c("a",NA,"b"),"-d")
str_c("a",c("b","c"))

#对比str_c()和paste()之间的不同点
#默认sep参数行为不一致
str_c("a","b")#ab
paste("a","b")#a b

#向量拼接字符串，collapse参数行为一致
str_c(head(letters),collapse = "")
paste(head(letters),collapse = "")

#拼接有NA的字符串向量，对NA的处理行为不一致
str_c(c("a",NA,"b"),"-d")
paste(c("a",NA,"b"),"-d")


#2.str_join():字符串拼接，同_c

#3.str_trim():去掉字符串的空格和TAB(\t)
#str_trim(string,side=c("both","left","right"))
str_trim("   left space\t\n",side="left")
str_trim("   left space\t\n",side="right")
str_trim("   left space\t\n",side="both")
str_trim("\nno space\n\t")


#4.str_pad():补充字符串的长度
#str_pad(string,width,side=c("left","right","both"),pad=" ")
str_pad("conan",20,"left")
str_pad("conan",20,"right")
str_pad("conan",20,"both")#left=right=10
str_pad("conan","20","both","x")


#5.str_dup:复制字符串
#str_dup(string,times)
val<-c("abca4",123,"cba2")
str_dup(val,2)#each 2 times
str_dup(val,1:3)#val[1]*1 time,val[2]*2 times,val[3]*3 times


#6.str_wrap:控制字符串输出格式
str_wrap(string,width = 80,indent = 0,exdent = 0)

txt<-"R语言作为统计学一门语言，一直在小众领域闪耀着光芒。直到大数据的爆发，R语言成为了一门炙手可热的数据分析利器。随着越来越多的工程背景的人的加入，R语言的社区在迅速扩大成长。现在已不仅仅是在统计领域，教育，银行，电商，互联网...都在使用R语言。"

#设置宽度为40个字符
cat(str_wrap(txt,width = 40),"\n")
#设置宽度为60个字符，首行缩进2字符
cat(str_wrap(txt,width = 60,indent = 2),"\n")
#设置宽度为10字符，非首行缩进4字符
cat(str_wrap(txt,width = 10,exdent=4),"\n")


#7.str_sub:截取字符串
#str_sub(string,start = 1L,end = -1L)
txt<-"I am Conan."

str_sub(txt,1,4)
str_sub(txt,6)
str_sub(txt,c(1,4),c(6,8))#start=1,end=6;strat=4,end=8
str_sub(txt,-3)#start=-3
str_sub(txt,end = -3)#start=1

#8.str_sub<-:截取字符串，并赋值，同str_sub
x<-"AAABBBCCC"
#在字符串的1的位置赋值为1
str_sub(x,1,1)<-1;x
#在字符串从2到-2的位置赋值2345
str_sub(x,2,-2)<-"22345";x


#字符串计算函数
#1.str_count:字符串计数
#str_count(string,pattern="")
str_count("aaa444sssddd","a")

fruit<-c("apple","banana","pear","pineapple")
str_count(fruit,"a")
str_count(fruit,"p")

#对字符串中的"."字符计数，由于.是正则表达式的匹配符，直接判断计数的结果是不对的
str_count(c("a.",".",".a.",NA),".")
#用fixed匹配字符
str_count(c("a.",".",".a.",NA),fixed("."))
#用\\匹配字符
str_count(c("a.",".",".a.",NA),"\\.")


#2.str_length:字符串长度
str_length(c("I","am","张丹",NA))


#3.str_sort:字符串排序
#str_sort(x,decreasing = FALSE,na_last = TRUE,locale = "",...)

#按ASCII字母排序
str_sort(c("a",1,2,"11"),locale = "en")
str_sort(letters,decreasing=TRUE)
#按拼音排序
str_sort(c("你","好","粉","丝","日","志"),locale="zh")

#对NA值的排序处理
str_sort(c(NA,"1",NA),na_last = TRUE)
str_sort(c(NA,"1",NA),na_last = FALSE)
str_sort(c(NA,"1",NA),na_last = NA)

#4.str_order:字符串索引排序，规则同str_sort
#str_order(x,decreasing = FALSE,na_last = TRUE,locale = "",...)


#字符串匹配函数
#1.str_split:字符串分割
#str_split(string,pattern,n=Inf)
val<-"abc,123,234,iuuu"
s1<-str_split(val,",");s1
#保留2块
s2<-str_split(val,",",2);s2
#结果返回list

#2.str_split_fixed:字符串分割，同str_split
s3<-str_split_fixed(val,",",2);s3
#结果返回matrix


#3.str_subset:返回匹配的字符串
val<-c("abc",123,"cba")
str_subset(val,"a")
str_subset(val,"^a")
str_subset(val,"a$")


#4.word:从文本中提取单词
#word(string,start = 1L,end=start,sep = fixed(" "))

val<-c("I am Conan.","http://fens.me, ok")
#默认以空格分割，取第一个位置的字符串
word(val,1)
word(val,-1)
word(val,2,-1)

#以,分割，取第一个位置的字符串
val<-"111,222,333,444"
word(val,1,sep = fixed(","))
word(val,3,sep = fixed(","))


#5.str_detect:检查匹配字符串的字符
val<-c("abca4",123,"cba2")
#检查字符串向量，是否包括a
str_detect(val,"a")
str_detect(val,"^a")
str_detect(val,"a$")


#6.str_match:从字符串中提取匹配组
#str_match(string,pattern)
val<-c("abc",123,"cba")
#匹配字符a，限1个，并返回对应的字符
str_match(val,"a")
str_match(val,"[0-9]")

#匹配字符0-9，不限数量，并返回对应的字符
str_match(val,"[0-9]*")


#7.str_match_all:从字符串中提取匹配组，同str_match
#返回matrix格式
str_match_all(val,"a")
str_match_all(val,"[0-9]")


#8.str_replace:字符串替换
#str_replace(string,pattern,replacement)
val<-c("abc",123,"cba")
#把目标字符串第一个出现的a或b替换为"-"
str_replace(val,"[ab]","-")


#9.str_replace_all:字符串替换，同str_replace
#把目标字符串所有出现的a或b替换为"-"
str_replace_all(val,"[ab]","-")
#把目标字符串所有出现的a替换为被转义的字符
str_replace_all(val,"[a]","\1\1")


#10:str_replace_na:把NA替换为NA字符串
#str_replace_na(string,replacement="NA")
str_replace_na(c(NA,"NA","abc"),"x")


#11.str_locate:找到匹配的字符串的位置
val<-c("abca",123,"cba")
str_locate(val,"a")
str_locate(val,c("a",12,"b"))


#12.str_locate_all:找到匹配的字符串的位置，同str_locate
#以matrix格式返回
str_locate_all(val,"a")
str_locate_all(val,"[ab]")


#13.str_extract:从字符串中提取匹配字符
val <- c("abca4", 123, "cba2")
str_extract(val,"\\d")
str_extract(val,"[a-z]+")


#14.str_extract_all:从字符串中提取匹配字符，同str_extract
#str_extract(string,patter,simplify=FALSE)
#TRUE返回matrix,FALSE返回字符串向量
str_extract_all(val,"\\d")



#字符串变换函数
#1.str_conv:字符编码转换
#把中文字符字节化
x<-charToRaw("你好");x
#默认win系统字符集为GBK,GB2312为GBK字集,转码正常
str_conv(x,"GBK")
str_conv(x,"GB2312")

#转UTF-8失败
str_conv(x,"UTF-8")

#把unicode转UTF-8
x1<-"\u5317\u4eac"
str_conv(x1,"UTF-8")


#2.str_to_upper:字符串转成大写
val<-"I am conan. Welcome to my blog!"
str_to_upper(val)


#3.str_to_lower:字符串转成小写，规则同str_to_upper
str_to_lower(val)


#4.str_to_title:字符串转成首字母大写，规则同str_to_upper
str_to_title(val)


#参数控制函数：仅用于构造功能的函数，不能独立使用
#1.boundary:定义使用边界
#2.coll:定义字符串标准排序规则
#3.fixed:定义用于匹配的字符，包括正则表达式中的转义符
#4.regex:定义正则表达式
