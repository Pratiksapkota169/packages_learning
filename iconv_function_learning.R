library(RMySQL)
con1 <- dbConnect(MySQL(), user = 'fin_huangying',password = 'huangying1231', host = '112.126.86.232',dbname='innotree_finance')
mydata <- dbGetQuery(conn = con1, statement = "SELECT * from admin_status where Name like '%事实表%';")

#step 1:读取数据，转换乱码
mydata$Name<-iconv(mydata$Name,"UTF8","GBK")

#step 2:做一些计算，测试数据框能否被操作
newdata<-cbind(mydata,mydata$Name)

newdata<-newdata[,2:7]

names(newdata)<-c("Update_time" ,"Rows_today","Rows_yesterday","Rows_difference","Engine","Name" )

#step 3:插入数据前，转换编码
newdata$Name<-iconv(newdata$Name,"GBK","UTF8")

#step 4:写入数据库，显示正常
dbWriteTable(conn = con1,'test_0919',newdata,row.names=FALSE,col.names=TRUE,append=FALSE,overwrite=TRUE)

