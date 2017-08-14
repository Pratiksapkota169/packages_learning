# 
# CREATE TABLE `IPO事件` (
#   `上市企业` varchar(255) NOT NULL DEFAULT '',
#   `交易所` varchar(255) DEFAULT NULL,
#   `所属行业` varchar(255) DEFAULT NULL,
#   `募集金额` varchar(255) DEFAULT NULL,
#   `week` varchar(255) DEFAULT NULL
#   KEY `i_name` (`上市企业`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
# 
# CREATE TABLE `并购事件` (
#   `被并购方` varchar(255) NOT NULL DEFAULT '',
#   `并购方` varchar(255) DEFAULT NULL,
#   `所属行业` varchar(255) DEFAULT NULL,
#   `所在地` varchar(255) DEFAULT NULL,
#   `收购金额` varchar(255) DEFAULT NULL,
#   `股权比例` varchar(255) DEFAULT NULL,
#   `week` varchar(255) DEFAULT NULL
#   KEY `i_name` (`被并购方`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
# 
# CREATE TABLE `新三板定增` (
#   `企业` varchar(255) NOT NULL DEFAULT '',
#   `主营业务` varchar(255) DEFAULT NULL,
#   `定增金额` varchar(255) DEFAULT NULL,
#   `投资人` varchar(255) DEFAULT NULL,
#   `week` varchar(255) DEFAULT NULL
#   KEY `i_name` (`企业`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
# 
# CREATE TABLE `新三板挂牌` (
#   `企业` varchar(255) NOT NULL DEFAULT '',
#   `代码` varchar(255) DEFAULT NULL,
#   `主办券商` varchar(255) DEFAULT NULL,
#   `行业` varchar(255) DEFAULT NULL,
#   `week` varchar(255) DEFAULT NULL
#   KEY `i_name` (`企业`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
# 
# CREATE TABLE `行业` (
#   `企业` varchar(255) NOT NULL DEFAULT '',
#   `主营业务` varchar(255) DEFAULT NULL,
#   `所在地` varchar(255) DEFAULT NULL,
#   `轮次` varchar(255) DEFAULT NULL,
#   `金额` varchar(255) DEFAULT NULL,
#   `投资人` varchar(255) DEFAULT NULL,
#   `所属行业` varchar(255) DEFAULT NULL,
#   `week` varchar(255) DEFAULT NULL
#   KEY `i_name` (`企业`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;



library(rvest)

url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746726&idx=1&sn=0f7e43171d43d268805424341592e801&chksm=bd4a7ae38a3df3f5434057be3507cca0dd51e2d00daa94adeb0e1814397eb0a411271c2adc32&scene=0#rd"

webpage<-read_html(url)

data_html<-html_nodes(webpage,"td")
title_html<-html_node(webpage,"#activity-name")

data<-html_text(data_html)
title<-html_text(title_html)

library(stringr)
title<-str_replace_all(title,"[\\r\\n ]","")
title<-str_replace(title,"[～]","~")

title<-str_split_fixed(title,"\\|",2)

week<-title[,1]
title<-title[,2]


# test<-as.list(data)



start_index_新三板定增<-which(data=="定增金额",arr.ind = TRUE)-2
# end_index_新三板定增<-length(test)
end_index_新三板定增<-length(data)

start_index_新三板挂牌<-which(data=="代码",arr.ind = TRUE)-1
end_index_新三板挂牌<-start_index_新三板定增-1

start_index_IPO事件<-which(data=="上市企业",arr.ind = TRUE)
end_index_IPO事件<-start_index_新三板挂牌-1

start_index_并购事件<-which(data=="被并购方",arr.ind = TRUE)
end_index_并购事件<-start_index_IPO事件-1




#新三板定增部分
新三板定增<-data.frame()
N<-seq(start_index_新三板定增,end_index_新三板定增,by=4)

