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


#行业无表头
#6.17-6.23
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746689&idx=1&sn=ba55d78a850879cca1439ef67fd59e0f&chksm=bd4a7ac48a3df3d29cb7afecff61119ed05b6df4d0af4ab5591dcaa909551bab97d7de8726bb&mpshare=1&scene=1&srcid=0814oYNWMU9eIXFseeu8RmwK#rd"

#部分有表头
#6.10-6.16
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746655&idx=1&sn=0842b646610eb5f62cdcb32e87f14060&chksm=bd4a7a9a8a3df38c3fa6596e24d88dd2f71f6bb46f04e68a72f4f1534303da43db4ff0fb8314&mpshare=1&scene=1&srcid=0814AuCgI3o6jekwyhatYKdZ#rd"

#有表头
#6.3-6.9
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746645&idx=1&sn=35aeb3d0829790feb337841cc567d994&chksm=bd4a7a908a3df3861963853183b37f7fb254b7a38835847b68ea337faea47e124198c646a84d&mpshare=1&scene=1&srcid=0814VhXpYdfuj7dkNGHiBcC3#rd"

#有空值
#5.27-6.2
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746645&idx=1&sn=35aeb3d0829790feb337841cc567d994&chksm=bd4a7a908a3df3861963853183b37f7fb254b7a38835847b68ea337faea47e124198c646a84d&mpshare=1&scene=1&srcid=0814VhXpYdfuj7dkNGHiBcC3#rd"

#5.20-5.26
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746632&idx=1&sn=63a00e7be1867bb90f757aa328e964f7&chksm=bd4a7a8d8a3df39b3061ed7b5351bde0a991392d7f0588526982fde27df47049f614df36d85d&mpshare=1&scene=1&srcid=0814ZF1vYWO4NJEUqcacUbz5#rd"


#5.13-5.19
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746626&idx=1&sn=686a7bcbc0e472bf183fa9dc3213abf2&chksm=bd4a7a878a3df391e34adf567b8da67cab378b2bc15a4c937a4198c47a700ff5ebdb01760f45&mpshare=1&scene=1&srcid=0814cGYh2U65NL5zfvJnLx6G#rd"


#5.6-5.12
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746619&idx=1&sn=ecf263c74f3e54f06cbb9dea2b1206d7&chksm=bd4a7b7e8a3df268119f19cc49fd1e001919553c080cf6a2131f5fff76c8685e14b3fcb248b4&mpshare=1&scene=1&srcid=0814JOIsFRADRoHzn21SfUG8#rd"


#4.29-5.5
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746613&idx=1&sn=8de7b641d55f6764a771a1df2803c2a9&chksm=bd4a7b708a3df266494567be71339e31b778d666760e0354e6979f6227f4023e9cc743a73282&mpshare=1&scene=1&srcid=0814Df8Jupj40sWYaReXqvaO#rd"

#4.8-4.14
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746607&idx=1&sn=52b52cb465fcb858964aac042aba5bf0&chksm=bd4a7b6a8a3df27cbf731311a36b0281ca0be8e845ccca61e2d723b86ec7424ecc1c61126ae4&mpshare=1&scene=1&srcid=0814LZNzAzOZfgbU2G4urutP#rd"

#4.2-4.7
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746600&idx=1&sn=164754a9c97d234d8914351c8457f4c8&chksm=bd4a7b6d8a3df27bc24dc19246bcdb6acab2be2f10fc7541ecf7766fb8c42c19f7c714fdc87d&mpshare=1&scene=1&srcid=08149Mg0mK0QKpFgD5d6fyHo#rd"

#3.25-4.1
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746595&idx=1&sn=1abe592019ab7522c80a21e30fa540eb&chksm=bd4a7b668a3df2701e96e7e5c2b9ff7f1c298c0c919adeaf96ed3ecdc5a36d2155233622d768&mpshare=1&scene=1&srcid=0814gZJmlvGAGvD4TvgxZD20#rd"


#3.18-3.24
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746582&idx=1&sn=d5b01da5f952123850ffd308de8ce2ed&chksm=bd4a7b538a3df245cd1b14cef66a2e8f808644a1d8a8f7235998ddd1c2993363ec998404f95a&mpshare=1&scene=1&srcid=081462gf5eoqg4bhWhCFVW5S#rd"

#3.11-3.17
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746569&idx=1&sn=e756241155d96a8232c36ec3c0f0a995&chksm=bd4a7b4c8a3df25ae74d027b4c8aa9f8ea8303cb6a8568746ae29a30c32c1b96528646c7f4cd&mpshare=1&scene=1&srcid=08149FoDEl9y5acTIuO5U7Kf#rd"

#多了日期列
#3.4-3.10
#url<-"https://mp.weixin.qq.com/s?__biz=MjM5ODY0NTQ4Mg==&mid=2658746558&idx=1&sn=fc0809bd1ff020033dbdc94376aabbcd&chksm=bd4a7b3b8a3df22dc0a67e770d7b65a966ee08e1754d592c3f1696a84cafcc72c8c012c993eb&mpshare=1&scene=1&srcid=0814MJpXonbllKyYgU8A9Uc8#rd"




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
