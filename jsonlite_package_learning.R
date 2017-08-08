library(jsonlite)
#library(rjson)

json_data<-fromJSON(paste(readLines("test0808.json",encoding = "UTF-8"),collapse = ""))#encoding本地windows中文可能会乱码
View(json_data)

json_str<-toJSON(json_data)

print(json_str)#打印可能会有转义字符'/'
cat(json_str)#打印无转义字符

writeLines(json_str,"test0808.json")#最后一行空行
