#抓取链家房屋成交数据，一页30，一个城市100页
rm(list = ls())
gc();gc();gc()

#先抓取每页的url地址
library(rvest)

url_0<-"https://bj.lianjia.com/chengjiao/pg"

total<-list()
for(i in 1:100){
  url<-paste(url_0,i,sep = "")
  webpage<-read_html(url)
  
  data_html<-html_nodes(webpage,".title") %>% html_nodes("a") %>% html_attr("href")
  
  data<-as.list(data_html)
  
  data<-data[1:30]
  
  total<-c(total,data)
  Sys.sleep(3)
}

test<-data.frame(total)
test<-t(test)
colnames(test)<-"url"


#进抓取的每页中抓取6个值

total_2<-list()
for(url_2 in test){
  webpage_2<-read_html(url_2)
  
  data_html_2<-html_nodes(webpage_2,".msg label")
  
  data_2<-html_text(data_html_2)
  
  data_2<-c(data_2,url_2)
  total_2<-c(total_2,data_2)
  
  Sys.sleep(3)
}

test_2<-data.frame(total_2)
test_2<-t(test_2)

#每6个转置
# test_3<-data.frame()
# N<-seq(1,nrow(test_2),by=7)
# for(i in N){
#   temp<-data.frame(t(test_2[i:(i+6)]))
#   test_3<-rbind(test_3,temp)
# }
# 
# colnames(test_3)<-c("挂牌价格/万","成交周期/天","调价/次","带看/次","关注/人","浏览/次")

#write.table(test_3,"lianjia_chengjiao.csv",col.names = FALSE,row.names = FALSE)

