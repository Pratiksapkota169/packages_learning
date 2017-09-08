
#house<-read.table("E:/workspace_r/packages_learning/house_test.csv")
#View(house)

library(rvest)

url_0<-"https://bj.lianjia.com/xiaoqu/rs"

total<-list()
for(i in house$V1){
  url<-paste(url_0,i,sep = "")
  webpage<-read_html(url)
  
  data_html<-html_nodes(webpage,".district , .info .title a")
  
  data<-html_text(data_html)
  
  total<-c(total,data)
  
  #Sys.sleep(3)
}

test<-data.frame(total)
test<-t(test)


#每2个转置
test_new<-data.frame()
N<-seq(1,nrow(test),by=2)
for(i in N){
  temp<-data.frame(t(test[i:(i+1)]))
  test_new<-rbind(test_new,temp)
}

colnames(test_new)<-c("小区名称","所属地区")

View(test_new)

write.table(test_new,"xiaoqu.csv",col.names = TRUE,row.names = FALSE)

