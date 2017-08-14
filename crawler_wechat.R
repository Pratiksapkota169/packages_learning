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

#8.4-8.10
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746726&idx=1&sn=0f7e43171d43d268805424341592e801&chksm=bd4a7ae38a3df3f5434057be3507cca0dd51e2d00daa94adeb0e1814397eb0a411271c2adc32&mpshare=1&scene=1&srcid=0814MOyKAG0WZ2vKNy4SH174#rd"

#7.28-8.3
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746721&idx=1&sn=856878b3101c1f5ed66560eb5fa4289e&chksm=bd4a7ae48a3df3f2e8640103f001e649e3b488b27f7b684ec07339c11dd8d3e0cf30270730b0&mpshare=1&scene=1&srcid=0814l2pMFGgPz7coH7Fu5l1b#rd"

#7.22-7.27
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746716&idx=1&sn=e979841d3e8501e3a1b6ceadf1307100&chksm=bd4a7ad98a3df3cf4df5fd8c84da15340187fb1ad2b7bd966cd22e321f23ad2e64688e46e586&mpshare=1&scene=1&srcid=0814KJNSrjfsrhjlbUeAKfIU#rd"


#无所属行业列
#7.15-7.21
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746711&idx=1&sn=cf25d465c073bd1e129d9a313a5ec549&chksm=bd4a7ad28a3df3c43bac4e3941348fdbe95b706b7ba7879604845d924b70febf62702b9680af&mpshare=1&scene=1&srcid=0814YPzLK3oZjcxMaVlJdYL5#rd"

#7.8-7.14
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746706&idx=1&sn=7094f0341165820ec10c000fb0a93a8e&chksm=bd4a7ad78a3df3c156428945bb1e1a50e13f176a0229713fe90e72e5d85c35da8394f49075b9&mpshare=1&scene=1&srcid=081462uDmvoRl0BufODtRCxE#rd"

#7.1-7.7
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746700&idx=1&sn=fc01cf3d5871731c262b4a298594afc8&chksm=bd4a7ac98a3df3dfffb303508b46fff94b8cf7018d9db1098835febf29fa4f34754beee437dd&mpshare=1&scene=1&srcid=0814MaEcDFPxe5PPwgbihMO4#rd"









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
