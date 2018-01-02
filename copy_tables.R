#已解决问题：
#1.融资金额单位换算
#2.投资机构按";"分列
#3.投资机构未知、NA的情况统一为"投资方为透露"
#4.新的行业三级分类，分别关联上公司名称和项目名称两张表
#5.替换投融资事件表里的三级行业为新三级行业分类
#6.未上市公司城市字段抽取，略有误差
#7.

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

#comp_baseinfo_innotree table:extract ciry from officeaddr
comp_baseinfo_innotree<-select(comp_baseinfo_innotree,name,ncid,cid,province,edate,registeno,legalrepr,orgainzetype,briefinfo,bussiness,regmoney,website,officeaddr,phone,logourl,hangye,hangye2,hangye3,tags,comp_scale,opreat_status,email,devep_stage,wechat_id,weibo_url,data_date) %>% 
  mutate(city=case_when(str_detect(officeaddr,"北京市")==TRUE~"北京市",
                        str_detect(officeaddr,"天津市")==TRUE~"天津市",
                        str_detect(officeaddr,"上海市")==TRUE~"上海市",
                        str_detect(officeaddr,"重庆市")==TRUE~"重庆市",
                        str_detect(officeaddr,"哈尔滨市")==TRUE~"哈尔滨市",
                        str_detect(officeaddr,"阿城市")==TRUE~"阿城市",
                        str_detect(officeaddr,"双城市")==TRUE~"双城市",
                        str_detect(officeaddr,"尚志市")==TRUE~"尚志市",
                        str_detect(officeaddr,"五常市")==TRUE~"五常市",
                        str_detect(officeaddr,"齐齐哈尔市")==TRUE~"齐齐哈尔市",
                        str_detect(officeaddr,"讷河市")==TRUE~"讷河市",
                        str_detect(officeaddr,"鸡西市")==TRUE~"鸡西市",
                        str_detect(officeaddr,"虎林市")==TRUE~"虎林市",
                        str_detect(officeaddr,"密山市")==TRUE~"密山市",
                        str_detect(officeaddr,"鹤岗市")==TRUE~"鹤岗市",
                        str_detect(officeaddr,"双鸭山市")==TRUE~"双鸭山市",
                        str_detect(officeaddr,"大庆市")==TRUE~"大庆市",
                        str_detect(officeaddr,"伊春市")==TRUE~"伊春市",
                        str_detect(officeaddr,"铁力市")==TRUE~"铁力市",
                        str_detect(officeaddr,"佳木斯市")==TRUE~"佳木斯市",
                        str_detect(officeaddr,"同江市")==TRUE~"同江市",
                        str_detect(officeaddr,"富锦市")==TRUE~"富锦市",
                        str_detect(officeaddr,"七台河市")==TRUE~"七台河市",
                        str_detect(officeaddr,"牡丹江市")==TRUE~"牡丹江市",
                        str_detect(officeaddr,"海林市")==TRUE~"海林市",
                        str_detect(officeaddr,"宁安市")==TRUE~"宁安市",
                        str_detect(officeaddr,"穆棱市")==TRUE~"穆棱市",
                        str_detect(officeaddr,"黑河市")==TRUE~"黑河市",
                        str_detect(officeaddr,"北安市")==TRUE~"北安市",
                        str_detect(officeaddr,"五大连池市")==TRUE~"五大连池市",
                        str_detect(officeaddr,"绥化市")==TRUE~"绥化市",
                        str_detect(officeaddr,"安达市")==TRUE~"安达市",
                        str_detect(officeaddr,"肇东市")==TRUE~"肇东市",
                        str_detect(officeaddr,"海伦市")==TRUE~"海伦市",
                        str_detect(officeaddr,"长春市")==TRUE~"长春市",
                        str_detect(officeaddr,"九台市")==TRUE~"九台市",
                        str_detect(officeaddr,"榆树市")==TRUE~"榆树市",
                        str_detect(officeaddr,"德惠市")==TRUE~"德惠市",
                        str_detect(officeaddr,"吉林市")==TRUE~"吉林市",
                        str_detect(officeaddr,"蛟河市")==TRUE~"蛟河市",
                        str_detect(officeaddr,"桦甸市")==TRUE~"桦甸市",
                        str_detect(officeaddr,"舒兰市")==TRUE~"舒兰市",
                        str_detect(officeaddr,"磐石市")==TRUE~"磐石市",
                        str_detect(officeaddr,"四平市")==TRUE~"四平市",
                        str_detect(officeaddr,"公主岭市")==TRUE~"公主岭市",
                        str_detect(officeaddr,"双辽市")==TRUE~"双辽市",
                        str_detect(officeaddr,"辽源市")==TRUE~"辽源市",
                        str_detect(officeaddr,"通化市")==TRUE~"通化市",
                        str_detect(officeaddr,"梅河口市")==TRUE~"梅河口市",
                        str_detect(officeaddr,"集安市")==TRUE~"集安市",
                        str_detect(officeaddr,"白山市")==TRUE~"白山市",
                        str_detect(officeaddr,"临江市")==TRUE~"临江市",
                        str_detect(officeaddr,"松原市")==TRUE~"松原市",
                        str_detect(officeaddr,"白城市")==TRUE~"白城市",
                        str_detect(officeaddr,"洮南市")==TRUE~"洮南市",
                        str_detect(officeaddr,"大安市")==TRUE~"大安市",
                        str_detect(officeaddr,"延吉市")==TRUE~"延吉市",
                        str_detect(officeaddr,"图们市")==TRUE~"图们市",
                        str_detect(officeaddr,"敦化市")==TRUE~"敦化市",
                        str_detect(officeaddr,"珲春市")==TRUE~"珲春市",
                        str_detect(officeaddr,"龙井市")==TRUE~"龙井市",
                        str_detect(officeaddr,"和龙市")==TRUE~"和龙市",
                        str_detect(officeaddr,"沈阳市")==TRUE~"沈阳市",
                        str_detect(officeaddr,"新民市")==TRUE~"新民市",
                        str_detect(officeaddr,"大连市")==TRUE~"大连市",
                        str_detect(officeaddr,"瓦房店市")==TRUE~"瓦房店市",
                        str_detect(officeaddr,"普兰店市")==TRUE~"普兰店市",
                        str_detect(officeaddr,"庄河市")==TRUE~"庄河市",
                        str_detect(officeaddr,"鞍山市")==TRUE~"鞍山市",
                        str_detect(officeaddr,"海城市")==TRUE~"海城市",
                        str_detect(officeaddr,"抚顺市")==TRUE~"抚顺市",
                        str_detect(officeaddr,"本溪市")==TRUE~"本溪市",
                        str_detect(officeaddr,"丹东市")==TRUE~"丹东市",
                        str_detect(officeaddr,"东港市")==TRUE~"东港市",
                        str_detect(officeaddr,"凤城市")==TRUE~"凤城市",
                        str_detect(officeaddr,"锦州市")==TRUE~"锦州市",
                        str_detect(officeaddr,"凌海市")==TRUE~"凌海市",
                        str_detect(officeaddr,"北宁市")==TRUE~"北宁市",
                        str_detect(officeaddr,"营口市")==TRUE~"营口市",
                        str_detect(officeaddr,"盖州市")==TRUE~"盖州市",
                        str_detect(officeaddr,"大石桥市")==TRUE~"大石桥市",
                        str_detect(officeaddr,"阜新市")==TRUE~"阜新市",
                        str_detect(officeaddr,"辽阳市")==TRUE~"辽阳市",
                        str_detect(officeaddr,"灯塔市")==TRUE~"灯塔市",
                        str_detect(officeaddr,"盘锦市")==TRUE~"盘锦市",
                        str_detect(officeaddr,"铁岭市")==TRUE~"铁岭市",
                        str_detect(officeaddr,"调兵山市")==TRUE~"调兵山市",
                        str_detect(officeaddr,"开原市")==TRUE~"开原市",
                        str_detect(officeaddr,"朝阳市")==TRUE~"朝阳市",
                        str_detect(officeaddr,"北票市")==TRUE~"北票市",
                        str_detect(officeaddr,"凌源市")==TRUE~"凌源市",
                        str_detect(officeaddr,"葫芦岛市")==TRUE~"葫芦岛市",
                        str_detect(officeaddr,"兴城市")==TRUE~"兴城市",
                        str_detect(officeaddr,"呼和浩特市")==TRUE~"呼和浩特市",
                        str_detect(officeaddr,"包头市")==TRUE~"包头市",
                        str_detect(officeaddr,"乌海市")==TRUE~"乌海市",
                        str_detect(officeaddr,"赤峰市")==TRUE~"赤峰市",
                        str_detect(officeaddr,"通辽市")==TRUE~"通辽市",
                        str_detect(officeaddr,"霍林郭勒市")==TRUE~"霍林郭勒市",
                        str_detect(officeaddr,"鄂尔多斯市")==TRUE~"鄂尔多斯市",
                        str_detect(officeaddr,"呼伦贝尔市")==TRUE~"呼伦贝尔市",
                        str_detect(officeaddr,"满洲里市")==TRUE~"满洲里市",
                        str_detect(officeaddr,"牙克石市")==TRUE~"牙克石市",
                        str_detect(officeaddr,"扎兰屯市")==TRUE~"扎兰屯市",
                        str_detect(officeaddr,"额尔古纳市")==TRUE~"额尔古纳市",
                        str_detect(officeaddr,"根河市")==TRUE~"根河市",
                        str_detect(officeaddr,"巴彦淖尔市")==TRUE~"巴彦淖尔市",
                        str_detect(officeaddr,"临河市")==TRUE~"临河市",
                        str_detect(officeaddr,"乌兰察布市")==TRUE~"乌兰察布市",
                        str_detect(officeaddr,"集宁市")==TRUE~"集宁市",
                        str_detect(officeaddr,"丰镇市")==TRUE~"丰镇市",
                        str_detect(officeaddr,"乌兰浩特市")==TRUE~"乌兰浩特市",
                        str_detect(officeaddr,"阿尔山市")==TRUE~"阿尔山市",
                        str_detect(officeaddr,"二连浩特市")==TRUE~"二连浩特市",
                        str_detect(officeaddr,"锡林浩特市")==TRUE~"锡林浩特市",
                        str_detect(officeaddr,"乌鲁木齐市")==TRUE~"乌鲁木齐市",
                        str_detect(officeaddr,"克拉玛依市")==TRUE~"克拉玛依市",
                        str_detect(officeaddr,"吐鲁番市")==TRUE~"吐鲁番市",
                        str_detect(officeaddr,"哈密市")==TRUE~"哈密市",
                        str_detect(officeaddr,"昌吉市")==TRUE~"昌吉市",
                        str_detect(officeaddr,"阜康市")==TRUE~"阜康市",
                        str_detect(officeaddr,"米泉市")==TRUE~"米泉市",
                        str_detect(officeaddr,"博乐市")==TRUE~"博乐市",
                        str_detect(officeaddr,"库尔勒市")==TRUE~"库尔勒市",
                        str_detect(officeaddr,"阿克苏市")==TRUE~"阿克苏市",
                        str_detect(officeaddr,"阿图什市")==TRUE~"阿图什市",
                        str_detect(officeaddr,"喀什市")==TRUE~"喀什市",
                        str_detect(officeaddr,"和田市")==TRUE~"和田市",
                        str_detect(officeaddr,"伊宁市")==TRUE~"伊宁市",
                        str_detect(officeaddr,"奎屯市")==TRUE~"奎屯市",
                        str_detect(officeaddr,"塔城市")==TRUE~"塔城市",
                        str_detect(officeaddr,"乌苏市")==TRUE~"乌苏市",
                        str_detect(officeaddr,"阿勒泰市")==TRUE~"阿勒泰市",
                        str_detect(officeaddr,"西宁市")==TRUE~"西宁市",
                        str_detect(officeaddr,"拉萨市")==TRUE~"拉萨市",
                        str_detect(officeaddr,"兰州市")==TRUE~"兰州市",
                        str_detect(officeaddr,"嘉峪关市")==TRUE~"嘉峪关市",
                        str_detect(officeaddr,"金昌市")==TRUE~"金昌市",
                        str_detect(officeaddr,"白银市")==TRUE~"白银市",
                        str_detect(officeaddr,"天水市")==TRUE~"天水市",
                        str_detect(officeaddr,"武威市")==TRUE~"武威市",
                        str_detect(officeaddr,"张掖市")==TRUE~"张掖市",
                        str_detect(officeaddr,"平凉市")==TRUE~"平凉市",
                        str_detect(officeaddr,"酒泉市")==TRUE~"酒泉市",
                        str_detect(officeaddr,"玉门市")==TRUE~"玉门市",
                        str_detect(officeaddr,"敦煌市")==TRUE~"敦煌市",
                        str_detect(officeaddr,"庆阳市")==TRUE~"庆阳市",
                        str_detect(officeaddr,"西峰市")==TRUE~"西峰市",
                        str_detect(officeaddr,"定西市")==TRUE~"定西市",
                        str_detect(officeaddr,"陇南市")==TRUE~"陇南市",
                        str_detect(officeaddr,"临夏市")==TRUE~"临夏市",
                        str_detect(officeaddr,"合作市")==TRUE~"合作市",
                        str_detect(officeaddr,"银川市")==TRUE~"银川市",
                        str_detect(officeaddr,"灵武市")==TRUE~"灵武市",
                        str_detect(officeaddr,"石嘴山市")==TRUE~"石嘴山市",
                        str_detect(officeaddr,"吴忠市")==TRUE~"吴忠市",
                        str_detect(officeaddr,"青铜峡市")==TRUE~"青铜峡市",
                        str_detect(officeaddr,"固原市")==TRUE~"固原市",
                        str_detect(officeaddr,"中卫市")==TRUE~"中卫市",
                        str_detect(officeaddr,"西安市")==TRUE~"西安市",
                        str_detect(officeaddr,"铜川市")==TRUE~"铜川市",
                        str_detect(officeaddr,"宝鸡市")==TRUE~"宝鸡市",
                        str_detect(officeaddr,"咸阳市")==TRUE~"咸阳市",
                        str_detect(officeaddr,"渭南市")==TRUE~"渭南市",
                        str_detect(officeaddr,"韩城市")==TRUE~"韩城市",
                        str_detect(officeaddr,"华阴市")==TRUE~"华阴市",
                        str_detect(officeaddr,"延安市")==TRUE~"延安市",
                        str_detect(officeaddr,"汉中市")==TRUE~"汉中市",
                        str_detect(officeaddr,"榆林市")==TRUE~"榆林市",
                        str_detect(officeaddr,"安康市")==TRUE~"安康市",
                        str_detect(officeaddr,"商洛市")==TRUE~"商洛市",
                        str_detect(officeaddr,"太原市")==TRUE~"太原市",
                        str_detect(officeaddr,"古交市")==TRUE~"古交市",
                        str_detect(officeaddr,"大同市")==TRUE~"大同市",
                        str_detect(officeaddr,"阳泉市")==TRUE~"阳泉市",
                        str_detect(officeaddr,"长治市")==TRUE~"长治市",
                        str_detect(officeaddr,"潞城市")==TRUE~"潞城市",
                        str_detect(officeaddr,"晋城市")==TRUE~"晋城市",
                        str_detect(officeaddr,"高平市")==TRUE~"高平市",
                        str_detect(officeaddr,"朔州市")==TRUE~"朔州市",
                        str_detect(officeaddr,"晋中市")==TRUE~"晋中市",
                        str_detect(officeaddr,"介休市")==TRUE~"介休市",
                        str_detect(officeaddr,"运城市")==TRUE~"运城市",
                        str_detect(officeaddr,"永济市")==TRUE~"永济市",
                        str_detect(officeaddr,"河津市")==TRUE~"河津市",
                        str_detect(officeaddr,"忻州市")==TRUE~"忻州市",
                        str_detect(officeaddr,"原平市")==TRUE~"原平市",
                        str_detect(officeaddr,"临汾市")==TRUE~"临汾市",
                        str_detect(officeaddr,"侯马市")==TRUE~"侯马市",
                        str_detect(officeaddr,"霍州市")==TRUE~"霍州市",
                        str_detect(officeaddr,"吕梁市")==TRUE~"吕梁市",
                        str_detect(officeaddr,"孝义市")==TRUE~"孝义市",
                        str_detect(officeaddr,"汾阳市")==TRUE~"汾阳市",
                        str_detect(officeaddr,"石家庄市")==TRUE~"石家庄市",
                        str_detect(officeaddr,"辛集市")==TRUE~"辛集市",
                        str_detect(officeaddr,"藁城市")==TRUE~"藁城市",
                        str_detect(officeaddr,"晋州市")==TRUE~"晋州市",
                        str_detect(officeaddr,"新乐市")==TRUE~"新乐市",
                        str_detect(officeaddr,"鹿泉市")==TRUE~"鹿泉市",
                        str_detect(officeaddr,"唐山市")==TRUE~"唐山市",
                        str_detect(officeaddr,"遵化市")==TRUE~"遵化市",
                        str_detect(officeaddr,"迁安市")==TRUE~"迁安市",
                        str_detect(officeaddr,"秦皇岛市")==TRUE~"秦皇岛市",
                        str_detect(officeaddr,"邯郸市")==TRUE~"邯郸市",
                        str_detect(officeaddr,"武安市")==TRUE~"武安市",
                        str_detect(officeaddr,"邢台市")==TRUE~"邢台市",
                        str_detect(officeaddr,"南宫市")==TRUE~"南宫市",
                        str_detect(officeaddr,"沙河市")==TRUE~"沙河市",
                        str_detect(officeaddr,"保定市")==TRUE~"保定市",
                        str_detect(officeaddr,"涿州市")==TRUE~"涿州市",
                        str_detect(officeaddr,"定州市")==TRUE~"定州市",
                        str_detect(officeaddr,"安国市")==TRUE~"安国市",
                        str_detect(officeaddr,"高碑店市")==TRUE~"高碑店市",
                        str_detect(officeaddr,"承德市")==TRUE~"承德市",
                        str_detect(officeaddr,"沧州市")==TRUE~"沧州市",
                        str_detect(officeaddr,"泊头市")==TRUE~"泊头市",
                        str_detect(officeaddr,"任丘市")==TRUE~"任丘市",
                        str_detect(officeaddr,"黄骅市")==TRUE~"黄骅市",
                        str_detect(officeaddr,"河间市")==TRUE~"河间市",
                        str_detect(officeaddr,"廊坊市")==TRUE~"廊坊市",
                        str_detect(officeaddr,"霸州市")==TRUE~"霸州市",
                        str_detect(officeaddr,"三河市")==TRUE~"三河市",
                        str_detect(officeaddr,"衡水市")==TRUE~"衡水市",
                        str_detect(officeaddr,"冀州市")==TRUE~"冀州市",
                        str_detect(officeaddr,"深州市")==TRUE~"深州市",
                        str_detect(officeaddr,"济南市")==TRUE~"济南市",
                        str_detect(officeaddr,"章丘市")==TRUE~"章丘市",
                        str_detect(officeaddr,"青岛市")==TRUE~"青岛市",
                        str_detect(officeaddr,"胶州市")==TRUE~"胶州市",
                        str_detect(officeaddr,"即墨市")==TRUE~"即墨市",
                        str_detect(officeaddr,"平度市")==TRUE~"平度市",
                        str_detect(officeaddr,"胶南市")==TRUE~"胶南市",
                        str_detect(officeaddr,"莱西市")==TRUE~"莱西市",
                        str_detect(officeaddr,"淄博市")==TRUE~"淄博市",
                        str_detect(officeaddr,"枣庄市")==TRUE~"枣庄市",
                        str_detect(officeaddr,"滕州市")==TRUE~"滕州市",
                        str_detect(officeaddr,"东营市")==TRUE~"东营市",
                        str_detect(officeaddr,"烟台市")==TRUE~"烟台市",
                        str_detect(officeaddr,"龙口市")==TRUE~"龙口市",
                        str_detect(officeaddr,"莱阳市")==TRUE~"莱阳市",
                        str_detect(officeaddr,"莱州市")==TRUE~"莱州市",
                        str_detect(officeaddr,"蓬莱市")==TRUE~"蓬莱市",
                        str_detect(officeaddr,"招远市")==TRUE~"招远市",
                        str_detect(officeaddr,"栖霞市")==TRUE~"栖霞市",
                        str_detect(officeaddr,"海阳市")==TRUE~"海阳市",
                        str_detect(officeaddr,"潍坊市")==TRUE~"潍坊市",
                        str_detect(officeaddr,"青州市")==TRUE~"青州市",
                        str_detect(officeaddr,"诸城市")==TRUE~"诸城市",
                        str_detect(officeaddr,"寿光市")==TRUE~"寿光市",
                        str_detect(officeaddr,"安丘市")==TRUE~"安丘市",
                        str_detect(officeaddr,"高密市")==TRUE~"高密市",
                        str_detect(officeaddr,"昌邑市")==TRUE~"昌邑市",
                        str_detect(officeaddr,"济宁市")==TRUE~"济宁市",
                        str_detect(officeaddr,"曲阜市")==TRUE~"曲阜市",
                        str_detect(officeaddr,"兖州市")==TRUE~"兖州市",
                        str_detect(officeaddr,"邹城市")==TRUE~"邹城市",
                        str_detect(officeaddr,"泰安市")==TRUE~"泰安市",
                        str_detect(officeaddr,"新泰市")==TRUE~"新泰市",
                        str_detect(officeaddr,"肥城市")==TRUE~"肥城市",
                        str_detect(officeaddr,"威海市")==TRUE~"威海市",
                        str_detect(officeaddr,"文登市")==TRUE~"文登市",
                        str_detect(officeaddr,"荣成市")==TRUE~"荣成市",
                        str_detect(officeaddr,"乳山市")==TRUE~"乳山市",
                        str_detect(officeaddr,"日照市")==TRUE~"日照市",
                        str_detect(officeaddr,"莱芜市")==TRUE~"莱芜市",
                        str_detect(officeaddr,"临沂市")==TRUE~"临沂市",
                        str_detect(officeaddr,"德州市")==TRUE~"德州市",
                        str_detect(officeaddr,"乐陵市")==TRUE~"乐陵市",
                        str_detect(officeaddr,"禹城市")==TRUE~"禹城市",
                        str_detect(officeaddr,"聊城市")==TRUE~"聊城市",
                        str_detect(officeaddr,"临清市")==TRUE~"临清市",
                        str_detect(officeaddr,"滨州市")==TRUE~"滨州市",
                        str_detect(officeaddr,"菏泽市")==TRUE~"菏泽市",
                        str_detect(officeaddr,"南京市")==TRUE~"南京市",
                        str_detect(officeaddr,"无锡市")==TRUE~"无锡市",
                        str_detect(officeaddr,"江阴市")==TRUE~"江阴市",
                        str_detect(officeaddr,"宜兴市")==TRUE~"宜兴市",
                        str_detect(officeaddr,"徐州市")==TRUE~"徐州市",
                        str_detect(officeaddr,"新沂市")==TRUE~"新沂市",
                        str_detect(officeaddr,"邳州市")==TRUE~"邳州市",
                        str_detect(officeaddr,"常州市")==TRUE~"常州市",
                        str_detect(officeaddr,"溧阳市")==TRUE~"溧阳市",
                        str_detect(officeaddr,"金坛市")==TRUE~"金坛市",
                        str_detect(officeaddr,"苏州市")==TRUE~"苏州市",
                        str_detect(officeaddr,"常熟市")==TRUE~"常熟市",
                        str_detect(officeaddr,"张家港市")==TRUE~"张家港市",
                        str_detect(officeaddr,"昆山市")==TRUE~"昆山市",
                        str_detect(officeaddr,"吴江市")==TRUE~"吴江市",
                        str_detect(officeaddr,"太仓市")==TRUE~"太仓市",
                        str_detect(officeaddr,"南通市")==TRUE~"南通市",
                        str_detect(officeaddr,"启东市")==TRUE~"启东市",
                        str_detect(officeaddr,"如皋市")==TRUE~"如皋市",
                        str_detect(officeaddr,"通州市")==TRUE~"通州市",
                        str_detect(officeaddr,"海门市")==TRUE~"海门市",
                        str_detect(officeaddr,"连云港市")==TRUE~"连云港市",
                        str_detect(officeaddr,"淮安市")==TRUE~"淮安市",
                        str_detect(officeaddr,"盐城市")==TRUE~"盐城市",
                        str_detect(officeaddr,"东台市")==TRUE~"东台市",
                        str_detect(officeaddr,"大丰市")==TRUE~"大丰市",
                        str_detect(officeaddr,"扬州市")==TRUE~"扬州市",
                        str_detect(officeaddr,"仪征市")==TRUE~"仪征市",
                        str_detect(officeaddr,"高邮市")==TRUE~"高邮市",
                        str_detect(officeaddr,"江都市")==TRUE~"江都市",
                        str_detect(officeaddr,"镇江市")==TRUE~"镇江市",
                        str_detect(officeaddr,"丹阳市")==TRUE~"丹阳市",
                        str_detect(officeaddr,"扬中市")==TRUE~"扬中市",
                        str_detect(officeaddr,"句容市")==TRUE~"句容市",
                        str_detect(officeaddr,"泰州市")==TRUE~"泰州市",
                        str_detect(officeaddr,"兴化市")==TRUE~"兴化市",
                        str_detect(officeaddr,"靖江市")==TRUE~"靖江市",
                        str_detect(officeaddr,"泰兴市")==TRUE~"泰兴市",
                        str_detect(officeaddr,"姜堰市")==TRUE~"姜堰市",
                        str_detect(officeaddr,"宿迁市")==TRUE~"宿迁市",
                        str_detect(officeaddr,"合肥市")==TRUE~"合肥市",
                        str_detect(officeaddr,"芜湖市")==TRUE~"芜湖市",
                        str_detect(officeaddr,"蚌埠市")==TRUE~"蚌埠市",
                        str_detect(officeaddr,"淮南市")==TRUE~"淮南市",
                        str_detect(officeaddr,"马鞍山市")==TRUE~"马鞍山市",
                        str_detect(officeaddr,"淮北市")==TRUE~"淮北市",
                        str_detect(officeaddr,"铜陵市")==TRUE~"铜陵市",
                        str_detect(officeaddr,"安庆市")==TRUE~"安庆市",
                        str_detect(officeaddr,"桐城市")==TRUE~"桐城市",
                        str_detect(officeaddr,"黄山市")==TRUE~"黄山市",
                        str_detect(officeaddr,"滁州市")==TRUE~"滁州市",
                        str_detect(officeaddr,"天长市")==TRUE~"天长市",
                        str_detect(officeaddr,"明光市")==TRUE~"明光市",
                        str_detect(officeaddr,"阜阳市")==TRUE~"阜阳市",
                        str_detect(officeaddr,"界首市")==TRUE~"界首市",
                        str_detect(officeaddr,"宿州市")==TRUE~"宿州市",
                        str_detect(officeaddr,"巢湖市")==TRUE~"巢湖市",
                        str_detect(officeaddr,"六安市")==TRUE~"六安市",
                        str_detect(officeaddr,"毫州市")==TRUE~"毫州市",
                        str_detect(officeaddr,"池州市")==TRUE~"池州市",
                        str_detect(officeaddr,"宣城市")==TRUE~"宣城市",
                        str_detect(officeaddr,"宁国市")==TRUE~"宁国市",
                        str_detect(officeaddr,"郑州市")==TRUE~"郑州市",
                        str_detect(officeaddr,"巩义市")==TRUE~"巩义市",
                        str_detect(officeaddr,"荥阳市")==TRUE~"荥阳市",
                        str_detect(officeaddr,"新密市")==TRUE~"新密市",
                        str_detect(officeaddr,"新郑市")==TRUE~"新郑市",
                        str_detect(officeaddr,"登封市")==TRUE~"登封市",
                        str_detect(officeaddr,"开封市")==TRUE~"开封市",
                        str_detect(officeaddr,"洛阳市")==TRUE~"洛阳市",
                        str_detect(officeaddr,"偃师市")==TRUE~"偃师市",
                        str_detect(officeaddr,"平顶山市")==TRUE~"平顶山市",
                        str_detect(officeaddr,"汝州市")==TRUE~"汝州市",
                        str_detect(officeaddr,"安阳市")==TRUE~"安阳市",
                        str_detect(officeaddr,"林州市")==TRUE~"林州市",
                        str_detect(officeaddr,"鹤壁市")==TRUE~"鹤壁市",
                        str_detect(officeaddr,"新乡市")==TRUE~"新乡市",
                        str_detect(officeaddr,"卫辉市")==TRUE~"卫辉市",
                        str_detect(officeaddr,"辉县市")==TRUE~"辉县市",
                        str_detect(officeaddr,"焦作市")==TRUE~"焦作市",
                        str_detect(officeaddr,"济源市")==TRUE~"济源市",
                        str_detect(officeaddr,"沁阳市")==TRUE~"沁阳市",
                        str_detect(officeaddr,"孟州市")==TRUE~"孟州市",
                        str_detect(officeaddr,"濮阳市")==TRUE~"濮阳市",
                        str_detect(officeaddr,"许昌市")==TRUE~"许昌市",
                        str_detect(officeaddr,"禹州市")==TRUE~"禹州市",
                        str_detect(officeaddr,"长葛市")==TRUE~"长葛市",
                        str_detect(officeaddr,"漯河市")==TRUE~"漯河市",
                        str_detect(officeaddr,"三门峡市")==TRUE~"三门峡市",
                        str_detect(officeaddr,"义马市")==TRUE~"义马市",
                        str_detect(officeaddr,"灵宝市")==TRUE~"灵宝市",
                        str_detect(officeaddr,"南阳市")==TRUE~"南阳市",
                        str_detect(officeaddr,"邓州市")==TRUE~"邓州市",
                        str_detect(officeaddr,"商丘市")==TRUE~"商丘市",
                        str_detect(officeaddr,"永城市")==TRUE~"永城市",
                        str_detect(officeaddr,"信阳市")==TRUE~"信阳市",
                        str_detect(officeaddr,"周口市")==TRUE~"周口市",
                        str_detect(officeaddr,"项城市")==TRUE~"项城市",
                        str_detect(officeaddr,"驻马店市")==TRUE~"驻马店市",
                        str_detect(officeaddr,"武汉市")==TRUE~"武汉市",
                        str_detect(officeaddr,"黄石市")==TRUE~"黄石市",
                        str_detect(officeaddr,"大冶市")==TRUE~"大冶市",
                        str_detect(officeaddr,"十堰市")==TRUE~"十堰市",
                        str_detect(officeaddr,"丹江口市")==TRUE~"丹江口市",
                        str_detect(officeaddr,"宜昌市")==TRUE~"宜昌市",
                        str_detect(officeaddr,"宜都市")==TRUE~"宜都市",
                        str_detect(officeaddr,"当阳市")==TRUE~"当阳市",
                        str_detect(officeaddr,"枝江市")==TRUE~"枝江市",
                        str_detect(officeaddr,"襄樊市")==TRUE~"襄樊市",
                        str_detect(officeaddr,"老河口市")==TRUE~"老河口市",
                        str_detect(officeaddr,"枣阳市")==TRUE~"枣阳市",
                        str_detect(officeaddr,"宜城市")==TRUE~"宜城市",
                        str_detect(officeaddr,"鄂州市")==TRUE~"鄂州市",
                        str_detect(officeaddr,"荆门市")==TRUE~"荆门市",
                        str_detect(officeaddr,"钟祥市")==TRUE~"钟祥市",
                        str_detect(officeaddr,"孝感市")==TRUE~"孝感市",
                        str_detect(officeaddr,"应城市")==TRUE~"应城市",
                        str_detect(officeaddr,"安陆市")==TRUE~"安陆市",
                        str_detect(officeaddr,"汉川市")==TRUE~"汉川市",
                        str_detect(officeaddr,"荆州市")==TRUE~"荆州市",
                        str_detect(officeaddr,"石首市")==TRUE~"石首市",
                        str_detect(officeaddr,"洪湖市")==TRUE~"洪湖市",
                        str_detect(officeaddr,"松滋市")==TRUE~"松滋市",
                        str_detect(officeaddr,"黄冈市")==TRUE~"黄冈市",
                        str_detect(officeaddr,"麻城市")==TRUE~"麻城市",
                        str_detect(officeaddr,"武穴市")==TRUE~"武穴市",
                        str_detect(officeaddr,"咸宁市")==TRUE~"咸宁市",
                        str_detect(officeaddr,"赤壁市")==TRUE~"赤壁市",
                        str_detect(officeaddr,"随州市")==TRUE~"随州市",
                        str_detect(officeaddr,"广水市")==TRUE~"广水市",
                        str_detect(officeaddr,"恩施市")==TRUE~"恩施市",
                        str_detect(officeaddr,"利川市")==TRUE~"利川市",
                        str_detect(officeaddr,"仙桃市")==TRUE~"仙桃市",
                        str_detect(officeaddr,"潜江市")==TRUE~"潜江市",
                        str_detect(officeaddr,"天门市")==TRUE~"天门市",
                        str_detect(officeaddr,"成都市")==TRUE~"成都市",
                        str_detect(officeaddr,"都江堰市")==TRUE~"都江堰市",
                        str_detect(officeaddr,"彭州市")==TRUE~"彭州市",
                        str_detect(officeaddr,"邛崃市")==TRUE~"邛崃市",
                        str_detect(officeaddr,"崇州市")==TRUE~"崇州市",
                        str_detect(officeaddr,"自贡市")==TRUE~"自贡市",
                        str_detect(officeaddr,"攀枝花市")==TRUE~"攀枝花市",
                        str_detect(officeaddr,"泸州市")==TRUE~"泸州市",
                        str_detect(officeaddr,"德阳市")==TRUE~"德阳市",
                        str_detect(officeaddr,"广汉市")==TRUE~"广汉市",
                        str_detect(officeaddr,"什邡市")==TRUE~"什邡市",
                        str_detect(officeaddr,"绵竹市")==TRUE~"绵竹市",
                        str_detect(officeaddr,"绵阳市")==TRUE~"绵阳市",
                        str_detect(officeaddr,"江油市")==TRUE~"江油市",
                        str_detect(officeaddr,"广元市")==TRUE~"广元市",
                        str_detect(officeaddr,"遂宁市")==TRUE~"遂宁市",
                        str_detect(officeaddr,"内江市")==TRUE~"内江市",
                        str_detect(officeaddr,"乐山市")==TRUE~"乐山市",
                        str_detect(officeaddr,"峨眉山市")==TRUE~"峨眉山市",
                        str_detect(officeaddr,"南充市")==TRUE~"南充市",
                        str_detect(officeaddr,"阆中市")==TRUE~"阆中市",
                        str_detect(officeaddr,"眉山市")==TRUE~"眉山市",
                        str_detect(officeaddr,"宜宾市")==TRUE~"宜宾市",
                        str_detect(officeaddr,"广安市")==TRUE~"广安市",
                        str_detect(officeaddr,"华蓥市")==TRUE~"华蓥市",
                        str_detect(officeaddr,"达州市")==TRUE~"达州市",
                        str_detect(officeaddr,"万源市")==TRUE~"万源市",
                        str_detect(officeaddr,"雅安市")==TRUE~"雅安市",
                        str_detect(officeaddr,"巴中市")==TRUE~"巴中市",
                        str_detect(officeaddr,"资阳市")==TRUE~"资阳市",
                        str_detect(officeaddr,"简阳市")==TRUE~"简阳市",
                        str_detect(officeaddr,"西昌市")==TRUE~"西昌市",
                        str_detect(officeaddr,"昆明市")==TRUE~"昆明市",
                        str_detect(officeaddr,"安宁市")==TRUE~"安宁市",
                        str_detect(officeaddr,"曲靖市")==TRUE~"曲靖市",
                        str_detect(officeaddr,"宣威市")==TRUE~"宣威市",
                        str_detect(officeaddr,"玉溪市")==TRUE~"玉溪市",
                        str_detect(officeaddr,"保山市")==TRUE~"保山市",
                        str_detect(officeaddr,"昭通市")==TRUE~"昭通市",
                        str_detect(officeaddr,"丽江市")==TRUE~"丽江市",
                        str_detect(officeaddr,"思茅市")==TRUE~"思茅市",
                        str_detect(officeaddr,"临沧市")==TRUE~"临沧市",
                        str_detect(officeaddr,"楚雄市")==TRUE~"楚雄市",
                        str_detect(officeaddr,"个旧市")==TRUE~"个旧市",
                        str_detect(officeaddr,"开远市")==TRUE~"开远市",
                        str_detect(officeaddr,"大理市")==TRUE~"大理市",
                        str_detect(officeaddr,"瑞丽市")==TRUE~"瑞丽市",
                        str_detect(officeaddr,"贵阳市")==TRUE~"贵阳市",
                        str_detect(officeaddr,"清镇市")==TRUE~"清镇市",
                        str_detect(officeaddr,"六盘水市")==TRUE~"六盘水市",
                        str_detect(officeaddr,"遵义市")==TRUE~"遵义市",
                        str_detect(officeaddr,"赤水市")==TRUE~"赤水市",
                        str_detect(officeaddr,"仁怀市")==TRUE~"仁怀市",
                        str_detect(officeaddr,"安顺市")==TRUE~"安顺市",
                        str_detect(officeaddr,"铜仁市")==TRUE~"铜仁市",
                        str_detect(officeaddr,"兴义市")==TRUE~"兴义市",
                        str_detect(officeaddr,"毕节市")==TRUE~"毕节市",
                        str_detect(officeaddr,"凯里市")==TRUE~"凯里市",
                        str_detect(officeaddr,"都匀市")==TRUE~"都匀市",
                        str_detect(officeaddr,"福泉市")==TRUE~"福泉市",
                        str_detect(officeaddr,"长沙市")==TRUE~"长沙市",
                        str_detect(officeaddr,"浏阳市")==TRUE~"浏阳市",
                        str_detect(officeaddr,"株洲市")==TRUE~"株洲市",
                        str_detect(officeaddr,"醴陵市")==TRUE~"醴陵市",
                        str_detect(officeaddr,"湘潭市")==TRUE~"湘潭市",
                        str_detect(officeaddr,"湘乡市")==TRUE~"湘乡市",
                        str_detect(officeaddr,"韶山市")==TRUE~"韶山市",
                        str_detect(officeaddr,"衡阳市")==TRUE~"衡阳市",
                        str_detect(officeaddr,"耒阳市")==TRUE~"耒阳市",
                        str_detect(officeaddr,"常宁市")==TRUE~"常宁市",
                        str_detect(officeaddr,"邵阳市")==TRUE~"邵阳市",
                        str_detect(officeaddr,"武冈市")==TRUE~"武冈市",
                        str_detect(officeaddr,"岳阳市")==TRUE~"岳阳市",
                        str_detect(officeaddr,"汨罗市")==TRUE~"汨罗市",
                        str_detect(officeaddr,"临湘市")==TRUE~"临湘市",
                        str_detect(officeaddr,"常德市")==TRUE~"常德市",
                        str_detect(officeaddr,"津市市")==TRUE~"津市市",
                        str_detect(officeaddr,"张家界市")==TRUE~"张家界市",
                        str_detect(officeaddr,"益阳市")==TRUE~"益阳市",
                        str_detect(officeaddr,"沅江市")==TRUE~"沅江市",
                        str_detect(officeaddr,"郴州市")==TRUE~"郴州市",
                        str_detect(officeaddr,"资兴市")==TRUE~"资兴市",
                        str_detect(officeaddr,"永州市")==TRUE~"永州市",
                        str_detect(officeaddr,"怀化市")==TRUE~"怀化市",
                        str_detect(officeaddr,"洪江市")==TRUE~"洪江市",
                        str_detect(officeaddr,"娄底市")==TRUE~"娄底市",
                        str_detect(officeaddr,"冷水江市")==TRUE~"冷水江市",
                        str_detect(officeaddr,"涟源市")==TRUE~"涟源市",
                        str_detect(officeaddr,"吉首市")==TRUE~"吉首市",
                        str_detect(officeaddr,"南昌市")==TRUE~"南昌市",
                        str_detect(officeaddr,"乐平市")==TRUE~"乐平市",
                        str_detect(officeaddr,"萍乡市")==TRUE~"萍乡市",
                        str_detect(officeaddr,"九江市")==TRUE~"九江市",
                        str_detect(officeaddr,"瑞昌市")==TRUE~"瑞昌市",
                        str_detect(officeaddr,"新余市")==TRUE~"新余市",
                        str_detect(officeaddr,"鹰潭市")==TRUE~"鹰潭市",
                        str_detect(officeaddr,"贵溪市")==TRUE~"贵溪市",
                        str_detect(officeaddr,"赣州市")==TRUE~"赣州市",
                        str_detect(officeaddr,"瑞金市")==TRUE~"瑞金市",
                        str_detect(officeaddr,"南康市")==TRUE~"南康市",
                        str_detect(officeaddr,"吉安市")==TRUE~"吉安市",
                        str_detect(officeaddr,"井冈山市")==TRUE~"井冈山市",
                        str_detect(officeaddr,"宜春市")==TRUE~"宜春市",
                        str_detect(officeaddr,"丰城市")==TRUE~"丰城市",
                        str_detect(officeaddr,"樟树市")==TRUE~"樟树市",
                        str_detect(officeaddr,"高安市")==TRUE~"高安市",
                        str_detect(officeaddr,"抚州市")==TRUE~"抚州市",
                        str_detect(officeaddr,"上饶市")==TRUE~"上饶市",
                        str_detect(officeaddr,"德兴市")==TRUE~"德兴市",
                        str_detect(officeaddr,"杭州市")==TRUE~"杭州市",
                        str_detect(officeaddr,"建德市")==TRUE~"建德市",
                        str_detect(officeaddr,"富阳市")==TRUE~"富阳市",
                        str_detect(officeaddr,"临安市")==TRUE~"临安市",
                        str_detect(officeaddr,"宁波市")==TRUE~"宁波市",
                        str_detect(officeaddr,"余姚市")==TRUE~"余姚市",
                        str_detect(officeaddr,"慈溪市")==TRUE~"慈溪市",
                        str_detect(officeaddr,"奉化市")==TRUE~"奉化市",
                        str_detect(officeaddr,"温州市")==TRUE~"温州市",
                        str_detect(officeaddr,"瑞安市")==TRUE~"瑞安市",
                        str_detect(officeaddr,"乐清市")==TRUE~"乐清市",
                        str_detect(officeaddr,"嘉兴市")==TRUE~"嘉兴市",
                        str_detect(officeaddr,"海宁市")==TRUE~"海宁市",
                        str_detect(officeaddr,"平湖市")==TRUE~"平湖市",
                        str_detect(officeaddr,"桐乡市")==TRUE~"桐乡市",
                        str_detect(officeaddr,"湖州市")==TRUE~"湖州市",
                        str_detect(officeaddr,"绍兴市")==TRUE~"绍兴市",
                        str_detect(officeaddr,"诸暨市")==TRUE~"诸暨市",
                        str_detect(officeaddr,"上虞市")==TRUE~"上虞市",
                        str_detect(officeaddr,"嵊州市")==TRUE~"嵊州市",
                        str_detect(officeaddr,"金华市")==TRUE~"金华市",
                        str_detect(officeaddr,"兰溪市")==TRUE~"兰溪市",
                        str_detect(officeaddr,"义乌市")==TRUE~"义乌市",
                        str_detect(officeaddr,"东阳市")==TRUE~"东阳市",
                        str_detect(officeaddr,"永康市")==TRUE~"永康市",
                        str_detect(officeaddr,"衢州市")==TRUE~"衢州市",
                        str_detect(officeaddr,"江山市")==TRUE~"江山市",
                        str_detect(officeaddr,"舟山市")==TRUE~"舟山市",
                        str_detect(officeaddr,"台州市")==TRUE~"台州市",
                        str_detect(officeaddr,"温岭市")==TRUE~"温岭市",
                        str_detect(officeaddr,"临海市")==TRUE~"临海市",
                        str_detect(officeaddr,"丽水市")==TRUE~"丽水市",
                        str_detect(officeaddr,"龙泉市")==TRUE~"龙泉市",
                        str_detect(officeaddr,"福州市")==TRUE~"福州市",
                        str_detect(officeaddr,"福清市")==TRUE~"福清市",
                        str_detect(officeaddr,"长乐市")==TRUE~"长乐市",
                        str_detect(officeaddr,"厦门市")==TRUE~"厦门市",
                        str_detect(officeaddr,"莆田市")==TRUE~"莆田市",
                        str_detect(officeaddr,"三明市")==TRUE~"三明市",
                        str_detect(officeaddr,"永安市")==TRUE~"永安市",
                        str_detect(officeaddr,"泉州市")==TRUE~"泉州市",
                        str_detect(officeaddr,"石狮市")==TRUE~"石狮市",
                        str_detect(officeaddr,"晋江市")==TRUE~"晋江市",
                        str_detect(officeaddr,"南安市")==TRUE~"南安市",
                        str_detect(officeaddr,"漳州市")==TRUE~"漳州市",
                        str_detect(officeaddr,"龙海市")==TRUE~"龙海市",
                        str_detect(officeaddr,"南平市")==TRUE~"南平市",
                        str_detect(officeaddr,"邵武市")==TRUE~"邵武市",
                        str_detect(officeaddr,"武夷山市")==TRUE~"武夷山市",
                        str_detect(officeaddr,"建瓯市")==TRUE~"建瓯市",
                        str_detect(officeaddr,"建阳市")==TRUE~"建阳市",
                        str_detect(officeaddr,"龙岩市")==TRUE~"龙岩市",
                        str_detect(officeaddr,"漳平市")==TRUE~"漳平市",
                        str_detect(officeaddr,"宁德市")==TRUE~"宁德市",
                        str_detect(officeaddr,"福安市")==TRUE~"福安市",
                        str_detect(officeaddr,"福鼎市")==TRUE~"福鼎市",
                        str_detect(officeaddr,"广州市")==TRUE~"广州市",
                        str_detect(officeaddr,"增城市")==TRUE~"增城市",
                        str_detect(officeaddr,"从化市")==TRUE~"从化市",
                        str_detect(officeaddr,"韶关市")==TRUE~"韶关市",
                        str_detect(officeaddr,"乐昌市")==TRUE~"乐昌市",
                        str_detect(officeaddr,"南雄市")==TRUE~"南雄市",
                        str_detect(officeaddr,"深圳市")==TRUE~"深圳市",
                        str_detect(officeaddr,"珠海市")==TRUE~"珠海市",
                        str_detect(officeaddr,"汕头市")==TRUE~"汕头市",
                        str_detect(officeaddr,"澄海市")==TRUE~"澄海市",
                        str_detect(officeaddr,"佛山市")==TRUE~"佛山市",
                        str_detect(officeaddr,"江门市")==TRUE~"江门市",
                        str_detect(officeaddr,"台山市")==TRUE~"台山市",
                        str_detect(officeaddr,"开平市")==TRUE~"开平市",
                        str_detect(officeaddr,"鹤山市")==TRUE~"鹤山市",
                        str_detect(officeaddr,"恩平市")==TRUE~"恩平市",
                        str_detect(officeaddr,"湛江市")==TRUE~"湛江市",
                        str_detect(officeaddr,"廉江市")==TRUE~"廉江市",
                        str_detect(officeaddr,"雷州市")==TRUE~"雷州市",
                        str_detect(officeaddr,"吴川市")==TRUE~"吴川市",
                        str_detect(officeaddr,"茂名市")==TRUE~"茂名市",
                        str_detect(officeaddr,"高州市")==TRUE~"高州市",
                        str_detect(officeaddr,"化州市")==TRUE~"化州市",
                        str_detect(officeaddr,"信宜市")==TRUE~"信宜市",
                        str_detect(officeaddr,"肇庆市")==TRUE~"肇庆市",
                        str_detect(officeaddr,"高要市")==TRUE~"高要市",
                        str_detect(officeaddr,"四会市")==TRUE~"四会市",
                        str_detect(officeaddr,"惠州市")==TRUE~"惠州市",
                        str_detect(officeaddr,"梅州市")==TRUE~"梅州市",
                        str_detect(officeaddr,"兴宁市")==TRUE~"兴宁市",
                        str_detect(officeaddr,"汕尾市")==TRUE~"汕尾市",
                        str_detect(officeaddr,"陆丰市")==TRUE~"陆丰市",
                        str_detect(officeaddr,"河源市")==TRUE~"河源市",
                        str_detect(officeaddr,"阳江市")==TRUE~"阳江市",
                        str_detect(officeaddr,"阳春市")==TRUE~"阳春市",
                        str_detect(officeaddr,"清远市")==TRUE~"清远市",
                        str_detect(officeaddr,"英德市")==TRUE~"英德市",
                        str_detect(officeaddr,"连州市")==TRUE~"连州市",
                        str_detect(officeaddr,"东莞市")==TRUE~"东莞市",
                        str_detect(officeaddr,"中山市")==TRUE~"中山市",
                        str_detect(officeaddr,"潮州市")==TRUE~"潮州市",
                        str_detect(officeaddr,"揭阳市")==TRUE~"揭阳市",
                        str_detect(officeaddr,"普宁市")==TRUE~"普宁市",
                        str_detect(officeaddr,"云浮市")==TRUE~"云浮市",
                        str_detect(officeaddr,"罗定市")==TRUE~"罗定市",
                        str_detect(officeaddr,"南宁市")==TRUE~"南宁市",
                        str_detect(officeaddr,"柳州市")==TRUE~"柳州市",
                        str_detect(officeaddr,"桂林市")==TRUE~"桂林市",
                        str_detect(officeaddr,"梧州市")==TRUE~"梧州市",
                        str_detect(officeaddr,"岑溪市")==TRUE~"岑溪市",
                        str_detect(officeaddr,"北海市")==TRUE~"北海市",
                        str_detect(officeaddr,"防城港市")==TRUE~"防城港市",
                        str_detect(officeaddr,"东兴市")==TRUE~"东兴市",
                        str_detect(officeaddr,"钦州市")==TRUE~"钦州市",
                        str_detect(officeaddr,"贵港市")==TRUE~"贵港市",
                        str_detect(officeaddr,"桂平市")==TRUE~"桂平市",
                        str_detect(officeaddr,"玉林市")==TRUE~"玉林市",
                        str_detect(officeaddr,"北流市")==TRUE~"北流市",
                        str_detect(officeaddr,"百色市")==TRUE~"百色市",
                        str_detect(officeaddr,"贺州市")==TRUE~"贺州市",
                        str_detect(officeaddr,"河池市")==TRUE~"河池市",
                        str_detect(officeaddr,"宜州市")==TRUE~"宜州市",
                        str_detect(officeaddr,"来宾市")==TRUE~"来宾市",
                        str_detect(officeaddr,"合山市")==TRUE~"合山市",
                        str_detect(officeaddr,"崇左市")==TRUE~"崇左市",
                        str_detect(officeaddr,"凭祥市")==TRUE~"凭祥市",
                        str_detect(officeaddr,"海口市")==TRUE~"海口市",
                        str_detect(officeaddr,"琼山市")==TRUE~"琼山市",
                        str_detect(officeaddr,"三亚市")==TRUE~"三亚市")) %>% 
  select(name,ncid,cid,province,city,edate,registeno,legalrepr,orgainzetype,briefinfo,bussiness,regmoney,website,officeaddr,phone,logourl,hangye,hangye2,hangye3,tags,comp_scale,opreat_status,email,devep_stage,wechat_id,weibo_url,data_date)


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


