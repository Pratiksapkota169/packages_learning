#已解决问题：
#1.融资金额单位换算
#2.投资机构按";"分列
#3.投资机构未知、NA的情况统一为"投资方为透露"
#4.新的行业三级分类，分别关联上公司名称和项目名称两张表
#5.替换投融资事件表里的三级行业为新三级行业分类
#6.

#待解决问题：
#1.投资机构还有按"；"、","分隔的
#2.投资机构为"天使投资人"是否可化为"投资方为透露"
#3.融资轮次NA--->未透露
#4.投资机构left有空格
#5.


library(RMySQL)


#first:delect tables
con1<- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '10.51.120.107', dbname='innotree_finance')

dbSendQuery(con1,'SET NAMES utf8')

dbGetQuery(conn = con1, statement = "delete from comp_baseinfo_a;")
dbGetQuery(conn = con1, statement = "delete from comp_baseinfo_guowai;")
dbGetQuery(conn = con1, statement = "delete from comp_baseinfo_innotree;")
dbGetQuery(conn = con1, statement = "delete from comp_baseinfo_ntb;")
dbGetQuery(conn = con1, statement = "delete from comp_baseinfo_tags;")
dbGetQuery(conn = con1, statement = "delete from comp_market_value;")
dbGetQuery(conn = con1, statement = "delete from comp_pe;")
dbGetQuery(conn = con1, statement = "delete from key_company;")
dbGetQuery(conn = con1, statement = "delete from 维表_公司;")
dbGetQuery(conn = con1, statement = "delete from 事实表_融资事件;")
dbGetQuery(conn = con1, statement = "delete from 事实表_融资事件_correct_industry;")
dbGetQuery(conn = con1, statement = "delete from 事实表_投资事件_correct_industry;")
dbGetQuery(conn = con1, statement = "delete from wiki_info;")
dbGetQuery(conn = con1, statement = "delete from 事实表_融资事件_correct;")
dbGetQuery(conn = con1, statement = "delete from 事实表_融资事件_recent;")
dbGetQuery(conn = con1, statement = "delete from 事实表_投资事件_correct;")
dbGetQuery(conn = con1, statement = "delete from 事实表_投资事件_recent;")
dbGetQuery(conn = con1, statement = "delete from company_classification;")
dbGetQuery(conn = con1, statement = "delete from project_classification;")
dbGetQuery(conn = con1, statement = "delete from innotree_industrychain_new;")

dbDisconnect(con1)

rm(list = ls())
gc();gc();gc();gc();gc();gc();gc();gc();gc();gc();



#second:copy tables from online databases
con1 <- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '100.115.97.86')

dbSendQuery(con1,'SET NAMES utf8')

comp_baseinfo_a <- dbGetQuery(conn = con1, statement = "SELECT * from dc_cscyl.comp_baseinfo_a;")
comp_baseinfo_guowai <- dbGetQuery(conn = con1, statement = "SELECT * from dc_cscyl.comp_baseinfo_guowai;")
comp_baseinfo_ntb <- dbGetQuery(conn = con1, statement = "SELECT * from dc_cscyl.comp_baseinfo_ntb;")
comp_baseinfo_tags <- dbGetQuery(conn = con1, statement = "SELECT * from nlp_company.comp_baseinfo_tags;")
comp_market_value <- dbGetQuery(conn = con1, statement = "SELECT * from dc_cscyl.comp_market_value;")
comp_pe <- dbGetQuery(conn = con1, statement = "SELECT * from dc_cscyl.comp_pe;")
维表_公司 <- dbGetQuery(conn = con1, statement = "SELECT * from dw.维表_公司;")
事实表_融资事件 <- dbGetQuery(conn = con1, statement = "SELECT * from dw.事实表_融资事件;")
wike_info <- dbGetQuery(conn = con1, statement = "SELECT * from nlp_company.wiki_info;")
company_classification <- dbGetQuery(conn = con1, statement = "SELECT key_company.ncid,cname,label1,tagname_1,label2,tagname_2,label3,tagname_3 FROM dc_key.key_company LEFT JOIN (SELECT ncid,label1,tagname_1,label2,tagname_2,label3,tagname as tagname_3 FROM (SELECT ncid,label1,tagname_1,label2,tagname as tagname_2,label3 FROM (SELECT ncid,label1,tagname as tagname_1,label2,label3 FROM nlp_company2.company_classification LEFT JOIN nlp_company2.classification ON nlp_company2.company_classification.label1=nlp_company2.classification.tagid)as t1 LEFT JOIN nlp_company2.classification ON t1.label2=nlp_company2.classification.tagid)as t2 LEFT JOIN nlp_company2.classification ON t2.label3=nlp_company2.classification.tagid)as t3 ON dc_key.key_company.ncid=t3.ncid;")
project_classification <- dbGetQuery(conn = con1, statement = "SELECT project.Id as pid,sName as pname,label1,tagname_1,label2,tagname_2,label3,tagname_3 FROM dc_cscyl.project LEFT JOIN (SELECT pid,label1,tagname_1,label2,tagname_2,label3,tagname as tagname_3 FROM (SELECT pid,label1,tagname_1,label2,tagname as tagname_2,label3 FROM (SELECT pid,label1,tagname as tagname_1,label2,label3 FROM nlp_company2.project_classification LEFT JOIN nlp_company2.classification ON nlp_company2.project_classification.label1=nlp_company2.classification.tagid)as t1 LEFT JOIN nlp_company2.classification ON t1.label2=nlp_company2.classification.tagid)as t2 LEFT JOIN nlp_company2.classification ON t2.label3=nlp_company2.classification.tagid)as t3 ON dc_cscyl.project.Id=t3.pid;")
innotree_industrychain_new <- dbGetQuery(conn = con1, statement = "SELECT cname,ncid,industry,chain,segment as segmentation_first,subsegment as segmentation_second FROM dc_cscyl.chain_complist;")

