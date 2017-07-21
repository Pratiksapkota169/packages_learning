library("plyr")
library("tidyr")
library("ggthemes")
library("sca")
library("dplyr")
library("showtext")
library("Cairo")
library("grid")

font.add("msyh","msyh.ttf")
font.add("msyhbd","msyhbd.ttf")

tea_data<-read.csv("E:/workspace_r/graphs_learning/tea_data.csv",stringsAsFactors = FALSE,check.names = FALSE)
View(tea_data)

#调整原数据"印度\n尼西亚"
tea_data$State[12]<-"印度尼\n西亚"

tea_data


tea_bump<-na.omit(tea_data[,c("State","Yield","Ratio")])
tea_bump

tea_bump<-arrange(tea_bump,-Yield)

#把缺失值全部归成other类
other_Ratio<-1-sum(tea_bump$Ratio)
other_Ratio

other_Yield<-sum(tea_bump$Yield)/sum(tea_bump$Ratio)-
  sum(tea_bump$Yield)
other_Yield

#形成一个data.frame格式
data1<-data.frame(State="其他",Yield=other_Yield,Ratio=other_Ratio)
data1

#把other和前面的数据合并
tea_bump<-rbind(tea_bump,data1)
tea_bump

#cumsum计算各行累加值
tea_bump$end<-cumsum(tea_bump$Yield)
#start范围
tea_bump$start<-c(0,tea_bump$end[1:nrow(tea_bump)-1])
tea_bump$id<-1:nrow(tea_bump)
#按State合并
tea_bump<-merge(tea_bump,tea_data[,c("State","Consum")],by="State",all.x = TRUE)
tea_bump
tea_bump<-arrange(tea_bump,-Yield)

