#create database tables status log
con1<- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '10.51.120.107', dbname='innotree_finance')

dbSendQuery(con1,'SET NAMES utf8')

status_yesterday<-dbGetQuery(con1,statement = "select * from admin_status;")

status_today<-dbGetQuery(conn = con1,statement = "show table status;")

status_today<-select(status_today,Name,Update_time,Rows,Engine)

status<-left_join(status_today,status_yesterday,by="Name") %>% 
  select(Name,Update_time.x,Rows,Rows_today,Engine.x)

names(status)<-c("Name","Update_time","Rows_today","Rows_yesterday","Engine")

status<-mutate(status,Rows_difference=Rows_today-Rows_yesterday) %>% 
  select(Name,Update_time,Rows_today,Rows_yesterday,Rows_difference,Engine)

dbGetQuery(conn = con1,statement = "delete from admin_status;")

dbWriteTable(con1, "admin_status", status, append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE)

dbDisconnect(con1)

#Finally:when finished the program ,send a email to me
library(mailR)
#email to
# recipients <- "ying.huang@innotree.cn" 
recipients <- "yinghuang@jieyuechina.com" 
#email from
sender = "493970240@qq.com"  
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
    host.name = "smtp.qq.com",
    port = 465,
    user.name = sender,  
    passwd = "btoqpfheeprlbgje",
    ssl = TRUE
  ),  
  authenticate = TRUE,  
  send = TRUE  
) 


rm(list=ls())

gc();gc();gc();gc();gc();gc();gc();gc();gc();gc()
