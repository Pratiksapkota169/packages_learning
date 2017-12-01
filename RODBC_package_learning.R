library(RODBC)
channel <- odbcConnect("app_db", uid="reader", pwd="jyjf@read_db*2017")
sqlTables(channel)  #查看数据中的表

data<-sqlFetch(channel,"app_t_version")  # 查看表的内容，存到数据框里
View(data)

channel

sqlQuery(channel,"select operat_system,version_num from app_t_version",max=1)