for(i in N){
  temp<-rbind(data[i:(i+3)])
  新三板定增<-rbind(新三板定增,temp)
}


新三板定增<-新三板定增[-1,]
新三板定增<-cbind(新三板定增,week)
names(新三板定增)<-c("企业","主营业务","定增金额","投资人","week")
# View(新三板定增)


#新三板挂牌部分
新三板挂牌<-data.frame()
N<-seq(start_index_新三板挂牌,end_index_新三板挂牌,by=4)

for(i in N){
  temp<-rbind(data[i:(i+3)])
  新三板挂牌<-rbind(新三板挂牌,temp)
}



新三板挂牌<-新三板挂牌[-1,]
新三板挂牌<-cbind(新三板挂牌,week)
names(新三板挂牌)<-c("企业","代码","主办券商","行业","week" )
# View(新三板挂牌)


#IPO事件部分
IPO事件<-data.frame()
N<-seq(start_index_IPO事件,end_index_IPO事件,by=4)

for(i in N){
  temp<-rbind(data[i:(i+3)])
  IPO事件<-rbind(IPO事件,temp)
}



IPO事件<-IPO事件[-1,]
IPO事件<-cbind(IPO事件,week)
names(IPO事件)<-c("上市企业","交易所","所属行业","募集金额","week")
# View(IPO事件)


#并购事件部分
并购事件<-data.frame()
N<-seq(start_index_并购事件,end_index_并购事件,by=6)

for(i in N){
  temp<-rbind(data[i:(i+5)])
  并购事件<-rbind(并购事件,temp)
}



并购事件<-并购事件[-1,]
并购事件<-cbind(并购事件,week)
names(并购事件)<-c("被并购方","并购方","所属行业","所在地","收购金额","股权比例","week")
# View(并购事件)




#行业部分
data<-data[1:(start_index_并购事件-1)]

title_index_行业<-which(data=="轮次",arr.ind = TRUE)-4
data<-data[-title_index_行业]

industry_title<-c("企业","主营业务","所在地","轮次","金额","投资人","所属行业")

data<-data[-which(data %in% industry_title)]

行业<-data.frame()
N<-seq(1,length(data),by=7)

for(i in N){
  temp<-rbind(data[i:(i+6)])
  行业<-rbind(行业,temp)
}


行业<-cbind(行业,week)
names(行业)<-c("企业","主营业务","所在地","轮次","金额","投资人","所属行业","week")


rm("data","data_html","end_index_IPO事件","end_index_并购事件",
   "end_index_新三板定增","end_index_新三板挂牌","i","N","start_index_IPO事件",
   "start_index_并购事件","start_index_新三板定增","start_index_新三板挂牌",
   "temp","title_index_行业","url","webpage","title_html","week","industry_title")
gc();gc();gc();gc();gc();gc();gc();gc();gc();gc()



library(RMySQL)

con1<- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '10.51.120.107', dbname='innotree_finance')

dbSendQuery(con1,'SET NAMES utf8')

# dbGetQuery(conn = con1, statement = "delete from scraper_新三板定增;")
# dbGetQuery(conn = con1, statement = "delete from scraper_新三板挂牌;")
# dbGetQuery(conn = con1, statement = "delete from scraper_IPO事件;")
# dbGetQuery(conn = con1, statement = "delete from scraper_并购事件;")
# dbGetQuery(conn = con1, statement = "delete from scraper_行业;")


dbWriteTable(con1, "scraper_新三板定增", 新三板定增, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con1, "scraper_新三板挂牌", 新三板挂牌,append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE) 
dbWriteTable(con1, "scraper_IPO事件", IPO事件,append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE) 
dbWriteTable(con1, "scraper_并购事件", 并购事件, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con1, "scraper_行业", 行业, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)


dbDisconnect(con1)

rm("con1","IPO事件","并购事件","新三板定增","新三板挂牌","行业","title")
gc();gc();gc();gc();gc();gc();gc();gc();gc();gc()
