#learn from:https://mp.weixin.qq.com/s?__biz=MzA3Njc0NzA0MA==&mid=2653191494&idx=1&sn=a465cc58eb198ae10ddcd002bda93bdf&chksm=848c4509b3fbcc1f834441251034e9784d4d644750ce787b2d5e06abf759682d8a335a4b04fe&mpshare=1&scene=1&srcid=0807vSnggHyO87HR123o4GgC#rd
#install.packages("rvest")
#install.packages("downloader")

rm(list=ls())
gc();gc();gc()

library(rvest)
library(downloader)
url<-"https://www.zhihu.com/question/35931586/answer/206258333"
link<- read_html(url)%>% html_nodes("div.RichContent-inner>span")%>%html_nodes("img")%>%html_attr("data-original")%>%na.omit   
#"div.RichContent-inner>span"，"img"为class的node，用html_nodes取；
#"data-original"为img内部的属性，用html_attr取

link<-link[seq(1,length(link),by=2)]                 #剔除无效网址
Name<-sub("https://pic\\d.zhimg.com/v2-","",link)    #提取图片名称
dir.create("E:/workspace_r/zhihu")             #建立存储文件夹，只能在工作目录下创建
setwd("E:/workspace_r/zhihu")                  #锁定临时目录
for(i in 1:length(link)){
  download(link[i],Name[i], mode = "wb")
}  
#下载过程
