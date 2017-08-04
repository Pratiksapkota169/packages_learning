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


事实表_融资事件_correct_split<- filter(事实表_融资事件_correct,str_detect(投资机构,";"))
#事实表_融资事件_correct_na <- filter(事实表_融资事件_correct,is.na(投资机构))
#事实表_融资事件_correct_not_split <- filter(事实表_融资事件_correct,!str_detect(投资机构,";"))
事实表_融资事件_correct_not_split <-setdiff(事实表_融资事件_correct,事实表_融资事件_correct_split)

事实表_融资事件_correct_split<-cbind(Index=c(1:nrow(事实表_融资事件_correct_split)),事实表_融资事件_correct_split)


事实表_融资事件_correct_split_a<-str_split(事实表_融资事件_correct_split$投资机构,";") #list
事实表_融资事件_correct_split_b<-mapply(cbind,事实表_融资事件_correct_split[,1],事实表_融资事件_correct_split_a)

事实表_融资事件_correct_split_c<-data.frame()
for(i in 1:nrow(事实表_融资事件_correct_split)){
  事实表_融资事件_correct_split_c<-rbind(事实表_融资事件_correct_split_c,
                                           data.frame(事实表_融资事件_correct_split_b[i]))
}

names(事实表_融资事件_correct_split_c)<-c("Index","投资机构")
#事实表_融资事件_correct_split_c<-mutate(事实表_融资事件_correct_split_c,integer(Index))

事实表_融资事件_correct_split_d<-merge(select(事实表_融资事件_correct_split,-投资机构),事实表_融资事件_correct_split_c,by=c("Index"="Index"))


#View(事实表_融资事件_correct_split_d)

事实表_融资事件_correct_split<- select(事实表_融资事件_correct_split_d,公司ID,融资日期,融资轮次,融资金额,`融资金额(万美元)`,投资机构,项目ID,公司全称,项目名称,一级行业,二级行业,三级行业)

事实表_投资事件_correct <- rbind(事实表_融资事件_correct_split,事实表_融资事件_correct_not_split)



con2<- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '10.51.120.107', dbname='innotree_finance')
dbSendQuery(con2,'SET NAMES utf8')

dbWriteTable(con2, "事实表_投资事件_correct", 事实表_投资事件_correct, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)

dbDisconnect(con2)


rm(list=ls())

gc()

