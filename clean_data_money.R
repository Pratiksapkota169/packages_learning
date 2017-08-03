#target:change different unit into million dollars

rm(list=ls())
gc()

library(RMySQL)

con1 <- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '100.115.97.86')

dbSendQuery(con1,'SET NAMES utf8')

事实表_融资事件 <- dbGetQuery(conn = con1, statement = "SELECT * from dw.事实表_融资事件;")

dbDisconnect(con1)

#step_1<-select(rongzi,融资金额) %>% distinct(融资金额)

#step_2<-str_replace_all(step_1$融资金额,"[0-9\\.\\t ]","")

#step_3<-data.frame(step_2) %>%
#  filter(!step_1$融资金额 %in% c("/ 云禾科技","清晗基金","沟沟手环")) %>% 
#  distinct(step_2)

#View(step_3)

#'/ 云禾科技' '清晗基金' 两条错位

# step_4_dollar<-filter(step_3,grepl("美元",step_2))
# step_4_dollar_much<-filter(step_4_dollar,grepl("数",step_2))
# 
# step_4_rmb<-filter(step_3,grepl("人民币",step_2))
# step_4_rmb_much<-filter(step_4_rmb,grepl("数",step_2))


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



con2<- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '10.51.120.107', dbname='innotree_finance')

dbSendQuery(con2,'SET NAMES utf8')

dbWriteTable(con2,"事实表_融资事件_correct",事实表_融资事件_correct,append=TRUE,row.names=FALSE,col.names=FALSE,overwrite=FALSE) 

dbDisconnect(con2)