dbDisconnect(con1)

library(dplyr)
library(stringr)

#clean 事实表_融资事件--->事实表_融资事件_correct
事实表_融资事件_correct<-select(事实表_融资事件,-`融资金额(万美元)`) %>% 
  mutate(iAmount=case_when(is.na(.$融资金额)~ 0,
                           str_detect(.$融资金额,"千万及以上人民币")==TRUE ~ 526,
                           str_detect(.$融资金额,"亿元及以上人民币")==TRUE ~ 1503,
                           str_detect(.$融资金额,"投资金额未透露")==TRUE ~ 0,
                           str_detect(.$融资金额,"数百万元人民币")==TRUE ~ 52,
                           str_detect(.$融资金额,"万数百万人民币")==TRUE ~ 52,
                           str_detect(.$融资金额,"近千万元人民币")==TRUE ~ 526,
                           str_detect(.$融资金额,"数千万级人民币")==TRUE ~ 526,
                           str_detect(.$融资金额,"数千万万人民币")==TRUE ~ 526,
                           str_detect(.$融资金额,"数千万元人民币")==TRUE ~ 526,
                           str_detect(.$融资金额,"亿元及以上港元")==TRUE ~ 1290,
                           str_detect(.$融资金额,"亿元及以上其他")==TRUE ~ 1503,
                           str_detect(.$融资金额,"亿元及以上美元")==TRUE ~ 10000,
                           str_detect(.$融资金额,"投资方未透露")==TRUE ~ 0,
                           str_detect(.$融资金额,"数十万人民币")==TRUE ~ 5,
                           str_detect(.$融资金额,"万澳大利亚元")==TRUE ~ 19,
                           str_detect(.$融资金额,"近百万人民币")==TRUE ~ 52,
                           str_detect(.$融资金额,"数百万人民币")==TRUE ~ 52,
                           str_detect(.$融资金额,"数千万新台币")==TRUE ~ 108,
                           str_detect(.$融资金额,"近千万人民币")==TRUE ~ 526,
                           str_detect(.$融资金额,"千万级人民币")==TRUE ~ 526,
                           str_detect(.$融资金额,"数千万人民币")==TRUE ~ 526,
                           str_detect(.$融资金额,"近亿元人民币")==TRUE ~ 5263,
                           str_detect(.$融资金额,"数亿元人民币")==TRUE ~ 5263,
                           str_detect(.$融资金额,"数万人民币")==TRUE ~ 0.5,
                           str_detect(.$融资金额,"数十万美元")==TRUE ~ 35,
                           str_detect(.$融资金额,"数百万美元")==TRUE ~ 350,
                           str_detect(.$融资金额,"数百万欧元")==TRUE ~ 393,
                           str_detect(.$融资金额,"数千万港元")==TRUE ~ 451,
                           str_detect(.$融资金额,"数百万英镑")==TRUE ~ 466,
                           str_detect(.$融资金额,"数千万美元")==TRUE ~ 3500,
                           str_detect(.$融资金额,"数千万其他")==TRUE ~ 3500,
                           str_detect(.$融资金额,"近亿人民币")==TRUE ~ 5263,
                           str_detect(.$融资金额,"数亿人民币")==TRUE ~ 5263,
                           str_detect(.$融资金额,"一亿人民币")==TRUE ~ 5263,
                           str_detect(.$融资金额,"千万欧元")==TRUE ~ 337,
                           str_detect(.$融资金额,"近亿美元")==TRUE ~ 35000,
                           str_detect(.$融资金额,"数亿美元")==TRUE ~ 35000,
                           str_detect(.$融资金额,"万不详")==TRUE ~ 0,
                           str_detect(.$融资金额,"未公开")==TRUE ~ 0,
                           str_detect(.$融资金额,"未透漏")==TRUE ~ 0,
                           str_detect(.$融资金额,"未透露")==TRUE ~ 0,
                           str_detect(.$融资金额,"不详")==TRUE ~ 0,
                           str_detect(.$融资金额,"多万人民币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.1488,
                           str_detect(.$融资金额,"万元人民币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.1488,
                           str_detect(.$融资金额,"万新加坡元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.7379,
                           str_detect(.$融资金额,"百万人民币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*14.88,
                           str_detect(.$融资金额,"千万人民币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*148.8,
                           str_detect(.$融资金额,"亿元人民币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1488,
                           str_detect(.$融资金额,"万韩国元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.0008,
                           str_detect(.$融资金额,"万新台币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.0331,
                           str_detect(.$融资金额,"万人民币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.1488,
                           str_detect(.$融资金额,"千万美元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1000,
                           str_detect(.$融资金额,"亿人民币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1488,
                           str_detect(.$融资金额,"人民币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.00001488,
                           str_detect(.$融资金额,"万韩元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.0008,
                           str_detect(.$融资金额,"万日元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.009,
                           str_detect(.$融资金额,"万卢比")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.0156,
                           str_detect(.$融资金额,"万港币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.128,
                           str_detect(.$融资金额,"万港元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.128,
                           str_detect(.$融资金额,"万其他")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.1488,
                           str_detect(.$融资金额,"万人民")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.1488,
                           str_detect(.$融资金额,"万澳元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.7196,
                           str_detect(.$融资金额,"万加元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.8006,
                           str_detect(.$融资金额,"万美金")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1,
                           str_detect(.$融资金额,"万美元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1,
                           str_detect(.$融资金额,"万欧元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1.1829,
                           str_detect(.$融资金额,"万英镑")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1.3222,
                           str_detect(.$融资金额,"亿美元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*10000,
                           str_detect(.$融资金额,"亿欧元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*11829,
                           str_detect(.$融资金额,"亿港币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1280,
                           str_detect(.$融资金额,"亿港元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1280,
                           str_detect(.$融资金额,"亿英镑")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*13222,
                           str_detect(.$融资金额,"亿其他")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1488,
                           str_detect(.$融资金额,"亿卢比")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*156,
                           str_detect(.$融资金额,"亿日元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*90,
                           str_detect(.$融资金额,"新元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.00007379,
                           str_detect(.$融资金额,"美元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.0001,
                           str_detect(.$融资金额,"万元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.1488,
                           str_detect(.$融资金额,"万美")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1,
                           str_detect(.$融资金额,"亿元")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1488,
                           str_detect(.$融资金额,"万")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.1488,
                           str_detect(.$融资金额,"亿")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1488
                           
  )) %>% 
  rename(`融资金额(万美元)`=iAmount) %>% 
  select(公司ID,融资日期,融资轮次,融资金额,`融资金额(万美元)`,投资机构,项目ID,公司全称,项目名称,一级行业,二级行业,三级行业)

事实表_融资事件_correct_temp_1 <- filter(事实表_融资事件_correct,!is.na(`融资金额(万美元)`))

#deal with some special cases
事实表_融资事件_correct_temp_2 <- filter(事实表_融资事件_correct,is.na(`融资金额(万美元)`)) %>% 
  rename(`融资金额(万美元)_new`=`融资金额(万美元)`) %>% 
  mutate(融资金额=str_trim(融资金额,side="both")) %>% 
  mutate(iAmount=case_when(str_detect(.$融资金额,"千万人民币")==TRUE ~ 526,
                           str_detect(.$融资金额,"百万人民币")==TRUE ~ 52,
                           str_detect(.$融资金额,"千万美元")==TRUE ~ 3500,
                           str_detect(.$融资金额,"亿人民币")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*1488,
                           str_detect(.$融资金额,"万人民")==TRUE ~ as.numeric(str_match(.$融资金额,"[0-9\\.]*"))*0.1488,
                           str_detect(.$融资金额,"人民币")==TRUE ~ 0,
                           TRUE ~ 0
  )) %>% 
  rename(`融资金额(万美元)`=iAmount) %>% 
  select(公司ID,融资日期,融资轮次,融资金额,`融资金额(万美元)`,投资机构,项目ID,公司全称,项目名称,一级行业,二级行业,三级行业)

事实表_融资事件_correct <- union(事实表_融资事件_correct_temp_1,事实表_融资事件_correct_temp_2)


#update tagname to new 
事实表_融资事件_correct <-left_join(事实表_融资事件_correct,company_classification,by=c("公司全称"="cname")) %>% 
  select(公司ID,融资日期,融资轮次,融资金额,`融资金额(万美元)`,投资机构,项目ID,公司全称,项目名称,tagname_1,tagname_2,tagname_3)
colnames(事实表_融资事件_correct)<-c("公司ID","融资日期","融资轮次","融资金额","融资金额(万美元)","投资机构","项目ID","公司全称","项目名称","一级行业","二级行业","三级行业")


#create 事实表_融资事件_recent
事实表_融资事件_recent <- 事实表_融资事件_correct %>% 
  group_by(公司全称) %>% 
  arrange(desc(融资日期)) %>% 
  do(head(.,1))


#clean 事实表_投资事件--->事实表_投资事件_correct
事实表_融资事件_correct_split<- filter(事实表_融资事件_correct,str_detect(投资机构,";"))

事实表_融资事件_correct_not_split <-setdiff(事实表_融资事件_correct,事实表_融资事件_correct_split)

事实表_融资事件_correct_split<-cbind(Index=c(1:nrow(事实表_融资事件_correct_split)),事实表_融资事件_correct_split)


事实表_融资事件_correct_split_a<-str_split(事实表_融资事件_correct_split$投资机构,";")
事实表_融资事件_correct_split_b<-mapply(cbind,事实表_融资事件_correct_split[,1],事实表_融资事件_correct_split_a)

事实表_融资事件_correct_split_c<-data.frame()
for(i in 1:nrow(事实表_融资事件_correct_split)){
  事实表_融资事件_correct_split_c<-rbind(事实表_融资事件_correct_split_c,
                                           data.frame(事实表_融资事件_correct_split_b[i]))
}

names(事实表_融资事件_correct_split_c)<-c("Index","投资机构")

事实表_融资事件_correct_split_d<-merge(select(事实表_融资事件_correct_split,-投资机构),事实表_融资事件_correct_split_c,by=c("Index"="Index"))


事实表_融资事件_correct_split<- select(事实表_融资事件_correct_split_d,公司ID,融资日期,融资轮次,融资金额,`融资金额(万美元)`,投资机构,项目ID,公司全称,项目名称,一级行业,二级行业,三级行业)

事实表_投资事件_correct <- rbind(事实表_融资事件_correct_split,事实表_融资事件_correct_not_split)


#unify institution--->投资方未透露
事实表_投资事件_correct_unknown<-filter(事实表_投资事件_correct,事实表_投资事件_correct$投资机构 %in% c("未透露","并购方未透露","*未透露","投资者未透露","投资人未透露","未透漏","不公开的投资者","不公开的风险投资者","不明确","不详",NA,"","	投资方未透露")) %>% 
  mutate(投资机构="投资方未透露")

事实表_投资事件_correct_known<-filter(事实表_投资事件_correct,!事实表_投资事件_correct$投资机构 %in% c("未透露","并购方未透露","*未透露","投资者未透露","投资人未透露","未透漏","不公开的投资者","不公开的风险投资者","不明确","不详",NA,"","	投资方未透露"))

事实表_投资事件_correct<-union_all(事实表_投资事件_correct_unknown,事实表_投资事件_correct_known)


#update tagname to new 
事实表_投资事件_correct <-left_join(事实表_投资事件_correct,company_classification,by=c("公司全称"="cname")) %>% 
  select(公司ID,融资日期,融资轮次,融资金额,`融资金额(万美元)`,投资机构,项目ID,公司全称,项目名称,tagname_1,tagname_2,tagname_3)
colnames(事实表_投资事件_correct)<-c("公司ID","融资日期","融资轮次","融资金额","融资金额(万美元)","投资机构","项目ID","公司全称","项目名称","一级行业","二级行业","三级行业")


#create 事实表_投资事件--->事实表_投资事件_recent
事实表_投资事件_recent <- 事实表_投资事件_correct %>% 
  group_by(投资机构) %>% 
  arrange(desc(融资日期)) %>% 
  do(head(.,1))



#third:write tables into developed databases
con2<- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '10.51.120.107', dbname='innotree_finance')

dbSendQuery(con2,'SET NAMES utf8')

dbWriteTable(con2, "comp_baseinfo_a", comp_baseinfo_a, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "comp_baseinfo_guowai", comp_baseinfo_guowai, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "comp_baseinfo_ntb", comp_baseinfo_ntb, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "comp_baseinfo_tags", comp_baseinfo_tags, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "comp_market_value", comp_market_value, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "comp_pe", comp_pe, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "维表_公司", 维表_公司, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "事实表_融资事件", 事实表_融资事件,append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE) 
dbWriteTable(con2, "wiki_info", wike_info, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "事实表_融资事件_correct", 事实表_融资事件_correct,append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE) 
dbWriteTable(con2, "事实表_融资事件_recent", 事实表_融资事件_recent,append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE) 
dbWriteTable(con2, "事实表_投资事件_correct", 事实表_投资事件_correct, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "事实表_投资事件_recent", 事实表_投资事件_recent, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "company_classification", company_classification, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "project_classification", project_classification, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "innotree_industrychain_new", innotree_industrychain_new, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)

dbDisconnect(con2)


rm(list=ls())

gc();gc();gc();gc();gc();gc();gc();gc();gc();gc()


#Error in .local(conn, statement, ...) : 
#could not run statement: Multi-statement transaction required more than 'max_binlog_cache_size' bytes of storage; 
#increase this mysqld variable and try again
#solution:change engine from InnoDB to MyISAM


#deal with some big tables
library(RMySQL)
con1 <- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '100.115.97.86')
dbSendQuery(con1,'SET NAMES utf8')

comp_baseinfo_innotree <- dbGetQuery(conn = con1, statement = "SELECT * from dc_cscyl.comp_baseinfo_innotree;")
key_company <- dbGetQuery(conn = con1, statement = "SELECT * from dc_key.key_company;")

dbDisconnect(con1)

con2<- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '10.51.120.107', dbname='innotree_finance')
dbSendQuery(con2,'SET NAMES utf8')

dbWriteTable(con2, "comp_baseinfo_innotree", comp_baseinfo_innotree, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con2, "key_company", key_company, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)

dbDisconnect(con2)


rm(list=ls())

gc();gc();gc();gc();gc();gc();gc();gc();gc();gc()


#rebuild 事实表_投资事件_产业链/事实表_融资事件_产业链 according to _correct series
con1<- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '10.51.120.107', dbname='innotree_finance')

dbSendQuery(con1,'SET NAMES utf8')

事实表_投资事件_correct_industry <- dbGetQuery(conn = con1, statement = "select 公司ID,融资日期,融资轮次,融资金额,`融资金额(万美元)`,投资机构,项目ID,公司全称,项目名称,一级行业,二级行业,三级行业,industry,chain,segmentation_first,segmentation_second FROM 事实表_投资事件_correct LEFT JOIN innotree_industrychain_new ON 事实表_投资事件_correct.公司全称=innotree_industrychain_new.cname;")
事实表_融资事件_correct_industry <- dbGetQuery(conn = con1, statement = "select 公司ID,融资日期,融资轮次,融资金额,`融资金额(万美元)`,投资机构,项目ID,公司全称,项目名称,一级行业,二级行业,三级行业,industry,chain,segmentation_first,segmentation_second FROM 事实表_融资事件_correct LEFT JOIN innotree_industrychain_new ON 事实表_融资事件_correct.公司全称=innotree_industrychain_new.cname;")

dbWriteTable(con1, "事实表_投资事件_correct_industry", 事实表_投资事件_correct_industry, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)
dbWriteTable(con1, "事实表_融资事件_correct_industry", 事实表_融资事件_correct_industry, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)

dbDisconnect(con1)


rm(list=ls())

gc();gc();gc();gc();gc();gc();gc();gc();gc();gc()

#Finally:when finished the program ,send a email to me
library(mailR)
#email to
recipients <- "ying.huang@innotree.cn" 
#email from
sender = "18810600277@163.com"  
#email title
title = "Daily Report"  
#print time
time=Sys.time()

send.mail(
  from = sender,
  to = recipients,  
  subject = title,
  body = paste("Program is finished.",time),
  encoding = "utf-8",
  html = TRUE,
  smtp = list(
    host.name = "smtp.163.com",
    port = 587,
    user.name = sender,  
    passwd = "root123456",
    ssl = TRUE
  ),  
  authenticate = TRUE,  
  send = TRUE  
) 


rm(list=ls())

gc();gc();gc();gc();gc();gc();gc();gc();gc();gc()
