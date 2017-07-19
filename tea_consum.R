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















