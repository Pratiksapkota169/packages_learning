#split institution by ";"

rm(list=ls())
gc()

library(RMySQL)

con1<- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '10.51.120.107', dbname='innotree_finance')

dbSendQuery(con1,'SET NAMES utf8')

事实表_融资事件_correct <- dbGetQuery(conn = con1, statement = "SELECT * from 事实表_融资事件_correct;")

dbDisconnect(con1)


library(stringr)
library(dplyr)


事实表_融资事件_correct_test<- filter(事实表_融资事件_correct,str_detect(投资机构,";"))


事实表_融资事件_correct_test<-cbind(Index=c(1:nrow(事实表_融资事件_correct_test)),事实表_融资事件_correct_test)


事实表_融资事件_correct_test_a<-str_split(事实表_融资事件_correct_test$投资机构,";")#list
事实表_融资事件_correct_test_b<-mapply(cbind,事实表_融资事件_correct_test[,1],事实表_融资事件_correct_test_a)

事实表_融资事件_correct_test_c<-data.frame()
for(i in 1:nrow(事实表_融资事件_correct_test)){
  事实表_融资事件_correct_test_c<-rbind(事实表_融资事件_correct_test_c,
                                          data.frame(事实表_融资事件_correct_test_b[i]))
}


names(事实表_融资事件_correct_test_c)<-c("Index","投资机构")
事实表_融资事件_correct_test_c<-mutate(事实表_融资事件_correct_test_c,integer(Index))

事实表_融资事件_correct_test_d<-merge(select(事实表_融资事件_correct_test,-投资机构),事实表_融资事件_correct_test_c,by=c("Index"="Index"))

View(事实表_融资事件_correct_test_d)

