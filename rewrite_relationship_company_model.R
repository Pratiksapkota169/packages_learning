#connect to database
library(RMySQL)

con1 <- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '100.115.97.86')

dbSendQuery(con1,'SET NAMES utf8')

comp_baseinfo_guowai <- dbGetQuery(conn = con1, statement = "SELECT name from dc_cscyl.comp_baseinfo_guowai;")
comp_baseinfo_ntb <- dbGetQuery(conn = con1, statement = "SELECT name,ifnewlayer from dc_cscyl.comp_baseinfo_ntb;")
key_company <- dbGetQuery(conn = con1, statement = "SELECT cname,ncid,hangye,hangye2 from dc_key.key_company;")
comp_baseinfo_a <- dbGetQuery(conn = con1, statement = "SELECT name from dc_cscyl.comp_baseinfo_a;")
事实表_融资事件 <- dbGetQuery(conn = con1, statement = "SELECT 公司全称,融资轮次 from dw.事实表_融资事件;")
comp_baseinfo_tags <- dbGetQuery(conn = con1, statement = "SELECT name,tags from nlp_company.comp_baseinfo_tags;")
维表_公司 <- dbGetQuery(conn = con1, statement = "SELECT 公司全称,公司得分 from dw.维表_公司;")

dbDisconnect(con1)

rm(con1)
gc()

#get data from database
library(dplyr)

company_china<-left_join(key_company,comp_baseinfo_ntb,by=c("cname"="name")) %>% 
  filter(!cname %in% comp_baseinfo_guowai["name"] & !ifnewlayer %in% is.null(comp_baseinfo_ntb["ifnewlayer"])) %>%
  select(cname,ncid,ifnewlayer,hangye,hangye2)

#View(company_china)

company_name_left_temp_1<-select(comp_baseinfo_a,name)
company_name_left_temp_2<-select(事实表_融资事件,公司全称,融资轮次) %>% 
  filter(融资轮次 %in% c('E轮','F轮','G轮','H轮') & 
               公司全称 %in% company_china$name & !公司全称 %in% comp_baseinfo_a$name)
company_name_left<-full_join(company_name_left_temp_1,company_name_left_temp_2,by=c("name"="公司全称")) %>% select(name)
company_name_left<distinct(company_name_left,name)

rm(company_name_left_temp_1,company_name_left_temp_2)
gc()

#View(company_name_left)

company_name_right_temp_1<-select(事实表_融资事件,公司全称,融资轮次) %>%
  filter(融资轮次 %in% c('E轮','F轮','G轮','H轮','IPO上市','Pre-IPO','PIPE','战略投资')) %>%
  select(公司全称)
company_name_right<-select(company_china,cname,ifnewlayer,hangye,hangye2) %>%
  filter(!cname %in% comp_baseinfo_a$name & !cname %in% company_name_right_temp_1$公司全称) %>% 
  select(cname,ifnewlayer,hangye,hangye2)
company_name_right<-rename(company_name_right,name=cname)
company_name_right<-distinct(company_name_right,name,.keep_all = T)

rm(company_name_right_temp_1)
gc()

#View(company_name_right)

no_possible_right_name<-"控股|国家|总公司|集团|（|分公司|证券|运营中心|研究院|研究所|分行|支行|分社|中心|核电|中国保险|中国物流|中国外运|阿里巴巴|携程|国网|建筑局|三一重|中交局|中建局|钢铁|中局|办事处"
company_name_right_temp_no_possible<-filter(company_name_right,grepl(no_possible_right_name,name))
company_name_right<-company_name_right %>% 
  filter(!name %in% company_name_right_temp_no_possible$name)

rm(no_possible_right_name,company_name_right_temp_no_possible)
gc()

#View(company_name_right)

company_name_tag_left<-left_join(company_name_left,comp_baseinfo_tags,by="name") %>% 
  select(name,tags)

#View(company_name_tag_left)

company_name_tag_right<-left_join(company_name_right,comp_baseinfo_tags,by="name") %>% 
  select(name,ifnewlayer,tags)

#View(company_name_tag_right)

company_score<-left_join(key_company,维表_公司,by=c("cname"="公司全称")) %>% 
  filter(!is.null(公司得分) & !公司得分=="") %>% 
  select(cname,公司得分) %>% 
  rename(score=公司得分)

#View(company_score)

gc()






