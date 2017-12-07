#database_dict

library(RMySQL)
library(dplyr)

con1<- dbConnect(MySQL(), user = 'XXXX',password = 'XXXX', host = 'XXXX', dbname='XXXXX')

dbSendQuery(con1,'SET NAMES GBK')

table_name<-dbGetQuery(conn = con1, statement = "show tables;")
table_comment<-dbGetQuery(conn = con1, statement = "show table status;") %>% 
  select(Name,Comment)

all_columns<-data.frame()
N<-seq(1,nrow(table_name),by=1)
for (i in N) {
  mytable_columns<-dbGetQuery(conn = con1, statement = paste("show full columns from", table_name[i,1]))
  all_columns<-rbind(all_columns,cbind(Table=rep(table_name[i,1],nrow(mytable_columns)),mytable_columns)) %>% 
  arrange(desc(Key)) %>% arrange(desc(Extra)) %>%  arrange(Table)
}

dbDisconnect(con1)

table_dict<-left_join(all_columns,table_comment,by=c("Table"="Name")) %>% 
  select(Table,Comment.y,Field,Type,Null:Extra,Comment.x)
names(table_dict)<-c("Table","Comment_tab","Field","Type","Null","Key","Default","Extra","Comment.col")

#View(table_dict)

write.csv(table_dict,"F:/workspace_r/table_dict.csv",row.names = FALSE)
