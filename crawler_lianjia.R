#抓取链家房屋成交数据，一页30，一个城市100页

library(rvest)

url_0<-"https://bj.lianjia.com/chengjiao/pg"

total<-list()
for(i in 1:100){
  url<-paste(url_0,i,sep = "")
  webpage<-read_html(url)
  
  data_html<-html_nodes(webpage,".listContent .info")
  
  data<-html_text(data_html)
  
  total<-c(total,data)
}

test<-data.frame(total)
test<-t(test)

write.table(test,"lianjia.csv",col.names = FALSE,row.names = FALSE)

